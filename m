From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 6/6] scsi_scan: Fixup scsilun_to_int()
Date: Tue, 10 Jun 2014 13:37:48 +0200
Message-ID: <5396EE0C.3070108@acm.org>
References: <1401785937-43581-1-git-send-email-hare@suse.de> <1401785937-43581-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:57013 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaFJLhz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 07:37:55 -0400
In-Reply-To: <1401785937-43581-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 06/03/14 10:58, Hannes Reinecke wrote:
> + *     Given a struct scsi_lun of: d2 04 0b 03 00 00 00 00, this function
> + *     returns the integer: 0x0b03d204
> + *
> + *     This encoding will return a standard integer LUN for LUNs smaller
> + *     than 256, which typically use a single level LUN structure with
> + *     addressing method 0.
>   **/
>  u64 scsilun_to_int(struct scsi_lun *scsilun)
>  {
> @@ -1279,7 +1280,7 @@ u64 scsilun_to_int(struct scsi_lun *scsilun)
>  
>  	lun = 0;
>  	for (i = 0; i < sizeof(lun); i += 2)
> -		lun = lun | (((scsilun->scsi_lun[i] << 8) |
> +		lun = lun | (((scsilun->scsi_lun[i] << ((i + 1) *8)) |
>  			      scsilun->scsi_lun[i + 1]) << (i * 8));
>  	return lun;
>  }

The above code doesn't match the comment header. Parentheses have been
placed such that each byte with an even index is shifted left (2*i+1)*8
bits instead of (i+1)*8. I assume this means the parentheses have been
misplaced ? Another bug in this code is that a cast from
scsilun->scsi_lun[i] from u8 to u64 is missing. I think the shift
operations in the above code trigger what is called undefined behavior
in the C standard if i >= 4.

Bart.
