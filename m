Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC25C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B66772078B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CvSWq06V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgGIRrM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgGIRqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:13 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F701C08C5DD
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a6so6738467wmm.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0WOUOFAj8gaRXgS5sweCsL/cD71WeCkTEB0KFrBJobo=;
        b=CvSWq06VbUcXSRnwGyqDxlPEPhqHonrMdhFqWh5wU+7F2EYTLjHQmon8jTG/Er9Oga
         K9zUwv08GqGI/dj1oPeifOcYIJUghMnSKcrS62TjwBLdO1k87bxM6GqW44Lajy21s/2+
         jjgGm/VwZJohS57A+4L2J3n/28TOKy3ZZR+Df+H/y8p8nTeiLTKTW//YvdAc5Xpx793E
         Wc0sELO/g+ZCdC9NNbDx7kILpoBIOilGSVjBay+WBHB87FJrNLDzIE3Y4R2uae1Q360+
         zQmlM8Co6yVmfzXPDgcv+cWm3jlTn46fOJtRqf+/VD1MQQmbBkp4gZWa4SQiTSwFolS+
         Wbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0WOUOFAj8gaRXgS5sweCsL/cD71WeCkTEB0KFrBJobo=;
        b=i0yZGw+Vuddtq8DUP0jlcNOTctBXenFUa2W0O+MHWTL9Xo/eHyBzp08t50itU8NzVr
         qftDJtGw537j12JVoqYAjoqRqLPQGE/KyQm+4h5p0gYwIqeUrASoNDEwd3qUL0OYqAmL
         MrAUKC8BqaW09KCg1dZvjn03m+O9Uk1EEf8i5ZRsGqhIQDOwa+NE5qPRazOE6geP5jd0
         ibIs0ooh+NK7wwpcjGrx3m33XBpCiDKLcJfyd7W/avp2wsHY8tRMrW6PMomM20AqIFZj
         cYn5rTyVdd3/X/AgBYTR78Xziewj5+GR28QBPTb+uDkFy9c8w7qU7/agc0K1vas0UNnp
         ULLQ==
X-Gm-Message-State: AOAM533hGRpCApjf4/tELl4p2XH99VrX4ouSjBpzlkcACZzb+V14zaYp
        4q4/0AXunHzvO5kMi9uJS+22ow==
X-Google-Smtp-Source: ABdhPJw+UQAw1tDMHZVupmnJNtYCNeMbSVRrkvixR673N+nHXclQOrE9d9MM6uM6P20WxHqHRzGBvg==
X-Received: by 2002:a7b:cd10:: with SMTP id f16mr1169293wmj.86.1594316771965;
        Thu, 09 Jul 2020 10:46:11 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 12/24] scsi: virtio_scsi: Demote seemingly unintentional kerneldoc header
Date:   Thu,  9 Jul 2020 18:45:44 +0100
Message-Id: <20200709174556.7651-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the only use of kerneldoc in the sourcefile and no
descriptions are provided.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/virtio_scsi.c:109: warning: Function parameter or member 'vscsi' not described in 'virtscsi_complete_cmd'
 drivers/scsi/virtio_scsi.c:109: warning: Function parameter or member 'buf' not described in 'virtscsi_complete_cmd'

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0e0910c5b9424..56875467e4984 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -100,7 +100,7 @@ static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
 		scsi_set_resid(sc, resid);
 }
 
-/**
+/*
  * virtscsi_complete_cmd - finish a scsi_cmd and invoke scsi_done
  *
  * Called with vq_lock held.
-- 
2.25.1

