Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A433CB540
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 20:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785442315; cv=none; b=kp1nlq/4nva2kRcK27p07gSRr/wMj8ei5EQPZpMhfP0MoRiospcjToVnJXCTrgUDuLOuq2UG59DOr7ty5NGhQpdU+kTCkuDyZCx8BTW5znKBJRcfFVoPtQ3nnWpsMJ3+jL0xvuk3GBldqMtnqYENJfqCr1J4MlfHofEQBNiw270=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785442315; c=relaxed/simple;
	bh=ZdvgeoWh2TerW5rE/vqKIpMlNmv0bCF+vIbf9z8+9Y8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q/Txh/wPVjHp15srhyoSt/c1qqrY8z4Qbr7h8Xv/XEzi/CWs+4xmQl1/x54BXTaPfVCxfVS0Y505uCGRZd4dq7lvUxVn27aukDj65msrl6BRMXyOzRkqZ4lXuMquJlmc9hSaENfvsqt9XZbZJkeFtzIcrVCqzrfG7bz5GRYmwfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLvLbPlT; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLvLbPlT"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84e0688b859so201465b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 13:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785442306; x=1786047106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W7nssRnI5PbZKyunLFrMTG5kzkBNYctSVirvyP8FTcY=;
        b=FLvLbPlTZGHeA6IkbXCPJhDPieVDpLmcH2m7gQubPq6BMmoTK/RqhrPaZB7QzafEnf
         3EPIYSnCXuxvlgtjh813EyHxw8dos2Q/2+nzLBnt5T0oiJ8aMcSaovp2xyl/ZvySGsKX
         BFmGPbCgh/tZf7uFYmBpR8SFFQ2st78hX/T63X2d23JzVAxTyT/DK0Jpgjhuj+riyDTu
         9Pdyv3n9iGsPaxKyis0NVhHMuS6ccShpWeu/EGqlKILAsWycedraVQBPikHc7zno+V9m
         wxiHDRu2rb+feGZI3mSX2icOMVa3yAXfTHgyL3ZjiEwifhOYOCkDuzWLe/Y9h/nJZLaT
         4c/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785442306; x=1786047106;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W7nssRnI5PbZKyunLFrMTG5kzkBNYctSVirvyP8FTcY=;
        b=dqmE7l8NdMnAdhy5Z3EenDFHJmcdpex70UKBH7L5Ce8RcKiqeIyUJ9QDJir+lI6cpB
         IcgmikqALhmHGN6MsJu1/3690KolLmjhEjy/NZ/+nDGg0fzgxDVrZ4TYQTkimAW53AXE
         aGW5mgxvnr5FucMbc3ZDNBL51K1NuvJVqK0wvrxP3A1rpQZ5Zc8wsHjH6CqGZGK+F4V7
         jMUHUBv4EOjrrWJlEzv6YAELwBVghRxOHAw3LMDUAhDyhzxz7/nCl2x6c2udon7eHGSW
         Wq63znsG/Pl1QOz03EYSLeIP58xlqsOWUIogztureRZlqj1p4RtUy9sCpikXwuFip4dG
         657Q==
X-Forwarded-Encrypted: i=1; AHgh+Rog/7uNQZaey8TtHHY5/7z0738soetmd9+Z/6HnUCNIWxN3/s3dujTI4frF+bplizMx40PXeLl90gdN@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2B55wTS9ZY0doDjKS//UdHgcz3WDuGLofLkczgI4K7CU1L9Kq
	yau/HCL2Ng5Mt4AVSMhHcDX/9Hvrwfryb9vMopXLIjTQKe8QeLWaxgxs
X-Gm-Gg: AR+sD12lN8q9X1+ug73XdI4dpfUygCt7gCQZxZt2u0Ta/ZVwuSCmhOlbCaD9tRpTTOj
	zaTxRDgKcDzUvlL9se7sEv+HyJQibOPmOlyLF6QXRuay/NbM9kSyrV4tBVr6/B+/c/I7pZLC6O1
	FC8A5i1aIPBURdUC0q0P3Cdl/fjUaPHJMc/v3XXgcypZ7a0YonBqeejl+AJXsDd9IRB+pbOMed8
	yos8DSS2nVpEsdk8tsvhkmMHVLYmGKiOGcX0sjOh/vJvOnlqKdBCBDJvFcbOhqzuQpGYZkcEDPz
	O1nuwoKj/ctZQ8aNsv3h/TweSZ4eUig4uYV41RPntaUAh/ihan5dU4So7XCFr5S4OWTr5td3/PJ
	qpEyao1SdVGbCeQ9bWN/uFjR1CdIMxq8cZESWXh6buQJgm/UvvvEtTagzoKECSXJEZLdUACXzfp
	JmEsA3ZooZz+fAjZhsYmEki17cMadlq/e5t8HK+BSo5ozRrVsQQhCEu7xdxLykuBePBMhH5K9xx
	whOkp1OxqHfzUulhLueAeUA9OFwui5TzsuWWL/2lx4=
X-Received: by 2002:a05:6a00:1741:b0:848:5b1e:aec2 with SMTP id d2e1a72fcca58-84ebc3e39b5mr3714867b3a.54.1785442305476;
        Thu, 30 Jul 2026 13:11:45 -0700 (PDT)
