From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 6/6] scsi_scan: Fixup scsilun_to_int()
Date: Mon, 2 Jun 2014 16:03:03 +0000
Message-ID: <1401724983.2204.12.camel@dabdike.int.hansenpartnership.com>
References: <1401526878-119472-1-git-send-email-hare@suse.de>
	 <1401526878-119472-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:45685 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaFBQDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 12:03:09 -0400
In-Reply-To: <1401526878-119472-7-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <7BEE6863D6059143856C69BB821D59C2@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "emilne@redhat.com" <emilne@redhat.com>

On Sat, 2014-05-31 at 11:01 +0200, Hannes Reinecke wrote:
> scsilun_to_int() has an error which prevents it from generating
> correct LUN numbers for 64bit values.
> Also we should remove the misleading comment about portions of
> the LUN being ignored; the initiator should treat the LUN as
> an opaque value.
> And, finally, the example given should use the correct
> prefix (here: extended flat space addressing scheme).
> 
> Suggested-by: Doug Gilbert <dgilbert@interlog.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_scan.c | 29 ++++++++++++-----------------
>  1 file changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index fa57a04..42843ec 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1263,25 +1263,23 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
>   *     truncation before using this function.
>   *
>   * Notes:
> - *     The struct scsi_lun is assumed to be four levels, with each level
> - *     effectively containing a SCSI byte-ordered (big endian) short; the
> - *     addressing bits of each level are ignored (the highest two bits).
>   *     For a description of the LUN format, post SCSI-3 see the SCSI
>   *     Architecture Model, for SCSI-3 see the SCSI Controller Commands.
>   *
> - *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function returns
> - *     the integer: 0x0b030a04
> + *     Given a struct scsi_lun of: d2 04 0b 03 00 00 00 00, this function
> + *     returns the integer: 0x0b03d204
>   **/
>  u64 scsilun_to_int(struct scsi_lun *scsilun)
>  {
> -	int i;
> -	u64 lun;
> +	const unsigned char * cp;
> +	uint64_t res;

u64 please; uint64_t is for shared headers with userspace only.

> -	lun = 0;
> -	for (i = 0; i < sizeof(lun); i += 2)
> -		lun = lun | (((scsilun->scsi_lun[i] << 8) |
> -			      scsilun->scsi_lun[i + 1]) << (i * 8));
> -	return lun;
> +	res = (scsilun->scsi_lun[6] << 8) + scsilun->scsi_lun[7];
> +	for (cp = scsilun->scsi_lun + 4; cp >= scsilun->scsi_lun; cp -= 2) {
> +		res <<= 16;
> +		res += (*cp << 8) + *(cp + 1);
> +	}
> +	return res;

This makes the code horrible to read because it implies wrongly that the
setup isn't the same code as the loop.  If we really have to have it
done this way, then do

u64 res = 0

for (cp = scsilun->scsi_lun + 6; cp >= scsilun->scsi_lun; cp -= 2) {
	res <<= 16;
        res += (*cp << 8) + *(cp + 1);
}
return res;

But really, I don't see what's wrong with

u64 lun = 0;

for (i = 0; i < sizeof(lun); i += 2)
	lun = lun | (((scsilun->scsi_lun[i] << ((i + 1) *8) |
		      scsilun->scsi_lun[i + 1]) << (i * 8));
return lun;


To my mind, the latter is clearer.

Changing the comment to match a realistic LUN is great.  However,
somewhere we should say that the reason for this transformation is that
a single level lun with address method zero matches the standard integer
luns for lun < 256.

After this is sorted out, the patch looks ready to go to me (you can add
my reviewed by).

James

