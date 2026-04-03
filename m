Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E982FD69A;
	Fri,  3 Apr 2026 02:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775181950; cv=none; b=NzZnuQ+Rsdu3TUCuPnXObg8IdHwUYWm+KsXExemQ84LTOBqxalvpCqfv535AlrnXVmfkXpMn/+fOlUfJpoYYi9Sf9537PNJtC3X16P7Jdndtx8J5TlPeDUe3RATuDg+hLP7tA/hHF66m1Y1OjCfUhmk+opmoGiw90b/V9HIauFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775181950; c=relaxed/simple;
	bh=5V9QkxKPbuXvjEVL/pPgQZQDPdMzGhVMa4EoBzK/pg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZtPzEVsD123UsdiAE/wtlpyMc0AHuvJbFk9k1gMv8LvptomHLvKnyd5Vj+xBE4TbHY7XYc2m5UQm7EQWrBKN5e0ZEMZHUQLXgasYbrBX6p07fER5OUXIQSFl9ARbBmtG3T5RHymPH7dvT5Q4zIcBYvRd25zZgYCoySpLAGS44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jCqOGlTV; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jCqOGlTV"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FBr3r2879390;
	Fri, 3 Apr 2026 02:05:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1NvQBbpSWlfXcgtrlLhfPayDq+mNWdEUvHf8YGAmFlU=; b=
	jCqOGlTV1HduDMun13VVNj6iMaJzogNelNm7OeWmdV8USjHvBkP8tDnj5xq5LkJG
	m+mcF+TmB5U4JIcYW3hAx8yymBEAxZ4OhiNkLu57bvkibvNV7vtg0M8DJxvjK+kE
	dCkzjt/8kxWG1ZAVDj2GEdyBcUjUVNeY7bHaF4ijdqq1BGZRxMiK0up1d2VYrBjs
	P0wEKbwVij/gJCG7eXA6gYcekBMHrc0ws8foCPvc3J9XJWT2U0TnKYrjaMrHg9c0
	X5MT7OkuryCACwcNIrsdGOf9ZpWj6IVync7675DZrW034Fq/mbnP7SMB6h54L2Zn
	JB8Pew7tYQue4GpeyVCeew==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65s11gae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6330qqGa029103;
	Fri, 3 Apr 2026 02:05:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eddp5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:45 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 63325cqh017364;
	Fri, 3 Apr 2026 02:05:44 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65eddp33-6;
	Fri, 03 Apr 2026 02:05:44 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Replace strncpy() with strscpy() in VPD dump functions
Date: Thu,  2 Apr 2026 22:05:29 -0400
Message-ID: <177517593431.3522679.14923158633747124728.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323171311.work.101-kees@kernel.org>
References: <20260323171311.work.101-kees@kernel.org>
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
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNyBTYWx0ZWRfX2/6qBNHAa1dO
 XBWRskRD/IG1HEXBVINGpXUhizN1q3NVAEswZLFN/YLcjatrcRLybkw3l9/k5JoeMg8qpLEgSEb
 zXgO1CUatA0n1212whyyTyJK4lZcIgxK9WI43IxRoTD/C73zk7YD//zLu82AgdXO9DRO6iOv5BL
 NqM5dsdzWXR8lKCTs6afuh1KiwB+Js/iTdmTrXfi48Iq9lzJJ3pz75xMQ2hcqCxY6PYmRecXoIS
 klokMB9A53sT//Bju7IOlaKIP+xs4narSd+1WBL+clOGqmD9ku/WGO0d9GHfdBgqwDt4ww+JQ4q
 44Oc0HgREw3lL4NFPBXfk7Ouy5IGTCxpWTaejnYKbdY+tqDEKewW2Uuv5nOWJ7aIgoDGA8cXaTJ
 uvLLdCMslMgyHGwM4DQ0jeYeyfDKHawlxrOKrGDRNWYmsZ76AN4yxU4TzhOcrCjinRmMkLScONg
 Cqc/RZO+gm38Qljut+w==
X-Proofpoint-ORIG-GUID: EjeZY0bpFmKaAvai252AZPzNypnUxqIb
X-Authority-Analysis: v=2.4 cv=BvOQAIX5 c=1 sm=1 tr=0 ts=69cf207a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=0OMCWzbaks6jYXudNfoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: EjeZY0bpFmKaAvai252AZPzNypnUxqIb

On Mon, 23 Mar 2026 10:13:15 -0700, Kees Cook wrote:

> Replace the deprecated[1] strncpy() with strscpy() in
> transport_dump_vpd_proto_id(), transport_dump_vpd_assoc(),
> transport_dump_vpd_ident_type(), and transport_dump_vpd_ident().
> 
> All four functions follow the same pattern: a local
> buf[VPD_TMP_BUF_SIZE] (254 bytes) is zeroed with memset(), populated
> via sprintf()/snprintf() (always NUL-terminated), then conditionally
> copied to p_buf with strncpy(). The p_buf destination is used as a
> C string by all callers in target_core_configfs.c: strlen(buf) and
> sprintf(page+len, "%s", buf) to build sysfs output.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: target: Replace strncpy() with strscpy() in VPD dump functions
      https://git.kernel.org/mkp/scsi/c/665fb6a64319

-- 
Martin K. Petersen
