Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043415;
	b=bV9yxspGFC4ETAU/kN+k3k5O0pfXqMCW10M9kOMuQHhXpTdONiuxu55uA30nO7iqIA/n
	 TaHydg5vbpvSiaToqVyxLc60N0SdLFUDZJNf00DcCQUbNt6stZKq8sI4FMk9BZlCZ1h4b
	 yISHBbROnicHlrv2R7lKrWPclxLA4SMaxSN08TOgwYb2NnyW8DUIXAOnrgJzZnNRXiBbd
	 +We2rf0+93ybmru6U9BevY2dThWglV1eJXU/Es4V3G0uhLTZlT03pypX7i3pYxThtIp0c
	 0cMKZUYWXsO20PJUvJhdf2pgj7tKy9NK0NkAYWDsW3FDHyYvDoSmah9VyH7O3SaFCXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043415;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=l+Rsz/lRpQJQZahRTOyKXO8dM+Q3Gjdy6ykvGWPsdbY=;
	b=Ubk7ABuPprkriP/MEen8jRQLcfyrGPVTSQf+/9U2ePtaOoiNwh9Vfcs6GmFWnRs8sUjK
	 mJGnHqpxvrexkV4nzcmjr3ObQzoiFWxougZ54DdbkfUml23wKpimrMk9in/66YwRFLrtn
	 5jes2M2z7rq2kK56wnq6EgQSqBtolpJzZqFlFViKHVzuTuOd5q85ev/uR92FYjhLa/s2T
	 83xNw04K6TsV8f5/vCTlhs8oVb+3V06e/406ReZNQAh4pbypb2nnliz12FGZkI9LScaCR
	 HGYW3Cyux/j1Jh06uett2UvTXDSMdlnieiuGhFVMxwVI5t/ceP6tBv2RKsOC1Y74TmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=asOWzzAB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA8860A3823;
	Wed, 18 Nov 2026 23:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=asOWzzAB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEC81F000D3;
	Wed, 18 Nov 2026 23:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043414;
	bh=l+Rsz/lRpQJQZahRTOyKXO8dM+Q3Gjdy6ykvGWPsdbY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=asOWzzABuIpniE0ug05f8gzZQXTajP6nQ0ZzubVp0yuxqV2WaTsVgZEiAFB247e4L
	 WE4NaC5mfxftbmsuBSbT61ixm90EXtMG51jUELLl5zMkKZz+mCIY1FgPVGQaAA4OXZ
	 h4IiBYIvBhcqJfF3KDHglsReG2HsCJs5OvGpKRrTg3+k6JkJ8bbSGz0j2cF/RpywsJ
	 vZYgvMyuxpcwR0pXH+lCOeLFPoeA5Gk9SaAyPK1IwU2dQiZ4NrTGXoDDdBrodYdGwH
	 LJC4ptsbmPV0+PhCZ5AOL3DBwOXenQeVAxgseCFVBNxwdYb4CUOHncu0qivAB4MP01
	 k/837vKnjU/8Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:10:04 -0800
Subject: [PATCH v3 07/11] scsi: mpt3sas: Reset the TUR retry count for each
 device
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-sas-abba-v3-7-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
In-Reply-To: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, 
 James Bottomley <JBottomley@Parallels.com>
Cc: Keith Busch <kbusch@kernel.org>, 
 Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2170; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=rC5vZOAow+6ceIesiT572FCQ9Ms9qxTSmCnkZb5D1pI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBR7Sm+GlTq3XINpPSaYZ7d0o2iGneQaT9JN
 CIUostddTKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUQAKCRAADmhBGVaC
 FfCuEADMCtbm4ueilP6KJKTflSds7r3uTkn/PPg9Fa/F6qaaQ8GpEotgSr41cF0kU6FbLMfNVe9
 Mjb07ixkMUvOCSjB09oRCp4jSwiij4VUHrb55jAdgQivirc6sqig7Mx6pmRxEnss9aNhSJOa+J7
 Be+JhaPjn+NCVxw9eLcifm3pdneUHvqv+23SkDE3cxt2iHTT/S1WcGJuIShl9kwIsLmz1RE+ch6
 fqh2Qvhr8mZTgMz+VZB5ORcL8VnNyGzipwZm8KUQEM3kRTMab7SCNLjLrJ4QsiGpyeeayo3Pzre
 IfvstsJcN7Hfgi6rzO88sbjSvzUd7oe/GH77HMQ0vRcq2DVExaF9ZIyVrwCPPb9omwGBCF6fbO/
 qzKJtSZy5XPisTRYh44q5mdrhYGH70LCXTNGWDHy7l3T1C6F/G1hoHvxmk+Z6RsHmJ4qVMD4YFk
 iP3s4AgC8OaCiMtTYfbyZVBzDzJhiDn7DFJ2QMsTc81cZfdjPxKe4uSFj6DpK/wb9PfOogglg4j
 +7LxtpLOpIZVqw2Y77q8ClccHS4rGG+wGpMjEGjhqGungzJ51SG4Zzv/LuthodlopgYYB/vksXG
 RHg/HELdy8ZYHfLLwQKR7JzraT1ACCoWta0Ow21gGMBlzEbViswFUYu6ODWHh5lGHvvv8RCEnXA
 Guuq2OCT+exEMkw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

_scsih_ublock_io_all_device() and _scsih_ublock_io_device_wait() poll
each blocked sdev with TEST UNIT READY, for up to command_retry_count
retries. These functions set the retry counter to 0 once per call, not
once per sdev. Thus retries on one device consume the retry budget of
all later devices. When the budget is empty, the driver marks a device
deleted after its first TUR and sets it SDEV_OFFLINE. This occurs even
for a device that needs only one retry.

Start the count from 0 for each sdev.

Fixes: 72340fecd0c8 ("scsi: mpt3sas: Add configurable command retry limit for slow-to-respond devices")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5657bda241f7..1269446eec4e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4089,7 +4089,7 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 	enum device_responsive_state rc;
 	struct _sas_device *sas_device = NULL;
 	struct _pcie_device *pcie_device = NULL;
-	int count = 0;
+	int count;
 	u8 tr_method = 0;
 	u8 tr_timeout = 30;
 
@@ -4113,6 +4113,7 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 			continue;
 		}
 
+		count = 0;
 		do {
 			pcie_device = mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
 			if (pcie_device && (!ioc->tm_custom_handling) &&
@@ -4199,7 +4200,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	struct _pcie_device *pcie_device;
 	u8 tr_timeout = 30;
 	u8 tr_method = 0;
-	int count = 0;
+	int count;
 
 	/* moving devices from SDEV_OFFLINE to SDEV_BLOCK */
 	shost_for_each_device(sdev, ioc->shost) {
@@ -4234,6 +4235,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		if (!sas_device_priv_data->block)
 			continue;
 
+		count = 0;
 		do {
 			host_reset_completion_count = 0;
 			pcie_device = mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);

-- 
2.56.1

