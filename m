Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DF624501B
	for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 01:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625301; cv=none; b=U67XCm33Sxm99X9FdMUjggyqz15TMAnL/1rSNIGGv4umIwq3gZAUzJJQTajLmZl8pKHZogJvRzxLUUE1gkETaU+Car41B5ebF8vAX0qzuzi0AilsvRqj9tHnZjxoES2uPlyLuNkeCVQoT+PAmoD1xoaaOq4X6dwvbC99quYvvrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625301; c=relaxed/simple;
	bh=lWgcbWZJ8lDK30wWSy9NhivcOmIfCJjRUmSVUIdccDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MvgIeLsZg1Geixt+c+gAC9Ik/YTiQXGDaUNXrWAo43yzFX7SKGQ/vyV/HMVXSsdyCD3/Jdweev3iHyZ3dfJmmCguickxUw/MorbOaifhQ11ORwNAuo3JYgTmg0g5bBwS4qjtDIWE2lBK6bEDmHY7JHLh1B0BWYGRs/MZW9TNy5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AO1lkaSe; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AO1lkaSe"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G0hemA3005786;
	Mon, 16 Mar 2026 01:41:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6bYAbt3uWYATV1Dn7lWcJ/Nn6mUWVLAho9MMePD7aXo=; b=
	AO1lkaSe5fXJhqL8gysYBEc7RkToAynvgYhFG/S+WVGjkw2O2Wj3Bu65zszDWaP/
	pGxMs8dUndXefTapvcPFapqoS0Q+sKAPLjxA7beDUuDMenEZXTeBqLOm9VRet0/6
	zBCcyoGgnJhZ3I5tEFyBrkWMWi//irY1vVfVHwww0EWfs3aqPMk9nsJ/BBDl7312
	Ng/3ZRNwfd+JjPPE487a8G2YgAARihUb+asxncuaZZJGRlvXU174gFnnofBSLYym
	R9xb9t0+pzCCClqgkCUEYgC3dD0Cr94ScwhrGsNDWUD6GxYsFKan5qBL+WPDD8A1
	BcGyKOYI55h34mk09lKDmQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqbsb4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62FL0THJ002788;
	Mon, 16 Mar 2026 01:41:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4j86my-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62G1fXhN032070;
	Mon, 16 Mar 2026 01:41:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4j86mp-2;
	Mon, 16 Mar 2026 01:41:33 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        Can Guo <can.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/1] Add sysfs entries to facilitate UFS UniPro QoS monitoring
Date: Sun, 15 Mar 2026 21:41:21 -0400
Message-ID: <177362524468.2599440.6758239022546905006.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260305110856.959211-1-can.guo@oss.qualcomm.com>
References: <20260305110856.959211-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_01,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=872 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160011
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAxMSBTYWx0ZWRfX+LGxzOL3qmDJ
 rqw/5BorMrFsPpnv8Zx20k8W0XdR0vdpFXWarwMCys8wudJZCKypE3n6a+hHCTmDTpOWCww90Kv
 A+j+6K4W+eGhXMyO/5VC33bMiMHbgeaWDaTWlQwCW+uSXutU5907/k574MyVZFxxvgxnbjVdEL9
 ztwGaiz9PPsPEd+03IAsa7Jdhwu9l9qokQhl8EM+knXCCnMDEwp7g0whHmiH+CVlKwgKhXxrFFB
 eV5uoUL2VVNDYA2NPF6tOb0dvTHrLRE/yDB6e215wz8JhSHHaZxNmAn7XJSAjLJQ5Nub4k0yL8V
 3pujZoDwMBXxfjFXTuhQXcY9/UDGkRkNGWlYiA+d0POLR4evVPCN4eUfgmR1Q5GtrCh7sA2Y9Se
 khPzQRnKDhl6Z7LS6U3BkK1XL8cROaiKdWpni8nBuUoC45q/k3/JVwN6JPVhBZldtShr8QmsYkV
 sb5RSVYNumL1TTeURjSuWNuvyIH1HpOp8q703+OI=
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69b75fce b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=8-nQ6o3H6mdb75LgHhIA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12271
X-Proofpoint-GUID: DgXeaf0C-XAjkLNgaRI6FtvAP0Nv7orw
X-Proofpoint-ORIG-GUID: DgXeaf0C-XAjkLNgaRI6FtvAP0Nv7orw

On Thu, 05 Mar 2026 03:08:55 -0800, Can Guo wrote:

> While userspace can currently configure UniPro Quality of Service (QoS)
> monitoring via UFS BSG, tracking events requires constant polling of
> UniPro attributes. Additionally, UFS host reset caused by err handling or
> resuming (from LPM) can reset UniPro QoS monitoring attributes.
> 
> This series introduces a sysfs attribute to the UFS core to improve the
> observability of DME QoS monitoring. Userspace can configure and enable
> UniPro QoS monitor via UniPro QoS Attributes (using UFS BSG) and get
> notified by the proposed dme_qos_notification attribute without polling
> UniPro QoS Status attribute. The dme_qos_notification attribute is a
> bitfield with the following bit assignments:
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: ufs: core: Add support to notify userspace of UniPro QoS events
      https://git.kernel.org/mkp/scsi/c/b5e21a29fe94

-- 
Martin K. Petersen
