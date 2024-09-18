Received: from mx1.t-argos.ru (mx1.t-argos.ru [109.73.34.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E251304BA;
	Wed, 18 Sep 2024 08:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.73.34.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726648097; cv=none; b=S8hw9kanHmGnw2Da2fuq5OXCy+Q36NVCoDfw1Gh5HjzBL4rPtvVkTKL+Epz7Yi+cROFrFTQpOePd903Ld2akSoY13nOYosxJuqf/YtqLQXi9zxLWmIHr6epDlgPiqqqFt/P+M8wR1FuZKFrqid8ALcky/RoFwmgFLMtid+CCBA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726648097; c=relaxed/simple;
	bh=hZwlQTwJtdlp1N573YzYJf9gsSLaxWPPduzGsP/A5JI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IM0pD9EfsZD/KVBZoWr7dKcfXTsbIBSzrci9ac7tYIyz5blKCDJkWVUVoF2br6Dz9Ar4d89p4lf/4xyANk7YZNI6lTp+qo8NG+IM/+BjjeW2mGdoW7DuZbsyzZFiiANg109MOC4ZXeHyEaC1goKzALCW4MNuH8bSn6kX39vd96s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=t-argos.ru; spf=pass smtp.mailfrom=t-argos.ru; dkim=pass (2048-bit key) header.d=t-argos.ru header.i=@t-argos.ru header.b=pedOXE0U; arc=none smtp.client-ip=109.73.34.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=t-argos.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-argos.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=t-argos.ru header.i=@t-argos.ru header.b="pedOXE0U"
Received: from mx1.t-argos.ru (localhost [127.0.0.1])
	by mx1.t-argos.ru (Postfix) with ESMTP id 4F70E100002;
	Wed, 18 Sep 2024 11:27:54 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=t-argos.ru; s=mail;
	t=1726648074; bh=0sPboU8IYRBlIY1XmA9cL2CH1HZBlyyxQXxh+ilOe/Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=pedOXE0UIoZo8HrV7G5utGFTvy0vXSWuc5+n24Y5sypF1g3Fvzt8tj1wY7AwwMdDa
	 je1Oi5zZVljR8RRJIy0sIsgr2Tec0lX1PLya7I0zvwvU5Ndkn8Xiwm6l/IymMQQFcN
	 Co1KooNhe6HxWGJ9BcKqti2XS2w1eGkfFyCqWwVZXcU7epn9qIJuu1mYMgpWodcpUf
	 UuCpFZoagZxfIT6zPdESq+QP3rmT3/dSqCFE9VaenM95nJUAiPdEB8impY/nX7slcT
	 /Uk4QvQckqnWt7rht91TTggpYktijGGefIE+EXmLd4/HWeoPTjBYF3Np/hurHeTAur
	 UhnsCxP7DEDeQ==
Received: from mx1.t-argos.ru.ru (mail.t-argos.ru [172.17.13.212])
	by mx1.t-argos.ru (Postfix) with ESMTP;
	Wed, 18 Sep 2024 11:26:53 +0300 (MSK)
Received: from Comp.ta.t-argos.ru (172.17.44.124) by ta-mail-02
 (172.17.13.212) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 18 Sep
 2024 11:26:33 +0300
From: Aleksandr Mishin <amishin@t-argos.ru>
To: Eric Moore <eric.moore@lsil.com>
CC: Aleksandr Mishin <amishin@t-argos.ru>, Sathya Prakash
	<sathya.prakash@broadcom.com>, Sreekanth Reddy
	<sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, James Bottomley
	<James.Bottomley@SteelEye.com>, <MPT-FusionLinux.pdl@broadcom.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>
Subject: [PATCH] scsi: message: fusion: mptsas: Adjust bitmask calculation in mptsas_setup_wide_ports()
Date: Wed, 18 Sep 2024 11:26:19 +0300
Message-ID: <20240918082619.13369-1-amishin@t-argos.ru>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ta-mail-02.ta.t-argos.ru (172.17.13.212) To ta-mail-02
 (172.17.13.212)
X-KSMG-Rule-ID: 1
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 187815 [Sep 18 2024]
X-KSMG-AntiSpam-Version: 6.1.1.5
X-KSMG-AntiSpam-Envelope-From: amishin@t-argos.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 34 0.3.34 8a1fac695d5606478feba790382a59668a4f0039, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;mx1.t-argos.ru.ru:7.1.1;t-argos.ru:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2024/09/18 08:11:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2024/09/18 06:30:00 #26614577
X-KSMG-AntiVirus-Status: Clean, skipped

In mptsas_setup_wide_ports() bitmask is a subject to overflow in case of
phy index is greater than 30 because shifted value is not cast to larger
data type before performing arithmetic.

Cast shifted value to u64 to prevent overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 547f9a218436 ("[SCSI] mptsas: wide port support")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
---
 drivers/message/fusion/mptsas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index a0bcb0864ecd..6641e305e888 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -915,7 +915,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 			port_details->port_info = port_info;
 			if (phy_info->phy_id < 64 )
 				port_details->phy_bitmask |=
-				    (1 << phy_info->phy_id);
+				    ((u64)1 << phy_info->phy_id);
 			phy_info->sas_port_add_phy=1;
 			dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\t\tForming port\n\t\t"
 			    "phy_id=%d sas_address=0x%018llX\n",
@@ -957,7 +957,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 			phy_info_cmp->port_details = port_details;
 			if (phy_info_cmp->phy_id < 64 )
 				port_details->phy_bitmask |=
-				(1 << phy_info_cmp->phy_id);
+				((u64)1 << phy_info_cmp->phy_id);
 			port_details->num_phys++;
 		}
 	}
-- 
2.30.2

