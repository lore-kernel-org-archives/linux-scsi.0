From: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Subject: Re: [PATCH v7] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Thu, 23 Jun 2016 15:19:47 -0500
Message-ID: <c378ee2a-6ec7-699d-68b1-f54268833951@linux.vnet.ibm.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1466433229-8812-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <20160623142213.GA30453@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25723 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750876AbcFWUTf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2016 16:19:35 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5NKJ2VA004716
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2016 16:19:34 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23ra2mnka1-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2016 16:19:34 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mikecyr@linux.vnet.ibm.com>;
	Thu, 23 Jun 2016 14:19:33 -0600
In-Reply-To: <20160623142213.GA30453@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, joe@perches.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com

Responding to those issues not already addressed by Bryant.

On 6/23/16 9:22 AM, Christoph Hellwig wrote:

<SNIP>
>> +		vscsi->flags &= (~PROCESSING_MAD);
> No need for the braces here. (ditto for many other places later on)
Fixed.

<SNIP>
>> +static struct ibmvscsis_tport *ibmvscsis_lookup_port(const char *name)
>> +{
>> +	struct ibmvscsis_tport *tport = NULL;
>> +	struct vio_dev *vdev;
>> +	struct scsi_info *vscsi;
>> +
>> +	spin_lock_bh(&ibmvscsis_dev_lock);
>> +	list_for_each_entry(vscsi, &ibmvscsis_dev_list, list) {
>> +		vdev = vscsi->dma_dev;
>> +		if (!strcmp(dev_name(&vdev->dev), name)) {
>> +			tport = &vscsi->tport;
>> +			break;
>> +		}
>> +	}
>> +	spin_unlock_bh(&ibmvscsis_dev_lock);
> Without grabbing a reference this looks inherently unsafe.
I don't understand your concern.  Could you please provide more detail?
>> +static void ibmvscsis_scheduler(struct work_struct *work)
> Odd name for a work item.
Not sure why it seems odd.  It schedules work to TCM.
>> +{
>> +	struct ibmvscsis_cmd *cmd = container_of(work, struct ibmvscsis_cmd,
>> +						 work);
>> +	struct scsi_info *vscsi = cmd->adapter;
>> +
>> +	spin_lock_bh(&vscsi->intr_lock);
>> +
>> +	/* Remove from schedule_q */
>> +	list_del(&cmd->list);
> What do you need the schedule_q for as the workqueue already tracks
> the commands?
There are a number of places where we need to see if there is anything 
on the work queue, and I am not aware of an existing function to do 
this, so we keep our own list of commands which have been queued.

<SNIP>
>> +static void ibmvscsis_alloc_common_locks(struct scsi_info *vscsi)
>> +{
>> +	spin_lock_init(&vscsi->intr_lock);
>> +}
>> +
>> +static void ibmvscsis_free_common_locks(struct scsi_info *vscsi)
>> +{
>> +	/* Nothing to do here */
>> +}
> No need for these wrapers.
Removed.
>> +static irqreturn_t ibmvscsis_interrupt(int dummy, void *data)
>> +{
>> +	struct scsi_info *vscsi = data;
>> +
>> +	vio_disable_interrupts(vscsi->dma_dev);
>> +	tasklet_schedule(&vscsi->work_task);
>> +
>> +	return IRQ_HANDLED;
>> +}
> Can you explain the need for the tasklet?  There shouldn't be a whole
> lot of working before passing the command off to the workqueue anyway.
There are some requests, like SRP Login and the various MADs, which can 
be handled at the interrupt level, and so we do so.

