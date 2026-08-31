Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FAC4B1299
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 15:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788191293; cv=none; b=oG7w+xR4K8MA3uVKByifY8wFGyP1sf0R2zRgqjLWoOT0kKujOMJy9gf6T/3APuqR3I2d4EP6pei1TS0Xbnit8bSkhZDoUqS86ZuOVlJAfQWd217s61y73FYgDWpUt1x6tYqvrEk0TefuTM5k2ywMkRDEsngHHVK/TCMxkGHCpe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788191293; c=relaxed/simple;
	bh=YuKf4TfuLSdGcJuTuRIIpFh/EgM5srvGQvIHuE7PH7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HveoQyCOI0Mi04h8N41VBeHA+jQnY1IMmtTGOTcBVHlofw4EZ41prKuHhu+iRtEUr3NuwIYiKjArF9f2llPVPZaLbBgpV8/HYJBtp1i4g+vofh79A/deA7x5lSz/cJhay+JJKevIfgiLMZmnDq8TUY2pURgvQ6lAWE7ydOUbnMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mU3lnRsN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gcjow6IO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mU3lnRsN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gcjow6IO"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VEU1QO3809030
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 15:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=QHh/nIGzCoRgzWrKEq4S+OEYLKw4ImM5Urz
	S+/gfDoQ=; b=mU3lnRsNSYlMYCEIiPZ3eu+N7BYcecUPtZgG4kBAeXFPD30iZ96
	9RfRKS9iOaqgtBkcYcnacwRFBO9kvL7+wR6/KA5l5IyQF0Dqb/oyV0yKt8S515Yb
	Hj+uhvT2Y8N9it8VbFGFLFgJorRoq+jbvqquAb6MNUHnLzX3Xwn4zZ51HsfRHenK
	5Hu/bsd7C9bPdnn62stacyujdVphdHpdzKdngy9Jp9G8K8fgbEMmxLQNI37nYljz
	FXq1s6F1EaswEFr0PbQwnrQWaThoKPiXK0pdp29+8OFoKMlcx3g/npHAqlATRX9S
	kxBrgbTV0eyG3vyU9zo7o9w6O4DqGCD82Jw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gcv7wbge6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 15:48:10 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e62e3459fso462215885a.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 08:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788191289; x=1788796089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QHh/nIGzCoRgzWrKEq4S+OEYLKw4ImM5UrzS+/gfDoQ=;
        b=gcjow6IOZI90LNrcHMbEehFMS81uA+otCCSNjuS8za/qTrLe1P7dpTE8pUjM/ilH9r
         COuJTLw6jV/ek7SzHXZXokOVkqwn5ORJKvp3gVWBYrZxvwXVwx0Dyxb3EJLci0oEnEE3
         BjCMdItcx+IoZTms183KbT63gk8fVJvLk+U8+6U933zGq/pQOHHkzRxc6yelTGrYht37
         Ln2I00MJiV9JkTNILAxEwlHVo5hnyHgPrY/0JaoDpBy7cRUmUs+3RaJLyO/ryToXEzWh
         +RCj16ECrsaSdgwrUZRC4evxqeCAvgAnCqiD4278EnVXAwideapDHofgphJNKxXLChm0
         VCiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788191289; x=1788796089;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QHh/nIGzCoRgzWrKEq4S+OEYLKw4ImM5UrzS+/gfDoQ=;
        b=hCM4606ohfYjT4jBqvzrx4YmdSDXkxRcER25y4tt0MI4Guj+xnHtyQhLnmISIcn/wP
         Zwoeb+rgBRf0te5vFF5MazFAYSblf4VOT0b3IuaIgIzgoIRExghggNLM3iFf2+cg+cjo
         2zOmo+bSZ0Wp0IEyjkSO3TITQSyhTT3was1XBuaBhq8QmhS+c5z4E8uaCtao4ltevwRg
         o8n1XZW1yUEPvEJPSN1ZdYFUJj8+cWwl7Y/eUVq4dYLdQx/qF2VEkIlNeLtOJ+b3rkh6
         G8LSfhJtSbfQpS4fMOQ7zClILLGA2DIqEQhEaqtQi7wa53pVrk8iIBJ54V6kuj9rvQGM
         vgsQ==
X-Gm-Message-State: AFuF++kAxj2MMI2Fs/+ddJ1WdDDKQYM1oWPUP4SbNMMQrhYMDdD2naY/
	uKR9GI3CB5RfFYi+lLkVtbSJ5kt7nwy5DH7kDhhdVpS9dfyXfoWmDupStWJw+ag0L8uwczFXP7+
	YvPyHcjxgJoaGavCWBMDmFuNgJ/C5SKFkSk451da2V1TicagPolXC3zcHUhp+ur4k
