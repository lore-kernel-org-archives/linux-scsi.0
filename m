Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DBCBC04A95
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 00:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiIXAEL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 20:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiIXAEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 20:04:10 -0400
Received: from mail-ot1-x361.google.com (mail-ot1-x361.google.com [IPv6:2607:f8b0:4864:20::361])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F91132FD9
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 17:04:09 -0700 (PDT)
Received: by mail-ot1-x361.google.com with SMTP id h9-20020a9d5549000000b0063727299bb4so994596oti.9
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 17:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=D1FE9xU7+IExBeharNsuuKm6USBA72cJZvyRumUo6lk=;
        b=P+wibKWHbPDV3j1aCQ2zmWXvZDTdUojPLyO4UYCd9bwKAA5HArdf8MfQhOnlcA6Zc6
         B6WFuRjLTJ4S4rfYYFW2YGS4N8727UKFcuusoMf+j3VS7Zsp1vindYo4XRkGya3iulpB
         JcDemarIB8LIUyGycFc/F73eCwpkc2EE/ss7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=D1FE9xU7+IExBeharNsuuKm6USBA72cJZvyRumUo6lk=;
        b=13kEU15SxX2W5cHiNDz3iUsffGgQUdpRXmPVLBtUeVz3EcYvAVAkI3TqHqVFAYP7ux
         NvE8Qo4/GFPMCkpE6keIeo4RdB1IZUG6OPIPbcqEbDGkZx8hP1Er/3hr1Tybza8wILGF
         gSQgLo2kY4KsJqrpSoxJ1wXuzXtoKZ/o3sd1R2JdgAlbJC9m7taUHWmFLGEvrtYCqAzB
         dKMg7gp9hTf4bEYL+rzDTK8bFRJrsi0LxWO8BeFmGqi7SpXILjCAZBNV5RmVYaUj8DVo
         PHDPzHWmJ2iI9h2gBnzE4mpdSVnfxGGziV3WKYZ3P1lgvnfHn9BlCeQV4vidcAM0+YIy
         A4WA==
X-Gm-Message-State: ACrzQf1lbGnvyHwRDU6nT2sH0CTtN9vSHe2AWwqJPuY7TgEHbz0YAhcS
        sQUM7DYPF9q40XZDg6WyGUFZQH9NMGtbgGDcqoFU9g+FwuIGaQ==
X-Google-Smtp-Source: AMsMyM6a45o/3BJInsIISottjOwXWLGU0+EFr3EBl9lWiGE3EXu4GHsfBuosip2lhZuSNcE+OV3cHBF8YFiD
X-Received: by 2002:a9d:61c1:0:b0:65b:d7e7:aba9 with SMTP id h1-20020a9d61c1000000b0065bd7e7aba9mr5058453otk.148.1663977848373;
        Fri, 23 Sep 2022 17:04:08 -0700 (PDT)
Received: from c7-smtp.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id og1-20020a056870bd4100b0010c289bc8ffsm1026310oab.16.2022.09.23.17.04.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Sep 2022 17:04:08 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev-ushankar.dev.purestorage.com [10.7.70.36])
        by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id BF3A1221B3;
        Fri, 23 Sep 2022 18:04:07 -0600 (MDT)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
        id BAE35E40D52; Fri, 23 Sep 2022 18:04:07 -0600 (MDT)
From:   Uday Shankar <ushankar@purestorage.com>
To:     linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Uday Shankar <ushankar@purestorage.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH] restrict legal sdev_state transitions via sysfs
Date:   Fri, 23 Sep 2022 18:02:42 -0600
Message-Id: <20220924000241.2967323-1-ushankar@purestorage.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Userspace can currently write to sysfs to transition sdev_state to
RUNNING or OFFLINE from any source state. This causes issues because
proper transitioning out of some states involves steps besides just
changing sdev_state, so allowing userspace to change sdev_state
regardless of the source state can result in inconsistencies; e.g. with
iscsi we can end up with sdev_state == SDEV_RUNNING while the device
queue is quiesced. Any task attempting IO on the device will then hang,
and in more recent kernels, iscsid will hang as well. More detail about
this bug is provided in my first attempt:
https://groups.google.com/g/open-iscsi/c/PNKca4HgPDs/m/CXaDkntOAQAJ

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Suggested-by: Mike Christie <michael.christie@oracle.com>
---
Looking for feedback on the "allowed source states" list. The bug I hit
is solved by prohibiting transitions out of SDEV_BLOCKED, but I think
most others shouldn't be allowed either.

 drivers/scsi/scsi_sysfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9dad2fd5297f..b38c30fe681d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -822,6 +822,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	}
 
 	mutex_lock(&sdev->state_mutex);
+	switch (sdev->sdev_state) {
+	case SDEV_RUNNING:
+	case SDEV_OFFLINE:
+		break;
+	default:
+		mutex_unlock(&sdev->state_mutex);
+		return -EINVAL;
+	}
 	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
 		ret = 0;
 	} else {

base-commit: 7f615c1b5986ff08a725ee489e838c90f8197bcd
-- 
2.25.1

