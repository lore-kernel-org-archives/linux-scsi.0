Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D533ECBE4
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 23:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849199; cv=none; b=P0R68hKvDD96oUCVtXdL/OZbVjpR3BrNc0XKzcs7KsEKxXnscTB/ky7IMyXF3A5w43Y4btkyaDg7TKyNQHU0RWtRHvxyZyUeDbxyut0VsrBpQ+NnVx6pwmJhsjXTZ+Sisrz20pJ0OeWH2UQhx1+dzyi6CYW14lj3QxsTAnyKmMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849199; c=relaxed/simple;
	bh=tER6xlnK90r8Qab1VZSZ1fLyySMbxeBEh1Ay11tOetw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RMD2GJuxsNEsrEjukRj0Nlw/j1HS6fLtbfQZq6fjtvow1fdYdh5c7cFuZef7JrqSKAWepTYeW2H2+YPzg8X5OgxtW4KdFgo+nnrHoq9wvjcj+ie5nf9nryURFdzPHvCZQ+yuqhRQ1sDG95MYSFHgGLtAgnSqTnPp3Cz3qKq9p34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s0ullyEW; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s0ullyEW"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-35a31bb9fb6so781552eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 16:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791849194; x=1792453994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WwBaVdVJ59R0rXXR591zjvN6CoT6wXS7+liHv+BZRLY=;
        b=s0ullyEWal9/wDStdNvrdPXPOQCGqUjDWA+WdxL4KKKADohR07RuGo0X4UBkUO4yv9
         ulfr7jgfYwwv+k8EUk2h9qxJ8O/jGAmsTPayTlSu4jIog6liXVFvDGkkGY5QOYtuFut+
         QiumhPH4fHfYXRBuQH75IrK4zYkz/bxZkC99FEPRq6W0rEwT5pvUzasdmuQ+A7mH0vCC
         fhNylNtiNgMlB2RnvG0SHBimLlD/ANg7L4JfMHcRIpYTtlWgSNYH+XurIYz5/eLIX6Ud
         Im39WpLOEiO4PbrfcTRJ1Spv6fN68QGQv7HRI/5dYxx2I4qKtGcw4BpzjB7Zkq3+MZ4Q
         CflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791849194; x=1792453994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WwBaVdVJ59R0rXXR591zjvN6CoT6wXS7+liHv+BZRLY=;
        b=cqo2X6HkS3bI95eFSNI2EYCYduZz2ZPl4Vv3CYJFrBLOtgznkCCYAL2BIrxA8vkTOR
         pxY11pgmf33ru94EhuyEd37EFoAEuqw8HioWm/q3xhStP5UJd7AAHgysrcXufSLSWSEf
         G9PQGQf7APxGNIOMohaP1inxH/RhtoDnjZAK0NiGAeCt1t/BNFs2MZbKnqHybHOTuku0
         OLDGQhvSaX1mgr0nfnAP9eJs27/OubcHMhSaAsBkLUkDbPfrtFGuJUeafJJrZyO96wk7
         PKxqiSG8WcqgPgrLDFS00eQVrGA3SEFslp6mL5aiyPlcS1mkIgl27noX1eHblSyTvaXU
         4OMA==
X-Gm-Message-State: AFq9FYLotfvfsaP+KTOzQbZ8fRaaL/f9sB8toV5vWkhAQv+HGbCviwqz
	66kcX51dQyPGcWoJKsnciySoAZ+kpjlMcmvRHWTobOc720h++yiFqt1z+VfFXoTI
X-Gm-Gg: AYBFou3KXPusN1mHeU8FKDAzjLSYaOAWbR86h+NRVoJrAjJzD97/iZUbZe6s806vOd7
	apYX9Iq06kckrJHeq7Tw68mnssTarPqsrSmRstd+LDXKwAGJ5ADACr5t8yvOIpkMHpnqjFfEMD8
	nd7K82cF73nmlQePMG5E9hzSDxd+aEX4MoomalVGHFQZizfW/n4bzxGnHQ4/K9D0ERgwhDI0TWx
	ZS8VZs+vw0w3mxGlFrYzFQO5sb+7PDuRJ/i9rUkPO7g9FPYL06TVJcEdS3JyHy21wrF3+1qLJhL
	9H+2BUeRauRogwmxEAFddsaeKzrK4yGAgJwaRR3oPIl36keODyKNPkhyovcu+9RRLFbxqDRu1YQ
	3N+k74qhgYhL0klVx0oOsaDIZ70v5GlG/B+frRD1jrZyANW+7KrQwye1Py190GTN5hY8bYSJUQc
	+U+lyXLwloQ+O5vaCshTmZJe7cHZSov6+Yq16bapYg4gkK0P1km1xMRdmLQ4BlmkBZLZUYso+ye
	niCfaZVzjPcqPA0GSMXKMYOtA11S3+LJpYVdWCU8ymoRjO7O7Lb2WYkdw==
X-Received: by 2002:a05:7300:e9d4:20b0:35b:20d6:8eae with SMTP id 5a478bee46e88-35b20e5d33bmr4870086eec.3.1791849194438;
        Mon, 12 Oct 2026 16:53:14 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm15137264eec.11.2026.10.12.16.53.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 16:53:13 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: jsmart833426@gmail.com,
	paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v6 8/8] lpfc: Update lpfc version to 15.0.0.1
Date: Mon, 12 Oct 2026 17:16:48 -0700
Message-Id: <20261013001648.62289-9-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 15.0.0.1

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index d6e6e436fbfc..7df63d118234 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "15.0.0.0"
+#define LPFC_DRIVER_VERSION "15.0.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

