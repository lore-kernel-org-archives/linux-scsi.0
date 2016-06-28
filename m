From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH v8] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Tue, 28 Jun 2016 15:56:56 -0500
Message-ID: <BB635617-87FA-4667-B1B0-657E2E9FF627@linux.vnet.ibm.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1467058632-1825-1-git-send-email-mikecyr@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61770 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752641AbcF1U5F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2016 16:57:05 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5SKsHBV036388
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2016 16:57:04 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23v096rucp-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2016 16:57:03 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
	Tue, 28 Jun 2016 14:57:03 -0600
In-Reply-To: <1467058632-1825-1-git-send-email-mikecyr@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Cyr <mikecyr@linux.vnet.ibm.com>, nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com



On 6/27/16, 3:17 PM, "Michael Cyr" <target-devel-owner@vger.kernel.org on behalf of mikecyr@linux.vnet.ibm.com> wrote:

<SNIP>

+	cmd->se_cmd.tag = be64_to_cpu(srp->tag);
+
+	spin_lock_bh(&vscsi->intr_lock);
+	list_add_tail(&cmd->list, &vscsi->active_q);
+	spin_unlock_bh(&vscsi->intr_lock);
+
+	srp->lun.scsi_lun[0] &= 0x3f;
+
+	pr_debug("calling submit_cmd, se_cmd %p, lun 0x%llx, cdb 0x%x, attr:%d\n",
+		 &cmd->se_cmd, scsilun_to_int(&srp->lun), (int)srp->cdb[0],
+		 attr);
+
+	rc = target_submit_cmd(&cmd->se_cmd, nexus->se_sess, srp->cdb,
+			       cmd->sense_buf, scsilun_to_int(&srp->lun),
+			       data_len, attr, dir, 0);
+	if (rc) {

<SNIP>

+ * ibmvscsis_parse_task() - Parse SRP Task Management Request
+ *
+ * Parse the srp task management request; if it is valid then submit it to tcm.
+ * Note: The return code does not reflect the status of the task management
+ * request.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Processor level
+ */
+static void ibmvscsis_parse_task(struct scsi_info *vscsi,
+				 struct ibmvscsis_cmd *cmd)
+{
<SNIP>

+		spin_lock_bh(&vscsi->intr_lock);
+		list_add_tail(&cmd->list, &vscsi->active_q);
+		spin_unlock_bh(&vscsi->intr_lock);
+
+		srp_tsk->lun.scsi_lun[0] &= 0x3f;
+
+		pr_debug("calling submit_tmr, func %d\n",
+			 srp_tsk->tsk_mgmt_func);
+		rc = target_submit_tmr(&cmd->se_cmd, nexus->se_sess, NULL,
+				       scsilun_to_int(&srp_tsk->lun), srp_tsk,
+				       tcm_type, GFP_KERNEL, tag_to_abort, 0);
+		if (rc) {
<SNIP>

I was hoping someone in the community can help answer this:

If I were to remove the masking off of the lun addressing method prior to target_submit_cmd/target_submit_tmr then I get a hang within scsi probe 
on bootup. (srp->lun.scsi_lun[0] &= 0x3f; and srp_tsk->lun.scsi_lun[0] &= 0x3f;)

[    0.842648] ibmvscsi 3000000d: sent SRP login
[    0.842667] ibmvscsi 3000000d: SRP_LOGIN succeeded
[    0.842682] scsi 0:0:2:0: CD-ROM            AIX      VOPTA                 PQ: 0 ANSI: 4
[  OK  ] Started Show Plymouth Boot Screen.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Basic System.
[    0.886179] sr 0:0:2:0: [sr0] scsi-1 drive
[    0.886199] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.888582] sd 0:0:1:0: [sda] 41943040 512-byte logical blocks: (21.4 GB/20.0 GiB)
[    0.888657] sd 0:0:1:0: [sda] Write Protect is off
[    0.888712] sd 0:0:1:0: [sda] Cache data unavailable
[    0.888722] sd 0:0:1:0: [sda] Assuming drive cache: write through
[    0.901443]  sda: sda1 sda2 sda3
[    0.901838] sd 0:0:1:0: [sda] Attached SCSI disk
[  124.522778] dracut-initqueue[353]: Warning: dracut-initqueue timeout - starting timeout scripts
[  125.151242] dracut-initqueue[353]: Warning: dracut-initqueue timeout - starting timeout scripts
[  125.662808] dracut-initqueue[353]: Warning: dracut-initqueue timeout - starting timeout scripts

Does anyone know of the reasoning for having to mask off the addressing method prior
to submitting to target?

Thanks,

Bryant


