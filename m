Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A732186E2E;
	Tue, 30 Sep 2025 02:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759199841; cv=none; b=MRbwPDjIXYtdWVaNM2T5H10e7q5AI0NNT4ACaoWjepXYOCyAiqziV1GChgliV5kRtzZWraWWaSyxXGX/Hgz/vVIqmN6/AJQh0W1ffcRriDIcysKQD1eRzKGmNR3+6LjLgpj7QsU7gl2L3j+qUU/a8VO3CtpbqgrSVIlTco6uyU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759199841; c=relaxed/simple;
	bh=Y855UhrMJQD6VnZYZvWcROJeKAxBAa2YXhFi10Anj0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O1p+bE0PfPjn5tzzy/jFd/QYfB8a89qsr2KEY9aTMzSngxmSebA3ff0bVetrnu8LGTDSNwpBhX6N+867mtBo0AO61pahTsAJH89kQ3YlG8DU9rqr2UnhxSxJauFWVrIRq7OxmiWZUUF5LaMPrZy2+iuI6USJrWzcBgJY8kySpSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ODZXEPpP; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ODZXEPpP"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U1ibk6029786;
	Tue, 30 Sep 2025 02:37:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FhDbPV3D1MKeI9tBld/+W6DRHYWPW9SeKsHGfihwMUI=; b=
	ODZXEPpPrHoyZ/9JbCovuPFRz2XOTcZ+XJJb8ymvwQ67w8QDNR1gbLoXWoACtFkx
	sLsBiapUA0/BzmRpQfbmiP0XaSBfsTdwjFBd66ghJKrt1JB3dqT/nKPMb9pbEN8I
	OGMddaqHsrG2RqSh7LQ9gvvYu4A/1M1ukEUYZGxKPITZDXThDGYdrCM4uNMF0U4L
	3IxifQg8RWiV6o7iOS3PD6De2/YoM/m3yCJFecr1y5JM8xOG9Th3/lnwk2FeqzA+
	6q/6UJUZAED75diqR2XmFOJO6gbuJNEy/9R0QT3ad6zYnpCrdFf10JMrOr9S3kFf
	wdxs0J98AtseKA38jDNcwA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49g5ta82w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 02:37:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58TNHjuN008099;
	Tue, 30 Sep 2025 02:37:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c86ey1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 02:37:06 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58U2awVJ004400;
	Tue, 30 Sep 2025 02:37:05 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 49e6c86eur-6;
	Tue, 30 Sep 2025 02:37:05 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com,
        Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        peter.wang@mediatek.com, tanghuan@vivo.com, liu.song13@zte.com.cn,
        quic_nguyenb@quicinc.com, viro@zeniv.linux.org.uk, huobean@gmail.com,
        adrian.hunter@intel.com, can.guo@oss.qualcomm.com, ebiggers@kernel.org,
        neil.armstrong@linaro.org, angelogioacchino.delregno@collabora.com,
        quic_narepall@quicinc.com, quic_mnaresh@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, ziqi.chen@oss.qualcomm.com
Subject: Re: [PATCH v3] scsi: ufs: core: Fix data race in CPU latency PM QoS request handling
Date: Mon, 29 Sep 2025 22:36:52 -0400
Message-ID: <175917739980.3755404.731706054489200591.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com>
References: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_08,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300021
X-Proofpoint-GUID: eqwlNG2nbaPCieWp2-jXK0cyiePmFwmf
X-Authority-Analysis: v=2.4 cv=HZ0ZjyE8 c=1 sm=1 tr=0 ts=68db4253 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=w3E3u23N8SuqHuMmXqsA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDAxMyBTYWx0ZWRfX7+1vWsVYL/eF
 ubSP80tLX2SOFDecsHyMwZbDK/UK4PHLjt86isTJndT3T9Y7StG0MWv+aESdhJhhsL3TLilL4Rz
 FjhF92hijdAfmtDt9cYi2nwKEM+/oUPZFXXbroMWixtyvA0xwaBCUxWFgSiqYBPLUJcVdBS4eR8
 8jK80ngFGVFnw3rLGH7jc25rXxFhGSlRKMjC1v3xOD1O3Bar6U/hXaWHS/DNLffcDnTyohE0XGq
 27bjGLorFf0Ycic3oaXWF3G4jKAOyyFF/HhpInKG+GL45kbhwGr9TFj20nw8WJv1xXK20ZYadgU
 xqKYYEvw91TetwUZOLnbc6j4tXH8jmSdv7TBPpcqmpFrMceIQxuP4x//stvD/lDyTMymfLsXnyX
 9lBdNTYbH6PxryrhnyM9WGdUoaCL+w==
X-Proofpoint-ORIG-GUID: eqwlNG2nbaPCieWp2-jXK0cyiePmFwmf

On Wed, 17 Sep 2025 17:41:43 +0800, Zhongqiu Han wrote:

> The cpu_latency_qos_add/remove/update_request interfaces lack internal
> synchronization by design, requiring the caller to ensure thread safety.
> The current implementation relies on the `pm_qos_enabled` flag, which is
> insufficient to prevent concurrent access and cannot serve as a proper
> synchronization mechanism. This has led to data races and list corruption
> issues.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: ufs: core: Fix data race in CPU latency PM QoS request handling
      https://git.kernel.org/mkp/scsi/c/79dde5f7dc7c

-- 
Martin K. Petersen
