Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19488176FB6
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396883; cv=none; b=uhZDfYJ5JYuDmWdew+j3hT0A5er2YLOI6y1Hf7jW5b4Aag03//In1eNH8RiztwagEyn3+7E2pjreEb4I/moqIgsW0XvrttdeA/wn3X/jzuXSNJVKdTLkzNnocSqRv4vpHLXvVDzU8cR+dQ6S8v3sXCw55ls8YqINyiRDeYxOP1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396883; c=relaxed/simple;
	bh=qhzhiFDpgx2yH4sDgL27HYvrb2uN4adm+OTfDCZNz2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl9Yk1SGgqlf81lAXzVWQhyjGgm9CZ1jVGRkXT/yv8v92yma67B239TZYjEIEC/8LRKHFR5Jzsm7nmXio81v2Iz0/Bo8k6Y+IksYx8skVes3Oh2fORAAjssLniACOtFkIn/FZAssB/iByRnC2D9ajn249uYh0rxqjbwxRTJC13A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QD7C41xU; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QD7C41xU"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fa75f53f42so10143385ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396881; x=1720001681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91eRDplxzUerXJ0Y9zFlX296qj0Sefn2X6PZdGUQWss=;
        b=QD7C41xU3ZPH1xycu146SyryZVOXaTuteBoypw9Zwh4rvr9aExSJ1rtZRFQ4t0/v8b
         10kFIiO9lfU5L/u+tG4kl3ntmAkmRsfnzcl7CNd/yLp9kIf/UH+EYVeqjG8OLu8ycPJs
         qWx3+hb6oZAz3iCPPr7zEizYqGpklpI3untlE0HsdMv2I685V3AOCCi7tBbcOtKSSS8Y
         Mq7D/TWH3k/cJ+RZF4UOqnRGs5AxxvKW4Xsr3SNw1MLGrz67dU/9MMmfBD3qIdXhD4ej
         qPSL4kgjmmwjgi/Dubc+zXTw8xhWWlwPcEKZSNEU3ZZV+f4PIFuC319fDOXjKmRt7OVt
         IGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396881; x=1720001681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=91eRDplxzUerXJ0Y9zFlX296qj0Sefn2X6PZdGUQWss=;
        b=GI3voD/BV8j8dOMOqFrFwUTLMar31A+73GXvwnLCyJjB2ifK4F79r5JcpSOI4kHCQ+
         oJdnZfyG6SnvsarU5t6kfb+eN2+wTCt+jS9lC7J7xdV8Bw/aS7wMh7gHNQpRhpXHLW3b
         eJctBKHTxfpjDwASX3XDb02CcoEb+nriEy7n6hHBDitL222NzQIuXSCkcogJFkQyMgku
         Hm0Q7iSkpDYXv4qYBF+k6P/8Epat61E1Hh5ntncT4nkzVfrA9HGxoviCbDXwKLUj/fIu
         vVWMZz/xhdZWT2iBxxkdcMFi5ifOUaVLjlmXs0Ld9Li0slSVUJoIQUQtfz9nW1TWOVyW
         wfvQ==
X-Gm-Message-State: AOJu0YzgErIUyyBy8xcsdzI9YXBDcH+4CeCT+IhUlXwweDYSG9NEByiK
	caxcmQBhUISqD0lR3M+9F7F1Cmqrf8CpfeThGcgoYXaeF4i6gJqom3ioaQ==
X-Google-Smtp-Source: AGHT+IGflbWmoPkcUQVv50wMyv+lOgpjoL3Rq7lt4GgdRE0HTgrpkLv8xGnKB00/6Qy0/FHpFwseCA==
X-Received: by 2002:a17:902:f68e:b0:1f7:710:34ed with SMTP id d9443c01a7336-1fa240821a2mr98813935ad.45.1719396881146;
        Wed, 26 Jun 2024 03:14:41 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:40 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 14/14] scsi: st: Used max() for buffer size in setup_buffering and Simplified transfer calculations in st_read, append_to_buffer, and from_buffer
Date: Wed, 26 Jun 2024 06:13:42 -0400
Message-ID: <20240626101342.1440049-15-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
References: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
---
 drivers/scsi/st.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0d8ce1a92168..b473f79c5a73 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1575,8 +1575,7 @@ static int setup_buffering(struct scsi_tape *STp, const char __user *buf,
 
 	if (!STbp->do_dio) {
 		if (STp->block_size)
-			bufsize = STp->block_size > st_fixed_buffer_size ?
-				STp->block_size : st_fixed_buffer_size;
+			bufsize = max(STp->block_size, st_fixed_buffer_size);
 		else {
 			bufsize = count;
 			/* Make sure that data from previous user is not leaked even if
@@ -2187,8 +2186,7 @@ st_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 					  STps->eof, STbp->buffer_bytes,
 					  (int)(count - total));
 			) /* end DEB */
-			transfer = STbp->buffer_bytes < count - total ?
-			    STbp->buffer_bytes : count - total;
+			transfer = min(STbp->buffer_bytes, count - total);
 			if (!do_dio) {
 				i = from_buffer(STbp, buf, transfer);
 				if (i) {
@@ -3997,7 +3995,7 @@ static int append_to_buffer(const char __user *ubp, struct st_buffer * st_bp, in
 	}
 	for (; i < st_bp->frp_segs && do_count > 0; i++) {
 		struct page *page = st_bp->reserved_pages[i];
-		cnt = length - offset < do_count ? length - offset : do_count;
+		cnt = min(length - offset, do_count);
 		res = copy_from_user(page_address(page) + offset, ubp, cnt);
 		if (res)
 			return (-EFAULT);
@@ -4029,7 +4027,7 @@ static int from_buffer(struct st_buffer * st_bp, char __user *ubp, int do_count)
 	}
 	for (; i < st_bp->frp_segs && do_count > 0; i++) {
 		struct page *page = st_bp->reserved_pages[i];
-		cnt = length - offset < do_count ? length - offset : do_count;
+		cnt = min(length - offset, do_count);
 		res = copy_to_user(ubp, page_address(page) + offset, cnt);
 		if (res)
 			return (-EFAULT);
-- 
2.45.1

