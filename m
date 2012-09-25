From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] aic94xx: fix handling of default CTRL-A settings
Date: Tue, 25 Sep 2012 14:07:39 +0200
Message-ID: <1348574859.1436.38.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1156 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077Ab2IYMHm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2012 08:07:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Compiling aic94xx_sds.o (part of the aic94xx driver) triggers this GCC
warning:
    drivers/scsi/aic94xx/aic94xx_sds.c: In function 'asd_read_flash':
    drivers/scsi/aic94xx/aic94xx_sds.c:597:21: warning: 'offs' may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/scsi/aic94xx/aic94xx_sds.c:985:6: note: 'offs' was declared here

This warning can be traced back to asd_find_flash_de(). If it fails to
find a FLASH_DE_CTRL_A_USER entry it will return without setting 'offs'.
And that will leave 'offs' uninitialized when asd_read_flash_seg() is
called a little later.

But that call of asd_read_flash_seg() isn't needed in that case.
Everything this code cares about can already be found in the "default
CTRL-A user settings section" that was created in the error path. So
let's just jump over that call (and all other unneeded code) after
creating that section.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed this warning while building v3.6-rc7 on current Fedora
17, using Fedora's default config.

1) Compile tested only. It might be best to run test this too, if only
to test whether the non-error path is unaffected.

2) This piece of code has not been touched ever since it was added in
v2.6.19, with commit 2908d778ab3e244900c310974e1fc1c69066e450 ("[SCSI]
aic94xx: new driver"). So, given the current code, chances are that a
"CTRL-A user settings section" is always present and the code to create
a default section might as well be dropped. So perhaps a more drastic
patch is preferable.

 drivers/scsi/aic94xx/aic94xx_sds.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index edb43fd..ecb4a1c 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -983,7 +983,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 {
 	int err, i;
 	u32 offs, size;
-	struct asd_ll_el *el;
+	struct asd_ll_el *el = NULL;
 	struct asd_ctrla_phy_settings *ps;
 	struct asd_ctrla_phy_settings dflt_ps;
 
@@ -1004,6 +1004,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 
 		size = sizeof(struct asd_ctrla_phy_settings);
 		ps = &dflt_ps;
+		goto ctrla_phy_settings;
 	}
 
 	if (size == 0)
@@ -1029,6 +1030,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 		goto out2;
 	}
 
+ctrla_phy_settings:
 	err = asd_process_ctrla_phy_settings(asd_ha, ps);
 	if (err) {
 		ASD_DPRINTK("couldn't process ctrla phy settings\n");
-- 
1.7.11.4

