From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: qla2xxx: Add LLD target-mode infrastructure for >= 24xx series
Date: Tue, 13 Mar 2012 20:20:45 +0300
Message-ID: <20120313172044.GD31808@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:47747 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab2CMRU4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 13:20:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org

Hello Nicholas,

The patch 962f988d031f: "qla2xxx: Add LLD target-mode infrastructure 
for >= 24xx series" from Mar 8, 2012, leads to the following Smatch
warning:

drivers/scsi/qla2xxx/qla_target.c:3207 qla_tgt_handle_srr_work()
	 error: potential null derefence 'vha'.


drivers/scsi/qla2xxx/qla_target.c
  3198                  imm = NULL;
  3199                  list_for_each_entry_safe(i, ti, &tgt->srr_imm_list,
  3200                                                  srr_list_entry) {
  3201                          if (i->srr_id == sctio->srr_id) {
  3202                                  list_del(&i->srr_list_entry);
  3203                                  if (imm) {
  3204                                          printk(KERN_ERR "qla_target(%d): There must "
  3205                                            "be only one IMM SRR per CTIO SRR "
  3206                                            "(IMM SRR %p, id %d, CTIO %p\n",
  3207                                            vha->vp_idx, i, i->srr_id, sctio);
                                                  ^^^
It looks like "vha" might not be initialized yet.

  3208                                          qla_tgt_reject_free_srr_imm(vha, i, 0);
  3209                                  } else
  3210                                          imm = i;
  3211                          }
  3212                  }
  3213  
  3214                  ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xe12f, "IMM SRR %p, CTIO SRR %p (id %d)\n",
  3215                          imm, sctio, sctio->srr_id);
  3216  
  3217                  if (imm == NULL) {
  3218                          ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xe130, "Not found matching IMM"
  3219                                  " for SRR CTIO (id %d)\n", sctio->srr_id);
  3220                          continue;
  3221                  } else
  3222                          list_del(&sctio->srr_list_entry);
  3223  
  3224                  spin_unlock_irqrestore(&tgt->srr_lock, flags);
  3225  
  3226                  cmd = sctio->cmd;
  3227                  vha = cmd->vha;
                        ^^^
It gets set here.

regards,
dan carpenter

