From: Prasad Gondi <pgondi@vmware.com>
Subject: RE: [Open-FCoE] [PATCH] scsi: fix Wunused-but-set-variable
 buildwarning
Date: Thu, 14 May 2015 23:24:28 +0000
Message-ID: <1488e7d0337944d98996c115cd0baefc@EX13-MBX-026.vmware.com>
References: <1431627166-12729-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431627166-12729-1-git-send-email-hofrat@osadl.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>, Vasu Dev <vasu.dev@intel.com>
Cc: "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

It seems like     rpriv is used to set the fsp->tgt_flags originally

>   fsp->tgt_flags = rpriv->flags 

And fsp->tgt_flags are used in "fc_fcp_cmd_send" like this

        setup_timer(&fsp->timer, fc_fcp_timeout, (unsigned long)fsp);
        if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
                fc_fcp_timer_set(fsp, get_fsp_rec_tov(fsp));

Main purpose of this flags used is to set the correct TimeOut Value for fc_fcp_timer. 

So is the removal of the "fsp->tgt_flags = rpriv->flags" in fc_queuecommand() is intentional? Or by mistake?

Once we clear that out we can see whether this change make sense?

Thanks,
Prasad Gondi

  
-----Original Message-----
From: fcoe-devel [mailto:fcoe-devel-bounces@open-fcoe.org] On Behalf Of Nicholas Mc Guire
Sent: Thursday, May 14, 2015 11:13 AM
To: Vasu Dev
Cc: fcoe-devel@open-fcoe.org; James E.J. Bottomley; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Nicholas Mc Guire
Subject: [Open-FCoE] [PATCH] scsi: fix Wunused-but-set-variable buildwarning

commit "[SCSI] libfc: remove tgt_flags from fc_fcp_pkt struct"
removed the last usage of rpriv (rpriv->flags) but forgot to remove the unused rpriv struct resulting in:
  drivers/scsi/libfc/fc_fcp.c: In function 'fc_queuecommand':
  drivers/scsi/libfc/fc_fcp.c:1795:30: warning: variable 'rpriv' set
  but not used [-Wunused-but-set-variable] so simply drop its declaration and setting.

Patch was compile tested with x86_64_defconfig + SCSI_LOWLEVEL=y, CONFIG_SCSI_FC_ATTRS=m, CONFIG_LIBFC=m

Patch is against 4.1-rc3 (localversion-next is -next-20150514)

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

 drivers/scsi/libfc/fc_fcp.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c index c438b81..fee6928 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1792,7 +1792,6 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 	struct fc_lport *lport = shost_priv(shost);
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	struct fc_fcp_pkt *fsp;
-	struct fc_rport_libfc_priv *rpriv;
 	int rval;
 	int rc = 0;
 	struct fc_stats *stats;
@@ -1814,8 +1813,6 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 		goto out;
 	}
 
-	rpriv = rport->dd_data;
-
 	if (!fc_fcp_lport_queue_ready(lport)) {
 		if (lport->qfull)
 			fc_fcp_can_queue_ramp_down(lport);
--
1.7.10.4

_______________________________________________
fcoe-devel mailing list
fcoe-devel@open-fcoe.org
https://urldefense.proofpoint.com/v2/url?u=http-3A__lists.open-2Dfcoe.org_mailman_listinfo_fcoe-2Ddevel&d=AwICAg&c=Sqcl0Ez6M0X8aeM67LKIiDJAXVeAw-YihVMNtXt-uEs&r=wjT-lROQxgFnmIgeyNof2ACTY91g4HqkQGUkJo2HQ0k&m=CyBs5yDLeN-k1LsnaCsHCdi06s2NEU0XemK8ry1EDg0&s=8x44EVd0jYu65AU-LSkgpi49VN9OIj9P6sDqg9AmLVo&e= 
