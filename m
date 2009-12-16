From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH, v2] SCSI/libsrp: document the libsrp source code
Date: Wed, 16 Dec 2009 13:08:39 -0800
Message-ID: <20091216130839.6e939ec4.randy.dunlap@oracle.com>
References: <200912162010.24325.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:61725 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbZLPVIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2009 16:08:47 -0500
In-Reply-To: <200912162010.24325.bart.vanassche@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Wed, 16 Dec 2009 20:10:24 +0100 Bart Van Assche wrote:

> Adds documentation to the libsrp source code.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> Cc: James E.J. Bottomley <James.Bottomley@suse.de>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> 
> ----
> This is the second version of this patch. While the first version of this
> patch did not adhere strictly to the kernel-doc format, this version should.

Not entirely :(
Just a few more to add, then you can include this line:
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks!

> 
> diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
> index 9ad38e8..83c0f45 100644
> --- a/drivers/scsi/libsrp.c
> +++ b/drivers/scsi/libsrp.c
> @@ -29,6 +29,10 @@
>  #include <scsi/srp.h>
>  #include <scsi/libsrp.h>
>  
> +/*
> + * Allowed values for the 'TASK ATTRIBUTE' field of an SRP_CMD request. See
> + * also section 6.8 of the T10 SRP r16a document.
> + */
>  enum srp_task_attributes {
>  	SRP_SIMPLE_TASK = 0,
>  	SRP_HEAD_TASK = 1,
> @@ -44,6 +48,16 @@ do {								\
>  /* #define dprintk eprintk */
>  #define dprintk(fmt, args...)
>  
> +/**
> + * Allocate a pool of information units for use by an SRP target.

Missing function_name: above.

> + * @q: pointer to the pool structure that will be initialized.
> + * @max: number of information units the pool will contain.
> + * @ring: pointer to an array of 'max' SRP buffer pointers. Each information
> + *   unit allocated for the pool will be initialized such that it points to
> + *   the corresponding SRP buffer in array 'ring'.
> + *
> + * Returns zero upon success and a negative error code upon failure.
> + */
>  static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
>  			     struct srp_buf **ring)
>  {


> @@ -393,6 +512,10 @@ static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
>  	return len;
>  }
>  
> +/**
> + * srp_cmd_queue() - Queue an SRP_CMD request for processing by appropriate
> + * target software, e.g. the user space process tgtd.

Missng function arguments in kernel-doc.


> + */
>  int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
>  		  u64 itn_id, u64 addr)
>  {


> diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
> index ba615e4..f5da2cc 100644
> --- a/include/scsi/libsrp.h
> +++ b/include/scsi/libsrp.h
> @@ -1,11 +1,17 @@
...

Data structs look good.



---
~Randy
