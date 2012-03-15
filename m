From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: re: qla2xxx: Add LLD target-mode infrastructure for >= 24xx series
Date: Thu, 15 Mar 2012 16:10:15 -0700
Message-ID: <1331853015.10203.128.camel@haakon2.linux-iscsi.org>
References: <20120313172044.GD31808@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120313172044.GD31808@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-03-13 at 20:20 +0300, Dan Carpenter wrote:
> Hello Nicholas,
> 
> The patch 962f988d031f: "qla2xxx: Add LLD target-mode infrastructure 
> for >= 24xx series" from Mar 8, 2012, leads to the following Smatch
> warning:
> 
> drivers/scsi/qla2xxx/qla_target.c:3207 qla_tgt_handle_srr_work()
> 	 error: potential null derefence 'vha'.
> 
> 
> drivers/scsi/qla2xxx/qla_target.c
>   3198                  imm = NULL;
>   3199                  list_for_each_entry_safe(i, ti, &tgt->srr_imm_list,
>   3200                                                  srr_list_entry) {
>   3201                          if (i->srr_id == sctio->srr_id) {
>   3202                                  list_del(&i->srr_list_entry);
>   3203                                  if (imm) {
>   3204                                          printk(KERN_ERR "qla_target(%d): There must "
>   3205                                            "be only one IMM SRR per CTIO SRR "
>   3206                                            "(IMM SRR %p, id %d, CTIO %p\n",
>   3207                                            vha->vp_idx, i, i->srr_id, sctio);
>                                                   ^^^
> It looks like "vha" might not be initialized yet.
> 
>   3208                                          qla_tgt_reject_free_srr_imm(vha, i, 0);
>   3209                                  } else
>   3210                                          imm = i;
>   3211                          }
>   3212                  }
>   3213  
>   3214                  ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xe12f, "IMM SRR %p, CTIO SRR %p (id %d)\n",
>   3215                          imm, sctio, sctio->srr_id);
>   3216  
>   3217                  if (imm == NULL) {
>   3218                          ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xe130, "Not found matching IMM"
>   3219                                  " for SRR CTIO (id %d)\n", sctio->srr_id);
>   3220                          continue;
>   3221                  } else
>   3222                          list_del(&sctio->srr_list_entry);
>   3223  
>   3224                  spin_unlock_irqrestore(&tgt->srr_lock, flags);
>   3225  
>   3226                  cmd = sctio->cmd;
>   3227                  vha = cmd->vha;
>                         ^^^
> It gets set here.
> 

It looks like this should be using qla_tgt->vha everywhere.  Applying
the following patch.

--nab


iff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e415d1e..2af075b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3169,11 +3169,11 @@ static void qla_tgt_reject_free_srr_imm(struct scsi_qla_host *vha, struct qla_tg
 static void qla_tgt_handle_srr_work(struct work_struct *work)
 {
        struct qla_tgt *tgt = container_of(work, struct qla_tgt, srr_work);
-       struct scsi_qla_host *vha = NULL;
+       struct scsi_qla_host *vha = tgt->vha;
        struct qla_tgt_srr_ctio *sctio;
        unsigned long flags;
 
-       ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xe12e, "Entering SRR work (tgt %p)\n", tgt);
+       ql_dbg(ql_dbg_tgt_mgt, vha, 0xe12e, "Entering SRR work (tgt %p)\n", tgt);
 
 restart:
        spin_lock_irqsave(&tgt->srr_lock, flags);
@@ -3192,17 +3192,17 @@ restart:
                                          "be only one IMM SRR per CTIO SRR "
                                          "(IMM SRR %p, id %d, CTIO %p\n",
                                          vha->vp_idx, i, i->srr_id, sctio);
-                                       qla_tgt_reject_free_srr_imm(vha, i, 0);
+                                       qla_tgt_reject_free_srr_imm(tgt->vha, i, 0);
                                } else
                                        imm = i;
                        }
                }
 
-               ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xe12f, "IMM SRR %p, CTIO SRR %p (id %d)\n",
+               ql_dbg(ql_dbg_tgt_mgt, vha, 0xe12f, "IMM SRR %p, CTIO SRR %p (id %d)\n",
                        imm, sctio, sctio->srr_id);
 
                if (imm == NULL) {
-                       ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xe130, "Not found matching IMM"
+                       ql_dbg(ql_dbg_tgt_mgt, vha, 0xe130, "Not found matching IMM"
                                " for SRR CTIO (id %d)\n", sctio->srr_id);
                        continue;
                } else
@@ -3211,7 +3211,6 @@ restart:
                spin_unlock_irqrestore(&tgt->srr_lock, flags);
 
                cmd = sctio->cmd;
-               vha = cmd->vha;
                /*
                 * Reset qla_tgt_cmd SRR values and SGL pointer+count to follow
                 * tcm_qla2xxx_write_pending() and tcm_qla2xxx_queue_data_in()
