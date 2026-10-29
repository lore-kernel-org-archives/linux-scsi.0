Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793233546;
	b=NUXpksQJEXen7UVx9ANnLX8KjVK46Eh9H2ZFL3yDNn5cRyNm7kkY1QAcrLloBE8eT6aP
	 8AfW1j6/6Kp/Tyk6c5mJJjlVrl8KNGD45aFVYYG7dpIOzVODRRn6znzRVGfPceqwiaWxp
	 40520KL8GvYuTjK7dGPJ6A18+vfnbkzGVU3K+YD82UvgMRWea7D5Y815UzJgk/daQznl7
	 uDDjAt9vLSSAjNb+TGGfw4ptKvSJJ/fMiPBDtCLmTlKfzD+7lNxptzlSnudnX2TxcnLvg
	 T3DHAeShT7dbejIa7f0VKwucldBOA1g7p8GcYXhOTH1tmh9v8dQfKzN8Lq8sQuu+umw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793233546;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=58BA4wmiehwqBDRQ8QyxgKiK12gxkFFjqzV6EDIWRVI=;
	b=yEHqVXbHOYZq1ppzooZwoqina87BgdLZGvodweiQo7wPi101oyoZVNHYMAS64uDshKPO
	 I7cqbUVdR5F7dtX6fXzQM9kXZaKZgKLorMXw6p5toWPLMPTCB0VmmVDq3IaqFo2lqJ9X1
	 mLJ7fG6OLRKgoyhRU9UmFheRLiJ3cyDIyEvKLVlKYMgCZQLgPruwaGBoQiSbOQU0wRT3O
	 o3I4pnhrKSmVejk3jYg/BcVeGCmkrOgljH2cPJlz2yvk81E/+SYNtW+xbgQY+/pJ2CwR/
	 2h1VTsDe0OrMexuo8WXKVwmMEn9Cb7QYxVk8CPkkayYQC2QEo7zRBNTZu5fxz0kJ6nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=eWIKbrQY;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4DB606A322
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:25:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA4DB606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=eWIKbrQY
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-36a2551d7b5so260088eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 17:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793233545; x=1793838345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=58BA4wmiehwqBDRQ8QyxgKiK12gxkFFjqzV6EDIWRVI=;
        b=eWIKbrQYMLwyFOOOuLimqYbiN/Z5cgQH9Jo4RLKaD8gmvUxiz/NtKiyUTcXUDORYqd
         wn1lQPf2BtyK5ZAPw41lv1qw2jLR/AE+X+YTSicWl2XXIDf9gITaHv+d7syzs1fqmqv/
         /MAQncvxTCldFQOhC/mN/BkgHdMEW2L9BpCt/av6y2WLPA2NpyTeDaRnJRTPs0Y1sUyd
         2yJZuvUewDDZeBTcCjnaUGqQFvIL9/+wp1+FuQvWz02LgRKlRokY8xCBQOJVT57VRXeX
         CGKWbicO0MRn9eX5MypTBp3FgkyyslmoNZOZB07yHmL8N4v4ngwiR/XMyqb4EjHFgj1L
         2RDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793233545; x=1793838345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=58BA4wmiehwqBDRQ8QyxgKiK12gxkFFjqzV6EDIWRVI=;
        b=rSdoKEimoAjTgdAT5/EfBJoJFeZRi0NdNubJnLVZQ60snIKoGP7CaQRjKWQS2OfdlJ
         eLd/wAGtyCi4/zMVzWFxPm+lPPpv3/FXf9Klk9HTgQJHwzami9VjEeTyq+IlTp6axLH3
         AdiPasaqJHTFzVA+Bfh/LoEUEy69g7tFxsvREKipUUlAGa42yEMKHk3LRSN+87y6+oT/
         KjqUb2dxdt5Guc+c9GzMPxIN9jljX/2SuMheRTgDAN3J5MMlShe4LIHWQ99qE1JbtPkA
         XmJ61WsvfQs5zgdcA1aU6s2NRN+1k7+KHuCjjh6lpNS6nyx4RIivT6IiuI9EgxHStfwt
         Tmqw==
