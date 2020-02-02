Return-Path: <SRS0=QSS4=3W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD84C3524A
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 07:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74C92206D3
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Feb 2020 07:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cf2ItoUx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgBBHmA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Feb 2020 02:42:00 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6569 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgBBHl7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Feb 2020 02:41:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580629318; x=1612165318;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pVVPGA2WzFp5c3l0K1TYYcBXTEJeNaWFm/zchLzBFCA=;
  b=cf2ItoUxjL/xL5atC6sNmYyExmt6O8Y61bVb6i3w/+2F+FL24MLq9X2R
   MoJHhfniCgyr4E8KkwXzOOMTFuWH3dpnxBNXNdI6tCMKykM9siC0VyRIA
   bqMNcLc0zbeEXG8JbqLLrcUZHo9WGxBQlqFdV6r2irl61DiFp5RBMFgtf
   QIjU6BkLMK4l2wuR4n9TAwHpjaK89svnVgvrpeWp9hFOvXmclnNINqT94
   uSmT/aqw4GxXs3FSlvR1XuWr0kWafsXqCs2CeY42HjEWfPQ7JpzIm99wk
   +IoLQBN0hDBI/RtDXwIavLIWezMyjomJlCnEeyJYBPzVrvc1LBdWz2FHE
   A==;
IronPort-SDR: NqIJVL35WNHEZKQHDEvNvydj1asX/5Wz4FnqArP1S77by2vVlcwdeHpFstSuqDRimFvrXouUrr
 olFFvl+/gFafOmW02tNhABdQJjNzUW8fJMXUc96uQTfopreUvtYQ3mo4Itf8/VCnyYm2kgbv8r
 675lgZvP4bm3xPBBhRMQ9e5dpqWjL9IXksIs00reMfOmBC5zXf7nY7D0GvpIuxkbTt2qeinQrU
 rGruNABEftyRR7DbwQ/x7b5Ma4pB0sMiWI0OwYFYhUCEyei/vrIS2faEoOdHVZwvRylVhsasE0
 HXw=
X-IronPort-AV: E=Sophos;i="5.70,393,1574092800"; 
   d="scan'208";a="130383374"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2020 15:41:58 +0800
IronPort-SDR: kVRhrivDNyWmctJ7DiyIRuqWW6r25YYHWhxBiNlXdcdtMduKbMrEKvVyofYSHxMm+8p/jknHNs
 4m8kYwK1LWhAkMNRkxR9zdJagA0KHBd0sRaC+mCIWXISZvcYYtyWpKXGdJrTqR+F5u9HIQCNTO
 9JuhDxaBe4UcqN/+GF4AVUfl3LZ9/foik5Xw82ozm6v+eO57SMhc+BEBKsQPeEdvtscZze1TUa
 rA8as9wwQCtBD/m+M9avwC7HPe1GcOddtG3rYP8byc1zR+vr1uHDEzrfpbSgWlo8mPA8drTcSh
 phmLAQRudniqNwdwLY32xGRm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 23:35:04 -0800
IronPort-SDR: ZVz61PXsm9VRyiyyjzqEdOLP5A/vwyBDKs5tpCxcDi22TnzcIv8ggkvRmR2eFoiVjXZBMEuXlo
 eQ6szzpkt+ZK1+rjPyzmAcxk2jhX2Hm39YchMFpDK84li39yCV13/enjT7/hE2JVZ3+Fj0Ec5Q
 rceIKf3Jxs9Y5tE+Yfs61RPetgChKCCFkfxF6nMMCC8Zmbed6OJK7Jx1Hd5QUcadvCzOSDIBHG
 JbY6gVReRZ8AlVEzr+MWu+qmg7xBDApVNBe6W41+3wYrrAlWNaYT5Soad5JFELTj/7GJ8Pcvb1
 9ug=
WDCIronportException: Internal
Received: from kfae419068.sdcorp.global.sandisk.com ([10.0.231.195])
  by uls-op-cesaip02.wdc.com with ESMTP; 01 Feb 2020 23:41:56 -0800
From:   Avi Shchislowski <avi.shchislowski@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Avi Shchislowski <avi.shchislowski@sandisk.com>
Subject: [PATCH 0/5] scsi: ufs: ufs device as a temperature sensor
Date:   Sun,  2 Feb 2020 09:41:48 +0200
Message-Id: <1580629313-20078-1-git-send-email-avi.shchislowski@wdc.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Avi Shchislowski <avi.shchislowski@sandisk.com>

UFS3.0 allows using the ufs device as a temperature sensor. The
purpose of this feature is to provide notification to the host of the
UFS device case temperature. It allows reading of a rough estimate
(+-10 degrees centigrade) of the current case temperature, And
setting a lower and upper temperature bounds, in which the device
will trigger an applicable exception event.

We added the capability of responding to such notifications, while
notifying the kernel's thermal core, which further exposes the thermal
zone attributes to user space. UFS temperature attributes are all
read-only, so only thermal read ops (.get_xxx) can be implemented.

Avi Shchislowski (5):
  scsi: ufs: Add ufs thermal support
  scsi: ufs: export ufshcd_enable_ee
  scsi: ufs: enable thermal exception event
  scsi: ufs-thermal: implement thermal file ops
  scsi: ufs: temperature atrributes add to ufs_sysfs

 drivers/scsi/ufs/Kconfig       |  11 ++
 drivers/scsi/ufs/Makefile      |   1 +
 drivers/scsi/ufs/ufs-sysfs.c   |   6 +
 drivers/scsi/ufs/ufs-thermal.c | 247 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-thermal.h |  25 +++++
 drivers/scsi/ufs/ufs.h         |  20 +++-
 drivers/scsi/ufs/ufshcd.c      |   9 +-
 drivers/scsi/ufs/ufshcd.h      |  12 ++
 8 files changed, 329 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-thermal.c
 create mode 100644 drivers/scsi/ufs/ufs-thermal.h

-- 
1.9.1

