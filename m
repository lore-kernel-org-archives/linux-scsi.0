Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FDD43C7B9
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787324784; cv=none; b=dQJgjNfVvAAmJFYPGdlAaepcUQnDaV7zySyeVSmhOA1vhvKL0+5Gbpgml3SEpyyr5nz0QlIVqKVur4H5PhLeKBv+CTNx9xSB1mGrruBYxLfBAkFI7MCCxxrqiN6shJzSpFhvdaD7CIOcT5x6y9ZE4uKri7n3EuxraGxyCvd8ZHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787324784; c=relaxed/simple;
	bh=o9PmtGNo0qNXdPm0HGpn7DO2Zfl3uf/bbHX4J5/hCjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fvahFHRH66Hf8YAHR81y+ulxPizWqKF0WwVj1yt+8/9JODSWHJEf09kIVuHTR8us8s/16cA4GCqNc9aG0pWC/cdCR/2cCiQl+UKJa3TKPIZyTK8ZpdNH0de3cOf24egxb72bp+upHscl+Xdo01nma7HjXCpUVDG6trRji9FoCNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YuKsds6F; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kAxaHzvt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YuKsds6F";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kAxaHzvt"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LCp2Y82467744
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 15:06:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=oFgHmRTuTjnvlChpCBQ5L6XCxlZ9swlsOSY
	SEBybm+o=; b=YuKsds6FFQiGGZ6z5J9KXm7pW+Kx8G0dIBP/3SFrwfiKndRGfTI
	VRwcGZNp4Px/vsSnrCwZgZGSmwcroPyEXR9P5Dzrbh30CIEy+kBCsdcw7H4RJY//
	AtFr6Sy1y6/TXOoP/psiV6qCFYXJkF1trouc9lf1o0Vay8WsaL8dcD3L02xUJMSE
	B5vn7ZwqkcK3q733KscKt7tIGSiMtPu+AWef5PCsNW4dl1wdyd5z/jWQ5EQ1ctXw
	OVSeHBzqRxTL82IZEc6lYD+1u6ayDeq8cNgUlIqnffSV88EVOBovwgbNu2oQ+z2a
	Bnde0HKNeTi1d7unr+HIbM209RvD8yDXtfQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g6gddj6gd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 15:06:20 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e538afe65so139720485a.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 08:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787324780; x=1787929580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oFgHmRTuTjnvlChpCBQ5L6XCxlZ9swlsOSYSEBybm+o=;
        b=kAxaHzvtUOHN2k89BpD6qq22fNmrc/ZSSxcenw6IjiG4gNvAB7ng5pbwIitBjdeCJ5
         ufHzwHZncbS+dDRllUSTjSG7cyXmZCXVW4Zr/TQ96RhEfgkFybQlicBq9XverHeLGApO
         bKlop6YPiFLH9PCMt1Vfm06uNjUxuKIlD1TmP/as+nNItPTOPb4ZtIk0R3n9UEWRhQYZ
         72dhTg9MgqHrLgjtlkO7C//tIGw3BopS/qlB3NxMTdayjH8Pl/lOFCyKuiUcr6IknD45
         VlcXAa1xe7Jvdmdm/Of94lu2301NiWQanK1JlQQB+/6VMGTWepSEV/gO6sPjChd9OtOb
         Zm2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787324780; x=1787929580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oFgHmRTuTjnvlChpCBQ5L6XCxlZ9swlsOSYSEBybm+o=;
        b=CpTMwwXN8U6T0zUK2MiyCVmwJ3ANzNDBXnGFtx9Ih+1/72n0B7gzJNbtj+JX4qbcfd
         IX9m3ysrp2Iy8P5FR4WNfyR1voReAE3HbIE3jSevYX/keqMkKO5JD8mhZ7wE8PgRTwEX
         /fZkDQPcAVMITqK8fEAHQT18cakn1B2Sc1l3lLXCL6ODTUAqzePJWqmgOv9ilOrCTXha
         OhTbOTdO1ZvsrUZ91vZgppMEbMa+aJtNtkOad4REXjKzCoBzGcsikvgGYaiXpmDgDO6w
         cxcfUyM22kb0IdyytPg0tPefCQ4CfIGx3tMc7THth0mtkL+wb41IfQdvGg0L+Jiyt6TV
         ynnQ==
