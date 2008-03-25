From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2 1/5] add scsi_build_sense_buffer helper function
Date: Tue, 25 Mar 2008 11:45:27 +0200
Message-ID: <47E8C9B7.1040406@panasas.com>
References: 1206378609.3494.50.camel@localhost.localdomain <1206404816-21710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:31322 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751873AbYCYJpl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 05:45:41 -0400
In-Reply-To: <1206404816-21710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James Bottomley <James.Bottomley@HansenPartnership.com>

On Tue, Mar 25 2008 at 2:26 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> This adds scsi_build_sense_buffer, a simple helper function to build
> sense data in a buffer.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/scsi_error.c |   28 ++++++++++++++++++++++++++++
>  include/scsi/scsi_eh.h    |    4 +++-
>  2 files changed, 31 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 1221d2c..221f31e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1993,3 +1993,31 @@ int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
>  	}
>  }
>  EXPORT_SYMBOL(scsi_get_sense_info_fld);
> +
> +/**
> + * scsi_build_sense_buffer - build sense data in a buffer
> + * @desc:	Sense format (non zero == descriptor format,
> + * 		0 == fixed format)
> + * @buf:	Where to build sense data
> + * @key:	Sense key
> + * @asc:	Additional sense code
> + * @ascq:	Additional sense code qualifier
> + *
> + **/
> +void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
> +{
> +	if (desc) {
> +		buf[0] = 0x72;	/* descriptor, current */
> +		buf[1] = key;
> +		buf[2] = asc;
> +		buf[3] = ascq;
> +		buf[7] = 0;
> +	} else {
> +		buf[0] = 0x70;	/* fixed, current */
> +		buf[2] = key;
> +		buf[7] = 0xa;
> +		buf[12] = asc;
> +		buf[13] = ascq;
> +	}
> +}
> +EXPORT_SYMBOL(scsi_build_sense_buffer);
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index 37a7614..d3a133b 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -57,7 +57,9 @@ extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
>  
>  extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
>  				   u64 * info_out);
> - 
> +
> +extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
> +
>  /*
>   * Reset request from external source
>   */
Tomo Hi.

Thanks for doing this. It was requested before by few people.

I have one small request please? This is to help me  with my "sense" effort.
(See here: http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=boaz_sense_effort)
Could you change it that a struct scsi_cmnd * is passed to the new API, instead of the
u8 * directly. This is because I'm removing the buffer at scsi_cmnd. Something like:

extern void scsi_build_sense_buffer(struct scsi_cmnd *, int desc, u8 key, u8 asc, u8 ascq);

If you do this then my patches get that much smaller.
Thanks
Boaz
  
