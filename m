From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: re: tcm_qla2xxx: Add >= 24xx series fabric module for target-core
Date: Thu, 15 Mar 2012 15:43:52 -0700
Message-ID: <1331851432.10203.106.camel@haakon2.linux-iscsi.org>
References: <20120313171948.GB31808@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120313171948.GB31808@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-03-13 at 20:19 +0300, Dan Carpenter wrote:
> Hello Nicholas,
> 
> The patch b3fd3cce29bb: "tcm_qla2xxx: Add >= 24xx series fabric 
> module for target-core" from Mar 8, 2012, leads to the following Sparse
> warning:
> 
> drivers/scsi/qla2xxx/tcm_qla2xxx.c:843:37: warning: right shift by
> 	bigger than source value
> 
> +       domain = (nacl->nport_id >> 16) & 0xff;
>                         ^^^^^^^^
> nport_id is a u16 so this is always zero.
> 
> +       area = (nacl->nport_id >> 8) & 0xff;
> +       al_pa = nacl->nport_id & 0xff;
> 
> [snip]
> 
> +struct tcm_qla2xxx_nacl {
> +       /* From libfc struct fc_rport->port_id */
> +       u16 nport_id;
> 
> fc_rport->port_id is a u32.
> 
> 

Hi Dan,

Thanks for reporting.  Applying the following to lio-core, and will get
this squashed into for-next-merge soon.

Thanks!

--nab

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index c6acb80..df5374e 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -812,7 +812,7 @@ static int tcm_qla2xxx_setup_nacl_from_rport(
 
                p->se_nacl = se_nacl;
                pr_debug("Setting p->se_nacl to se_nacl: %p for WWNN: 0x%016LX,"
-                       " port_id: 0x%04x\n", se_nacl, rport_wwnn,
+                       " port_id: 0x%08x\n", se_nacl, rport_wwnn,
                        nacl->nport_id);
                spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 
@@ -856,7 +856,7 @@ void tcm_qla2xxx_clear_nacl_from_fcport_map(struct qla_tgt_sess *sess)
 
        p->se_nacl = NULL;
        pr_debug("Clearing p->se_nacl to se_nacl: %p for WWNN: 0x%016LX,"
-               " port_id: 0x%04x\n", se_nacl, nacl->nport_wwnn,
+               " port_id: 0x%08x\n", se_nacl, nacl->nport_wwnn,
                nacl->nport_id);
 }
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index e700c15..41730ed 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -10,7 +10,7 @@
 
 struct tcm_qla2xxx_nacl {
        /* From libfc struct fc_rport->port_id */
-       u16 nport_id;
+       u32 nport_id;
        /* Binary World Wide unique Node Name for remote FC Initiator Nport */
        u64 nport_wwnn;
        /* ASCII formatted WWPN for FC Initiator Nport */