X-Gm-Message-State: AOJu0YzPfuuzCs8ZUAaSJhkceAQFxY60uXc3IoYzoZ+sD7jwqDFEd9BJ
	E96IGxfyu40TMiLYK9IkQ3FFJldXyk/2jgus7/HZ+lBco9FCB8jjSidkPjJvumiX3uoADTfDhx9
	Syo+dUxkfQRUlKo/G78gYIlR1IjidHXr7YE/lrm2JHVGx5x5RoE+0G5KQ6DUMXGPF
X-Gm-Gg: AR+sD10PvZkSG7Fap1iP+OXcSZA7Bc4OK2fjxL0A5RHtH35d2YevkacawfIwW15Mrif
	XtsTINqM79mjGlUZv8MjjYJAeS2GjStxcy7dlrm+yEG8+gSQbYCRwAOtvsgRA6LIYp8+NV/hrhM
	yiUsLfzB3kAsK1RpOQSDr2ItPGb3ZuU6W/pPq1lrDfm0NIYVniYmIAf6rdfUdcYAKJhjUsfgw0W
	azmFdjWaiiVHA3J8c7jbM2Sc0TmMvmOGwqvjfmlDrzaVHDp0K9rsPPNvxvE9cvzfFZ1f9vGjSQ5
	IFsROVax2R2q8rQGSy7GI4Njf6ecx/pGE+1Dai/T9J7s9hi6kKrUEdTTEbNF/R6w3nWHKp/MPOw
	hsQhGD3Y4w/eWx5x9h/cPGsiKyXoIR7bbOZJp4AAUZB3pItUkHzA=
X-Received: by 2002:a05:620a:4398:b0:936:e196:894b with SMTP id af79cd13be357-93739559d73mr603757485a.31.1787324779974;
        Fri, 21 Aug 2026 08:06:19 -0700 (PDT)
X-Received: by 2002:a05:620a:4398:b0:936:e196:894b with SMTP id af79cd13be357-93739559d73mr603740485a.31.1787324779132;
        Fri, 21 Aug 2026 08:06:19 -0700 (PDT)
Received: from trex (137.red-79-144-199.dynamicip.rima-tde.net. [79.144.199.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b14b8050sm17960936f8f.19.2026.08.21.08.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 08:06:17 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        beanhuo@iokpp.de, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: [PATCH v3 0/2] ufs: rpmb: make RPMB usable with OP-TEE key derivation
Date: Fri, 21 Aug 2026 17:06:06 +0200
Message-ID: <20260821150612.3944782-1-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX3Dqe8o2gXqGF
 kKL/6SnkO3Ginjww3tNZrJoaJHjdsOZovyvsg/a0NXaHhnaiKMyMDtkbY+BJKYWW7Hcyh13mgDp
 eCL8F0y3JcD1btoYKVQOjq4ZXoKoBLc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfXx6GIMOUBWB/a
 tLDlT2j8DwtDW3lnOm+QJxmtsWeiccTU0yRifN9Uaa32NjvBo8grDznAi8PB+Dwb1xBQQDc6Vsv
 3y5JwKJKfwV5Lsi/BYtEtiCcy8YwIlZHqRlCjt9Lo70DwIlQH/TA/o8viJocEFDC3nn5BOie/Ok
 CDsYzsIYw7/jRNYlP4CYvaDEetYfTHktxRSlRW06WO5LHCauWaf7Cy1S1UIWGJBYkmnlV8hOneM
 m3L+MaDriWmB3PAZqvWICXIuuJvMdi5GuV8hk+Q252QI26j5FJ4JJcfNIkKZ65GJM+O4IbaoLyO
 54Dn4mL6b0VplKwOb+26JCaOfIZV/fF47sr6xXfzpttq3XajVWQUfZzfZ4wd/pyZcqwjjB11tv3
 iHtgTp02A2OYG/QOTaruqh+wVFxY5H7Hlrlm/wTn4jO8/a94Wy+2iLuBGZn7N52gQU2BzvxuGGP
 Bk61P7T5thmg5R0PszQ==
X-Authority-Analysis: v=2.4 cv=ApHeGu9P c=1 sm=1 tr=0 ts=6a88696c cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=qBhfTSQT0jQfJ5OHMlDVQg==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=_EMmJvYMAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=NEAV23lmAAAA:8 a=wgeUl87hhcvhY68aDoIA:9
 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19 a=NFOGd7dJGGMPyQGDc5-O:22
 a=emCv1hD2LFd8cNRmW21v:22
X-Proofpoint-GUID: Ka-8Fqs0d2H1VBORYTYK0OQdMVHj8VVe
X-Proofpoint-ORIG-GUID: Ka-8Fqs0d2H1VBORYTYK0OQdMVHj8VVe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_04,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210117

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