Received: from localhost.localdomain (c-174-165-208-10.hsd1.wa.comcast.net. [174.165.208.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0055325sm3689108b3a.15.2026.07.30.13.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 13:11:44 -0700 (PDT)
From: Michael Kelley <mhkelley58@gmail.com>
X-Google-Original-From: Michael Kelley <mhklinux@outlook.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	daniel.lezcano@kernel.org,
	ssengar@linux.microsoft.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	sgarzare@redhat.com,
	horms@kernel.org
Cc: x86@kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [RESEND PATCH 5/6] scsi: storvsc: Remove support for storvsc protocol of old Hyper-V hosts
Date: Thu, 30 Jul 2026 13:11:22 -0700
Message-Id: <20260730201123.1767-6-mhklinux@outlook.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730201123.1767-1-mhklinux@outlook.com>
References: <20260730201123.1767-1-mhklinux@outlook.com>
Reply-To: mhklinux@outlook.com
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the overall removal of Linux support for running on Hyper-V
hosts earlier than WS2016 and Windows 10, it's no longer necessary
to support older storvsc protocols. Remove the support and associated
special case code. However, support for the protocol for Windows
Server 2012R2 and Win8.1 (protocol version 6.0) is *not* removed
because it is activiely used by HvLite in the paravisor for Azure VMs.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
---
 drivers/scsi/storvsc_drv.c | 53 +++++++-------------------------------
 1 file changed, 10 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 571ea549152b..095fce47c5f1 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -47,9 +47,15 @@
  * V1 RC < 2008/1/31: 1.0
  * V1 RC > 2008/1/31:  2.0
  * Win7: 4.2
- * Win8: 5.1
- * Win8.1: 6.0
- * Win10: 6.2
+ * Win8/WS2012: 5.1
+ * Win8.1/WS2012R2: 6.0 (also for HvLite paravisor in Azure)
+ * Win10/WS2016: 6.2
+ *
+ * Protocol versions earlier than Win8.1 are no longer supported since
+ * Win8.1/WS2012R2 and earlier hosts are no longer supported by Linux.
+ * But protocol version 6.0 is retained since it is used by the HvLite
+ * paravisor in Azure. The #define's for the earlier versions remain
+ * for the historical record.
  */
 
 #define VMSTOR_PROTO_VERSION(MAJOR_, MINOR_)	((((MAJOR_) & 0xff) << 8) | \
@@ -218,7 +224,6 @@ struct vmscsi_request {
 static const int protocol_version[] = {
 		VMSTOR_PROTO_VERSION_WIN10,
 		VMSTOR_PROTO_VERSION_WIN8_1,
-		VMSTOR_PROTO_VERSION_WIN8,
 };
 
 
@@ -1601,13 +1606,12 @@ static int storvsc_sdev_configure(struct scsi_device *sdevice,
 	sdevice->no_write_same = 1;
 
 	/*
-	 * If the host is WIN8 or WIN8 R2, claim conformance to SPC-3
+	 * If the host is WIN8 R2, claim conformance to SPC-3
 	 * if the device is a MSFT virtual device.  If the host is
 	 * WIN10 or newer, allow write_same.
 	 */
 	if (!strncmp(sdevice->vendor, "Msft", 4)) {
 		switch (vmstor_proto_version) {
-		case VMSTOR_PROTO_VERSION_WIN8:
 		case VMSTOR_PROTO_VERSION_WIN8_1:
 			sdevice->scsi_level = SCSI_SPC_3;
 			break;
@@ -1703,28 +1707,6 @@ static enum scsi_timeout_action storvsc_eh_timed_out(struct scsi_cmnd *scmnd)
 	return SCSI_EH_RESET_TIMER;
 }
 
-static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
-{
-	bool allowed = true;
-	u8 scsi_op = scmnd->cmnd[0];
-
-	switch (scsi_op) {
-	/* the host does not handle WRITE_SAME, log accident usage */
-	case WRITE_SAME:
-	/*
-	 * smartd sends this command and the host does not handle
-	 * this. So, don't send it.
-	 */
-	case SET_WINDOW:
-		set_host_byte(scmnd, DID_ERROR);
-		allowed = false;
-		break;
-	default:
-		break;
-	}
-	return allowed;
-}
-
 static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
 						struct scsi_cmnd *scmnd)
 {
@@ -1738,21 +1720,6 @@ static enum scsi_qc_status storvsc_queuecommand(struct Scsi_Host *host,
 	u32 payload_sz;
 	u32 length;
 
-	if (vmstor_proto_version <= VMSTOR_PROTO_VERSION_WIN8) {
-		/*
-		 * On legacy hosts filter unimplemented commands.
-		 * Future hosts are expected to correctly handle
-		 * unsupported commands. Furthermore, it is
-		 * possible that some of the currently
-		 * unsupported commands maybe supported in
-		 * future versions of the host.
-		 */
-		if (!storvsc_scsi_cmd_ok(scmnd)) {
-			scsi_done(scmnd);
-			return 0;
-		}
-	}
-
 	/* Setup the cmd request */
 	cmd_request->cmd = scmnd;
 
-- 
2.25.1

