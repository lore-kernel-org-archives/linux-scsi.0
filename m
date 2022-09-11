Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DABDC6FA8A
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiIKWPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiIKWP2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:28 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEE317E24
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:23 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id j1so5495818qvv.8
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=LtqRw6AUxLtc0YPMeMIUJga063P0I2Zv0hMnS+ZtVuU=;
        b=oqzOG+TL4iE8GZ3xOigWKYUG2D0LwejUw4TJszaVsEYyKKrmkbn8dRbOLiSB7PzImA
         hO42TzAmC0g1NjdioggUo7+bjyKdnQQmlgTDzDhqYSdzteWQZ7gOSikzK8SuVJbNui0Z
         PRxqN+kUe7eHo7n8sc6er6mfV6qTEzNwsIEs8kPNgAz3u+CPGYs5UmYcXgzflJ4y5Tcu
         ofy7W7hpM9jHnRvHP9ahXq4ELISPElWZg2IzhfjHNdCKxmXD9vuWimp1kpYaqZqFeasf
         BcxrC5QpLl0clsH5OrPHK85y3ubDpRAu6KtBUp+txQRpl4wP+XGCeK46LUdEZ+08BYrO
         o7Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LtqRw6AUxLtc0YPMeMIUJga063P0I2Zv0hMnS+ZtVuU=;
        b=vRjsjcsbgt/NUajv8N0gy7G0Xu+yj346oE78e+JdWQzIj7KcAe7N5Nbw7wQsyBNGXe
         aLwdOnTDAbG99Z6yKHTlTFP+cqcuYedhLAts+uWOPm6IwzD3GjEWBqIKcYowSiYWflfv
         QQ/oo9xo1arbzCzUzNfG8RKEy/W5Dilq0YWIvtdlbaJ9sqHPcYH/KEtrQ/twyzm+ucG8
         gcaxDS2nOHl1fRMRJj/huUxyeq8sxtozcWwLW/SXrwiyPzLKbF1oMgF0fF5WruwLlE23
         CC8RavoD/PtAD9UylCGwf7VdCnOyvNehQWyLCV0vgzap6k7HIH5lSL1xTqyCQoI1Vo0G
         NGag==
X-Gm-Message-State: ACgBeo0y4BRYPjUKr/gS+ZzVZK6ziTTWeaLTOyH4o0pFey7VNydk4USR
        g8iiNVOIkZ8WncnlrxS11d0YVdjaWIg=
X-Google-Smtp-Source: AA6agR7nuBQpxke/hkNg6xwGh3mi9ivFfx6QH2zzgqbEO1mLNFu1XOejOt881eu3C4FdGrq3w0yjpg==
X-Received: by 2002:a05:6214:260e:b0:4ac:8470:99a7 with SMTP id gu14-20020a056214260e00b004ac847099a7mr12932746qvb.102.1662934522492;
        Sun, 11 Sep 2022 15:15:22 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:22 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 13/13] lpfc: Update lpfc version to 14.2.0.7
Date:   Sun, 11 Sep 2022 15:15:05 -0700
Message-Id: <20220911221505.117655-14-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.7

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index aa89225e0595..192d5630a44d 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.6"
+#define LPFC_DRIVER_VERSION "14.2.0.7"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.35.3

