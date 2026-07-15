Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622C439EF27
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 21:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784151817; cv=none; b=lkjIrviLH9eHhxYu3gXHnQMnnFy24Vnka5LBw8G2X6O46DCo45eL9L7A3AamULVbrB5k0rpOB7UZOvqDB6QTqlQwxkbfM3552uhtQ5Cw7Nv1UbUTM9Bu/MOkN4T9Q7ddrGqU369LTM6Qry92C53fmc3vON46808IqacyZWLfyeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784151817; c=relaxed/simple;
	bh=ydesc48nFZN4QYKxkYYCcJd6lszzjzByE6lV+3I5Mfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pIqHl3ttM5T11wgvCnbK4jjNhI9aHe/DLwvJTeVm76fm9+2GTY5wiUAL0IYNon+jGHL4uqrJUVDb4Z9b5KRI/Vl6AeDh4wFCjv9A+UIzS+oo77msPkzQ6V++3C+wfglUCxcZMOhhHLDyxXZvIAUKjSdl9+/ifMlmagnv5c62LEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cQRUIiDj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JX2y+0/+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cQRUIiDj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JX2y+0/+"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66FKPiQr1715135
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 21:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=kqzd4g9UykK7dMt3kOtTRxoaEwoOgQlKy8d
	2xlJaY6Q=; b=cQRUIiDjPr0f+/aBODRJ7Mbe/mu7SCg7WktgfrWXl2WAl9K8r9p
	aCqBNWBbfOH+dKcXQl2C9dA1EEkWInsPh+ihNSJ9QhsmZ7eHyPp/LDu0xmg4FxR7
	I7ZpCj4278Bbf1SeR1Pke01d659VVAhe0q4ls6gqRiXQuxZowUNQc9SbF7RfF+bG
	72lWdXhXr7etNihawUOlLbdzxPgGO0m5jMyI20IzL+LoeLguC/Q7FAkTR0zH8RAa
	N2XNKAQ3wR0N6oHT7FmYcpExS0OfW3TPE1b+0brqKhc81QhpdWjAnRfmvc5SrLo5
	QjlsPOiihCe5aMPykKpIEDk/1/Roii1ay0A==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fe68wu9yr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 21:43:33 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5174a23afcbso30419161cf.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 14:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784151812; x=1784756612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kqzd4g9UykK7dMt3kOtTRxoaEwoOgQlKy8d2xlJaY6Q=;
        b=JX2y+0/+lok1pH4NW5LonpxVGE3QDhgIciG8MYbQ29R3gdMHoYkhosoH+ZnKC0PnSR
         32tHQcAtp0KcDnG9zKcog7Lug++hb/gQGa7on/HRMffsG6aOQCBAOGYssZgn+0b+l5Zh
         Q4kYBiWjpdjv7I/6Df35Bn57ATTwErGB79awFwXAD/oHLEPRMBxu2VZmBninhqm2tYnH
         p0PXGF17bM79EngZrYa1U7oHlGzwHF1llFKg+FbtBq66TNaU6EW3ig1Lg1E7g5krEyZC
         JFuq9+1Wiey1ovq5B9gyYPl51Co3db90e10pQOA/d9p/+gtU9JkpjWsfQn/SagzbJWoA
         0Mkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784151812; x=1784756612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kqzd4g9UykK7dMt3kOtTRxoaEwoOgQlKy8d2xlJaY6Q=;
        b=DNQS6lzZksddRBYK+PSvApt2Bz8vtMwDeaos55/4X2UQ620z48i2Rmhf4isc9hDcpv
         FyWYWfw7t5rTwCwBEPF6e3rW2ZaTYbd1uWwiNImfbcJUQDDmxhxQIrDF/wh8HwQ8HpD8
         sNqPZwBD92oVpFgnQl0EWJERqFYUmr+ZaiM/04OcvPILQ4umTfO92SrrxqAFMuHPMl+8
         huSnRbjvW0dN3fXRCj6RpsdgYYmui1Ps0WsXTmPVL3B5fGn5wnZ1Sre9s37LoE9PE4uZ
         3+XHHp+XjwuTJ106EeLNX38muzgIhDiPlGQUy1HaCfUORPBq0qeqQbxom/e6GszwBHqR
         FgtQ==
