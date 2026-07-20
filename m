Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C48346ADA
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 09:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538987; cv=none; b=SNdbzjtbj8h3nLVQYNcKptAdR8hp6njfBA/nn6QHm9Jm0Pr5xcrWQhomJYgblff162QXRc+GRd4OnzxL2OeJUKrs9p/HUlnUaSHGvtz2bSnt7E0wDnFXtikYsNZFuE9ejANpKdYZS2reOwy0qpsAM1bO/EQ99bI//VPAsxFoHsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538987; c=relaxed/simple;
	bh=hLiCu8CHxsjmDrs7lAbwH45NEdiNScRL3OPRtwTkJ1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zu7kQoAlVsvHwLqi4LxwOKRLEtSTreoi5ZPPZ8H79JT1WF+PNPwDpdOvVa2UBuclkICc4foD3fYgReuTPkUcVn0Bbk5vY5zP4Zdaf1CFOXIgoJq7A5d9X/4jgeaH8rEUPXtOqo/iz2pJ7BcGC2/jLPEEObTFUebve2EpbUV/a0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TNtwNbP+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q4GBtlPE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TNtwNbP+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q4GBtlPE"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6RgOu1774822
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 09:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=9oQcZnrPsmef5DW7iw5TAiJvQJixC0ZK8rq
	xshwGSUk=; b=TNtwNbP+NawTBo0Ywm4izTjT/gxS8EdVYFoOHHgav0s3XmMiHVY
	kuVp8fQxwUG8ll0mqHEQo1L7dgt0aFzVpcxyg42hfSLCVsluAGS5BWXsBhEbmyiT
	xIzGuzAT486xL+SzY3dCkMj9MwNReYHxZx1PfT2gLJv87R0vpXKMSbeoBPBj9WzK
	Qv3oNjrN0NNUnhsMTr8Syf9xBQtHmCmWFtVD1AWuibpjqGTzbh3HKZ75aUoQA81d
	QvkvpTKviJHVF8gOZKfF76IHte9xaRoHeEr4AJYju82vhgWG0Xs2jJPlHE8CmyL8
	fWREVsqfdGIgONOiECSmu+t6QPESbBRCbSg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2af5eqh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 09:16:19 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c0f0a0760so236694721cf.2
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 02:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784538978; x=1785143778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9oQcZnrPsmef5DW7iw5TAiJvQJixC0ZK8rqxshwGSUk=;
        b=Q4GBtlPERtWPfHsF29IHeHGrtdtQWiWvPEwfMbInujkAMHS31ZVj7xoZsZpXxO+e5x
         n5mzQSnptw0yXfBmgcbIHFMgoG2A0yu+NRJtXLh0WhdclswFSjkeMrTOrBLmpSQ84/jw
         QApPRaR1jam/GpvqZLI3wCaPmJQsxA5BMkSDcvyW2sazU8JbptYhi6FS7RHFYa61E4iM
         GHV9DXGI2KydxFxm2S+QtyENHkDSvP4tEdF/Vu918EIFWj/LOUzw2YxjrxemVvtCKKD6
         r30FquTgeN9VoZVSO9jdVgnYWdut9shMAOLuKrGcX/WM1gaFxtsXHMeXjEeMyMU/qd+c
         hjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784538978; x=1785143778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9oQcZnrPsmef5DW7iw5TAiJvQJixC0ZK8rqxshwGSUk=;
        b=jFXiBCN/h+S92GAcCI4rvyT6g4yQ/E/CGo/phST1ClTWZHesO3W878DWJ+HGetzizv
         +JMnCp55e1Z7DpUxW+CZaIByqPB5c4lQ+T33aCnr/eplImQpNzaA43EWaDtfGDJ7lZHr
         JIoM7eswh+3T1L9ALaLZLHFLgolnKNMYPVZ99amOqk/DiZHat9ODSqtV7ab/URDZAJFP
         taXOV4lDk5hLheNTmZBr/w3NkO3U36+yK7C1jp+KXqKIgw2PelPD9s/Jf03eUm60LLnA
         YTT470egEnlOyX9j5x/zoee0+p0CqbRuMWqDP8CSTwOOmM1bBH5iv734c/rdLJwng8mU
         k+Xg==
X-Gm-Message-State: AOJu0Yx71KOb6oZYa5bUTVAnpPSUJZEjB0PR4ymiqhnIj0kJJChu7gdg
	6sqIumkEid4uO7lmROGFwClKbS69QD/THOiHyAvXVMr16L6M/tgR1lAVbmcD3w8GMZ2Jd2i3dAx
	YsabbQyUM1ukhOGvBv+x1zSeChKxQtCaEgrocJ+7ptT2e/LbTXbM49DkYVVhhjo98
