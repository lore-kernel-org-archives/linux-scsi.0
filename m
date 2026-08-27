Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02898296BA9
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 07:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787814234; cv=none; b=cSpiNOXnFubU5vY0l36cQRpK+kmuES+IgIs9nEEBH74bE6/9ZK9BWgphbgaz9T6HVKk+1W4Ik0+Q3rtWZkhK0IhF+WKjjcBXa3IxbNkoOjVsDEFy1NkWmkDzS9gWHGtf5XJKr/40qzxiq/oecBkbT+JCYtm0A8pth5ZV0AkQVGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787814234; c=relaxed/simple;
	bh=YU+dpOx506Gyv3qnb05But5K7iNWhb4zHsEv2N0EA9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SGnIRZbizaxUU1MyLfOdlHibZ3RvFPfDlo9Pg5UuFSYJ9nPFyqmeRpJaR2C5RGql79jD9ecJXq3Ug+5kcQnVhDEHmxtt+vDfgvhthlYR9B9SzPTbbwULX87uQdt/HxJjs6e5U+fupSgzz1kRmOJwKnpxzys2+YQFKzuZkZPfOQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mNdlHq7j; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZsJXiIFN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mNdlHq7j";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZsJXiIFN"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67R6RBcM087858
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 07:03:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=9GHTnyyGYsUI5zmnXqS8PIIxqLj0GNfc1Ae
	++1SY2R0=; b=mNdlHq7japmunS0CjVaRdcv0SSvbfZ+oqyufL/COpsNChuX5usS
	d7MRscPXlwiEFRtVUgNjGFrzzdli3bvw+pETX7CgLVvRMyjkk72IzVC4pMLn4ech
	co6/tO32WUDjp9n9MIdiO0lPArD7fRPG927dWrZcg22LKODaepIVrd9OZYksxweB
	uw5XHO3+IWJ0hq3IuMGiI6IEjwnyCfSvCTjDkQtW3CSzq1spcsB9H5+1GgsFftfl
	WtuzAj1DxU9sqpfcWredb4K4WbS1e8jzvDQhv5FbjwYE2GSXt93BVK3lNjbaUiJa
	5KMqWz76ojcUIGML249ZU2rKJWG4zpuWSfw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ga8m5hfwj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 07:03:51 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e62e3459fso166278085a.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 00:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787814231; x=1788419031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9GHTnyyGYsUI5zmnXqS8PIIxqLj0GNfc1Ae++1SY2R0=;
        b=ZsJXiIFNROeDln2DvsCL/5AZlh8prKaq4WjqDYvR0ZLtfnMMhpQ29h4Ig9Exc+CEp3
         Q0SLXWUcVVCwHkMrD1AvwW49JWsUHUC3Etkk2WtDlJwYNqeXwTlBB825IzY4E38fZzIR
         JHUqdpeglnHJf7S7F1UyLQDhm2hCwfNcHfste8g0Lg7PwcanFZ4r7Iv3cVYauErCOCkB
         sHYmLeFXGySBKxE/VnFxiDUn3YpJFt7+ymLK9k+JOaHWw9mJcNkHSFHzpl5MeELVx7dG
         HbPfgNSLxkwHq3KYLH8Xr7VqU/j1EPQ2ex3ruQlRm4nfEkIOSgMgJINFVrbptaJnZ2jw
         MfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787814231; x=1788419031;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9GHTnyyGYsUI5zmnXqS8PIIxqLj0GNfc1Ae++1SY2R0=;
        b=sFIuHRjdHQYg5mppZQ66hVD2+Yg9WlFa7oXoeX+4/roi8QrJdULJxr62UbaqjdpgEa
         42o9yzA3P8TJScpDgwOnUv3qknY9CMmkPuUv0Hz1/n33PwuzLCvaWDb9t+scRW9nCUii
         D28j0QVchBvp6NoM45kh/c36Vwjk6RPEQcUiVBgJQFAWUFwQoQ6hK2D/oDBOGkXq4C1d
         g/hyDVXe2XCeKuocOpJ5nozftfi36ck4cKleWPrh9p0caFW4hQ03dOsWeaT/yIWAXCGa
         H4WLA4vOULVyQVJdXYe6helLiHxJlz61Ennk1M2DaA1cv6uoroK1eEfUITu1fLE2EqX8
         PwPg==
