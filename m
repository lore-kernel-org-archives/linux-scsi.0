Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93AB39D3DA
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191059; cv=none; b=mu+LSAJ1Ra/CSfmmSzc9YcIrs2veMOGdCPFyzQKWCAtbN/deMv4iuuOwxJ8vuEChiIS7ytvJRsgu/kiQa2NeihXwsuS7e8A8LcvPfLP59xCDvV+ShlMyv1lGTv5BKX1oKC4bUOYFQnYLRP+EnHtjLif6x3FZkvJP4ndf+HaFVFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191059; c=relaxed/simple;
	bh=DFUmG7barH67047rlslm7AUbisk/Fbm3Y0Olr4q+NdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D/Vx75PkeHej+6bKbmsJqvh1cMdJMi8nwMom2EVkg9/pgL1Mx3D0qMYZ3uDfwJixuz8rbAOkEo0YTA9ZIzLfZ8sEnlUzsWSCcgxUP+52NkU9bk8aYCv+g7vaNZcIAo7Z9bfTaM4j2dmia3IyvsREvakwj/kMCyQ4VMiGwcAi12Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SLPmVk2L; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NndB+kfa; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SLPmVk2L";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NndB+kfa"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G7DviK2115242
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=aSKnOaJDl8e+I17N0jewdcxP1Pjy4BPpkit
	SoVF0jVA=; b=SLPmVk2Lsc4coujiqO6sa0hT2S1yFA1OspJ6aypmFgErB/CfCvr
	M0cJtG8bnSe2G4EHHNhz406e8YBSxpGPvhKmfEgMXHm3kBD9MTHomtrkExQNEBLY
	LzJc5FB62msy0knD1vgp+YyWRkkUPANL/frzp3SVipnJUvamixPFCL7+OE6cg72h
	hEQL0vdOKZgshXl+FybhI1587OVUF2jdHLiimV9H4VaRALabubsOfHUE8LTdBpHd
	/96sUp/8GHDiXnpz6MfI7+vWvP4zDSmznidU2cEwXg/CsYMfIXTq0Y94OFy78UG4
	EmDzcsfn5AZ6AIatdgol5yp610V/W0sEy/g==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4feeg1jv1n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:37:36 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8eb8914e651so58783926d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 01:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784191056; x=1784795856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aSKnOaJDl8e+I17N0jewdcxP1Pjy4BPpkitSoVF0jVA=;
        b=NndB+kfaYXof2F9wbN+NWkxJh+uQznXA6l+JVOwOGJQuQ39bv8XrJKdBMhcYQFAACo
         25gZ2Ksx1pO9xSaAJLNMpvJPmh2QIptVC08ho4H074TiJsTYW8RC3tv1GDA2o3HVG5Ht
         0jGVc84bnJd1IVmEFuYSi6di8PtiNVb4nl74UDzdOXPjtMpEdPuRwIbfyVaDkCTfqESd
         pEN26NONK7LHMQUFte9ADggr+Fxt2QFfW/uTCzzDKUIpP5Q7m9dRVx53kqTT/UOVTv3J
         sFL7edUjnSRSZXAwCDxSg2Z6dk3XxdnFm+eGsCn2J9xv4TAH6fuTALdJ8NUUOiidjjWP
         fKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784191056; x=1784795856;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aSKnOaJDl8e+I17N0jewdcxP1Pjy4BPpkitSoVF0jVA=;
        b=kkORpCGQjdHcIcUKkFB9J2CZ5H0aBEwwFJOsdqtZIv0BIY0c8g57cCIzhLcALhPgDU
         R1NpVN6P2Qh0OwOE3+YS6XxSTTNWluazeYWQCQhyutVHDHnbGY0tdCR2ljjcHw51DiGR
         vCMgmmjDSsqhpiJ9XPnYq8FkUI05KN+ccbH17ecwX6iNp07q1LUVyrdhZRUXYtdA9qja
         JY875LLSVLQAg310dsoLZOXfr91IMC9JSF6DG0T2DvNLUQJUe6dxPgr0h3WITN0Ycy2J
         F0CGePLa/KFLyO1UdwlBMcnKrsWwh1JLf4shYVyb6puBCH7Ia9WS+x0+HQIUM2RG5//l
         8vHA==
