From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] bsg-lib: fix use-after-free under memory-pressure
Date: Mon, 25 Sep 2017 18:54:31 +0200
Message-ID: <20170925165431.GA3283@bblock-ThinkPad-W530>
References: <9040282c25a027344945e9be2c3afc3d90386909.1506016742.git.bblock@linux.vnet.ibm.com>
 <20170925155307.GA27522@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935429AbdIYQyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Sep 2017 12:54:37 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8PGsKo9008329
        for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2017 12:54:37 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2d73a5rad3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2017 12:54:36 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Mon, 25 Sep 2017 17:54:35 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v8PGsWCV29491436
        for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2017 16:54:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAA0C52049
        for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2017 16:49:23 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.145.46.238])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A087B52043
        for <linux-scsi@vger.kernel.org>; Mon, 25 Sep 2017 16:49:23 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <20170925155307.GA27522@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, stable@vger.kernel.org

On Mon, Sep 25, 2017 at 08:53:07AM -0700, Christoph Hellwig wrote:
> >  	if (!q)
> >  		return ERR_PTR(-ENOMEM);
> >  	q->cmd_size = sizeof(struct bsg_job) + dd_job_size;
> > -	q->init_rq_fn = bsg_init_rq;
> > -	q->exit_rq_fn = bsg_exit_rq;
> > +	q->init_rq_fn = bsg_init_job;
> > +	q->exit_rq_fn = bsg_exit_job;
> > +	q->initialize_rq_fn = bsg_init_rq;
> 
> Please use function names that match the method names, that is keep
> the existing names and name the new helper bsg_initialize_rq;
>

OK, I can change that.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block

> 
> Except for that the patch looks fine to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
