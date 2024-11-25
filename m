Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F18F18893C
	for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 12:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732539233; cv=none; b=sdkJ5hJQX5sk5DM1C7KWM9254cHQqaGTwm4dSgUYWDGXPYqFGg97x9VNIc4LPCWobxPZ/u1PTZSDM7HjXLfOIrIN+7B354alvbIBXAYqykyoM3HoYbxPfniQbYg6eYZjoVewdXUI8iiSzvMKqGUvdw8WpQCW+JYSo8/k3i29GLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732539233; c=relaxed/simple;
	bh=qpn3nL4ruTIH9jcXSn5EnaywmyoyKdo1VON2EkUGiV0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WcWE7WSIS0vOm3v9p3Oqokn2uteTCXVf5Rtuwwz47wq2dzEYkogpMiAH+VfDS43Pv3bh6YRhHiU3WhRfOz4tFChTYjVuvxPgkZ6U3ZUnPB7F35RkN0tPmASfwhWUT14QwHqSj3zUa7qxL1r5d6ZpMz5rodW+y114/QQfz65dzNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vamshigajjela.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EUG+O85Q; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vamshigajjela.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EUG+O85Q"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6eedce8447eso37560767b3.2
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2024 04:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732539231; x=1733144031; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kQ4bkEkWXI9460U69LX56jW+n+QgNq12f2hQHN4SQHQ=;
        b=EUG+O85QFtdwdD6iurL9QkH6pPPod3l62m7vNUX9J3FmJUZKaKGHjJWuAEvEP6IaiC
         243biEHaM+xutmCgPZKUi+md/TMW1YMwKMmi4c/utrXUMHf7bxsRN0jUS8XQPOqmMj7T
         7vX/EoGITzMMwlkEVDdqhhad+1hEdfy1OhA1109t38JlDjdMU8Ps3XPVNPRg0zsyPAfo
         9elHJzUlARNBBtMAitm9l4wmFKSPTuiW3kaG12RIcbv/OxawXWbJrCYZ0275oZ2zCkif
         iFbUoouo7sDug8gEDKWEO3bSNUZ/bP1eWPAkdHrJ2UjyrJjCxykodETqOrB+Pvxgvswf
         qYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732539231; x=1733144031;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQ4bkEkWXI9460U69LX56jW+n+QgNq12f2hQHN4SQHQ=;
        b=rATwtDywc3RMwI4LI+FRYN20KrHs/u9A6ve9tUcsA+fwWywPXZqHhz+fLKZrC/MtMH
         B762ymJyPCEF7pSDlw5o2aYfz9v20QlOxNg7jht0L0hhtyOCEzxGow/DkyqUGkyWlgY8
         9OksXLDSzBAcXUTUPXxggQ44hAbpyBa/9R0veoZFr7+6Z7JQQDsji+a/WaFrJdUQdLXU
         hW0Rvfz+Sfmh54/WqoPbKtbOvIk1vLAchr3aupQrovjRzlfPFC5eD0aJWGr/fy3YzRwA
         hdlWsNu8v/t1AdQIOqXlHJA2ANFnBkyeRTKqTPt66saR7wzM6LFuGBi/KPxZGFE/aNVQ
         6yxg==
X-Forwarded-Encrypted: i=1; AJvYcCXyi0d0FgTsw4gKFsO/8n1icieHu53yYTK21FkunmkSPu7yZAyIzzopaLP+bmOZf8B6PjelKn1i29iU@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1v9F5sEu7XspOiPOjhfPvnkT6bgUCiOwfKeL7NJGAZAxF4HX1
	6vPXU3jrkzZvd8Bs4X/nzIuatxJQfF4pqOJpTP30nGjSxpSemZ5CsfTuwrzNmk/rOfJ9r/chu11
	Oi1xvDdfPwNsVVu5fYmhBwFgqxfqawg==
X-Google-Smtp-Source: AGHT+IE19EwzHoDlqo1+yfATE7tPwcQWjdN41993yStl979u2Ve1bKHZt1w5Eo8cthREpp6xIqRXTv4idhncz1Ja+bW0
X-Received: from vamshig51.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:70c])
 (user=vamshigajjela job=sendgmr) by 2002:a05:690c:6709:b0:6e2:1713:bdb5 with
 SMTP id 00721157ae682-6eee0a39166mr522877b3.5.1732539230924; Mon, 25 Nov 2024
 04:53:50 -0800 (PST)
Date: Mon, 25 Nov 2024 18:23:37 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241125125338.905146-1-vamshigajjela@google.com>
Subject: [PATCH] scsi: ufs: core: Fix link_startup_again on success
From: Vamshi Gajjela <vamshigajjela@google.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Vamshi Gajjela <vamshigajjela@google.com>
Content-Type: text/plain; charset="UTF-8"

Set link_startup_again to false after a successful
ufshcd_dme_link_startup operation and confirmation of device presence.
Prevents unnecessary link startup attempts when the previous operation
has succeeded.

Signed-off-by: Vamshi Gajjela <vamshigajjela@google.com>
Fixes: 7caf489b99a4 ("scsi: ufs: issue link starup 2 times if device isn't active")
Cc: stable@vger.kernel.org
---
 drivers/ufs/core/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index abbe7135a977..cc1d15002ab5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4994,6 +4994,10 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 			goto out;
 		}
 
+		/* link_startup success and device is present */
+		if (!ret && ufshcd_is_device_present(hba))
+			link_startup_again = false;
+
 		/*
 		 * DME link lost indication is only received when link is up,
 		 * but we can't be sure if the link is up until link startup
-- 
2.47.0.371.ga323438b13-goog

