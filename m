From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH] csiostor: Avoid content leaks and casts
Date: Mon, 22 May 2017 20:35:47 +0530
Message-ID: <20170522150544.GA1677@chelsio.com>
References: <20170509223444.GA51314@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170509223444.GA51314@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 09, 2017 at 03:34:44PM -0700, Kees Cook wrote:
> When copying attributes, the len argument was padded out and the resulting
> memcpy() would copy beyond the end of the source buffer.  Avoid this,
> and use size_t for val_len to avoid all the casts. Similarly, avoid source
> buffer casts and use void *.
> 
> Additionally enforces val_len can be represented by u16 and that
> the DMA buffer was not overflowed. Fixes the size of mfa, which is not
> FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN (but it will be padded up to 4). This
> was noticed by the future CONFIG_FORTIFY_SOURCE checks.
> 
> Cc: Daniel Micay <danielmicay@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/scsi/csiostor/csio_lnode.c | 43 +++++++++++++++++++++++---------------
>  1 file changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
> index c00b2ff72b55..be5ee2d37815 100644
> --- a/drivers/scsi/csiostor/csio_lnode.c
> +++ b/drivers/scsi/csiostor/csio_lnode.c
> @@ -238,14 +238,23 @@ csio_osname(uint8_t *buf, size_t buf_len)
>  }
>  


>  
>  	csio_append_attrib(&pld, FC_FDMI_HBA_ATTR_MAXCTPAYLOAD,
> -			   (uint8_t *)&maxpayload,
> -			   FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN);
> +			   &maxpayload, FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN);
>  	len = (uint32_t)(pld - (uint8_t *)cmd);
>  	numattrs++;
>  	attrib_blk->numattrs = htonl(numattrs);
> @@ -1794,6 +1801,8 @@ csio_ln_mgmt_submit_req(struct csio_ioreq *io_req,
>  	struct csio_mgmtm *mgmtm = csio_hw_to_mgmtm(hw);
>  	int rv;
>  
> +	BUG_ON(pld_len > pld->len);
> +

I think WARN_ON() is better than BUG_ON() in this case

	if (WARN_ON(pld_len > pld->len))
		return -EINVAL;

>  	io_req->io_cbfn = io_cbfn;	/* Upper layer callback handler */
>  	io_req->fw_handle = (uintptr_t) (io_req);
>  	io_req->eq_idx = mgmtm->eq_idx;