X-Gm-Message-State: AOJu0YxRXpC/yr9IRC9mcR4JT0lMXqxQrvqFpYfaYkcLAz5tZvW6RQ6m
	lNl2LqyO0Q5qmbS4/Qs+UIgqcR2Voxa0YArcU7s5hH9cRv3bNct5O4CNiuqh9tmdY2Dfk79gEAM
	C+1SvEescDeb2zB8060zreko7UTp41pmzOckH5HojCAJFkWmuUGI6kSUW/tLSODY7
X-Gm-Gg: AfdE7cnme0VWhckkxz/qIIO6HwFHo7SQpGEmVzkPiIFvlQ75/9tXeJpqtsGbGjtuTcT
	UPIqtlpvI/vuIT4qK/IBgWkesP32n/I1EQalNkBIgNTihfGWB5qmmUqZhSqYUsx2YsXu20A3Q7K
	asrCmPZYQTaMsIlJJEOvffXMsInfiWDi34sioe58jtweitaYkKR7pF+wtLqG6XhANsyJHwDqE28
	zDbQaKWEoXLir7Nw6bKzuJKu48Kwelzfhvw33+KQKvb9K2ApwgnruUINWjaW/o5dP/XIVqxMr3e
	dgJGXJLJ6ge2ANK/nZNn+7MxA7juuFirWaXSJoRMgLsAzGp6XKqcqPZVYdYxH1Rt+q/fm9EV8ct
	vYhYRn6CkxzwdD2gvfJMCSLs/kNYveh/ecGlr+G9pDr0beETPASw=
X-Received: by 2002:a05:622a:5a12:b0:51a:8c99:1f14 with SMTP id d75a77b69052e-51cbf27f4femr186098761cf.67.1784151812388;
        Wed, 15 Jul 2026 14:43:32 -0700 (PDT)
X-Received: by 2002:a05:622a:5a12:b0:51a:8c99:1f14 with SMTP id d75a77b69052e-51cbf27f4femr186098411cf.67.1784151811951;
        Wed, 15 Jul 2026 14:43:31 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541eb7372sm14200775e9.13.2026.07.15.14.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:43:31 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        beanhuo@micron.com, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: ufs: rpmb: make RPMB usable with OP-TEE key derivation
Date: Wed, 15 Jul 2026 23:39:14 +0200
Message-ID: <20260715214327.1933560-1-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: l7QgAHRB3qUVdZ6CgwPfPOZD6iuaMi0S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDIxNyBTYWx0ZWRfX4+Dx3rCkM/fG
 cy0P3cNmSXWty5z93dnXP9AKJ5vKcUgZ95642SwgIYBTBZFXhkdyoHdvNAuR3HkxC0R9g8suu+f
 XIQsuNR3v99xWyux3U1HzqmkkS6U7/UNtlh54oTiQkiMgPrAq3I4ZN2t8y2JCoAV3hfZhNBNi2J
 3k9EeIQC5z2ZOM1wGJLrOmABf/L/gmZBJHkSnAQi623bVq0cLNXmWxpxJoh5KIECqRqZFvIHNUt
 iTsYkWf6Ojuo8nR7m3JoQu2nQ5vlX60s3Ln0wLiFX0BB7MAwsJ9LavlNjfjOOZlM13kfHaavFCq
 eusUarhGaklCKWy1nMo7OFRKbqEcy2veaH2U8LqF7eaW5AW+nktY7cwD7SP+Tbsz0/gshnbQajb
 AvOjMbEGSdNuf27Rw5yzY1GdDYiFdjjYCNCsGNDwmyDpKRkN3jEcY8N6MUkydXFnWI24a/qzJnf
 8QXwYFmX5BhVoe9ZxmQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDIxNyBTYWx0ZWRfX6+U33CsTyM1t
 5dBjHkULluGNeBZdgtNpoCgN2fIjIZZg/AtnKLrNGda9Fxzgv3cPjiXwUZkJtxf08rCOMcLGgs1
 rME5cqoXzHlEK8Pes/l/bAVhiz1PcxI=
X-Authority-Analysis: v=2.4 cv=LbgMLDfi c=1 sm=1 tr=0 ts=6a57ff05 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EIJ3WXMgmfCyFXXGMWUA:9
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: l7QgAHRB3qUVdZ6CgwPfPOZD6iuaMi0S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_05,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1011
 phishscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607150217

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
(requires minimal OP-TEE changes).

Jorge Ramirez-Ortiz (2):
  ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN
  ufs: rpmb: use a fixed-length RPMB dev_id

 drivers/ufs/Kconfig         |  1 +
 drivers/ufs/core/ufs-rpmb.c | 41 ++++++++++++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)
