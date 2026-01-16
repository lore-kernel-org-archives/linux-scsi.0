Received: from mail-dl1-f98.google.com (mail-dl1-f98.google.com [74.125.82.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF4A34D3AD
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 06:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768544035; cv=none; b=oosNFT5QwAmExj5tbMX9auzKxyYji63sda6ZhQnGMVR4Tg+LO8i2AE3RALjaeDYEr6SGsQWBCN0pjbgHJq1eFGAwF7SPKqhxgfOGH1rV7YodCIe4c1RJgm37ZNcBLHr+8wMXiP6ywocL8YIMfNA1vCGB3vb11ljBTUpfI3FgURs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768544035; c=relaxed/simple;
	bh=8qYqj7OopSpEo5EwoOfYLidYsJhdyMMtYv/YCDYLrhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlLwlQP1+GochG9282Kr31q9qobSZyxPJG1BGBpfqb6gAJB7720qv1vy/IWbN80dWQqyg6COyjrDUaGnFKWvZsGF3KZYDGDcCDRWycGf7YCEYJh/rVOJw/68xSl0FwAEwlQvk1JjN1djUgHmyWXZUAn4UZb58fkdEw/3zg4amLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ezPKY7st; arc=none smtp.client-ip=74.125.82.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ezPKY7st"
Received: by mail-dl1-f98.google.com with SMTP id a92af1059eb24-121a0bcd376so4398405c88.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:13:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768544034; x=1769148834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AsuNs7TIEyqtlTcsf6/g+jMXDETc9mH3Q+Ng0LnHQ78=;
        b=FQudpr7+c7ScaLLTww0IA4q1FkgIryyklaweCioJ8D1HmFBewT7pfCx+tcRDDN3uQa
         R6/K3FJF+yGHOdtm+QSewUQC8izzr3PiO5i40srLZqrNydu659Bicdzh0x5AG6envEtI
         mnYlRrCP0mykoupRQwZWuE611XQUOZa6aEewRuAOSFASGhwZnBXXcrtOjunsr9l8EnmD
         aypeK5ncWHLIgIjpOo2ZC3pOGXZXzW5vsqG6W/7LWyWEa4u3KtY3rMtGQdFqEvuXFJ5g
         Y2QWBJ8/YCJ9heS/NH1XnMttMqntK5ORhlqP1PU7GN7v/hHIPKQ1/DdtEiTPt5l7cBOB
         F8Hw==
X-Gm-Message-State: AOJu0Yz5wmzljFUs0apKmM1S+UO+pE2/YZDDboLmocn43PK0WDasBo2L
	KUv3LyPTn2Z1AJVm+PvRceYKFYdid7YVVGz02E/yF0ZvgROEhFV6S4TRLPhmz/bVo8gEjXxrF0Q
	Bezhin1jKewG7SOKhTdEP1OS4A1JvSroaog5TdG0D0bL2RDyfzRmJ2XrbNb95VPokfwALtL0UnV
	o6qLyMOY1vbFMUiNbn1c55vaGTUYBEWEPxgPd1DXgDP3pWcqq5ud+jB3KKJcmaCbvq4lPPh7UIr
	3dvX05YUyq5zAfC
X-Gm-Gg: AY/fxX4MurnLQphFEw5K/OleDNYuH3r4PeAk7Rnkqfpnvjrm42YgufVzpgKNY61vlAH
	H198HXRYQ93+rjEM/J05shvueqj6rkxuEv0y4qZewQqxW/EuEoZ89qSTIScH0SLvOm9UMIOVr8j
	49h8q/CRQjMEbu0iHc2m3Bp/7NpdrH0+aLH2t6rSvzJSKzquOK7Frdh834rIEQx77gIGM8QFjb/
	yxbX1wqI8Gm5hMb/y50H5iTorWFmdZRrmjLe4x0OiDccH4REouuGZahamLkug6BiZV4jBdMtFKY
	EGw+CQIh/ZmZBLA+DjRVcWz9ntE+7MRKcOSHi6P3JGfMXYeOgvEAPKUZtXABawMm0BP4M077i/4
	HAlcUuCJsjcT6cJm7kH3Swts+2oxLWAcT1gPRRr+vYttq53pK3Rb+2pgFv6LrVKB74xpTIF0qkJ
	WJ6yV75dSzH+TJMeAvEXr/suSWxozSBq8aBks6Iydno21iB4k=
X-Received: by 2002:a05:7022:48e:b0:123:3461:99be with SMTP id a92af1059eb24-1244a6fe904mr2814040c88.21.1768544033602;
        Thu, 15 Jan 2026 22:13:53 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-1244ac45d6asm352181c88.1.2026.01.15.22.13.53
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jan 2026 22:13:53 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a0e952f153so35506105ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 22:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1768544031; x=1769148831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AsuNs7TIEyqtlTcsf6/g+jMXDETc9mH3Q+Ng0LnHQ78=;
        b=ezPKY7stegadpCTPZTQe/7wm0gP1Ivs06wI0cRp3LbX5XpmMN9UesOC3Ezu/kwpJBR
         6L9RJr5VJSam5+lS8ecLgu1lxOitQFueeLkUI637V/gJ0Cuv2s8tdAZU4CNCCz6DsQs1
         vrgo8/T+44tAwr+M7i8CfrbWtbrg9f7nIMxzA=
X-Received: by 2002:a17:902:d484:b0:2a0:d43f:c934 with SMTP id d9443c01a7336-2a717529f3emr15760865ad.8.1768544031473;
        Thu, 15 Jan 2026 22:13:51 -0800 (PST)
X-Received: by 2002:a17:902:d484:b0:2a0:d43f:c934 with SMTP id d9443c01a7336-2a717529f3emr15760715ad.8.1768544031059;
        Thu, 15 Jan 2026 22:13:51 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941bd9bsm10231315ad.93.2026.01.15.22.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 22:13:50 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	salomondush@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 1/8] mpi3mr: Add module parameter to control threaded IRQ polling
Date: Fri, 16 Jan 2026 11:37:12 +0530
Message-ID: <20260116060719.32937-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
References: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Add a module parameter to enable or disable threaded IRQ polling
in the driver. The default behavior remains unchanged
with polling enabled.

When disabled, completion processing is kept entirely in the
hard IRQ context, avoiding the threaded polling path.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index b564fe5980a6..1300f9af4c74 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -21,6 +21,10 @@ static int mpi3mr_check_op_admin_proc(struct mpi3mr_ioc *mrioc);
 static int poll_queues;
 module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
+static bool threaded_isr_poll = true;
+module_param(threaded_isr_poll, bool, 0444);
+MODULE_PARM_DESC(threaded_isr_poll,
+			"Enablement of IRQ polling thread (default=true)");
 
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, void __iomem *addr,
@@ -595,7 +599,8 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		 * Exit completion loop to avoid CPU lockup
 		 * Ensure remaining completion happens from threaded ISR.
 		 */
-		if (num_op_reply > mrioc->max_host_ios) {
+		if ((num_op_reply > mrioc->max_host_ios) &&
+			(threaded_isr_poll == true)) {
 			op_reply_q->enable_irq_poll = true;
 			break;
 		}
@@ -692,7 +697,7 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
 	 * If more IOs are expected, schedule IRQ polling thread.
 	 * Otherwise exit from ISR.
 	 */
-	if (!intr_info->op_reply_q)
+	if ((threaded_isr_poll == false) || !intr_info->op_reply_q)
 		return ret;
 
 	if (!intr_info->op_reply_q->enable_irq_poll ||
-- 
2.47.3

