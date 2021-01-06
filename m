Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD5CC43381
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 821E922EBF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 04:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbhAGEwc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 23:52:32 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:51640 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbhAGEwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 23:52:31 -0500
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id D892D398D2;
        Wed,  6 Jan 2021 20:41:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com D892D398D2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609994520;
        bh=Xu35SRAGm2m+0ciX4ibXhSngucaM0nXut76Py/7apMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mR6ezSk4364HkT8JXoTXLRvBGKaQawERREwWe3j2qJ8eu+ncvFf6rpnrf2mvqNOcd
         FgHVwFdV2RMyHXIvjQoOl8RlwFckKIZfvzq9tXwvvhOIjX2x5gT4GoqjGeUL3brJvm
         6CH172Tho4WZhIAf3sIymh11D3trrKwyAyaQTTAg=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v8 4/5] scsi_transport_fc: Added store fucntionality to set the rport port_state using sysfs
Date:   Thu,  7 Jan 2021 03:19:07 +0530
Message-Id: <1609969748-17684-5-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1609969748-17684-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Added a store functionality to set rport port_state using sysfs
under  fc_remote_ports/rport-*/port_state

With this functionality the user can move the port_state from
Marginal -> Online and Online->Marginal.

On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
scmd->state for all the pending io's on the scsi device associated
with target port.

On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
scmd->state for all the pending io's on the scsi device associated
with target port.

Below is the interface provided to set the port state to Marginal
and Online.

echo "Marginal" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
echo "Online" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v8:
Rebased the patches on top of 5.11-rc2

v7:
No change

v6:
No change

v5:
No change

v4:
Addressed the error reported by kernel test robot
Removed the code needed to traverse all the devices under rport
to set/clear SCMD_NORETRIES_ABORT
Removed unncessary comments.
Return the error values on failure while setting the port_state

v3:
Removed the port_state from starget attributes.
Enabled the store functionality for port_state under remote port.
used the starget_for_each_device to traverse around all the devices
under rport

v2:
Changed from a noretries_abort attribute under fc_transport/target*/ to
port_state for changing the port_state to a marginal state
---
 drivers/scsi/scsi_transport_fc.c | 56 ++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index ffd25195ae62..d378ca4a60fe 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1238,7 +1238,59 @@ show_fc_rport_roles (struct device *dev, struct device_attribute *attr,
 static FC_DEVICE_ATTR(rport, roles, S_IRUGO,
 		show_fc_rport_roles, NULL);
 
-fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
+static ssize_t fc_rport_set_marginal_state(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+	enum fc_port_state port_state;
+	int ret = 0;
+
+	ret = get_fc_port_state_match(buf, &port_state);
+	if (ret)
+		return -EINVAL;
+	if (port_state == FC_PORTSTATE_MARGINAL) {
+		/*
+		 * Change the state to marginal only if the
+		 * current rport state is Online
+		 * Allow only Online->marginal
+		 */
+		if (rport->port_state == FC_PORTSTATE_ONLINE)
+			rport->port_state = port_state;
+		else
+			return -EINVAL;
+	} else if (port_state == FC_PORTSTATE_ONLINE) {
+		/*
+		 * Change the state to Online only if the
+		 * current rport state is Marginal
+		 * Allow only  MArginal->Online
+		 */
+		if (rport->port_state == FC_PORTSTATE_MARGINAL)
+			rport->port_state = port_state;
+		else
+			return -EINVAL;
+	} else
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t
+show_fc_rport_port_state(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	const char *name;
+	struct fc_rport *rport = transport_class_to_rport(dev);
+
+	name = get_fc_port_state_name(rport->port_state);
+	if (!name)
+		return -EINVAL;
+
+	return snprintf(buf, 20, "%s\n", name);
+}
+
+static FC_DEVICE_ATTR(rport, port_state, 0444 | 0200,
+			show_fc_rport_port_state, fc_rport_set_marginal_state);
+
 fc_private_rport_rd_attr(scsi_target_id, "%d\n", 20);
 
 /*
@@ -2681,7 +2733,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
-	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(port_state);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
 
-- 
2.26.2