X-Gm-Message-State: AFq9FYJO03ez+iZrLJl2qN9e7j0sPY16mQz3vwO5uaF/u8NXvNfv0NXO
	2Ws11PsS7ar59Zh2cQgAUY3D22O7E6IsiLNHiRafDh+M5FOjF1Zkr02+6eqJtZmW4rS5nJhf4Kc
	J2CpwTGenCV7Ima6HQJCDhhRTMhHtPNbPYyaG1fw35qY5CBFSsLAFmgDvdJs47gz/aUKOBl4Tsl
	0IRjUNz66otLeTK/C+JskZymOjMQp2mUhnWNy+SvyBJOs4wEee2A==
X-Gm-Gg: AYBFou3UuxLzTgtNtQnVLf+4kh34p2WuRJyoEI7MAOw2GEyIL7bB2SuZiCykPTJcSBo
	/Ks2R5k3EoBu4splztNBi9aij+QML2x31vr77QK2MAH7whLDFB8JMneOYfStrNQ9Z8bTF/kywRK
	dPqj91qBxsi4ILW+HumW8IUvYr2wWjWw/U7NU9QtZfu4QsAeovAoTcPGzscOxjfhHUP2zQ80JPm
	3uOsi68yGZkAJBmUSHqhXrScLfIVK30rX7tqEvVo1KlR+CNpPBKTvCLeXEYkPqtQeWu0/Dz7utr
	1gBrphrnWhqQKGQ2b+4aIHUzOLn4RJW+bfD+Tf207/YeBsYsEVFW4iEI5YRjl/2C6UUeeRwn5Y9
	WCDnrywAeiIzHQSJrMuvKjH+XJUzlCRKLQZ1aGhlroaRJVmafCirLD+gCtNkQXfrD1OJYIvfrwc
	ufAOFKcJzvvLZq7L75jX+dNIiZvIQDVGbL0IViNWf1vLaKkNb99GBQgA0j2hb5lsCgnUylpWYDQ
	IUKrpSiKCrfVr8NAhw1Ihk3CxYtTkskuGWOgRgiiwlSfK8w0rMTiTno/dX4v+McFkv/MjhkOeua
	Qy29vguI8raYO+0WCWFALOumBONM0oh9XYuGZ1s/bmrvY7IV8sXAH4aCyW+PFbAmByn2IggXEJF
	eMpi0LIblTiQRjRb+L0QL4VKFeUwUG6weWjIODw5rZh8jSzByrfMonfZ6u05WMIl8v4RmJZ4mzO
	zQP6K3LPFmixI2aBqknIYGRv+2zQ==
X-Received: by 2002:a05:693c:88d7:10b0:35e:af84:bf1e with SMTP id 5a478bee46e88-36a2fd70954mr1434704eec.7.1793233544540;
        Wed, 28 Oct 2026 17:25:44 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a239a2e29sm11294226eec.26.2026.10.28.17.25.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 17:25:44 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v3 2/3] scsi: core: Read the ALUA access state when a device is scanned
Date: Wed, 28 Oct 2026 17:25:30 -0700
Message-ID: <20261029002531.82824-3-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029002531.82824-1-brian@purestorage.com>
References: <20261029002531.82824-1-brian@purestorage.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sdev->access_state is only set by a device handler, and the ALUA
device handler reads the state with an RTPG that runs after the device
has been registered and matched to a driver. The SCSI core therefore
has no ALUA state for a device while it decides whether to bind an
upper-level driver to it.

