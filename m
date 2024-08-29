Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7414962C;
	Thu, 29 Aug 2024 02:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724899893; cv=none; b=DtSeNiWSo2WlbUpmzmWCWUqscIPNhqtFYjhRuqOe1r70pMHVfItKTln2x5/LpkuSAe4akp1GyPVtZBJiGVFhyvtC+azbhRy79PhK583RJD29z1OauHNWlMYrbr3IncU3f5fH9ScXo0DIPHWPdgs8BFm7YWZJRE+zmXix7fzNcKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724899893; c=relaxed/simple;
	bh=sBxWhMxBRhvV1lCP1ByAudHybzF+1cL+4yWUk87B+fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8OP/V4NiGw6aI3KyCMiRkSxL/6cHpFAgyvPaET8J4H6ADYghuFfkMqgf0YCKj8OnkZmYZCPBrj5VOi0hT8X4Kgq0M2Cub6gNFpKZMWRbMlu57DlSR6WpZ2s36KR5BrcjcGa+KQDzfTeZiquHpeiZPJIZ2cZSC15hbbZ4KBjT4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DBQz3xeE; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DBQz3xeE"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1fjp2028824;
	Thu, 29 Aug 2024 02:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=Z0cCTLyPwOoFdCXpqFejqxiWlPiROL5eX/C0s4LfuiE=; b=
	DBQz3xeEFImqkW+IKhoDYeSSi5wMhkurdG8hzbgobhq3Ld9C/8Uj8sZdk0QTYDeE
	l0vV6TF5mPDv5M1UCuWu12lZWt4ohyovb5yPe+Pv7jZ7OrWRO04aGjOxRITmY/XD
	dNkvOoOWu2fqwapuYG8b/dZK5SvI20xelqG5883aEBR+In7UP91WBAtOTUBmZjV5
	A63JTiWo9g7SgQf0X7l6gjgCwJ4hjnbA4L+YfpuR+3WP9vs4ANEPJEfFQ+TZc3AH
	TqGdCzi3uvmHg1mFOPblA+1VW3MGm9HgKo3DWfNcnqqLh5vTdGnVriCiyfyt/lJP
	oYYTDYwG1Q0wakyrKHXEUg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pwv352x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:51:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47T249GL010667;
	Thu, 29 Aug 2024 02:51:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894q4qmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:51:24 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47T2pKYq013333;
	Thu, 29 Aug 2024 02:51:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41894q4qje-4;
	Thu, 29 Aug 2024 02:51:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Yue Haibing <yuehaibing@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: target: Remove unused declarations
Date: Wed, 28 Aug 2024 22:50:45 -0400
Message-ID: <172489245035.551134.783996217197531386.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240810093437.2586476-1-yuehaibing@huawei.com>
References: <20240810093437.2586476-1-yuehaibing@huawei.com>
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
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290020
X-Proofpoint-GUID: ikaV5pCoqqmakvmuTXztlEeaN9BK3BTh
X-Proofpoint-ORIG-GUID: ikaV5pCoqqmakvmuTXztlEeaN9BK3BTh

On Sat, 10 Aug 2024 17:34:37 +0800, Yue Haibing wrote:

> Commit 13247018d68f ("scsi: target: iscsi: Fix hang in the iSCSI login code")
> removed iscsi_handle_login_thread_timeout() but leave declaration.
> Commit 3e1c81a95f0d ("iscsi-target: Refactor RX PDU logic + export request PDU handling")
> leave iscsi_target_get_initial_payload() declaration.
> Commit d703ce2f7f4d ("iscsi/iser-target: Convert to command priv_size usage")
> remove iscsit_alloc_cmd() but leave declaration.
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: target: Remove unused declarations
      https://git.kernel.org/mkp/scsi/c/3c9265ed191d

-- 
Martin K. Petersen	Oracle Linux Engineering
