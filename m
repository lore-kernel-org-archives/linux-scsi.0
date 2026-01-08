Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC5C33D4EA
	for <linux-scsi@vger.kernel.org>; Thu,  8 Jan 2026 06:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767854612; cv=none; b=rtG6cXl1Fu/q9EsTzqfXBrFQZJh6cvTNBT5JpQ9ofkIkoj0G8/x3uTuhnqmvndBl+Qcu+1i1yYcyPnUwat8oWsq+2r4P1wt7klwv3bkRFaPBJxrvAMnCqhND87Ufrmu+i9gsTJg43C4L4j01ukbfLUEhPv+HS/gtOoIPkwGnBQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767854612; c=relaxed/simple;
	bh=LEZrTdpa9KGGKDcyEtrC6XpwXPdO9NdBvgi1GHEilzA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HL4MYZl+4YwVcS9oq86XevhJFalPv5yC79g7d4ykOHu7zmBTq9Yqxe3J7WC2H1+4ohjmO5Lfqp/RBjp6W8spy8jdnyjCXb1mEO9PzjLllJ1iQYQk+NXkjZ1TpleYTPwCwiu3Jkwy2ir/VJ8gdorrU2oDFeHagIxYOrGQ7m3Rvi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BJFYyH23; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BJFYyH23"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-29f2676bb21so26613895ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 22:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767854602; x=1768459402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZuPSNWn+b82ZHyLskpPT7wonBtOCk8mr0NLWFqNBPY8=;
        b=px9qZd2phU5xkFZb7O8UEydZbKfmCZ3FRU2Fqw776FFawTiqufxKFZERmdQb3ltgi5
         ZHROrHk4MG2c84CyAy0b2vuTUw8+FLzf7EoKGdQdgKAGrzl0qqMLMcEhhwYDKLv74eE1
         GgftYDbGvJjC3DIvaxm+AWvvTbYnXqJc/DtZt3dGm/TgqG7/kPHFqEx3tzGELQ5ghVwh
         CjrlgQQDbC3hJ2UGawHxUY7ItH/nzOwXnDuDIT8JpopqyEo9fAGg7kqDHOUK5rtnijnv
         GzklXIbLhwTnaTVbovfCM8ulXhJTGic+YZ+ekPguPVNxJcOLumsPpDZrTe24SuKQrZ9U
         vlyA==
X-Forwarded-Encrypted: i=1; AJvYcCUb5cfs6/1sFWKIDVnO9RwpO221PEMYYJ7Cj81gh1uNcPSzjFVr8+FIo5CWsvKTEGUKcYMJRFE3d7Ka@vger.kernel.org
X-Gm-Message-State: AOJu0YwQO1zjvl7DiTJ4fsIf5LHB+hKIAhv7S1Fl37KhbjZcPInVRWGX
	Ivapriq0xyOAW30+Kks8xhsROpwXL/lnA7K3uKWK8D9CNdaiGAEcCekXvkAESvvvvBDtmzDlO1W
	LLisQFlhgvfTdVmuKqRNKdxy2QOcqwBAmYYtLpRRM6MIO08Lfl8lpiEbGslYUyEuC2Y5XVD1l4I
	532QOUlSxCkSIB0rnJQaDbOEbFZ2OCxa2dmnZD3K87kl83qEQ/uS4LZ1yFnrejcXqOhujmVbGvn
	KqfoBH6ykZgYcfiYOy9
X-Gm-Gg: AY/fxX78J6NaBBsDdBWQPkqVI1Z/sJKCB3IEizSPTLACtpQcXVxaQbu8yQ716m9HQlt
	D/8IUORSAO2MKPdkqN8ca4i6FD+5Z+C15XqG3YHJdwS5Rt37M5PxYfPk6e8r7P0fLgQuc8gkm5G
	FcJwKsGBkxT2BMvuSwtpQS/tok3F0NvrPg47YL+uAGkOYMBsM0M2hywhkyaycbv8ZXKY+7lyb1Y
	nOCpL+VO7ovHRGOD4ZqlTtKrIiGmRVYP2GjgjNdzziQDLZJMWdvG6Ypf6KM/t21ur2SLjtQJBfN
	zgb4nK5+mtkWUKISNPVAeYQn6SZUL3jGYObZ6dJKeXfK21G2BRYcdZ2oiSQz+LF8CcpXOfRYQYP
	+ypWXggbJWRm/jR7upbVO3mbhaOP5Pn7LwiYlXiApjDVUa5Q5y29xAYB/Dp0YHVf643uIyDcWp9
	xu6lIYVWeWrAjtwO3Bq0sDSA4F4yqzDZF1ZM+QicewMFESq7qdzLM=
X-Google-Smtp-Source: AGHT+IFes6Z7d2F9RiI3cWlxdApQ3FG8QFrfmAFeJxHcWx/jvaWG8FnKvpMgcJr1Pc2ySIXgkpCLM6WxMvC+
X-Received: by 2002:a17:903:354b:b0:2a0:af76:f8cf with SMTP id d9443c01a7336-2a3ee425182mr49990045ad.2.1767854601615;
        Wed, 07 Jan 2026 22:43:21 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2a3e3c3c1aesm8581795ad.11.2026.01.07.22.43.21
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jan 2026 22:43:21 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2ae26a77b76so2433762eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 22:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1767854600; x=1768459400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZuPSNWn+b82ZHyLskpPT7wonBtOCk8mr0NLWFqNBPY8=;
        b=BJFYyH23L3rmEw/uPAB9akE38fdhK48K3zT33K1irTKDuYmHNSROBBMWvjVLH2qd+j
         CNbnhwbqHloRBFSwRcvTuqnXd1esJ0JAPZ6S8GsGEmP4js8WVX5z6Dc+xERgEDDQ1y3M
         57K1AYD1aYWKYC+EzhfvW87cUszHQV4Fa6mck=
X-Forwarded-Encrypted: i=1; AJvYcCUPhvU0aXlvfSLeOo7g9M0z7JeFJm1VW5zs7hdcdXNTSg7ey18IUyfjpBhO2KJu4v0v6cioH7H8klsY@vger.kernel.org
X-Received: by 2002:a05:7022:2217:b0:11d:f44d:34db with SMTP id a92af1059eb24-121f8b8dc49mr4003993c88.35.1767854599965;
        Wed, 07 Jan 2026 22:43:19 -0800 (PST)
X-Received: by 2002:a05:7022:2217:b0:11d:f44d:34db with SMTP id a92af1059eb24-121f8b8dc49mr4003977c88.35.1767854599427;
        Wed, 07 Jan 2026 22:43:19 -0800 (PST)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f243421esm13193731c88.2.2026.01.07.22.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 22:43:19 -0800 (PST)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 0/2 v5.10] Fix CVE-2023-52975
Date: Wed,  7 Jan 2026 22:22:20 -0800
Message-Id: <20260108062222.670715-1-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Fix CVE-2023-52975 by backporting the required upstream commit
6f1d64b13097. This commit depends on a1f3486b3b09, so both patches
have been backported to the v5.10 kernel.

Mike Christie (2):
  scsi: iscsi: Move pool freeing
  scsi: iscsi_tcp: Fix UAF during logout when accessing the shost
    ipaddress

 drivers/scsi/iscsi_tcp.c | 11 +++++++++--
 drivers/scsi/libiscsi.c  | 39 +++++++++++++++++++++++++++++++--------
 include/scsi/libiscsi.h  |  2 ++
 3 files changed, 42 insertions(+), 10 deletions(-)

-- 
2.43.7

