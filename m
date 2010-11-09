From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC v2 16/21] tcm: Add PSCSI subsystem plugin
Date: Tue, 09 Nov 2010 11:16:34 +0200
Message-ID: <4CD91172.4010007@panasas.com>
References: <1285195867-11728-1-git-send-email-nab@linux-iscsi.org>	 <4CD01EE2.20705@panasas.com> <1289279587.19946.69.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:57728 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752596Ab0KIJQj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 04:16:39 -0500
In-Reply-To: <1289279587.19946.69.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>

On 11/09/2010 07:13 AM, Nicholas A. Bellinger wrote:
> <More follow up on Boaz comments from last week>
> 

<snip>

>>> +static inline void pscsi_blk_init_request(
>>> +	struct se_task *task,
>>> +	struct pscsi_plugin_task *pt,
>>> +	struct request *req,
>>> +	int bidi_read)
>>> +{
>>> +	/*
>>> +	 * Defined as "scsi command" in include/linux/blkdev.h.
>>> +	 */
>>> +	req->cmd_type = REQ_TYPE_BLOCK_PC;
>>> +	/*
>>> +	 * For the extra BIDI-COMMAND READ struct request we do not
>>> +	 * need to setup the remaining structure members
>>> +	 */
>>> +	if (bidi_read)
>>> +		return;
>>> +	/*
>>> +	 * Setup the done function pointer for struct request,
>>> +	 * also set the end_io_data pointer.to struct se_task.
>>> +	 */
>>> +	req->end_io = pscsi_req_done;
>>> +	req->end_io_data = (void *)task;
>>> +	/*
>>> +	 * Load the referenced struct se_task's SCSI CDB into
>>> +	 * include/linux/blkdev.h:struct request->cmd
>>> +	 */
>>> +	req->cmd_len = scsi_command_size(pt->pscsi_cdb);
>>> +	req->cmd = &pt->pscsi_cdb[0];
>>
>> Here!   req->cmd = TASK_CMD(task)->t_task_cdb;
>>
>> I don't see in this patch the actual memcpy of TASK_CMD(task)->t_task_cdb into
>> pt->pscsi_cdb, which I suspect is done in Generic code through the use of
>> ->get_cdb(struct se_task *);?
>>
>> If so then it means all the plugins have their own copy of the CDB? Now I finally
>> understand the get_max_cdb_len().
>>
>> All that could be totally clean. All plugins use the TASK_CMD(task)->t_task_cdb
>> directly. Then get_max_cdb_len(), get_cdb(), the memcpy() and all these extra buffers
>> just magically go away.
> 
> As described in the last response, the T_TASK(cmd)->t_task_cdb is used
> as a base for all CDBs, and is the primary storage for all *non*
> SCF_SCSI_DATA_SG_IO_CDB type ops.
> 
> For all bulk SCF_SCSI_DATA_SG_IO_CDB, we will memcpy
> T_TASK(cmd)->t_task_cdb into the backend specific location (for
> TCM/pSCSI this is pt->pscsi_cdb[])  and then update the LBA+length when
> splitting the single received struct se_cmd across multiple struct
> se_task w/ backend descriptors due to backend struct
> se_dev_limits->limits.max_sectors limitations for underlying backend HW.
> 

OK Thanks I was missing this part. Sorry I only looked at the patches and
not the complete code.

So for pSCSI could you use the cmnd buffer at struct request? Maybe
postpone a little bit the patching of the cdb to after the request allocation.
Than anything bigger then 16 bytes (max cmnd at struct request) you allocate
and free on request completion.
But all that could be cleaned up later. You are currently busy with bigger
stuff, just as a future note.

The rest look good. I have some holes in my knowledge of how you did bidi.
I promise to one of these days actually clone the tree and look at the real
code.
My goal is to have Lio-iscsi => lio-pSCSI => iscsi-initiator as a passthrough
of OSD commands. That will prove things are done right.

Also a Lio-iscsi => lio-tgt_if => tgtd-user-mode should also be very useful
and OSD-able

Thanks, Nic. Hope you feeling better now
Boaz
