From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5] add scsi_build_sense_buffer helper function
Date: Mon, 24 Mar 2008 12:10:09 -0500
Message-ID: <1206378609.3494.50.camel@localhost.localdomain>
References: <1206377695-26084-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1206377695-26084-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43158 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772AbYCXRKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 13:10:15 -0400
In-Reply-To: <1206377695-26084-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

On Tue, 2008-03-25 at 01:54 +0900, FUJITA Tomonori wrote:
> This adds scsi_build_sense_buffer, a simple helper function to build
> sense data in a buffer.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/scsi_error.c |   30 ++++++++++++++++++++++++++++++
>  include/scsi/scsi_eh.h    |    5 ++++-
>  2 files changed, 34 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 1221d2c..85add5b 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1993,3 +1993,33 @@ int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
>  	}
>  }
>  EXPORT_SYMBOL(scsi_get_sense_info_fld);
> +
> +/**
> + * scsi_build_sense_buffer - build sense data in a buffer
> + * @desc:	Sense format (non zero == descriptor format,
> + * 		0 == fixed format
> + * @buf:	Where to build sense data
> + * @key:	Sense key
> + * @asc:	Additional sense code
> + * @ascq:	Additional sense code qualifier
> + * @addlen:	Additional sense length
> + *
> + **/
> +void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq,
> +			     int addlen)
> +{
> +	if (desc) {
> +		buf[0] = 0x72;	/* descriptor, current */
> +		buf[1] = key;
> +		buf[2] = asc;
> +		buf[3] = ascq;
> +		buf[7] = addlen;
> +	} else {
> +		buf[0] = 0x70;	/* fixed, current */
> +		buf[2] = key;
> +		buf[7] = addlen;
> +		buf[12] = asc;
> +		buf[13] = ascq;
> +	}

This doesn't look quite right ... if you're using this call to
manufacture sense data, you're always doing it at a fixed size, aren't
you (i.e. addlen is always 0 for descriptor format and 10 for fixed
format, isn't it)?  So we should just hard code that rather than
requiring it to be passed in.

Also, the libata piece needs to go to linux-ide@vger.kernel.org as well.

James