For a device that reports TPGS support, send REPORT TARGET PORT GROUPS
from scsi_add_lun(), after the VPD pages have been read, and set
sdev->access_state from the descriptor of the target port group of
this path. UNIT ATTENTIONs, which a target typically reports first
after a login or an ALUA state change, are retried, and the command is
resent without the extended header if the target rejects it. If the
command fails, e.g. with LOGICAL UNIT NOT SUPPORTED because no LU is
mapped at the LUN, sdev->access_state is left as it is.

The command uses the same timeout as the INQUIRY of the scan. The ALUA
device handler keeps updating sdev->access_state afterwards as before.

Suggested-by: Hannes Reinecke <hare@kernel.org>
Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 94 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8aae12fd38f3..a21dee1d9e9e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -861,6 +861,93 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	return 0;
 }
 
+/**
+ * scsi_read_access_state - Read the ALUA state of a device
+ * @sdev: SCSI device that supports target port groups
+ *
+ * Send REPORT TARGET PORT GROUPS and set sdev->access_state to the
+ * asymmetric access state that the device reports for the target port
+ * group of this path, as identified in VPD page 0x83. If the command
+ * fails, e.g. with LOGICAL UNIT NOT SUPPORTED because no LU is mapped at
+ * this LUN for this I_T nexus, sdev->access_state is left unchanged. The
+ * ALUA device handler, if attached, keeps the state up to date later.
+ */
+static void scsi_read_access_state(struct scsi_device *sdev)
+{
+	/*
+	 * Each UNIT ATTENTION reports a different condition queued for this
+	 * I_T nexus, e.g. a power on or reset after login followed by ALUA
+	 * state and INQUIRY data changes, so retry until the target answers
+	 * the command itself.
+	 */
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense_key = UNIT_ATTENTION,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
+	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = &failures,
+	};
+	/* scsi_report_tpgs() replaces the buffer if this is too small */
+	int bufflen = 128;
+	int group_id, len, k, off;
+	unsigned char *buff, *desc;
+	bool ext_hdr = true;
+	int ret;
+
+	group_id = scsi_vpd_tpg_id(sdev, NULL);
+	if (group_id < 0)
+		return;
+
+	buff = kzalloc(bufflen, GFP_KERNEL);
+	if (!buff)
+		return;
+
+ retry:
+	ret = scsi_report_tpgs(sdev, &buff, &bufflen, ext_hdr,
+			       HZ / 2 + HZ * scsi_inq_timeout, 3, &exec_args);
+	if (ret) {
+		/*
+		 * Some targets reject the extended header format with
+		 * ILLEGAL REQUEST (see alua_rtpg()), so retry without it,
+		 * unless the reason is that no LU is mapped at this LUN.
+		 */
+		if (ret > 0 && ext_hdr && scsi_sense_valid(&sshdr) &&
+		    sshdr.sense_key == ILLEGAL_REQUEST &&
+		    sshdr.sense_code != LU_NOT_SUPPORTED) {
+			ext_hdr = false;
+			goto retry;
+		}
+		goto out;
+	}
+
+	len = get_unaligned_be32(&buff[0]) + 4;
+	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
+		k = 8;
+	else
+		k = 4;
+
+	for (desc = buff + k; k + 8 <= len; k += off, desc += off) {
+		off = 8 + (desc[7] * 4);
+		if (get_unaligned_be16(&desc[2]) == group_id) {
+			sdev->access_state = desc[0];
+			break;
+		}
+	}
+
+ out:
+	kfree(buff);
+}
+
 /**
  * scsi_add_lun - allocate and fully initialize a scsi_device
  * @sdev:	holds information to be stored in the new scsi_device
@@ -1126,6 +1213,13 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	scsi_cdl_check(sdev);
 
+	/*
+	 * Read the ALUA state before the device is registered, so that
+	 * scsi_bus_match() can use it. This needs VPD page 0x83.
+	 */
+	if (scsi_device_tpgs(sdev))
+		scsi_read_access_state(sdev);
+
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
-- 
2.56.0

