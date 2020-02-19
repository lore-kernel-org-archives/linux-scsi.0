Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931F8C34047
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 16:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 705252464E
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 16:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgBSQwU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 11:52:20 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:52941 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgBSQwU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 11:52:20 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M8QFi-1j8sQZ3yPg-004Vt0; Wed, 19 Feb 2020 17:51:52 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Adam Williamson <awilliam@redhat.com>,
        Chris Murphy <bugzilla@colorremedies.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Waugh <tim@cyberelk.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] compat_ioctl, cdrom: Replace .ioctl with .compat_ioctl in four appropriate places
Date:   Wed, 19 Feb 2020 17:50:07 +0100
Message-Id: <20200219165139.3467320-1-arnd@arndb.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:s83bO8mKDR7xliqovCqp1GmWzEogAJvpGM54ZuLLH4pmNDsLTFY
 ZxQUDSrXrb28nM+9drVbtrJ8MxqeW1pcICoxq0M2y+aB7qvD7iMDpcHWlECDzZL3mhdhI8K
 BS8BYAcJqRI2ZWDXrlXqDDTO/DjF/Q05SjUWe1SBIBOeT7W12CpXurHmSTHy5X5VVQQIUtO
 bOHv7lVkw7ikMgz7kiz/w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6qcWV+qWiLI=:kjXIiUB/VicY7yGRA7ziGY
 1kANGtrqCMHfXJf786bqSJ4WFSALkZjbMLtINIV4T+vxgzLgP14+/+o87XoB8AVtCbsM8kSU2
 JI4f2MPP0HNWgn+2LpS3cLb7xghKtlFrZesE8ZoHQdrwNQA8TYnwo7i8iyWT9HB/jOsfGV3LL
 44C+RdOO+cVWTpSTxrIQlkh0FqrhHoevLjCx+9RY95AdV8S2y5F34wcsWwJ6ip0PT5kuzV6Il
 hzgefpeFTffFB3QgfQolJedi0HJGGr8LxI0ncuaVgWICAk3xBtKfPuNevbrVXP4lsI1AM8hgF
 e+AIJYY4vi0qSKjKANRQ/QT0Dx71Txo5/LLy3/UAuJTwirsg+AcLyZvPJMm64+1WptLr3b6BF
 RKNkDnFWVixEY95EGsfpmnYdt9NeK0dbodW6RUy81Q/jnEPU2MGfTAu1tIbqmB2W35IXC6DuF
 podvY+5Xxnq/2Q2vk9VqoBFXvehS9LY6pj6EZ5yEWpyT7NauOEat01WVpSczGhPHXHnEN/3h6
 aKIueqLHBKpGHnXYIjiuy2iGxQsibiG/eLbSbcBMKwYVdRWRbqcnHP4Kq9GTyLwL4dTE5USZi
 aPOlnrKGSAjB/LMbVO4F7dN1KG6ykrsF2HvXh7QxFP6Q1NvKuZte5cMMhgj1N8BSC4ARzLYxv
 LBdyXTSwHlhJGZV+d1tLgWwyR1mZFiTy0jP5n1sx42z9DwEe1XaujjxQN57RcT2S93y3Qj0Ky
 rm7R3B5pUNK3kdNFswGHNan0hA50VY7ikJxsHyKcBI69ebqUEeCdCLq1mGBHTdpDNsPeiCTQE
 1WnDQxC7sbtImKsPybVj6QylWejuYsNDlTlTBj14+wohn9SOzM=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Adam Williamson <awilliam@redhat.com>

Arnd Bergmann inadvertently typoed these in d320a9551e394 and
64cbfa96551a; they seem to be the cause of
https://bugzilla.redhat.com/show_bug.cgi?id=1801353 , invalid
SCSI commands when udev tries to query a DVD drive.

[arnd] Found another instance of the same bug, also introduced
in my compat_ioctl series.

Fixes: d320a9551e39 ("compat_ioctl: scsi: move ioctl handling into drivers")
Fixes: 64cbfa96551a ("compat_ioctl: move cdrom commands into cdrom.c")
Fixes: c103d6ee69f9 ("compat_ioctl: ide: floppy: add handler")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1801353
Bisected-by: Chris Murphy <bugzilla@colorremedies.com>
Signed-off-by: Adam Williamson <awilliam@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/block/paride/pcd.c | 2 +-
 drivers/cdrom/gdrom.c      | 2 +-
 drivers/ide/ide-gd.c       | 2 +-
 drivers/scsi/sr.c          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 117cfc8cd05a..cda5cf917e9a 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -276,7 +276,7 @@ static const struct block_device_operations pcd_bdops = {
 	.release	= pcd_block_release,
 	.ioctl		= pcd_block_ioctl,
 #ifdef CONFIG_COMPAT
-	.ioctl		= blkdev_compat_ptr_ioctl,
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 #endif
 	.check_events	= pcd_block_check_events,
 };
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 886b2638c730..c51292c2a131 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -519,7 +519,7 @@ static const struct block_device_operations gdrom_bdops = {
 	.check_events		= gdrom_bdops_check_events,
 	.ioctl			= gdrom_bdops_ioctl,
 #ifdef CONFIG_COMPAT
-	.ioctl			= blkdev_compat_ptr_ioctl,
+	.compat_ioctl		= blkdev_compat_ptr_ioctl,
 #endif
 };
 
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 1bb99b556393..05c26986637b 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -361,7 +361,7 @@ static const struct block_device_operations ide_gd_ops = {
 	.release		= ide_gd_release,
 	.ioctl			= ide_gd_ioctl,
 #ifdef CONFIG_COMPAT
-	.ioctl			= ide_gd_compat_ioctl,
+	.compat_ioctl		= ide_gd_compat_ioctl,
 #endif
 	.getgeo			= ide_gd_getgeo,
 	.check_events		= ide_gd_check_events,
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0fbb8fe6e521..e4240e4ae8bb 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -688,7 +688,7 @@ static const struct block_device_operations sr_bdops =
 	.release	= sr_block_release,
 	.ioctl		= sr_block_ioctl,
 #ifdef CONFIG_COMPAT
-	.ioctl		= sr_block_compat_ioctl,
+	.compat_ioctl	= sr_block_compat_ioctl,
 #endif
 	.check_events	= sr_block_check_events,
 	.revalidate_disk = sr_block_revalidate_disk,
-- 
2.25.0