X-Gm-Message-State: AOJu0YxhnY9ZHpf6/h+boyMYUipOIGRavgX2Y9sYtafDHIrN8huVfi0G
	XW6uquN4FFOQiuj2Ki8XG1Vkmq56zp4z2UFfMKRCwV8xm1NKYOU+JGqgBeKszAjl+WLbRGbzDSJ
	jEGzVEFd+SN/HHaFuvHIg/Hh45MuiiWbP6TUnSQgd4J4q7DyHP5yX6Z6VomxI9BS9
X-Gm-Gg: AfdE7ckfK9s3lJJBKTK59fqM89nHXcccbnMiYVNFtHteeaJmE9F+9cgkvqYBz/9Lz0A
	vItkiAQoRNUzD5VTECbl7ZxzpVbJD8nKCeIPuZeO8O8PP0Qiu3VijWFkYgKVQnEzLNJQ+Zn4c62
	L9zoyD+AZaOykqrSRpKBZWetQsvI7n0kRCIkGdZPugxzH6byqo37XgQ00nVQYVefe1S01jQpzR0
	fj0E+JMMfpTwDOUG/25iuw7+yQLVwvAPUn4gt6s3A8XZ9gQRFZjGFj7xY7oYmIfbtIQ7Z39epPG
	4Hc30x0q5Dzc+FmmrPgrMplVbLKIjgtIEWW9s/l4kcJ1ywcp+sshgvBPJ/dN1dAIbdgQT/4Ho9z
	rLqla1RaMA5cl+oV2KyOEl0MDcXQrs5dfTsbpGpZ3drsd8Pwbuok=
X-Received: by 2002:ac8:5994:0:b0:51c:147d:9bec with SMTP id d75a77b69052e-51cbf0dff64mr201887461cf.6.1784191055825;
        Thu, 16 Jul 2026 01:37:35 -0700 (PDT)
X-Received: by 2002:ac8:5994:0:b0:51c:147d:9bec with SMTP id d75a77b69052e-51cbf0dff64mr201887321cf.6.1784191055428;
        Thu, 16 Jul 2026 01:37:35 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e94e7asm43614295e9.12.2026.07.16.01.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 01:37:34 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        beanhuo@micron.com, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: [PATCH v1 0/2] ufs: rpmb: make RPMB usable with OP-TEE key derivation
Date: Thu, 16 Jul 2026 10:37:18 +0200
Message-ID: <20260716083728.2226422-1-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDA4NyBTYWx0ZWRfX39r4nADbLFv7
 kxRUlUhpVgSkLEkFKjSPkk+gSLn7JfcYaAX+GGkGdqeMswQ9TKRHP/G8hhEo0o/JIMxxQgE5cYC
 vw57SPKQ9a63GsKkXtY+fLMwjUP+zaGbDy91kJNvpRT4WXpelpdKpuLHWZ0gNG5R/y8dQKr/vIx
 SFXrCHDuZnioYM47nY7PFIeR8sMaqox2NAnDkCtAvsY6nZatZE9cXQvHw+JOB/DANciL2IUK2Kt
 +lgf6y9F3tiKRWXBw443+BjKEK42KUZ/qL8B2qOYNnHV7WOciV0g+4eZUf6LfHqws6JiO1Lzv+Y
 k9sLuhYIMTOL8qpVjj87UPjkoa+/1qgPg9j4pqDldMNV9GQYGUBpvVEK9doe9XmSAOi43EF3Eoj
 YF3l7YjcL6ThKn+QLSRXQV6u91E5GI0E+lWWBnHe92PuHfvgsEDU0pkWpHoV4Gvb/G1nHjoVNl1
 hf52mK6ObbUYoYd7tMw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDA4NyBTYWx0ZWRfX/CWRKiR601tL
 8Hgel06maYdipubMUfRyHfAGreq23RwfbdN/w8QdE6ms8/a9xR/+9VAPvPLASHrN8mnt1IzRwaf
 qegJZ7dQGtBgNRfTQhsIJAd4jPqSrCs=
X-Proofpoint-GUID: w7o0ABd6ymrM66eqJGOBORThNCJkYvaH
X-Proofpoint-ORIG-GUID: w7o0ABd6ymrM66eqJGOBORThNCJkYvaH
X-Authority-Analysis: v=2.4 cv=SsOgLvO0 c=1 sm=1 tr=0 ts=6a589850 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=_EMmJvYMAAAA:8
 a=EIJ3WXMgmfCyFXXGMWUA:9 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19
 a=iYH6xdkBrDN1Jqds4HTS:22 a=emCv1hD2LFd8cNRmW21v:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_03,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160087

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

