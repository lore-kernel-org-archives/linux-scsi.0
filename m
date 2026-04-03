Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0D6349B15;
	Fri,  3 Apr 2026 02:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775182013; cv=none; b=qeI08e4eVI+61/Ljlc1EgEeQmdZuKN7zXfmzOTEvUEZE8fYFyZgDcGkz0nJwCCg6lqZEVUTcbbwQF0nwe+bZMwh0QGuJnGG5rS4B0FgZAp2SZKqkXjmQ/F0l6riAoA4nymy5atILulYfre09s+ae/uYXjRSzNAhawfHc1MKj1+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775182013; c=relaxed/simple;
	bh=Vo34Uc1lQORoW1XqU8BYBX9pGGMwq80NL8/RQVTj9pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZZ3xoUJ05tv0cPIZBkphxxH2N/0U/+CoPMmBtCY0tJHCyhhCZvHmLgWbGKr/nEN+zfa+iMn2IOFy4O2CXl8r4qlNu6VXY/FJKbKrqxY7LKUFR+3PhSEXQsaht3RuYEWRAPCWqNb5hz5D/Gabi1jxs+qSaQs0y8PPC5l7ZiIcU70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RlgBosKL; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RlgBosKL"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FBoWH001805;
	Fri, 3 Apr 2026 02:05:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UlqMwyFN4jGry2f/H7eMah//0aISrIxSYI+TEU9pX2U=; b=
	RlgBosKLt/CmQB11EV+T3gb3IVRM10iK+ED+VOkW6USx83qLhptvzW2RH9adhdZC
	+JFMRSOCkUDq/rVYitd1PK8nWNwib0XEbEO2Se6Pa5bYCTFHZG8LQO/9E4WDzpQl
	k8KFf3ZbWXQ0jFNApVTSF5mUf6/x5lBIBldEFsPHKv0S3kmIFuHm6ureVFn3ms3c
	J+FkLsRXxjhRa4GcdMnhTbOtPPIvA0T25JsPag7p2E4/YfHMXek7QP3wN2QDL2JI
	eNBg6Y7TqqmyB6q2Y7v23zNNwnEuxaiSb6AgcTg8VMu365LJrYmIjWmhIRT55v6C
	ekuz8VOMsmQGY8MYNt3ZnQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d671b1gvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6330n19t029083;
	Fri, 3 Apr 2026 02:05:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eddp5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:46 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 63325cqj017364;
	Fri, 3 Apr 2026 02:05:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65eddp33-7;
	Fri, 03 Apr 2026 02:05:45 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: lduncan@suse.com, cleech@redhat.com, michael.christie@oracle.com,
        James.Bottomley@HansenPartnership.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kexin Sun <kexinsun@smail.nju.edu.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, julia.lawall@inria.fr,
        xutong.ma@inria.fr, yunbolyu@smu.edu.sg, ratnadiraw@smu.edu.sg
Subject: Re: [PATCH] scsi: iscsi_tcp: update outdated comment for renamed iscsi_conn_set_callbacks()
Date: Thu,  2 Apr 2026 22:05:30 -0400
Message-ID: <177517593450.3522679.10454991872090765767.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321105904.7726-1-kexinsun@smail.nju.edu.cn>
References: <20260321105904.7726-1-kexinsun@smail.nju.edu.cn>
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
 malwarescore=0 mlxlogscore=739 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNyBTYWx0ZWRfX/8Z3ej5bftxQ
 gL4sS/7uAMLA5DcdGTsfC6viDamt6c4fApf2jCqFR0Fv0oVIC1mhuHqqpnD++QP3E7wEmXtccMV
 LliOB31Z8elG6g+eUDy4COAS5SBTbyrDm/X6mQuH3xQ9B4OZkAq1C8EokxV6txyQGjyVDJpf9I3
 tsSmYVBVAuy3jX0M/6LghmXcpOWXfSAmkcgVsqgraFB9XHVdZvqLABCMnBqXoaNleI/oFvOzpFN
 Te3fjghKKQtwRgy2AWXbtcTf3utAJoVKjw1nKGfuIdfmdWPqOCU2rasccJYwg3L1vETxAetkj0y
 xI6+5p8/6rpftWTzLjexHSkkfbp94r6vy6blTo0HD6UCIcDHfIQ7AzWkivKkJpbpNNCGO34It5u
 S/opQ9Jz2ZoO3553m4B1eUwahjbp8IF09Uz22L8+TPRSEKmwtHvA2nLhoTCggQWnHZ+DsH7qGm5
 RNnQjGzLuPsAqE8cuTA==
X-Authority-Analysis: v=2.4 cv=PJkCOPqC c=1 sm=1 tr=0 ts=69cf207b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=6LU6Rs01mCspBcRghAAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3vJ3996LYGz0MKWCEbKm_7t-UVLfoZxg
X-Proofpoint-ORIG-GUID: 3vJ3996LYGz0MKWCEbKm_7t-UVLfoZxg

On Sat, 21 Mar 2026 18:59:04 +0800, Kexin Sun wrote:

> The function iscsi_conn_set_callbacks() was renamed to
> iscsi_sw_tcp_conn_set_callbacks() by commit 38e1a8f5479d
> ("[SCSI] iscsi_tcp: hook iscsi_tcp into new libiscsi_tcp
> module").  Update the stale reference in
> iscsi_sw_tcp_conn_restore_callbacks().
> 
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: iscsi_tcp: update outdated comment for renamed iscsi_conn_set_callbacks()
      https://git.kernel.org/mkp/scsi/c/5b44c3757ca3

-- 
Martin K. Petersen