X-Gm-Gg: AR+sD10Av8GDfyZ7miDO2SLwnmGcvS1/+NCXLGCAhFLkgCndyn/IynjCSmJ7+aORXF8
	HYs8YlR93r974u9obyD9T4fGzkQQ8yR/PhKYZ/UUfdxb81VUCfkEiKf2xIvdE6PdPwYm4QkyUys
	1+oomNOLmrOv+L0BGaHOr2SSJTj7FA3Wl3Q8zTFyosdkahYfIkDPBKUlXoTIv8aZiYqAbWhgUxz
	IfvjGiwTESlLyIfWIYJ5nGGWgUFDyTr0L7ws19rMkhBJiYXgLP4PG+4OBCzg1+zRAElzXP/y6IQ
	wFE02PJRWToW6abwrCAEIORq0Elcxa+vb05deSInOxFBt/JJ0bbCWjkQdZAY2Nl2iIJTCISodS9
	EEbiJHXVOGtnnBEpZRnfdejXEybgJs9I2LTCPfiII74N6s7U=
X-Received: by 2002:a05:620a:40cb:b0:936:cda7:554d with SMTP id af79cd13be357-93913798773mr3050736785a.14.1788191289373;
        Mon, 31 Aug 2026 08:48:09 -0700 (PDT)
X-Received: by 2002:a05:620a:40cb:b0:936:cda7:554d with SMTP id af79cd13be357-93913798773mr3050728285a.14.1788191288866;
        Mon, 31 Aug 2026 08:48:08 -0700 (PDT)
Received: from trex (250.red-81-38-139.dynamicip.rima-tde.net. [81.38.139.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce0b456sm1558315e9.2.2026.08.31.08.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 08:48:07 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, stanleyjhu@google.com, beanhuo@micron.com,
        beanhuo@iokpp.de, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, can.guo@oss.qualcomm.com,
        sumit.garg@oss.qualcomm.com, jenswi@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org
Subject: [PATCH v5 0/2] ufs: rpmb: make RPMB usable with OP-TEE key derivation
Date: Mon, 31 Aug 2026 17:47:59 +0200
Message-ID: <20260831154804.719528-1-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=E9f9Y6dl c=1 sm=1 tr=0 ts=6a95a23a cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=N2KLPU99T7rsMuN2xAoQUA==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=_EMmJvYMAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=NEAV23lmAAAA:8 a=wgeUl87hhcvhY68aDoIA:9
 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19 a=bTQJ7kPSJx9SKPbeHEYW:22
 a=emCv1hD2LFd8cNRmW21v:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDEzNSBTYWx0ZWRfX0d9XIQa4JxQg
 tkNMLQbKLH3WZI+/8nvMG7vI/lCe55IhwC2NIl+xN+/Zg/iHEYj908qSef3NlQFc40oY7VCSIf0
 MkMVH8GOTHkR5etSpnEOWhxbRWM6H/M=
X-Proofpoint-ORIG-GUID: 3Nd5fEMl9n0SbMcw6wcBphT-t95f3Y20
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDEzNSBTYWx0ZWRfX2QegE0njlRjW
 zcUcpqkxV805cFUpbLHYDAzGldO8zFkkckYQ6lMZZWfuArsT8trg9G+xbpLDl55fOPZp9/6CF40
 0elM145V08MvmaIf2X48muNMF4sSGUGZD020Awva4YRYwQClN5+61BIZxMO0IKja0NzayHk+us7
 R4gFxCrqi3QKNtiS00MX6VZZRmamSuXmkcm1cXnIw/poD6B2QzqRTr9m0iOeTwBZ0KxjQRY2Dib
 QlylozC5o7zxlnErJi59If6s8m3Ie8JGVhIoFr/+0Ko5/p0M4tv8YxOmwFFYMPhQDxolvbHqKGe
 keF/O4Q9yxWO65EEl7CgjMue9gaTDO8ox6UDv6HC2DlNmShsdHb+ubksuIrMqde4gbFaEP/AthG
 wtdWC4xQAtUTODeyqGF3+gffMt+ThKh+ddNhKT6vFsnx/h6QtLKDUyYolwpJLUc2suvUkvZuf2c
 UsF7PwQLFiPV+lbQcZg==
X-Proofpoint-GUID: 3Nd5fEMl9n0SbMcw6wcBphT-t95f3Y20
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_05,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310135

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

v5:
  * added Reviewed-by tags from Bean Huo and Stanley Jhu; no code change.

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

