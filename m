From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.9 aacraid: dynamic dev update
Date: Sat, 25 Sep 2004 01:33:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040925013317.A1441@infradead.org>
References: <1096049918.31620.33.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:26898 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S269151AbUIYAdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 20:33:24 -0400
Content-Disposition: inline
In-Reply-To: <1096049918.31620.33.camel@markh1.pdx.osdl.net>; from markh@osdl.org on Fri, Sep 24, 2004 at 11:18:38AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

> -	struct fsa_scsi_hba *fsa_dev_ptr;
> +	struct fsa_dev_info *fsa_dev_ptr;
>  	u32 index; 
>  	int status = 0;
> -	struct aac_query_mount *dinfo;
> -	struct aac_mount *dresp;
>  	struct fib * fibptr;
>  	unsigned instance;
>  
> -	fsa_dev_ptr = &(dev->fsa_dev);
>  	instance = dev->scsi_host_ptr->unique_id;
>  
>  	if (!(fibptr = fib_alloc(dev)))
>  		return -ENOMEM;
>  
> -	for (index = 0; index < MAXIMUM_NUM_CONTAINERS; index++) {
> +	{
> +		struct aac_get_container_count *dinfo;
> +		struct aac_get_container_count_resp *dresp;
> +		int maximum_num_containers = MAXIMUM_NUM_CONTAINERS;

Please don't introduce such scopes for the sake of it, it makes the code really hard to
read.

> @@ -635,6 +633,8 @@
>  	iounmap((void * )aac->regs.sa);
>   out_free_fibs:
>  	kfree(aac->fibs);
> +	if (aac->fsa_dev)
> +		kfree(aac->fsa_dev);

kfree(NULL) is fine.


