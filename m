From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: tcm_qla2xxx Add SCSI command jammer/discard capabilty to the
 tcm_qla2xxx module - revision4
Date: Sat, 02 Apr 2016 16:39:35 -0700
Message-ID: <1459640375.13184.14.camel@haakon3.risingtidesystems.com>
References: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com>
	 <56FB5E98.9010103@sandisk.com>
	 <1459402453.31390.45.camel@haakon3.risingtidesystems.com>
	 <3F517A19-EDA5-4B16-B103-C3F38242F8D8@qlogic.com>
	 <1049122887.26432420.1459534525185.JavaMail.zimbra@redhat.com>
	 <1615130599.26684873.1459613094650.JavaMail.zimbra@redhat.com>
	 <363538615.26701710.1459617008813.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <363538615.26701710.1459617008813.JavaMail.zimbra@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hi Laurence,

On Sat, 2016-04-02 at 13:10 -0400, Laurence Oberman wrote:
> Hello Himanshu
> 
> I noticed a typo in the patch I submitted here is the corrected patch.
> Please ignore the prior patch
> 
> I was missing the full CONFIG name in the #ifdef check 
> 
> Corrected Patch

Two quick process related comments:

Please avoid top-posting responses, as it makes the thread more
difficult for others to follow.

Also, please send out kernel patches for list review using
git-format-patch + git-send-email tools, instead of responding with new
versions in the original email thread.

> 
> [root@localhost home]# linux-4.5/scripts/checkpatch.pl jammer_patch.v4
> total: 0 errors, 0 warnings, 81 lines checked
> 
> jammer_patch.v4 has no obvious style problems and is ready for submission.
> 
> 
> This patch was reworked to only include the jammer code if the parameter TCM_QLA2XXX_DEBUG=Y is set.
> The default is to not provide this functionality at all.
> I looked at using attributes but this code is in the fastpath and the overhead or fetching the attribute
> each time is not a good idea.
> Control of this needs to be dynamic and the module parameter allows a simple compare in the fastpath.
> 

I don't see how a per tcm_qla2xxx (scsi_qla_host) TPG endpoint attribute
has any noticeable performance impact with TCM_QLA2XXX_DEBUG=y vs. a
global module parameter doing scsi_qla_host->host_no comparison.

Eg, have you tried something like the following..?

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index c1461d2..3b13a89a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -477,6 +477,17 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_c
                return -EINVAL;
        }
 
+#ifdef CONFIG_TCM_QLA2XXX_DEBUG
+       {
+       struct se_portal_group *se_tpg = se_sess->se_tpg;
+       struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+                               struct tcm_qla2xxx_tpg, se_tpg);
+
+       if (tpg->tpg_attrib.jam_host)
+               return 0;
+
+       }
+#endif
        cmd->vha->tgt_counters.qla_core_sbt_cmd++;
        return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
                                cmd->unpacked_lun, data_length, fcp_task_attr,
@@ -845,12 +856,19 @@ DEF_QLA_TPG_ATTRIB(demo_mode_write_protect);
 DEF_QLA_TPG_ATTRIB(prod_mode_write_protect);
 DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
 
+#ifdef CONFIG_TCM_QLA2XXX_DEBUG
+DEF_QLA_TPG_ATTRIB(jam_host);
+#endif
+
 static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] = {
        &tcm_qla2xxx_tpg_attrib_attr_generate_node_acls,
        &tcm_qla2xxx_tpg_attrib_attr_cache_dynamic_acls,
        &tcm_qla2xxx_tpg_attrib_attr_demo_mode_write_protect,
        &tcm_qla2xxx_tpg_attrib_attr_prod_mode_write_protect,
        &tcm_qla2xxx_tpg_attrib_attr_demo_mode_login_only,
+#ifdef CONFIG_TCM_QLA2XXX_DEBUG
+       &tcm_qla2xxx_tpg_attrib_attr_jam_host,
+#endif
        NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 3bbf4cb..37e026a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -34,6 +34,7 @@ struct tcm_qla2xxx_tpg_attrib {
        int prod_mode_write_protect;
        int demo_mode_login_only;
        int fabric_prot_type;
+       int jam_host;
 };
 
 struct tcm_qla2xxx_tpg {