X-Gm-Message-State: AFuF++kkkZ7j0l6xgNUrufQ5NXqIoV6G1bLn2H6iai/+stlDK7jFhA6+
	2VKTo+PakhjlOwse8qUoAHBdZYRU/y2wcMvhE0hcurlk/h6F3fDgdh2+fZkNhTZFyCLf/Jp4KJC
	bdlBgnVcd1p+9xrxOSmHq9/DmB0S9HLg+6xdVQQTMoS8HjXc8pzOA1One4K0/vSe7
X-Gm-Gg: AR+sD10iyL9SzNpcLxV9NpFzLJfF0OywA3EQKVLmJrV32DArqMo0zimDBJ8KpSzQDaK
	QbVLEjuZeKj6RetzdJtan9E2buj1AS2Uvp82ztJj6GWRwulU06+5vVcEuJvA5jIYwv3bDe62meL
	u8xX6+pFaPJKPFEN6AK43ltzolhXl9jAMQHl04RU6HNobNze5vVpvu8a+lbwciy2LJ/1JznOHz2
	26SGJazxzvAOFZddFgkV3eX9g5NDuaddBBzldnNVPUcQS1e7EtKNrJj15YpLVmOqnitcjO1JybM
	jaCYBGS2pGqTjdfUGgooW255NmfFT6ydu38mWVS09msGrzH5mKrK0Q2c9Bgz7Pj7ExE+o9pvW9e
	nlYwTN1UTndJ72yH6groV7pmJXnbGuVuBU4KyPe3wQVmcHh2I2g==
X-Received: by 2002:a05:622a:6106:b0:528:3b9d:2c7a with SMTP id d75a77b69052e-52e4234d653mr131401341cf.21.1787814230814;
        Thu, 27 Aug 2026 00:03:50 -0700 (PDT)
X-Received: by 2002:a05:622a:6106:b0:528:3b9d:2c7a with SMTP id d75a77b69052e-52e4234d653mr131400901cf.21.1787814230265;
        Thu, 27 Aug 2026 00:03:50 -0700 (PDT)
