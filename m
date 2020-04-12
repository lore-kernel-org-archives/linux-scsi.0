Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D868EC2BB55
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF5A32073E
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:34:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IN5KQ1tO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgDLDeH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:34:07 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33987 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgDLDeF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:34:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id v23so3006786pfm.1
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iXCriI9UNfyPknMKRh+gL/erVdk1xHZUT03YG/h+oL4=;
        b=IN5KQ1tOM23P0gUEEOudEK2IB4b7dHitpi1MHpWJya8eHY1ZRkz3taQONor7ryuTZ5
         sYTm5omfMAjKIOeiTQqHruJ6jajqqWfEd06P2YEmn+UCuPV0ruVs89L0Bb4NqyFi2YAb
         POv1P2AEBa3dMWIKklvk7tofUTHwh7aPNKncD6VVrJ/vU4R0KjtYyAUK2uJSBlk9Eipn
         Ha0pjmnhUBWenR+BDea4H3yK6SevJo8znbYsm0iSjNnp8QrVg5J0gEBU0U8W68MvuBoq
         DY+mjNXsCVPhZQz5IF2RpSI5AqrE/FAJUHDjrzlGkADspRAivyyCn0USloQexe+g7BCJ
         kIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iXCriI9UNfyPknMKRh+gL/erVdk1xHZUT03YG/h+oL4=;
        b=p6Y7jqx7EUQnRY713ihENY57xXQJM1Btn/m6R7EXl51xpscTgCKv0CImXdAe+RjfdK
         3jMXrDl+esEIllhSfcHdVT/Y8hxcXPtEYS7VHGtxPf1CUsLruvh6BhqmjN/yY49hT5tm
         lRWmQ7o9ww/PJeUQV/lIRUWSTS0GBEKbYjYLPmH2ph3PlGPNy5ipez2dYN068WuRW8QS
         Re1uv3nGxmHekFtIAP3qWuPIBI3jyWC45gPx2K2yaD7Oy0pJ9C/8ZdQp4vuI6VL7DP6v
         uFlF6C5sBaUF/n3hns53abPafH15PDCNcc+/0py2/GkY3KVhc3idoarmjdTi2YYRrOwE
         wo1w==
X-Gm-Message-State: AGi0PuavYsTm8M79S0LMK0BwLdG5sBscxtZyqevyYQFH3RAFcNMbL/ae
        I8EXZK5CwIUM23U8MTW79y6185z6
X-Google-Smtp-Source: APiQypLO39BIM4NDQ6z+Vr0YbxowI2JzWXSwTyhaPzrDBwRcGJUTmnxJGGfAC8asBN31O4lBiwY/uQ==
X-Received: by 2002:a63:a70b:: with SMTP id d11mr11408991pgf.358.1586662444615;
        Sat, 11 Apr 2020 20:34:04 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.34.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:34:03 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 31/31] elx: efct: Tie into kernel Kconfig and build process
Date:   Sat, 11 Apr 2020 20:33:03 -0700
Message-Id: <20200412033303.29574-32-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200412033303.29574-1-jsmart2021@gmail.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This final patch ties the efct driver into the kernel Kconfig
and build linkages in the drivers/scsi directory.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/Kconfig  | 2 ++
 drivers/scsi/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index b5be6f43ec3f..e476eaad6f49 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1168,6 +1168,8 @@ config SCSI_LPFC_DEBUG_FS
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
+source "drivers/scsi/elx/Kconfig"
+
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on EISA && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index c00e3dd57990..844db573283c 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
 obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
+obj-$(CONFIG_SCSI_EFCT)		+= elx/
 obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_CHELSIO_FCOE)	+= csiostor/
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
-- 
2.16.4

