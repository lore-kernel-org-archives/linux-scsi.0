Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E21A1C2DDC
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 23:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726182612; cv=none; b=e8FK7bQoUy7LtZgbIRiTTIrEiKNS/rZ9shyn/zx8vmE/VKCbOUty/VSlyv/6ttW5lMYYhoKPvddlWOvwzmo+ajxN9qfRDg77k2kTuUTXu44Eji1QS+z309sbRmMOeZt/smD3K/P3WBj0VzkCwmZwfMx0QV6gv6UBdE0gErB9L/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726182612; c=relaxed/simple;
	bh=UgPFkQGZug/ahUiaxMk6A8FcjUTTD6DFvopAbeY4uns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S4QkzCItxQMyfvUYH5nIdcAbsZmZ5yJ8x8aJXe8PEbi41oRiRAVYuiEOctpNGNBrQLXO9iEOfDgBgE7cKWZVXwIWrpZEVXgq9CDGao1WY3UyQ8UnMgixExgOXsFZXIBV4cq4xOPCZ9sPEKHeOFvsQHUnxsRCCziQiwCh5PmFbOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RocuqWhL; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RocuqWhL"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7a9b3cd75e5so140705685a.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 16:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726182610; x=1726787410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpI8WcXF0Hq+UKc04Wgfp6cPkOWYxJvd+5/cargUOVo=;
        b=RocuqWhLHJdZdatu31XbVvmfoSMQG26Mw9v7bQEKlzY1myRLA83Sh6vqsEFPYH/aHr
         bsxhNfPFOw8A+HVEnkvBCMi922cVOvZulaPnRImFf4Is92pbDOzPwpKcV0SdX/KcgtHo
         w1M4q/Zwbd7nhyg6fyxvR0sPlqTUEBfGpJrAY35yJ9OwBnQc6O6to4Ek0LRCW4vo89Dz
         T3FoOHJtTz3I+gUzhImbji3HIqih8wa9UiccshCEKfOskh+m0/n8YrRHK5vQySfhRPwo
         +bZYi9s4PHvIgIIX4jDz5tRMExzUdBdg1U6Xq7l/igInKq5IPaB0/j7PnNcH0PKgCWLN
         jEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726182610; x=1726787410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fpI8WcXF0Hq+UKc04Wgfp6cPkOWYxJvd+5/cargUOVo=;
        b=bB3obRDKk9c6MVlyHsgWY0Qro5TsxP93brfjhPpfRWT+jTsEeezoX6J9QlRtRyaPsf
         4xQ+rxhWA7Xu54VVJDhYvLMSBu6mYfsbx1OLsrfrVyNeDsrTfMfkmlTZEBjgXhFREeAo
         T2yj4US64K5IUhUu3KGGIbIMKoyB1zFAtDfAKb1sRsI1poTU0ka1ETze5a01/e7Z96g1
         nV9vpH/eFc30yTkJfqo/dom6OqbGL0Igr+BAXylG2SwZOd+A5r9mX1KGtvuM/INzceGu
         dq9Ol6BvrcUu9YH8fEuY1kJws3D0P1P64/C8fP75LyQPPQJYUvWcGoeKs0JcULU81Xu+
         3mIA==
X-Gm-Message-State: AOJu0YyINtJi3f/2PibBptXKVxjLMkt/pbWdxknzNFWOZVC+bfP06EfN
	y7kmc2LCFBvxniZIwGkxaV8ScX/cYT+6zwm26AUgdzETu9AKXiU8J49UUA==
X-Google-Smtp-Source: AGHT+IFJn8Ye+y7jG1GzGCLORc+H/Xu1tCM7tjQUUvtYnkXIRMc0c6wIyXMKcF0MUpR2I+RFJeFuhQ==
X-Received: by 2002:a05:6214:469c:b0:6c5:4f37:2b51 with SMTP id 6a1803df08f44-6c57352dff0mr74379146d6.28.1726182610214;
        Thu, 12 Sep 2024 16:10:10 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c534339a88sm59363136d6.50.2024.09.12.16.10.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2024 16:10:09 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 8/8] lpfc: Update lpfc version to 14.4.0.5
Date: Thu, 12 Sep 2024 16:24:47 -0700
Message-Id: <20240912232447.45607-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240912232447.45607-1-justintee8345@gmail.com>
References: <20240912232447.45607-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.5

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 2fe0386a1fee..e70f163fab90 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.4"
+#define LPFC_DRIVER_VERSION "14.4.0.5"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

