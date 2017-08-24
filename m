From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/1] bsg-lib: fix kernel panic resulting from missing
 allocation of reply-buffer
Date: Thu, 24 Aug 2017 15:36:50 +0200
Message-ID: <20170824133650.GE27001@bblock-ThinkPad-W530>
References: <cover.1503528302.git.bblock@linux.vnet.ibm.com>
 <4cf376032b459b7a14cdad22987177b86cc669c0.1503528302.git.bblock@linux.vnet.ibm.com>
 <20170824084556.GA19418@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751112AbdHXNgz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 09:36:55 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7ODZYri010737
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2017 09:36:54 -0400
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2chyc91uxt-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2017 09:36:54 -0400
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Thu, 24 Aug 2017 14:36:53 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v7ODapNx30867644
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2017 13:36:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ACF9AA4051
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2017 14:33:27 +0100 (BST)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FA42A404D
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2017 14:33:27 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.188])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2017 14:33:27 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <20170824084556.GA19418@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>

On Thu, Aug 24, 2017 at 10:45:56AM +0200, Christoph Hellwig wrote:
> >  /**
> > - * bsg_destroy_job - routine to teardown/delete a bsg job
> > + * bsg_teardown_job - routine to teardown a bsg job
> >   * @job: bsg_job that is to be torn down
> >   */
> > -static void bsg_destroy_job(struct kref *kref)
> > +static void bsg_teardown_job(struct kref *kref)
> 
> Why this rename?  The destroy name seems to be one of the most
> common patterns for the kref_put callbacks.
>

Hmm, I did it mostly so it is symmetric with bsg_prepare_job() and it
doesn't really itself destroy the job-struct anymore. If there are other
thing amiss I can change that along with them, if it bothers poeple.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block

> 
> Otherwise this looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