Received: from trex (137.red-79-144-199.dynamicip.rima-tde.net. [79.144.199.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b0d263dd5sm28306585e9.1.2026.08.27.00.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 00:03:49 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, beanhuo@iokpp.de,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, can.guo@oss.qualcomm.com,
        sumit.garg@oss.qualcomm.com, jenswi@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org
Subject: [PATCH v4 0/2] ufs: rpmb: make RPMB usable with OP-TEE key derivation
Date: Thu, 27 Aug 2026 09:03:34 +0200
Message-ID: <20260827070345.2853821-1-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: kTch-0hS3iIIULs_Aof2iix5PN1T6wtz
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA1NiBTYWx0ZWRfX5293RAmkb7vU
 2ZXnw1yi7rfJdl/uZ3ipyc0lqa0/6Jz9ppt89Y593//hvTzd8UL92aT1i7Z0i7eqYQVVO2jh2ua
 ZhdnE4XbdI4z1tQAFDbzyA9s22kyfyM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA1NiBTYWx0ZWRfX6Wo/ImYDapYK
 Rs6MJWxsrPRgXZ52YR1aBx/VDSTwgtlT3Q6j797sd58U4xeI1u1mEsww9QGYYVRWbMgAkh7eBwR
 bqMAY5/DxH+Tatem1rRUJ8FFd/CG9T5K5D4tch6SqB39cr+msZ5tU+tbP4Ysd/xgldsJtEmzx7n
 OKlZIg/Mq1MgKP6AeldG3NirJ1GqQvSTN/a7pswt6OqJWJiMs9vdF61CsphYJftAD9549zFLqfB
 lpA5hWNF+dU+S1hCaxkk/1Sx603uRNFX9tQKF97V34gPdwDYleXAOlRyQDRg34IKBBQPxNUmrP+
 GW041j/yEDH1cy7mfaE4pLctXlAKKZixk9baWU/4WhhXG9FIlm3t/DZrbu0ylxpyBK1AlvhZ/dX
 e/tvmXqaaJ57X+RosOGUyTiVo47KaYVWh17LxWYuiMgaOUkzwG33Wus4yOh2Njh4eDlAYZ3S9v5
 zkoK8WYO7J6eDKBNRDg==
X-Proofpoint-GUID: kTch-0hS3iIIULs_Aof2iix5PN1T6wtz
X-Authority-Analysis: v=2.4 cv=SomgLvO0 c=1 sm=1 tr=0 ts=6a8fe157 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=qBhfTSQT0jQfJ5OHMlDVQg==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=_EMmJvYMAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=NEAV23lmAAAA:8 a=wgeUl87hhcvhY68aDoIA:9
 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19 a=bTQJ7kPSJx9SKPbeHEYW:22
 a=emCv1hD2LFd8cNRmW21v:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_03,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270056

This series makes UFS RPMB work out of the box with an OP-TEE that
implements the standard eMMC RPMB key-derivation flow, without requiring
any fundamental changes on the OP-TEE side.

RPMB provides an authenticated, replay-protected storage area whose
security relies on a secret authentication key. In our setup that key is
never exposed to the kernel: OP-TEE derives it in the secure world from
its hardware-unique key and a device identifier (dev_id) that the RPMB
core hands down. OP-TEE's implementation targets eMMC, where dev_id is
the 16-byte eMMC CID, and both the fixed length and the raw-CID layout
are baked into its key derivation.

Two things stand in the way of reusing that same, unmodified OP-TEE flow
for UFS RPMB:

  1. On a cold boot the very first frame sent to the RPMB well-known LU
     comes back with a power-on UNIT ATTENTION (ASC 0x29), which the SCSI
     core reports rather than retries. RPMB has no earlier guaranteed
     access that could clear the condition first, so RPMB fails on every
     power cycle. Patch 1 asks the SCSI core to retry the power-on UNIT
     ATTENTION on the RPMB WLUN.

  2. The UFS RPMB id is "<device_id>-R<region>", which is variable length
     and longer than 16 bytes. Passing it verbatim would tie the derived
     key to a length OP-TEE does not expect and diverge from the fixed
     eMMC CID ABI. Patch 2 hashes it into a fixed 16-byte dev_id with
     blake2b, keeping the key stable and unique per region while matching
     the eMMC CID layout OP-TEE relies on. The hash algorithm and input
     string are thus part of the key-derivation ABI and must stay stable.

With both patches, UFS RPMB is functional from the first access after a
cold boot and derives keys through the existing eMMC-style OP-TEE flow,
(requires minimal OP-TEE changes pending on the CID proposal done here).

Tested on IQ-9075 with Open Firmware [1], pending OP-TEE changes
[1]https://ldts.github.io/qcom-buildroot

Dependencies:

U-boot:
https://lore.kernel.org/u-boot/20260720085202.537019-1-jorge.ramirez@oss.qualcomm.com/T/#mc423eb4dcf8a15849077029e4f7c1913bb7d8873

OP-TEE:
https://github.com/OP-TEE/optee_os/pull/7881

v4:
  * ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN: open-code
    the power-on ASC 0x29 (with a naming comment) as the rest of the SCSI
    tree does, instead of a UFS_RPMB_ASC_POWER_ON define; add a
    UFS_RPMB_UA_RETRIES define for the retry count; reworded the commit
    message.
  * ufs: rpmb: use a fixed-length RPMB dev_id: reworded the commit
    message; no functional change.

v3:
  * ufs: rpmb: use a fixed-length RPMB dev_id: hash into a stack buffer
    instead of a kzalloc'd one; rpmb_dev_register() copies dev_id, so the
    heap allocation and its cleanup were unnecessary.

v2:
  * ufs: rpmb: replace blake2s with blake2b so that the same support
    can be added to u-boot (CRYPTO_LIB_BLAKE2B)
  * added links to U-boot and OP-TEE changes.

v1:
  * ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN:
     - fix using uses SCMD_FAILURE_ASC_ANY to retry any Unit Attention
     - fix unused variable
  * ufs: rpmb: use a fixed-length RPMB dev_id
     - fix selecting a non-existent Kconfig symbol

Jorge Ramirez-Ortiz (2):
  ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN
  ufs: rpmb: use a fixed-length RPMB dev_id

 drivers/ufs/Kconfig         |  1 +
 drivers/ufs/core/ufs-rpmb.c | 29 ++++++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

-- 
2.54.0

