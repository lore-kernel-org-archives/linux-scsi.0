From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH 3/3] tcm_qla2xxx: Expose per endpoint dynamic_sessions
 attribute
Date: Tue, 10 Mar 2015 04:50:44 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D0194155AB1@AVMB1.qlogic.org>
References: <1425706029-2436-1-git-send-email-nab@daterainc.com>
 <1425706029-2436-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1425706029-2436-3-git-send-email-nab@daterainc.com>
Content-Language: en-US
Content-ID: <B8FE54DC1AE09E428A559AEFF87ADCBB@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>

Thanks,
~Saurav

>From: Nicholas Bellinger <nab@linux-iscsi.org>
>
>This patch exposes a new ../qla2xxx*/$WWPN/$TPGT/dynamic_sessions
>attribute to dump the currently active sessions by FC initiator WWPN
>that have been created with dynamically generated se_node_acls.
>
>This information is useful so that user-space can optionally perform
>dynamic -> explicit NodeACL conversion based on $INITIATOR_WWPN.
>
>Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
>---
> drivers/scsi/qla2xxx/tcm_qla2xxx.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)
>
>diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>index 99f43b7..c4f66f5 100644
>--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>@@ -1082,8 +1082,18 @@ static ssize_t tcm_qla2xxx_tpg_store_enable(
> 
> TF_TPG_BASE_ATTR(tcm_qla2xxx, enable, S_IRUGO | S_IWUSR);
> 
>+static ssize_t tcm_qla2xxx_tpg_show_dynamic_sessions(
>+	struct se_portal_group *se_tpg,
>+	char *page)
>+{
>+	return target_show_dynamic_sessions(se_tpg, page);
>+}
>+
>+TF_TPG_BASE_ATTR_RO(tcm_qla2xxx, dynamic_sessions);
>+
> static struct configfs_attribute *tcm_qla2xxx_tpg_attrs[] = {
> 	&tcm_qla2xxx_tpg_enable.attr,
>+	&tcm_qla2xxx_tpg_dynamic_sessions.attr,
> 	NULL,
> };
> 
>-- 
>1.9.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
