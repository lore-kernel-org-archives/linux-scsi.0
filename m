From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 12/17] scsi: ufs: add retry for query descriptors
Date: Thu, 22 Oct 2015 01:05:59 +0900
Message-ID: <CAC5umygn_VMS7+8Nx1b_sqzwPLE7T1m=3zuxO7MZfd6NT0ORKQ@mail.gmail.com>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
	<1442155977-7686-13-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442155977-7686-13-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-09-13 23:52 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> Query commands have 100ms timeout and it may timeout if they are
> issued in parallel to ongoing read/write SCSI commands, this change
> adds the retry (max: 10) in case command timeouts.
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 48 ++++++++++++++++++++++++++++++++---------------
>  1 file changed, 33 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a649250..528e46e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1906,21 +1906,7 @@ static int ufshcd_query_attr_retry(struct ufs_hba *hba,
>         return ret;
>  }
>
> -/**
> - * ufshcd_query_descriptor - API function for sending descriptor requests
> - * hba: per-adapter instance
> - * opcode: attribute opcode
> - * idn: attribute idn to access
> - * index: index field
> - * selector: selector field
> - * desc_buf: the buffer that contains the descriptor
> - * buf_len: length parameter passed to the device
> - *
> - * Returns 0 for success, non-zero in case of failure.
> - * The buf_len parameter will contain, on return, the length parameter
> - * received on the response.
> - */
> -static int ufshcd_query_descriptor(struct ufs_hba *hba,
> +static int __ufshcd_query_descriptor(struct ufs_hba *hba,
>                         enum query_opcode opcode, enum desc_idn idn, u8 index,
>                         u8 selector, u8 *desc_buf, int *buf_len)
>  {
> @@ -1985,6 +1971,38 @@ out:
>  }
>
>  /**
> + * ufshcd_query_descriptor - API function for sending descriptor requests
> + * hba: per-adapter instance
> + * opcode: attribute opcode
> + * idn: attribute idn to access
> + * index: index field
> + * selector: selector field
> + * desc_buf: the buffer that contains the descriptor
> + * buf_len: length parameter passed to the device
> + *
> + * Returns 0 for success, non-zero in case of failure.
> + * The buf_len parameter will contain, on return, the length parameter
> + * received on the response.
> + */
> +int ufshcd_query_descriptor(struct ufs_hba *hba,
> +                       enum query_opcode opcode, enum desc_idn idn, u8 index,
> +                       u8 selector, u8 *desc_buf, int *buf_len)
> +{
> +       int err;
> +       int retries;
> +
> +       for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
> +               err = __ufshcd_query_descriptor(hba, opcode, idn, index,
> +                                               selector, desc_buf, buf_len);
> +               if (!err || err == -EINVAL)
> +                       break;
> +       }
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(ufshcd_query_descriptor);

You introduced query flag and attribute APIs for retry version with
'_retry' suffix.
This function retries but doesn't have '_retry' suffix.
Should we have consistent function names for these query APIs?
