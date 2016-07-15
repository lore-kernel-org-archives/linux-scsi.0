From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ibmvfc: prevent a potential deadlock
Date: Fri, 15 Jul 2016 14:18:57 +0300
Message-ID: <20160715111857.GC13153@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

My static checker complains that we need to unlock on this path.  Seems
true.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index fc523c3..ab67ec4 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4722,6 +4722,8 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
 					tgt_dbg(tgt, "Setting rport roles\n");
 					fc_remote_port_rolechg(rport, tgt->ids.roles);
 					put_device(&rport->dev);
+				} else {
+					spin_unlock_irqrestore(vhost->host->host_lock, flags);
 				}
 
 				kref_put(&tgt->kref, ibmvfc_release_tgt);
