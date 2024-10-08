Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF9F125A9;
	Tue,  8 Oct 2024 02:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353083; cv=none; b=AlWPOy5klxPuTA9Sl03fbjSAV0mte1cuL7YLJs3geT10LcBLG1peIhV5l3UsOQmyW2xPVKaKhF8BafRGHEV2XuEhOD4lIfxDAvUqJkY+IZM8nfC1CNA9TMboUIeFVFenXeU+R+d5ORxXIlcWXJthYWyKpz2TMjBmL5MQgOq9e0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353083; c=relaxed/simple;
	bh=Q/4kKgkc6OWzN2m1BwLMu02zY3yA7eZ0zzLL/VFiMQA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tkPz/tU8aIouHpqnsunC8ZBtLnTdobsuYANRZQ2D17Ffy6XB9a6h0qkOBPM83JeFu7QULdIzvuXXviNNTB885xdRNN7Kpq+xQGPMrrirufNmuWt+jUrGWbdXKmWU4tjD80AlKmuF5L0g7hPU071ARzCLbm4HyLa4JUePXfgyZGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bWW/CTgN; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bWW/CTgN"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4981MnSc028646;
	Tue, 8 Oct 2024 02:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=Q/4kKgkc6OWzN2m1BwLMu02zY3yA7
	eZ0zzLL/VFiMQA=; b=bWW/CTgNan8SjdmLEQNybgr9QApdc6bwmfmeMoVxUUDSM
	uG75Kqg+atyaRoi9mxsxJowvHJKN4+WaQ3x93QtXP01NpFvayaTl+5F6eEkXwWoG
	L5VRi20B5s+W6sd8sF9H66nTFn3Z+OcHS/i2ba+5vAmyiyaQfEwFI+vO4sD1eAXj
	RrkGEzkQNZdQdyjF343/NzYfY7HxRtmU6lQ/e0iPiiOJUGFCBYrN2vZDoZOmlHUt
	XfXFUFI8Z5rCulN7KkkvMbtR6ZlHmL8GmXMdijFcaS4zw2uxSO8Kkat0Q48ZyYJ6
	0k4gNo0TbJnZsy0t4ndrf+2AMAwQPVOzVsMR5MqNg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 423034mwj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 497NnL0U004695;
	Tue, 8 Oct 2024 02:04:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uw6k886-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:39 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49824dIp004476;
	Tue, 8 Oct 2024 02:04:39 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-39-198-64.vpn.oracle.com [10.39.198.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uw6k87u-1;
	Tue, 08 Oct 2024 02:04:39 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 0/7] scsi: target: Add WRITE_ATOMIC_16 support
Date: Mon,  7 Oct 2024 21:03:09 -0500
Message-ID: <20241008020437.78788-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-08_01,2024-10-07_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=783 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410080011
X-Proofpoint-GUID: stWeiH0xrSrAEkDILPFeKUs0_FLiLF6a
X-Proofpoint-ORIG-GUID: stWeiH0xrSrAEkDILPFeKUs0_FLiLF6a

The following patches were made over Linus's current tree and add
WRITE_ATOMIC_16 support to LIO.

In this patchset we only support target_core_iblock. It's implemented
similar to UNMAP where we do not do any emulation and instead pass the
operation to the block layer.

