Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A122B646;
	Sat, 17 Aug 2024 01:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723858172; cv=none; b=W/vZHLhMZtnjuQJ1tU80j7UFPHD4DqfNCvRlfeVSo4mYGzmlFfkkLwyUzqALkTcV1gFZ7gRurJsGAJaUJnrGgWcL2tssd5btKJO9LuJN7xf9K/AOV6bHnVSOkANtL2s5p/H84E7geSskMYCSK8TFDX3GGSI2cZzcrZY59eVbyKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723858172; c=relaxed/simple;
	bh=5HW8SW67EU+FWOVYhuY2pgXSU6w1OwrkpOnNHUvFTTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1TdySEOJZWCXSrZuTp1IL7j0Zt7E4KHWPSY2Q2dUX/Hb57ngT8baPxwB/FWX8NZg4/t5YddiL+2e221/qnXN8+j2L53mUhxIG3oAGLSrbA2yA6v3YIc6Xd3Yq/9GzdiAEMrMtRw+/zlTozN6JVFnjc0TrPzvpJGkpg/7QLQH0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Km/2mFSp; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Km/2mFSp"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLBwI3002666;
	Sat, 17 Aug 2024 01:29:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=EA6ZqVmrLUT8u1Gi/L2ocydEWTBAELEMEgUj7rbu3c0=; b=
	Km/2mFSpOhheyR1VtQQDRx8XfDGWbKLYPxkU6hIHWnzOYOggVPhUwJNxt80390BZ
	L16uYNfyrgXsStn75p7i5IOXI2wqDwALT/MGEUBMIVtrX29gn8KhZw7bHabuB+lk
	ad3df2qWBNaqwX7bSch93wI6FlzSBpKkUHzgIcwFeQS23UwaAqN8wGPAwj3QUHgM
	mKyQpRPaTnq6Ybu9EvFaahnjLv8RqenBUw8uNxo1Mce4jz8HssrUv0dN6xiYALMG
	VMudC3/J5xEP6UX/borAP2KCn37V0Elge0GUgO0ssHlgCe9XXVrAOcaNDIKHzfvG
	aETUjj6MQJHIxTMcyWIroA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x0rtws25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:29:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47H1Bl7S020945;
	Sat, 17 Aug 2024 01:29:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnkh7vy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:29:14 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47H1TDaW025300;
	Sat, 17 Aug 2024 01:29:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40wxnkh7vt-1;
	Sat, 17 Aug 2024 01:29:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        Chaotian Jing <chaotian.jing@mediatek.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, srv_heupstream@mediatek.com,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] scsi: fix the return value of scsi_logical_block_count
Date: Fri, 16 Aug 2024 21:28:34 -0400
Message-ID: <172385808991.3430657.4000095161450212305.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240813053534.7720-1-chaotian.jing@mediatek.com>
References: <20240813053534.7720-1-chaotian.jing@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-16_18,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=820
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408170009
X-Proofpoint-ORIG-GUID: EKuiijOEDYYkysP55e_fT2efBn111NWZ
X-Proofpoint-GUID: EKuiijOEDYYkysP55e_fT2efBn111NWZ

On Tue, 13 Aug 2024 13:34:10 +0800, Chaotian Jing wrote:

> scsi_logical_block_count() should return the block count of scsi device,
> but the original code has a wrong implement.
> 
> 

Applied to 6.11/scsi-fixes, thanks!

[1/1] scsi: fix the return value of scsi_logical_block_count
      https://git.kernel.org/mkp/scsi/c/f03e94f23b04

-- 
Martin K. Petersen	Oracle Linux Engineering
