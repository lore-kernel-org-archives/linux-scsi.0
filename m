Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699180;
	b=kjMFbRSMjL2lajoZogohDzuL6C4CIyiCvpC035X2Q1o/Teg50C6+GGJFGtYVhPkUWSg2
	 wMW4CbsSB1clu3r3c8A3Y3b4rnTgqJO8Ka/NIwPLPXcPl/tNLe+DHXZvS0TgoUzk15ClF
	 +pSUadz9GcYZvBIsjpBT2XAFRSRGXZXeaAzeF+nfNoV5G/SgAKb9fsOiUPHxBH1JTFTXq
	 ZYFXPtfaCeAjDJ2g8+/QxsAY9ciFUmFYzF/ktNhYaNRGbpRmSqZQgg4yXoWsRbsqoe4l6
	 steRAPo9akIOGQ7ld4kEj/PQrm+IGiai+9VyFbeVro6X2d+wbrq5i0JxUCixnHJx81w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699180;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=IErLZQ5klLGiNPfBwdYPl2dFtqBHQL7H8/SqhYiFBvE=;
	b=V9gFfcvs79JGKmznm9+d/9wSgDZmZNu/x/X5IFb/RF4iIAJsepeqpdqqik58Yob6HdQB
	 DazfW9QDgapawnRchjwLBBtozQ3mTwFdJGWNlChpSkEjB+fQe+ts54gsEe5XJOMZlk1Zg
	 0SvfolRG//zr85FaMsI41FhAppIE1dT0JpnDCLra1BKIEI4WUvWtlZ6E7gBAcMG+BIKBB
	 yPjdFlZw7TbHcLzn1jPEjZjeh/9WQ0W5po9zwywKQq2H4lDKjtaXJBeLYGXPnjCGxBln7
	 g/+BRxr4SDe6wYuYO97mMBmedbq+Sq/o2gS6dsQxTqeo8GEhJD8Of/iwzXdaO11v8Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D1A6082BC0;
	Tue,  3 Nov 2026 09:46:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2D1A6082BC0
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAHF5horelqOE87AA--.2657S2;
	Tue, 03 Nov 2026 17:46:17 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH 1/4] scsi: mptfusion: Put the SCSI device in mptspi_write_spi_device_pg1()
Date: Tue,  3 Nov 2026 09:46:25 +0000
Message-Id: <20261103094625.1289590-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:rQCowAAHF5horelqOE87AA--.2657S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw18GF15trWUXrWfur1rZwb_yoW8Xr45pF
	WUWayjyF98GrW7KFnxGa45ZFyY93yIy3yrC3s7Ca4Ig3WrJFy5GrykJFyrWrsYyFZ3GFWU
	Zr47tF1xurWDZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWx
	JVW8Jr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
	jU-B_UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwgAA2rpnO5OTQAAs+

mptspi_write_spi_device_pg1() walks the LUNs of the target looking for a
tape device so that inline data padding can be enabled for it.  The loop
uses scsi_device_lookup_by_target(), which takes a reference on the
returned scsi_device, but the reference is never dropped: not when the
LUN turns out not to be a tape and not when the loop is left after a tape
has been found.  Every SPI negotiation that runs with a minimum sync
period of 8 therefore leaks one reference to a SCSI device and keeps the
device from being released.

Release the reference with scsi_device_put() both before moving on to the
next LUN and before leaving the loop.

Fixes: 19fff154e7ee ("[SCSI] mptfusion: Adding inline data padding support for TAPE drive.")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/message/fusion/mptspi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 56892b1f3de2..9c513ba9fe05 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -914,8 +914,11 @@ static int mptspi_write_spi_device_pg1(struct scsi_target *starget,
 				nego_parms |= MPI_SCSIDEVPAGE1_RP_IDP;
 				pg1->RequestedParameters =
 				    cpu_to_le32(nego_parms);
+				scsi_device_put(sdev);
 				break;
 			}
+			if (sdev)
+				scsi_device_put(sdev);
 		}
 	}
 
-- 
2.34.1

