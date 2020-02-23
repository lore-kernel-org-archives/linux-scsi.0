Return-Path: <SRS0=lsQb=4L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9EBC35670
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 05:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 226C6208C4
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 05:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKPPeRPi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgBWFmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 00:42:36 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36041 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgBWFmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Feb 2020 00:42:36 -0500
Received: by mail-pj1-f67.google.com with SMTP id gv17so2626598pjb.1
        for <linux-scsi@vger.kernel.org>; Sat, 22 Feb 2020 21:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sBcpUEikr4BVNDaC5sxBh2nBjtOfILlrf6tgzXt34O8=;
        b=IKPPeRPih+jfKOW4lu6ThGJsCEPhs768DPYXk+92Sg2BK6jnvCSVIv031QOpfQk8zu
         HBtlh2wZ63/JKwpBxnv7EktCFn7HmsK2nDHg5w/6AO6VLpkztl6JXjQn7rh770uH3r5b
         Tms281tqAloYvjz+GSzFUz6M/BqEye8qcVp0Dtu1vprx7fNeZZZh6+VKyYKgEZxBGL9I
         VDPJDJ9wGzSFnM+U/ZtVPPh7/qE4eqgwxlFgo2K3b/XrXw9USs8thwum2bWBReImjfAa
         8UEz5bolUrJ3HwPOZMTBuqBnOpsIUaGl+0leqvkI4BrEFB1gVe9C6C2Ncd5Tg6S7LwDh
         Zq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sBcpUEikr4BVNDaC5sxBh2nBjtOfILlrf6tgzXt34O8=;
        b=n/img6AtCr1Qhm+SGDq9T5tVEyd0z4aSxxzjqjF/UNjfOgnqoN88a+2Hv+REPyjHE+
         EJ7Ur3XWWAnmJUdT85I++L5za+YL7nRj+xBYUOiUTZv5iwfwKR6wAACnsEt/t5QOlbv8
         jg1uLogzz+V29IznNX8n8GsKLPcxiMuJQLKYg/UbKtCXla29N/HScITjuWdJ1oR47q5K
         trTve4qosa0H6Mby/jnXh4Kd2O8lQmCOJPI09Fv2U216BHDsYvEkJ80DtG7rUbp6HQiM
         +aUTUbmgK+2kti+7Hro6zDEDAAbItPBYS+7C7KVBO3MjmUP/OvSV7mMFqpjLK4ZqvbER
         5Q9Q==
X-Gm-Message-State: APjAAAW9Key9unBsr23P+PzN8DMB06KqjZcRyXHCokVtyyNwwmi11Zmo
        ANWwWdmbXiufICYPnumyO+jRUnsMvIc=
X-Google-Smtp-Source: APXvYqzjsPedUCsVxjjtx79y1TvT2dc0ATqNmiVnXjfR7ppxUrfFB3YGktpiD3Kp1Z70qscXjV6Z0Q==
X-Received: by 2002:a17:90a:8c0f:: with SMTP id a15mr13348002pjo.86.1582436555656;
        Sat, 22 Feb 2020 21:42:35 -0800 (PST)
Received: from localhost ([43.224.245.179])
        by smtp.gmail.com with ESMTPSA id g72sm8306239pfb.11.2020.02.22.21.42.34
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 22 Feb 2020 21:42:35 -0800 (PST)
From:   qiwuchen55@gmail.com
To:     linux@armlinux.org.uk, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        chenqiwu <chenqiwu@xiaomi.com>
Subject: [PATCH] scsi: arm: list_for_each() -> list_for_each_entry()
Date:   Sun, 23 Feb 2020 13:42:31 +0800
Message-Id: <1582436551-14244-1-git-send-email-qiwuchen55@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: chenqiwu <chenqiwu@xiaomi.com>

Use list_for_each_entry() instead of list_for_each() to
simplify code.

Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
---
 drivers/scsi/arm/queue.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/arm/queue.c b/drivers/scsi/arm/queue.c
index e5559f2..da39597 100644
--- a/drivers/scsi/arm/queue.c
+++ b/drivers/scsi/arm/queue.c
@@ -158,12 +158,11 @@ static struct scsi_cmnd *__queue_remove(Queue_t *queue, struct list_head *ent)
 struct scsi_cmnd *queue_remove_exclude(Queue_t *queue, unsigned long *exclude)
 {
 	unsigned long flags;
-	struct list_head *l;
+	QE_t *q;
 	struct scsi_cmnd *SCpnt = NULL;
 
 	spin_lock_irqsave(&queue->queue_lock, flags);
-	list_for_each(l, &queue->head) {
-		QE_t *q = list_entry(l, QE_t, list);
+	list_for_each_entry(q, &queue->head, list) {
 		if (!test_bit(q->SCpnt->device->id * 8 +
 			      (u8)(q->SCpnt->device->lun & 0x7), exclude)) {
 			SCpnt = __queue_remove(queue, l);
@@ -207,12 +206,11 @@ struct scsi_cmnd *queue_remove_tgtluntag(Queue_t *queue, int target, int lun,
 					 int tag)
 {
 	unsigned long flags;
-	struct list_head *l;
+	QE_t *q;
 	struct scsi_cmnd *SCpnt = NULL;
 
 	spin_lock_irqsave(&queue->queue_lock, flags);
-	list_for_each(l, &queue->head) {
-		QE_t *q = list_entry(l, QE_t, list);
+	list_for_each_entry(q, &queue->head, list) {
 		if (q->SCpnt->device->id == target && q->SCpnt->device->lun == lun &&
 		    q->SCpnt->tag == tag) {
 			SCpnt = __queue_remove(queue, l);
@@ -234,11 +232,10 @@ struct scsi_cmnd *queue_remove_tgtluntag(Queue_t *queue, int target, int lun,
 void queue_remove_all_target(Queue_t *queue, int target)
 {
 	unsigned long flags;
-	struct list_head *l;
+	QE_t *q;
 
 	spin_lock_irqsave(&queue->queue_lock, flags);
-	list_for_each(l, &queue->head) {
-		QE_t *q = list_entry(l, QE_t, list);
+	list_for_each_entry(q, &queue->head, list) {
 		if (q->SCpnt->device->id == target)
 			__queue_remove(queue, l);
 	}
@@ -257,12 +254,11 @@ void queue_remove_all_target(Queue_t *queue, int target)
 int queue_probetgtlun (Queue_t *queue, int target, int lun)
 {
 	unsigned long flags;
-	struct list_head *l;
+	QE_t *q;
 	int found = 0;
 
 	spin_lock_irqsave(&queue->queue_lock, flags);
-	list_for_each(l, &queue->head) {
-		QE_t *q = list_entry(l, QE_t, list);
+	list_for_each_entry(q, &queue->head, list) {
 		if (q->SCpnt->device->id == target && q->SCpnt->device->lun == lun) {
 			found = 1;
 			break;
@@ -283,12 +279,11 @@ int queue_probetgtlun (Queue_t *queue, int target, int lun)
 int queue_remove_cmd(Queue_t *queue, struct scsi_cmnd *SCpnt)
 {
 	unsigned long flags;
-	struct list_head *l;
+	QE_t *q;
 	int found = 0;
 
 	spin_lock_irqsave(&queue->queue_lock, flags);
-	list_for_each(l, &queue->head) {
-		QE_t *q = list_entry(l, QE_t, list);
+	list_for_each_entry(q, &queue->head, list) {
 		if (q->SCpnt == SCpnt) {
 			__queue_remove(queue, l);
 			found = 1;
-- 
1.9.1

