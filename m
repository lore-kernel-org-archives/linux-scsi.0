From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] [SCSI] megaraid_sas: Sanity check user supplied length before passing it to dma_alloc_coherent()
Date: Wed, 19 Jan 2011 09:56:34 +0100
Message-ID: <87lj2h2rwd.fsf@nemi.mork.no>
References: <8739op51hr.fsf@nemi.mork.no>
	<4B6A08C587958942AA3002690DD4F8C30106FA7846@cosmail02.lsi.com>
	<87tyh52yi3.fsf@nemi.mork.no>
	<20110119165809X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:49338 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab1ASI5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2011 03:57:35 -0500
In-Reply-To: <20110119165809X.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Wed, 19 Jan 2011 17:12:00 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Bo.Yang@lsi.com, linux-scsi@vger.kernel.org, megaraidlinux@lsi.com, James.Bottomley@suse.de

=46UJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

> The patch looks fine to me. dma_alloc_coherent() doesn't take zero fo=
r
> the size argument (causes a kernel crash). The driver can't assume
> that an applications is sane so it needs to check the size that an
> application passed on.
>
> Unfortunately, your patch can't be applied to the latest git. I think
> that you need to submit the updated patch first. After it's merged,
> you can send stable maintainers the modified patch that can be applie=
d
> to stable kernels.
>
> Btw, about your patch, it's better to use "if (!hoge)" instead of "if
> (hoge =3D=3D 0)"=20

I believe that is a matter of taste, although I tend to agree that it
looks better.  I used the "(hoge =3D=3D 0)" syntax to try to keep in li=
ne
with the style already used in this driver, like e.g.

static int
megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct =
scsi_cmnd *))
{
	struct megasas_instance *instance;
	unsigned long flags;

	instance =3D (struct megasas_instance *)
	    scmd->device->host->hostdata;

	if (instance->issuepend_done =3D=3D 0)
		return SCSI_MLQUEUE_HOST_BUSY;



but I see now that there are quite a few "if (!hoge)" as well, so I wil=
l
update as you suggest.


> and kbuff_arr[] is initialized so seems that you don't
> need to reset it again.

Thanks.  Don't understand how I could have missed that.


> The updated patch would be something like:
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index 5d6d07b..cee1d3b 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4611,6 +4611,9 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *=
instance,
>  	 * For each user buffer, create a mirror buffer and copy in
>  	 */
>  	for (i =3D 0; i < ioc->sge_count; i++) {
> +		if (!ioc->sgl[i].iov_len)
> +			continue;
> +
>  		kbuff_arr[i] =3D dma_alloc_coherent(&instance->pdev->dev,
>  						    ioc->sgl[i].iov_len,
>  						    &buf_handle, GFP_KERNEL);


Yes, I'll followup with that in a separate mail.  Thanks a lot for your
thorough review.



Bj=C3=B8rn
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
