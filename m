Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BE92FBDE7
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 14:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759156331; cv=none; b=HRpO0QQpoQq2foRGozpO0wqzNRofRlNMUNHGyEezRejG/2aR8ejY/QvMmbF/uRrAMK4H/Tvb7klTxraU7cWHbG6NVfECk4FDrbNRrAqfFtUSU54Put4BvjBzI5o43wBVWjjl6M0luQJy7kALN1ou/JDjiE2qQDQjU+fw9Fj0kr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759156331; c=relaxed/simple;
	bh=LrRPQuMKiOe2UB2zNAgT4DBwOCNLXjtjlT0UfiIrZ1c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=W0Xs+x45HdFeLiCq0jhjXWf5UCe1yzMUZDz2oC6BqHhFfhqbbPoi5h0f8RvJ7MNScqHxgATOOrgJ2tVLBnLNh8VPUYjCqi85akwogo4edpEHM9A9r85Ju2Yl05ioL1V6fwNWDki0aZZZiFJrvpitBR0Zg43LSNFaL5HX/e8nRjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=REi+Z5gF; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="REi+Z5gF"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id dhWndp0tgPYFqwyP; Mon, 29 Sep 2025 10:32:02 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=0Js2CVA9NOJYSlBrL8cos40aWaC+e7UZeUO/zTkOktk=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=REi+Z5gF6X28Y+INjVnP
	SwcEg5LIxLg7mFIvOva+2X1uiOQg9xH3osRicX31B2DOkUEOKuRoFy/L29K4ToRsdBNo+VLEScif5
	0Mu3TPPYFi2uUownFmVkV6poIGW1hYuCeCyBpDoiO0+P3RPNlnytQWb4w7IeN+czlgPR7kbN/s=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14216600; Mon, 29 Sep 2025 10:32:02 -0400
Message-ID: <8082039b-df86-47e7-aaca-8f5413793d6f@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 29 Sep 2025 10:32:02 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2 02/16] scsi: qla2xxx: fix initiator mode with
 qlini_mode=exclusive
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH v2 02/16] scsi: qla2xxx: fix initiator mode with
 qlini_mode=exclusive
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <e95ee7d0-3580-4124-b854-7f73ca3a3a84@cybernetics.com>
In-Reply-To: <e95ee7d0-3580-4124-b854-7f73ca3a3a84@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1759156322
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1172
X-Barracuda-BRTS-Status: 1
X-ASG-Debug-ID: 1759156322-1cf43947df3c0120001-ziuLRu

When given the module parameter qlini_mode=exclusive, qla2xxx in
initiator mode is initially unable to successfully send SCSI commands to
devices it finds while scanning, resulting in an escalating series of
resets until an adapter reset clears the issue.  Fix by checking the
active mode instead of the module parameter.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

v1 -> v2: no changes

 drivers/scsi/qla2xxx/qla_os.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a52293972e10..f0b77f13628d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3438,13 +3438,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->mqenable = 0;
 
 	if (ha->mqenable) {
-		bool startit = false;
-
-		if (QLA_TGT_MODE_ENABLED())
-			startit = false;
-
-		if (ql2x_ini_mode == QLA2XXX_INI_MODE_ENABLED)
-			startit = true;
+		bool startit = !!(host->active_mode & MODE_INITIATOR);
 
 		/* Create start of day qpairs for Block MQ */
 		for (i = 0; i < ha->max_qpairs; i++)
-- 
2.43.0

