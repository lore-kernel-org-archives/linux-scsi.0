From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/4] scsi_scan: Fixup scsilun_to_int()
Date: Mon, 04 Mar 2013 13:22:08 -0500
Message-ID: <5134E650.6040404@interlog.com>
References: <1361368034-54444-1-git-send-email-hare@suse.de> <1361368034-54444-2-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51935 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab3CDSWR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Mar 2013 13:22:17 -0500
In-Reply-To: <1361368034-54444-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>

On 13-02-20 08:47 AM, Hannes Reinecke wrote:
> scsilun_to_int() has an error which prevents it from generating
> correct LUN numbers for 64bit values.
> Also we should remove the misleading comment about portions of
> the LUN being ignored; the initiator should treat the LUN as
> an opaque value.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/scsi_scan.c |    9 +++------
>   1 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3e58b22..4f315f5 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1228,14 +1228,11 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
>    *     truncation before using this function.
>    *
>    * Notes:
> - *     The struct scsi_lun is assumed to be four levels, with each level
> - *     effectively containing a SCSI byte-ordered (big endian) short; the
> - *     addressing bits of each level are ignored (the highest two bits).
>    *     For a description of the LUN format, post SCSI-3 see the SCSI
>    *     Architecture Model, for SCSI-3 see the SCSI Controller Commands.
>    *
> - *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function returns
> - *     the integer: 0x0b030a04
> + *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function
> + *     returns the integer: 0x0b030a04
>    **/
>   int scsilun_to_int(struct scsi_lun *scsilun)
>   {
> @@ -1244,7 +1241,7 @@ int scsilun_to_int(struct scsi_lun *scsilun)
>
>   	lun = 0;
>   	for (i = 0; i < sizeof(lun); i += 2)
> -		lun = lun | (((scsilun->scsi_lun[i] << 8) |
> +		lun = lun | (((scsilun->scsi_lun[i] << ((i + 1) * 8)) |
>   			      scsilun->scsi_lun[i + 1]) << (i * 8));
>   	return lun;
>   }
>

Hmm, this proposed patch is broken for 32 bits (and is thus
broken when extended to uint64_t in patch 2/4 of this series).

This is assuming the example shown in the comment is what
we want this function to do. And the example is ill chosen
since by the T10 (SAM-5) definition it is showing a 3 level
hierarchial LUN which requires 48 bits to represent.

Yet Hannes is correct in a way, because when the existing
scsilun_to_int() is extended to 64 bits, it breaks in a
non-obvious way. If sizeof(int) is 4 (which is often the
case in Linux) then for scsi_lun being an array of (unsigned
char), the expression:
       scsi_lun[0] << 32
is zero for values of scsi_lun[0], somewhat surprisingly.

The following works:

static uint64_t
t10_2linux_lun(const unsigned char t10_lun[])
{
     const unsigned char * cp;
     uint64_t res;

      res = (t10_lun[6] << 8) + t10_lun[7];
      for (cp = t10_lun + 4; cp >= t10_lun; cp -= 2) {
         res <<= 16;
         res += (*cp << 8) + *(cp + 1);
     }
     return res;
}


Doug Gilbert