X-Gm-Gg: AfdE7cl38UnLxt9ZzZmLqoUpNsrimZoPxFZIV4OM6iTSD7DWlRZoRGGwbRBwdNQdP14
	LjQCO2GZeoxRtj5tZQu67atC+6Fuu/+1S9PD4xcuvNCRzYLiAhrTJWwbKsw6FvJOKMZboto0nLK
	V6PMdYC9NPtG0GWrM0HoOwjTmTRlnwXvGTAZzqAVo+asluJGCzzHp3ZBSF0M6D1J34s9jGhf8Wj
	oPGt0G7LqsdvXl0Efwp0fmYN0YKPkvS7SG0zdcbPLg9fcA1IJ9djCW8RwlyhkXgbD8SFTqzi+22
	UblMWevwKwvfsUtrdagQ9E6CSFhiCpfqnvneHUfi+tS1YJfNR4opFfYaShhaGKTSBLvOVocj9OM
	Uw1VUO2G84aKHR6z56tu9uI2wHUICrFEF4aFpCYSrqA0USE0LtTg=
X-Received: by 2002:ac8:5705:0:b0:51c:24a:ea6b with SMTP id d75a77b69052e-5213c8e3425mr118751771cf.4.1784538978595;
        Mon, 20 Jul 2026 02:16:18 -0700 (PDT)
X-Received: by 2002:ac8:5705:0:b0:51c:24a:ea6b with SMTP id d75a77b69052e-5213c8e3425mr118751471cf.4.1784538978050;
        Mon, 20 Jul 2026 02:16:18 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49563969482sm12331985e9.3.2026.07.20.02.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:16:17 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, can.guo@oss.qualcomm.com,
        beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jenswi@kernel.org, sumit.garg@oss.qualcomm.com
Subject: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key derivation
Date: Mon, 20 Jul 2026 11:16:09 +0200
Message-ID: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDEwMiBTYWx0ZWRfXxZnwfH+ixpXY
 JCV0xhUv/O/cFNtDkVD6Fi3OW4fcGqMiS7hqL6vnl9s6nPxMQ+6Ft1+TOqK8P8b6nuK8l/Wv+cF
 q/L0pVDnaK+t2zYt3hQb5kHDHH0PF4Q=
X-Proofpoint-GUID: H19f8nuHmTkKQvmtHSTKm4o0q5GVQUT4
X-Proofpoint-ORIG-GUID: H19f8nuHmTkKQvmtHSTKm4o0q5GVQUT4
X-Authority-Analysis: v=2.4 cv=a+sAM0SF c=1 sm=1 tr=0 ts=6a5de763 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=_EMmJvYMAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=NEAV23lmAAAA:8 a=EIJ3WXMgmfCyFXXGMWUA:9
 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19 a=dawVfQjAaf238kedN5IG:22
 a=emCv1hD2LFd8cNRmW21v:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDEwMiBTYWx0ZWRfXxsbLZdB7DpgN
 pDRl+Lv0K6eFBiWKpbdTWLcSyMo4u6YZpOC9l5XvJwPM2nHZzUs+wzIXsBAQiWBgSLAr0eFf77S
 V+xytpDd9C3Zq/9sdGzPt4dQyVTobn+c0x49sObFORczgjRgadEK3wl06g+lSu2xcd3/s+QMCsY
 Pj93VC+CgB8U2S1K+IlWx4lio9tMc6ZOCsAvm+wIAt+cTcBOW7k+Fnxes7BrmyQMp9a13VnLH1d
 5ll4kE9sDmLBOyX8GY64qae7EaprYlrkbZu1ZTMi0VqpSirSiR9csmhJGMoJPMykvfpRBrnO7Z9
 WS2Zrr6bo7iG73spk9HSJatdxtBGNpN2I7d4cFzjkkQsJjuHRjrQJ0xZNwAjMnFk+x4tUblzVFI
 LE4QGDXMB+xXbVF26MjO0VDMt3w18z/AvfZ2Hq0k+Pfn+/hgCVTaDoZc1zCPXX+mJVX8kaNOT4Q
 Gnm4rkKq6bixFzoxyxg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200102

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
     blake2s, keeping the key stable and unique per region while matching
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

 drivers/ufs/core/ufs-rpmb.c | 39 ++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

-- 
2.54.0

