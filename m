Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0ACAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 05:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239331AbhKZFUv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbhKZFSu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 00:18:50 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9164C061574;
        Thu, 25 Nov 2021 21:15:38 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id h63so7106765pgc.12;
        Thu, 25 Nov 2021 21:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z01gsFHGTnCRQyJePRSWxEv8bkUY4nc7ReFN3WH9M/Q=;
        b=orABTColjaSfkLaqgQYJkATAfvPURwPeBXzmboNQiZB/vLeD+7nv9/wyaFg/3BgXLO
         SFA3U7gaqVZv8cqsxGB9TpX6x9Ic5fMGrWGVOqEV7SMpibqSLt3xoETy6KYHNWowWjbR
         /DRLRM8HHo6R7XFRpmkda/t9zY+CnjwfXzH2NKdnShXiNi6lWEp2Mco4iQNr/xTHnaG4
         JeaIwhKVMNZYhNkTOoyAt6s49W7K4fGrgmCgPknPaRIDOV+WO9LE56+SN4iD2ee6ivZz
         ivHtMB2nBuDdLhscMPi2Fx8rznNl1MyLX+zdz/pSUQVBbt5Z/TkboPDTp4xaOXFf5P3z
         XjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z01gsFHGTnCRQyJePRSWxEv8bkUY4nc7ReFN3WH9M/Q=;
        b=Bg+sZjmLpdREVb578t/FsBe74O4KGFOSnRkNt2fh8eup7jTrKQf/xYOvPCYwIIaJwP
         zdj6XqSQooDNnhxzW6IITcr8aa2bj/rIKYHUQkHdBG3Mb99KaLSdapYNKGl3bFd62vNY
         C4Spd+56WRsrL6KrxIrA2lkrcN8QJl39gBXPqoMgmKoUYkrwvbjsVsUoY2LKErvnyr33
         VFwbmzPzpsBicW4pIICHe6MbVHpcw60UC+dndh8iea2LGF50lCUWWkE2WAd3cWX/7JIx
         14obTUpOdANK5ovjBid31SylnSPAg615+/knGRYqCbpcFu7BlZTAwPJhIegorx0YF6sz
         w0Vw==
X-Gm-Message-State: AOAM533dNa7waKALWQ6v6VbrzaJKoaklDA8tos6SYtg4A+JmzQHgwHg6
        rrHGsEQUyl4yoviwezXUOkQPMS7V7/w+hg==
X-Google-Smtp-Source: ABdhPJwuS/Y5C14NKMg5q5qErbb1EWrz3Vph1jvcJ03JDam7IMaSlrJSGMBdJJ+dG1rsnFSNr3bW1w==
X-Received: by 2002:a05:6a00:1a8e:b0:49f:a4a9:8f1e with SMTP id e14-20020a056a001a8e00b0049fa4a98f1emr18573914pfv.67.1637903737884;
        Thu, 25 Nov 2021 21:15:37 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id lb4sm10326377pjb.18.2021.11.25.21.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 21:15:37 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com (supporter:QLOGIC QL41xxx ISCSI
        DRIVER), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:QLOGIC QL41xxx ISCSI DRIVER)
Subject: [PATCH 0/2] scsi: qedi: Couple of warning fixes
Date:   Thu, 25 Nov 2021 21:15:27 -0800
Message-Id: <20211126051529.5380-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These warnings started to show up after enabling PCI on BMIPS (32-bit
MIPS architecture) and were reported by the kbuild robot.

I don't know whether they are technically correct, in particular the
unused 'page' variable might be unveiling a genuine bug whereby it
should have been used. Please review.

Florian Fainelli (2):
  scsi: qedi: Remove set but unused 'page' variable
  scsi: qedi: Fix SYSFS_FLAG_FW_SEL_BOOT formatting

 drivers/scsi/qedi/qedi_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

-- 
2.25.1

