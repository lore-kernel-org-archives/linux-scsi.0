Received: from sonic301-20.consmr.mail.gq1.yahoo.com (sonic301-20.consmr.mail.gq1.yahoo.com [98.137.64.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1A417571
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 03:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.64.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717731788; cv=none; b=Hm1RPLQwJbehcDojUU6pqbofxbz/vRDAvaISXS6Yt4x2nVt+rf/NU6rYXmFnJtSbb6CVtsK18vuiSp85Cq2VdwebkxQ22ysv0gebmLIlVABEcV1ADknkIln5iDhth6aUOwdt2EZF1y2NnhSQZEJkis1Pdq4W7TkEIex5ya08z10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717731788; c=relaxed/simple;
	bh=IpJGEGr45jVuWDbw3eeBtBXtj8q1hpx003Vx0hbGImg=;
	h=From:To:Subject:cc:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=CBvbTpn65VRT9TtOsWBnFIZMmSnjmHBejdyO/XAHlnPmhh8HMhYyZXn2RrCD5MzWFqDo1AKWpt/EK+ID/jm/vJKMD75qioqUpulzV/AdJPQmxl6EVH1+vs5GZedbn2j2fT07ucuCYEM/3DgXFrrap5pZaiY1Bdvzo+UdR12Y9lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=Bx5Qem+g; arc=none smtp.client-ip=98.137.64.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="Bx5Qem+g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1717731787; bh=Q6x70XqkxpQhjKlSSOz0uqzdL65rjXGnszv/ieyuSlY=; h=From:To:Subject:cc:Date:References:From:Subject:Reply-To; b=Bx5Qem+g1a96Ovwk6I1aObgCpsdWjd+c+iUEfdyQIK6qzVtaJplgGTwesoSXl6CXDvacuaQhzRLXC+YFLomLV/ox3Ei4DiYs+dXxiPs8lalFyNL1RIlT+I9awc2p9Uear1x5qgXcp+pEf5OSqqUis5a5O6ruGAlUX7S3qDz7QSGmLJXDzWfz0PyOwu2JgLmUsVRRcA4yrXiBw/UX50kTfsU8cHv1CONuriMXke7mfYjavaxjATA0AFmRUhw6pbYRxpMAZNsOOZkVQoSxvtZ3+BFMx9sShecTD70qgvxGR9wUVBefQXmNTLyO6X6qaZs16GUG1penMaguJukv/IsP5Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1717731787; bh=9M4JcK4joZ43GWID9+ApYgg/18zyLhRPeKRvNbAo9Xd=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=UQpT4jdmosBiauHncflhCeHWG0sDHSFAb/hXnQe/3r1vqdwj6DDIz6HtRa/xTqQ+FcYi9m4HmPl3tu06f5tlWqcZB8YUAP4k3M/zllCreS+ld8x9+osW3AkUyCbvwolqxZemdBi2AJw/DfqB7Gs3KcjdLlRQZ7N87QXNDV+BHmAMtChKftv6tc6pP7A9cq1+MgfiBiLpbekvKyWmbyeu2d/3DpDEpE1r3OGzTJO5bm9FgGCZpaMM+qitgqLiWiTCqGgeyrF+T0aG5iJ1JK7bRsR+UTCDlplcl5eZfjK0Ebis9NszF2cLA3nvXWnruOd7na9+sTNiNA7GDD6Ukk53LQ==
X-YMail-OSG: v36CNDEVM1nI75LeZJq5dsEpm96CkBer4zePfkGYllXkkyccQ9ikpla2Ihmq8XD
 q1.ZgNKmx73j5JRJIOqSlJcV3IlR_kW.iWwqrQaUDbC1APYsEWXJErxSfRm8.7Xb0iv13hrirtt3
 lrXKcLTTEcPlevCNkZVIDCkxxe5WIaqHhniE6LTxIxP0lTM96akBGtr_d8Zwou7ukD72UPMD2sdY
 VtkMO8E_8J1fQF_u1.u65S1Gtl68FeSgwGTSzvRENnOTM8Lx8_ORK.g9a1nazMXR7rJg2SVLTbyo
 L_pEM5Kk3DpBCMCW1LD51Jph0.UyIyaTS31pqrLtmSK44Acay8ElIYvyY2sUHGHVOIH12FDk5Pj8
 w_sFm83JNX7b4RNkcYYFEOv7TrlXMP0.yGJokTSyyh3rJRRh0M.cbcFT5DK9_e8g0lN5BAAnfYBb
 m6OHHpZcooC0McuiYz_JCErBy_JBIXwuAHl6CeGVAEkem2J.drHIDMlHpm33d8fCgIVZjNgKtGsA
 Hh2cmu0LCv.lBse0C5VaLObufrOM8Hz0LuGm6agdb_sFmBzs8xj0H3yjigfYQN4clds6ggEOugYS
 TUCtyndr1VZW.9cyhUVLM5l0a8ECxKHb1mPy_9QNtvTsg.IDqUFqWt8EM8FdOOr.gltAFqnyzVTM
 F4.ojJ1nFCVzNqCOVHKAqET7YhLBeiNyYbvYCtgJm46loI.bcBcsMoVbUBV5.xA_hEHDfXgecLfN
 eDCw8g.V0JXZhieab8H8foWjTgJHyPoL4w6YxZWUS7tO17nMZpe94qkpKCy_o.u12gRGdmjJH272
 B1WORYl1zDxUDtbOeGHbIWgy4z0DEmiuMgJZrOO_DchzSUAtvUbYSp3eyaRXMT1KRaBv5rjy9AmJ
 fb2TGM_MgBNIiE97vrlfZ4kj4O.n87CZeAdWfNJ.bEG4_osBNNMZRv5ieY_Gv3tL_41qylS6qlgP
 84O4s.zs8YoZxWHld.t1OD.54e0kVnOjToW.1mx.mOxGCWjyG0SGC1DMGWRWg64XdonfoqGbpaCv
 gsJ3IV62D2eqrXvQaNNA06UmvOWal55hNNBPkJWAkyQ5tYO72i9s8HeBGjxyalTSKIWSPg2VrOw1
 o7TlUcoF3QSQy7WD1XrH5QmS_JvsM4rQjFnZYc_ixrFX.XjWbTGJBi4yyajFuYLScf_ajPh_3nNH
 XPz1U53VYLLcGjVdAB94C1fOPQX.cK_RqqskJspNAKYcxYMtkR2ErRAWDrYTHTCL.RCwZ3O5Lm.o
 jednIXbKJAHWmO.MbZNMFgbIisFTbhuUBK54UCnAopEDRzFG2dz0UKvJknYUhZ_1VYAeKbXZrk_t
 j.eFRUnkMow4yvW8tco20RCeJiDHzZuEi4WQo5U6wrVWeKHru2cs5L0IhawngAhl6qZyBoU6KH5n
 QzJFlssjpdwc6Q8guuasDp3GGaIpDtAhNobO9JV5QK_u7S3FiquBnm97CEH5gdiSFM5bI1R7MQX7
 tFLQ2lKGM8XPerc4vekaGx.02K.EyIoX88N3ITFe2znaWhMLoUxfYcwE4UgdeL_yW8BrmC7hMSWi
 pFlyrCDngpS2MMDw_23ENs24AqCRk9McchG3AdVt82t9aKHfZj7W7IlHmBiwRbk5ZdRws6r.YbgD
 fXxxOoh.py.AkKrxsBZI3FXWk3LcLPQ_hsQFQVGFeTAa.rn7bkCU8Buri.kC._cJ6LfNmzFOkvZk
 9IgfRgh.RmADsUIBYiBJFW0wte902IhyyGhRGnFSJvnFAvas59bBYg4WmzKJ2tg2jgi374Av3Gz2
 0UsmOsLAgI2FujkU6JKKyb3zQGPxfXdeQDTbh3YdIKNGc.eLUTwacJVE.R1uXrKYrbljuXH2FhzZ
 iPnZOeDZxJ0OB9hxHOEc1R8IJjvgtOytIHJT78Ak90R3ec7aeP2iOYUnPnNs56zZAc9gRTpQiJxh
 Rob1Z765OWd278_yh3VZmP33grMJo6wDhsJQQ891w3artI1Nr83I.c9d0NXUsG7CebZuDC.sRx20
 np_sAPZ42RIOVbD8BFU37wy5hoTSXspcfU.43VJbmOYr5sWL0rto9.gDNR.Yl23Mno1SoISLpy1M
 7V2spgM8ftShBlomuNuIJgyVP8maP6KYu.YjqNA5KF9yPMRQIq3jy7H6c6G3rpk5OkHI6MwUjowN
 x0WnI7BNjbHnnKchzdXzlYD86TevV1Q_Hy2JDD3kyK0C3_C9Y4L8oiEhZsWfpnm1egmMvdqbcN0N
 OyrOF3wrLS1kaIHz6ucrnxxpZq8c4tmOMHwobsW_Zbco-
X-Sonic-MF: <sgoel01@yahoo.com>
X-Sonic-ID: ff8817ce-e8a5-4c36-8020-1cae7f60b75e
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.gq1.yahoo.com with HTTP; Fri, 7 Jun 2024 03:43:07 +0000
Received: by hermes--production-bf1-5cc9fc94c8-lh7nk (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 30ff7e5fec496a63b87261d9bb8a5863;
          Fri, 07 Jun 2024 03:32:58 +0000 (UTC)
From: Shantanu Goel <sgoel01@yahoo.com>
To: Oliver Neukum <oneukum@suse.com>
Subject: [RESEND][PATCH] usb: uas: set host status byte on data completion
 error
cc: linux-usb@vger.kernel.org <linux-usb@vger.kernel.org>,
 linux-scsi@vger.kernel.org <linux-scsi@vger.kernel.org>
Date: Thu, 06 Jun 2024 23:32:57 -0400
Message-ID: <87msnx4ec6.fsf@yahoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
References: <87msnx4ec6.fsf.ref@yahoo.com>
X-Mailer: WebService/1.1.22407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Set the host status byte when a data completion error is encountered
otherwise the upper layer may end up using the invalid zero'ed data.
The following output was observed from scsi/sd.c prior to this fix.

[   11.872824] sd 0:0:0:1: [sdf] tag#9 data cmplt err -75 uas-tag 1 inflight:
[   11.872826] sd 0:0:0:1: [sdf] tag#9 CDB: Read capacity(16) 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
[   11.872830] sd 0:0:0:1: [sdf] Sector size 0 reported, assuming 512.

Signed-off-by: Shantanu Goel <sgoel01@yahoo.com>
---
 drivers/usb/storage/uas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 451d9569163a..f794cb39cc31 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -422,6 +422,7 @@ static void uas_data_cmplt(struct urb *urb)
 			uas_log_cmd_state(cmnd, "data cmplt err", status);
 		/* error: no data transfered */
 		scsi_set_resid(cmnd, sdb->length);
+		set_host_byte(cmnd, DID_ERROR);
 	} else {
 		scsi_set_resid(cmnd, sdb->length - urb->actual_length);
 	}
-- 
2.43.0

