From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 6/6] scsi_scan: Fixup scsilun_to_int()
Date: Mon, 02 Jun 2014 18:16:20 +0200
Message-ID: <538CA354.8050002@acm.org>
References: <1401526878-119472-1-git-send-email-hare@suse.de> <1401526878-119472-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:36138 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaFBQQV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 12:16:21 -0400
In-Reply-To: <1401526878-119472-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 05/31/14 11:01, Hannes Reinecke wrote:
>  u64 scsilun_to_int(struct scsi_lun *scsilun)
>  {
> -	int i;
> -	u64 lun;
> +	const unsigned char * cp;
> +	uint64_t res;
>  
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
>  }
>  EXPORT_SYMBOL(scsilun_to_int);

Has it been considered to use get_unaligned_be16(cp) instead of (*cp <<
8) + *(cp + 1) ? At least in my opinion the former is easier to read.

Bart.

