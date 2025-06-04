Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843F46F073;
	Wed,  4 Jun 2025 23:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749080527; cv=none; b=UKW/sNU5WftpSGIfmTOcwxC3PFVhc7q8wyO45h8MGPW0qZE8fGf8NTA7Rbd0E/ZIPaiF0RR+xV2r2GluEwEVC8hTDzSGyW6CoXDN2DcLR/cXuoSJEot4t+eMPoumqKwA7bGnFNlCPkC7wh2CTWnaWI/+DDBv4Optryv3c+JN/YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749080527; c=relaxed/simple;
	bh=TssufhLWCeePlGG2Z0MM13Ur1COb2ebvj5gdMsFKJJA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FtnWHAeF1fUcybHVH2s+p4GhnJtz2SkgPvV+VecB2ytUOqzFXJ5IEiWRvJ2RbW47K53cBMW4zJ73L1xmK4vFY/QZfLjHmFSnpq/B3Q02SVAxv8X37mMonXEjGqqDWqwYKzwDWhnvMbfUmCDl1ICIcaEKT8NieQUuH8Q+diQxa64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k0o9ES7l; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k0o9ES7l"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e740a09eae0so415652276.1;
        Wed, 04 Jun 2025 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749080524; x=1749685324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ogtPkHGBxY5aXjHm5ko6SRdjkhMwenqN1SLiQIlyNC0=;
        b=k0o9ES7lPRzLFrnc8CT0juMnk5EgVSXF7hnE9BCqxg7zF4HVeEPmzY03oLfiurIhkK
         rPshu1ku6BtsMQ0zN1IkDADkQiDtyNcZy7jweXgBVPmv8ALq348+oyfCnaxqJuGZQYZE
         NvD3AaeCprvnfb4Yv3ItRYr8XPxgXnBNu/LIBvsGteLP0zIbYRXa7U6p25+yrDtnzfLs
         PMyKKGz8RjTrw2klaVzh2lQlAI7C+mpZbqT3HeZ0P5xrgQlvKKL8STlGNgCkxz7dGfRo
         zOW956I9H/9J9+aQkGNtQThkL1S61CcAQ2rqcxjbOHE4b5uwVnaViDjpP1zawG0nrVON
         7b3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749080524; x=1749685324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ogtPkHGBxY5aXjHm5ko6SRdjkhMwenqN1SLiQIlyNC0=;
        b=Woc9eX3HdeQjZeg8XPM5oWUqxouMZk+8fwKd9ta9kjdPxUjyUsu1sMuK7i93RyIVF7
         v4T9Xo/huUsP0v+LgUflbct070eNFmzaDr3p3g0Zu1yOXXR/UvIldncBj3ix5DMR3eTF
         8WCuUdQLqKGuIaGxq1SO0oBt90YnHpGJa0D0zeOvsZ2vYT76czNv3W0n9TUvH7wCSx37
         ENQxbqYLeQonBzqDDrkIUjKV5vMV0rECWTwcVGZgVl/3ydsqmfG63XOKelZ9PzYT3Nrn
         RzNMbKWUg+lx1Yw4KmmI6n3H0KzVpbPvdk9MMf2Cbs8Yai7dI/Fjd18a+IWKaszV7X8b
         GfkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzjmwhI2y34H0MiIxC/U/t3k1EX6ep/Qc1vSu2LNrb8SYGSGwPa0auLeVr59lB1aB/0ehmTJHgYWu+WDo=@vger.kernel.org, AJvYcCVMBaz2GagXf8RBcafbKLX00eWUz6zU0qjakrwBvStG4/b5kgFL6btgMghDvmfQfCJqIVBiMHho3KPjxw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx9u1z8dSe7IumOJxq0zffj3L1FO1kzDKYhHDoMGUkbeo4U+d5
	g8fbvNycajDMtIIkqKAiwcQju1bCjfrCYAVOnQiF5sjcazL1z3Bjs1DZtfPFuw==
X-Gm-Gg: ASbGncvugHafpg+LLfXi7MXDINyB25LnOu75FCk7qnnsDhV/sIGjnz8nGx6yKboddTS
	AkmeUeNBRZkLvyG/dR1LRYIzp4XS0lhozLD+T0mvECAtAqTn7WZHE3nVpLC8pu6a28YOSrJi0eZ
	lLY0Pr30VV5puBeV3a0ZluEkiYmmlCfJGdbRo1jAf4ZMS3TpKQrizBkOOo1nIpq2cxi3jSrOM40
	5yyAvS/flSFABzVodwNB6raNqoXuwF/tLBAfk3BYfFvmDTklXPKxYuk7tnH4jjiJDq1n9ODaonO
	aZMs5vM3xHyZDwFLUigvmi8VL18awiY55JeiyCc9SVIsD+lp/tcgkNHx8pdmcU23PDtbIk1MT98
	vbq7jM+xpySc=
X-Google-Smtp-Source: AGHT+IGYLFQSXYiQ1P74k/ZFrgZ+D8x/YLl+JJqMylp7u3vT/i81AKeVBGpIjDbKx265JQylSgO5jA==
X-Received: by 2002:a05:6902:2291:b0:e81:8639:c59b with SMTP id 3f1490d57ef6-e818639ce51mr3781407276.48.1749080524378;
        Wed, 04 Jun 2025 16:42:04 -0700 (PDT)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e7f733c9f9csm3373822276.17.2025.06.04.16.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 16:42:03 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH] scsi/fcoe: simplify fcoe_select_cpu()
Date: Wed,  4 Jun 2025 19:42:00 -0400
Message-ID: <20250604234201.42509-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cpumask_next() followed by cpumask_first() opencodes
cpumask_next_wrap(). Fix it.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/scsi/fcoe/fcoe.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index b911fdb387f3..07eddafe52ff 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1312,10 +1312,7 @@ static inline unsigned int fcoe_select_cpu(void)
 {
 	static unsigned int selected_cpu;
 
-	selected_cpu = cpumask_next(selected_cpu, cpu_online_mask);
-	if (selected_cpu >= nr_cpu_ids)
-		selected_cpu = cpumask_first(cpu_online_mask);
-
+	selected_cpu = cpumask_next_wrap(selected_cpu, cpu_online_mask);
 	return selected_cpu;
 }
 
-- 
2.43.0

