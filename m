From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/2] scsi: Handle Unit Attention when issuing SCSI
 command
Date: Tue, 25 Oct 2016 15:23:57 -0700
Message-ID: <1477434237.3079.84.camel@linux.vnet.ibm.com>
References: <1477279216-11256-1-git-send-email-krisman@linux.vnet.ibm.com>
         <27d08f8f-bbf5-1298-1985-f0c3ee45d2d1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39247 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751576AbcJYWYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Oct 2016 18:24:04 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9PMNdub106146
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 18:24:04 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26a8rw7e1u-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2016 18:24:04 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 25 Oct 2016 16:24:03 -0600
In-Reply-To: <27d08f8f-bbf5-1298-1985-f0c3ee45d2d1@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, gabriel@krisman.be, brking@linux.vnet.ibm.com

On Tue, 2016-10-25 at 15:16 -0700, Bart Van Assche wrote:
> On 10/23/2016 08:20 PM, Gabriel Krisman Bertazi wrote:
> > +
> >  /**
> >   * scsi_execute - insert request and wait for the result
> >   * @sdev:	scsi device
> > @@ -187,7 +197,14 @@ int scsi_execute(struct scsi_device *sdev,
> > const unsigned char *cmd,
> >  	struct request *req;
> >  	int write = (data_direction == DMA_TO_DEVICE);
> >  	int ret = DRIVER_ERROR << 24;
> > +	unsigned char sense_buf[SCSI_SENSE_BUFFERSIZE];
> > 
> > +	if (!sense) {
> > +		sense = sense_buf;
> > +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
> > +	}
> > +
> > + retry:
> >  	req = blk_get_request(sdev->request_queue, write,
> > __GFP_RECLAIM);
> >  	if (IS_ERR(req))
> >  		return ret;
> > @@ -210,6 +227,13 @@ int scsi_execute(struct scsi_device *sdev,
> > const unsigned char *cmd,
> >  	 */
> >  	blk_execute_rq(req->q, NULL, req, 1);
> > 
> > +	if (scsi_sense_unit_attention(sense) && req->retries > 0)
> > {
> > +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
> > +		retries = req->retries - 1;
> > +		blk_put_request(req);
> > +		goto retry;
> > +	}
> > +
> >  	/*
> >  	 * Some devices (USB mass-storage in particular) may
> > transfer
> >  	 * garbage data together with a residue indicating that
> > the data
> 
>  From scsi_io_completion():
> 
> 	if (sense_valid && !sense_deferred) {
> 		switch (sshdr.sense_key) {
> 		case UNIT_ATTENTION:
> 			if (cmd->device->removable) {
> 				cmd->device->changed = 1;
> 				action = ACTION_FAIL;
> 			} else {
> 				action = ACTION_RETRY;
> 			}
> 			[ ... ]
> 
> Why do you think new retry code is needed in scsi_execute()?

Because scsi_execute uses REQ_BLOCK_PC which is completed before you
get to that code.

James


