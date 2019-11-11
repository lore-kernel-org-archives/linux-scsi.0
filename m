Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C486C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 17:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDE2D20818
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 17:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfKKRsv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:48:51 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42586 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfKKRsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 12:48:51 -0500
Received: by mail-pf1-f195.google.com with SMTP id s5so11129548pfh.9
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2019 09:48:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5UMgjZygVeIUQEPX/5GgBbdfkQ/h7fhHpH3rSCKfmU=;
        b=ECnP2SFGUtvL9rJQIeODMFkj9AptkacXjUJC8j8uDrpM79Ory8u4XLyVv78y5oVw7s
         UA/Hz/U1LyDNEu3/CdzkkUYwNd5GbFObTnttFS4iu5LGLEi4YwwtFXMWu/R/tN7G4OfQ
         b6BxzUASRvaSBZaHyTzG1mHp1b3pEKfho2OqYwGBNkWvNrEExC/y6XoJjcKlv4RZKEbH
         3yTd7KucQntSi8aOdC8iDlioXCt1x28TaAK4gFStYPjKktc4XTH1+kDxbrFuY0+DSZll
         AWaBmKZuH6AnipEZubeB/4lwERE90i3NoOrRhyIDwQY9FTm9qGPINTo0gs1SF02ERzfI
         L0Ig==
X-Gm-Message-State: APjAAAVHfVKXZdrEynO8qswff+45vHHWbIx8jEJMN4kIZwDyE7IRBdy4
        rtcsk9rBNuuFDyJUusm2FJk=
X-Google-Smtp-Source: APXvYqxPvRNZyNZV6iP5OypoXBfnCPz3I3wFAUtuLIujqV+SHr540a8VHinTMKAn2s/vmtFm0+8ZIg==
X-Received: by 2002:a17:90a:e651:: with SMTP id ep17mr306940pjb.74.1573494528902;
        Mon, 11 Nov 2019 09:48:48 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p123sm18126763pfg.30.2019.11.11.09.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 09:48:47 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     Bean Huo <beanhuo@micron.com>, Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/3] Simplify and optimize the UFS driver
Date:   Mon, 11 Nov 2019 09:48:38 -0800
Message-Id: <20191111174841.185278-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin,

This patch series that simplifies and optimizes the UFS driver. Please consider
this patch series for kernel v5.5.

Thanks,

Bart.

Changes compared to v3:
- Left out "scsi" from the name of the functions that suspend and resume
  command processing.

Changes compared to v2:
- Use a separate tag set for TMF tags.

Changes compared to v1:
- Use the block layer tag infrastructure for managing TMF tags.

Bart Van Assche (3):
  ufs: Avoid busy-waiting by eliminating tag conflicts
  ufs: Use blk_{get,put}_request() to allocate and free TMFs
  ufs: Simplify the clock scaling mechanism implementation

 drivers/scsi/ufs/ufshcd.c | 384 +++++++++++++++++---------------------
 drivers/scsi/ufs/ufshcd.h |  21 +--
 2 files changed, 173 insertions(+), 232 deletions(-)
