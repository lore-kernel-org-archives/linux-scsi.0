From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] qla2xxx: Drop srb reference before waiting for completion
Date: Fri, 01 Oct 2010 16:10:21 -0500
Message-ID: <4CA64E3D.7080207@cs.wisc.edu>
References: <20101001121844.4ABF3353A8@ochil.suse.de> <4CA64C35.6010506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090604070001060100020305"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57732 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab0JAVEO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2010 17:04:14 -0400
In-Reply-To: <4CA64C35.6010506@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090604070001060100020305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/01/2010 04:01 PM, Mike Christie wrote:
> On 10/01/2010 07:18 AM, Hannes Reinecke wrote:
>>
>> This patch fixes a regression introduced by commit
>> 083a469db4ecf3b286a96b5b722c37fc1affe0be
>>
>> qla2xxx_eh_wait_on_command() is waiting for an srb to
>> complete, which will never happen as the routine took
>> a reference to the srb previously and will only drop it
>> after this function. So every command abort will fail.
>>
>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>> Cc: Andrew Vasquez<andrew.vasquez@qlogic.com>
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_os.c
>> b/drivers/scsi/qla2xxx/qla_os.c
>> index 1e4bff6..0af7549 100644
>> --- a/drivers/scsi/qla2xxx/qla_os.c
>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>> @@ -883,6 +883,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>> }
>> spin_unlock_irqrestore(&ha->hardware_lock, flags);
>>
>> + if (got_ref)
>> + qla2x00_sp_compl(ha, sp);
>> +
>
> You can just get rid of got_ref, because if you just move the compl call
> up a little more you know that in that code path we always get a ref.
> And there is no need to hold the ref to where it is above. See attached
> patch.
>

Sorry. Last patch had some other iscsi dev loss stuff in there. See this 
patch.

--------------090604070001060100020305
Content-Type: text/plain;
 name="qla2xxx-rm-got-ref2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="qla2xxx-rm-got-ref2.patch"

qla2xxx: Drop srb reference before waiting for completion

This patch fixes a regression introduced by commit
083a469db4ecf3b286a96b5b722c37fc1affe0be

qla2xxx_eh_wait_on_command() is waiting for an srb to
complete, which will never happen as the routine took
a reference to the srb previously and will only drop it
after this function. So every command abort will fail.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bdd53f0..6ea314f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -832,7 +832,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = vha->req;
 	srb_t *spt;
-	int got_ref = 0;
 
 	fc_block_scsi_eh(cmd);
 
@@ -866,7 +865,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 		/* Get a reference to the sp and drop the lock.*/
 		sp_get(sp);
-		got_ref++;
 
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		if (ha->isp_ops->abort_command(sp)) {
@@ -879,6 +877,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 			wait = 1;
 		}
 		spin_lock_irqsave(&ha->hardware_lock, flags);
+		qla2x00_sp_compl(ha, sp);
 		break;
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -893,9 +892,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		}
 	}
 
-	if (got_ref)
-		qla2x00_sp_compl(ha, sp);
-
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): Abort command issued -- %d %lx %x.\n",
 	    vha->host_no, id, lun, wait, serial, ret);

--------------090604070001060100020305--
