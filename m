From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: Fix for 64K data
Date: Thu, 15 Jul 2010 15:14:02 -0500
Message-ID: <4C3F6C0A.5080502@cs.wisc.edu>
References: <20100714182749.GA25200@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60943 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934618Ab0GOUKn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2010 16:10:43 -0400
In-Reply-To: <20100714182749.GA25200@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 07/14/2010 01:28 PM, Jayamohan Kallickal wrote:
>     This patch fixes a wraparound issue when the length=65536 for an sge.
> Since it was defined as a short, the length becomes zero
>
> This patch has been made over  scsi-rc-fixes-2.6 tree pulled today
>
> Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
> ---
>   drivers/scsi/be2iscsi/be_main.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index dd5b105..38e6d32 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -1764,7 +1764,7 @@ hwi_write_sgl(struct iscsi_wrb *pwrb, struct scatterlist *sg,
>   	      unsigned int num_sg, struct beiscsi_io_task *io_task)
>   {
>   	struct iscsi_sge *psgl;
> -	unsigned short sg_len, index;
> +	unsigned int sg_len, index;
>   	unsigned int sge_len = 0;
>   	unsigned long long addr;
>   	struct scatterlist *l_sg;

Looks good.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
