From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: [PATCH] target: Remove unused variable
Date: Tue, 15 Feb 2011 21:02:27 +0100
Message-ID: <AANLkTikxd4QeKjFhBAWbH6fqo2ef0xZQLQEgtB3Mj0rk@mail.gmail.com>
References: <AANLkTi=dHh9Ombj=ZgA4AnPUyD3qo9kcr8z7UbXce-Or@mail.gmail.com>
	<1297725129.29207.34.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1BOUC1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2011 15:02:27 -0500
Received: by iyj8 with SMTP id 8so431983iyj.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2011 12:02:27 -0800 (PST)
In-Reply-To: <1297725129.29207.34.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Feb 15, 2011 at 12:12 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> The usage of ref_cmd here will be used in for-39 code, so this should be
> kept in place for now..

I'm curious to see it.

Does the patch below make sense ? It removes an unused argument from
transport_get_lun_for_cmd().

diff --git a/drivers/target/target_core_device.c
b/drivers/target/target_core_device.c
index 5da051a..53f31fd 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -56,7 +56,6 @@ static void se_dev_stop(struct se_device *dev);

 int transport_get_lun_for_cmd(
 	struct se_cmd *se_cmd,
-	unsigned char *cdb,
 	u32 unpacked_lun)
 {
 	struct se_dev_entry *deve;
diff --git a/include/target/target_core_device.h
b/include/target/target_core_device.h
index 52b18a5..d9745bf 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -1,7 +1,7 @@
 #ifndef TARGET_CORE_DEVICE_H
 #define TARGET_CORE_DEVICE_H

-extern int transport_get_lun_for_cmd(struct se_cmd *, unsigned char *, u32);
+extern int transport_get_lun_for_cmd(struct se_cmd *, u32);
 extern int transport_get_lun_for_tmr(struct se_cmd *, u32);
 extern struct se_dev_entry *core_get_se_deve_from_rtpi(
 					struct se_node_acl *, u16);
