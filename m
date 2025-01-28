Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C7A1EEA3E;
	Tue, 28 Jan 2025 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738082828; cv=none; b=UgBWnaE9oN4qPrJ5OSod24KI78SO6E/mXvLiTEip0pPEUust413ACcCxUd3qk4wWxUANpOoOIJCOv1DVYe73KBT5HRssxAk2t7AZ1XFHuq7lBuJERXtwT0FMEEbZakwtSzCcd5J3lczuQjO6j2ikpxIJwjFlkie1ML7XAAaZjmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738082828; c=relaxed/simple;
	bh=xwsJBuJWYQvgBSzjTEX0AGU/W3tEznN5MToOHmkEGRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx+r+0/swqqds08ba6TvlL/Z2LxrhMHFg6JC2smLxhyJJ/sb0g8CBnMXNEMiQeEvi+O4DJhSEkX2Nvgb4GDzKhwF3g7uqTSQun9ogThlfDK2T7INnDsQgqpXHD6/IcNoAs6EWZLQjkdfThbwvxobLI0G6eFlRsaIK9enW4W1ap0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iXbUG6Bq; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXbUG6Bq"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e46ebe19368so8436276276.0;
        Tue, 28 Jan 2025 08:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738082826; x=1738687626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nECvGuISJzvWzXqBfzABNhjFV024u8eo2ZzrlCq8YFQ=;
        b=iXbUG6Bq6p+tKJB+NRPDQ9VgQITE5Zn9Vjo3hT2uwJsTaeRab2mNcYy8HN7Q4FE0lW
         ANQU8YQv87lwDiaPuS/JyOHmXIjXpjH7bx9lJErEf4DxtFvySQYMwRuiQIj8EtVO5ja4
         PnsW8j0MDtkodc4Xmr1AXH5HBCTpC3lLFeubk+8dxm3DHj80a56G0CfvZI2Arej8DjEp
         iL/QqLKt8Qse1mFcVh+juna/E3hmzjlw11Co8dnifw6AF+9hg27I1ZGgJ+sTzyYQcuQC
         8U8rjLWMTFPPjwf2kUPRSph04CX9w63ZdWgKxAfWZE3bNQer9ddm6hvrPK3Bx7As6e6w
         fp5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738082826; x=1738687626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nECvGuISJzvWzXqBfzABNhjFV024u8eo2ZzrlCq8YFQ=;
        b=G3MZhydzjvNv7sM5ctWz7tSDUoRzf0e+ISeEJUXc9ilGPRQUvoQTzm+dFhlwN96rLv
         52MIc7IKl9hRkij0tYSxum4SQUewZLe2ax0UTqh2HvoWl81QgE7Ph1kxlAzpek/JW7Gd
         YbggyCW6zEm8JKrnIglmy6ZHFa6GtT0Vj1YGaaIEGnWM9FZQP1jzeuDYLc3l5mnylKnA
         Bf7Yj8Mtj8LZE77iHqwVczxtmwID/qj6akoZdVjhoYbdk+kfjheWr0Zz3ljkyf/fvMRQ
         EoqjGJg0d2dG24BQwpQPQM2q8Kpw78T7w/Dbweoijs3kc9nDFx0PlkrJTGgBvgAIYCSd
         7ccw==
X-Forwarded-Encrypted: i=1; AJvYcCUxk14u9bE+x86oSRGmJ9w8fHZxSOGUNMfuao1xdvSlGBPKNDTnj2eupBggyoxzcFbT5d8x96qYsYUe@vger.kernel.org
X-Gm-Message-State: AOJu0YxG9WgDJMns4fnkGG9GSpm3YvMcHb7+UTFdRL4yQsbj7XkBCuj1
	IHLa7G7dTwOk77uK9sQv0BGqoRaVAVzYxJMZgzVxsg1CT7LjQss5oMuqYnMW
X-Gm-Gg: ASbGncveO29DK/JB3Vw2OYBlqVwQiUzTFIrPFMbIjhJpAuvfeJNZYjYJxeQSinVE79W
	GmEivgJqfPBVJaLHTLIEQMxDTo26e3wCzdC2GiH/g3MHEMKvPe1AhFBfFcjmZqVWJNsoeqtqxX1
	sp1hrWoRR5ZjL9OuElnkhwPBhusJl7KQW9NjdzNXCIWjMhSPDwPXNUs/CTY/DdQmcBHTmYgN/U6
	MX6DNq7P1jIjaoBp0nukrWfPx9RmZZdh6bTFd0Xp+VfJEHQBKeyR2RrcucuFUm+OyXBONEQ5iw7
	PvfBN7vN6nY/MPFkb3BGVNrt3lEb9Z0Bo+o4NKRvVOy9PP6cgkg=
X-Google-Smtp-Source: AGHT+IEsXoF439CCPEfGileFbbXu5z7dOf++ilKqvwhQ7iCLQYkj0a19LBqsHqxQaxQctf3TXToaFA==
X-Received: by 2002:a05:690c:f09:b0:6f7:598d:34c2 with SMTP id 00721157ae682-6f7598d3d7dmr133398347b3.24.1738082825856;
        Tue, 28 Jan 2025 08:47:05 -0800 (PST)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6f75787710dsm19357597b3.4.2025.01.28.08.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 08:47:05 -0800 (PST)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Justin Tee <justin.tee@broadcom.com>
Subject: 
Date: Tue, 28 Jan 2025 11:46:39 -0500
Message-ID: <20250128164646.4009-11-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250128164646.4009-1-yury.norov@gmail.com>
References: <20250128164646.4009-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Subject: [PATCH v2 10/13] scsi: lpfc: switch lpfc_irq_rebalance() to using
 cpumask_next_wrap()

Calling cpumask_next_wrap_old() with starting CPU equal to wrapping CPU
is the same as request to find next CPU, wrapping around if needed.

cpumask_next_wrap() is the proper replacement for that.

Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 31622fb0614a..e94a7b8973a7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12876,7 +12876,7 @@ lpfc_irq_rebalance(struct lpfc_hba *phba, unsigned int cpu, bool offline)
 
 	if (offline) {
 		/* Find next online CPU on original mask */
-		cpu_next = cpumask_next_wrap_old(cpu, orig_mask, cpu, true);
+		cpu_next = cpumask_next_wrap(cpu, orig_mask);
 		cpu_select = lpfc_next_online_cpu(orig_mask, cpu_next);
 
 		/* Found a valid CPU */
-- 
2.43.0

