Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794467905;
	b=lKZNwOEFPnYzlsGxJOajXvIMPqqj7wvD2YQQSdmSJNmqbXVSrRbi2y2OZqOq0NpD2MtM
	 F44i0fVl0hPsSXBPdoFaN82xqDAlcebIBpVsPovC4vq+SpWNci8qNQWbcuIKcK6BwSCOf
	 AuOC7tLlCBJUoWiKM7OeRDHyjUStgrM8Kz8NofDeeeipzXzKPWxYth+1qj+rUFUA4Bp3M
	 xVciWJ0PjQ4Oxcwoe03ocD1vMFtn1aiA0HPpjNxmfRCEJX4SM3mewvwHHq33BgTaZgv8n
	 eee1/B0po8ds+hXPzcD/EAoW9Q+MVHg360NJJCBQ/gRNckIxAW9U+pKjE7GepWFl1JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794467905;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pm4Wc6TgatGh/qcvmdtaAjAUmMmeL2zmmSm7W51Q4A0=;
	b=yVAlOXol0h4zWq+0v2ZSJqi8fgGVTFFjPIRuZuKbVh5CoQtOCrxAKzopzryDqXPruSGR
	 OYoMhmXBttziyjP3Z3fPeQ+LncVfDqfIVb4vZJc8Y4JkF9q1YWMqKrTxBN8qeu6OkFk8h
	 HFAtgfW4ApVNhZe8WMABFtUzi6i4vqVfa83E3OoAwoLAetCWcV5KgWW6I4JuSb0s0rWHm
	 xMX8wMjyiYWPgeol6QbL48G02OsbeafBibm8Bx5L91wBANO6/FFEmdwDW5QC4Ce6BevKp
	 +sk/wLiKumxQmLcqZFdMaUFm1H2gzmX/r0EUsDMWxgjb1n5oxl25tsTncr/O2qCGK3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ELUiBbVX;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72FF60A3814;
	Thu, 12 Nov 2026 07:18:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B72FF60A3814
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=ELUiBbVX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=ELUiBbVX1MHpgDG3K4Fxo6GXYEL9BmE6n0wiPyeOXW8N7laPoTIZG3M4HEO0YmvDX3ZcQG53ziMQX
	 SVNwYBWb07MjfBAdJXSIrxYIJpaWpq8z/5DlMdqha9dI7rxcPr1y2ZJVSRpIKEdabH1E23kcY/kc89
	 AhqqaO681UdHzpis=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56af5681f3a3-dcac8;
	Thu, 12 Nov 2026 15:17:53 +0800 (CST)
X-RM-TRANSID:2ee56af5681f3a3-dcac8
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from devin-VMware-Virtual-Platform.localdomain (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea6af56820331-f6894;
	Thu, 12 Nov 2026 15:17:53 +0800 (CST)
X-RM-TRANSID:2eea6af56820331-f6894
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: hare@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhu Jun <zhujun2@cmss.chinamobile.com>
Subject: [PATCH] scsi: myrs: Put the SCSI device after logging a physical event
Date: Thu, 12 Nov 2026 15:17:51 +0800
Message-ID: <20261112071752.154639-1-zhujun2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.51.0
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

myrs_log_event() takes a SCSI device reference when processing a
physical-device event, but does not release it after logging the event
and updating the cached device state. Each matching event leaks a
device reference and a reference to the low-level driver module.

Put the device after processing the physical event, including when no
host-private information is available.

Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
---
 drivers/scsi/myrs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 1192b01fab8e..1f248501a611 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -877,6 +877,8 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
 				break;
 			}
 		}
+		if (sdev)
+			scsi_device_put(sdev);
 		break;
 	case 'L':
 		shost_printk(KERN_INFO, shost,
-- 
2.51.0



