Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8C2311C2D;
	Sun,  4 Jan 2026 21:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767562994; cv=none; b=EYf2UVOdcT/qn++U0tjINX8UmWoUUhvQmU5p1CHSadnS5WsQVjyR789xpzJtzm2bk1r9gru3YRk3XSoNm1GsIPo7AFlPP9mBkmO1V64ZN5//HEKUa/40XqCdQsRNZ8ODw8/F3qPiYE/pSl3ftALO7drEYdrInYSry+8V2r4D0Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767562994; c=relaxed/simple;
	bh=bdFIf/Dr1XTRxkK7+Uhg2aPZo4bQ7/iN8qEFt5Ca8W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n5UP/P/pqoUMYsFW3Dwy351Pp1e4BXddeCb57H8nGkAOlFdpBhJeawSp5C/qAx9QMY4yogA4zufjDlhWYumEsRMmrbhH9Ye4EHgG/zW5wA/yo4laauVPnaBbZerQYORg92w/IUenUEyVTJOsCSgcXRv1eEF9nCmAMr/SZXLr3ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X11ICmtw; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X11ICmtw"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LdAFl067675;
	Sun, 4 Jan 2026 21:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/9e+oa33x4y3tTLbowaJSJ1uMSFxG48G7oAsEzVg4eo=; b=
	X11ICmtwACOmC7kJ4JixGg2AmvYrUXA6HnXE0TNXapuDfuE2HdONtbgNaHTLmJhN
	20Hht0Zu8qA7XcaMDiCJGzm/w1K2gbaIDskCEimpwmjBNEklZxk6lbn83Bd35nNd
	vyug+IFoeDSxUWmWzSt6m5fbGGAzcUqqzh58kCczV4OOBrkEJIhyq24HsanvQt/S
	EvjHaEm3kTJddan6PxxpAdyxr6szqwpK89y9dH6NW1dNhTymeYEagUHKYnl+MZBK
	WeZdK54AKCroAtdn1JqQMxop4itsHlpQuYlxMfQc8dtFCWruaCiIdEdGvDFyBxpR
	OQ8xaAlp3YmVqKZKOnRTbA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev1qry1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604GFQFP030810;
	Sun, 4 Jan 2026 21:42:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjarf37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:53 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LgpIs034017;
	Sun, 4 Jan 2026 21:42:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4besjarf2n-4;
	Sun, 04 Jan 2026 21:42:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Miao Li <limiao870622@163.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miao Li <limiao@kylinos.cn>
Subject: Re: [PATCH] scsi: core: Correct documentation for scsi_test_unit_ready()
Date: Sun,  4 Jan 2026 16:42:44 -0500
Message-ID: <176756271684.1812936.1338386823391125912.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218023129.284307-1-limiao870622@163.com>
References: <20251218023129.284307-1-limiao870622@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040199
X-Proofpoint-GUID: KfL15VztvjMjnr8ky7MsBOHFbDzdGyLl
X-Authority-Analysis: v=2.4 cv=Ec7FgfmC c=1 sm=1 tr=0 ts=695adedd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=-8v_p7c9YMDfaItegl0A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13654
X-Proofpoint-ORIG-GUID: KfL15VztvjMjnr8ky7MsBOHFbDzdGyLl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX0wlZTzIVflsl
 unRT4ICZ5DjHC6cmvEP1RhfYrv+RY1BfKWgWgr0a9i2RqJmCv8wObLSjLA7Tvy0CAl6VLfAFZ5+
 mSptt9f8DAOQStJvKeGZWsPb7Am5OYlOZLpL7Rcw6wm9rvtkUFW8MAR6RCncndUMtAZpx27/Q8b
 Pd07bjIekD0xvjeOohycclCpatFtynOPfXu1UqoXIaPl0LMm89YDGGb0Lq1Zh8eV0ije5SLaJn+
 q553s+OSQvAqRVWJvgk5rGVetf9Z9pUOm0VCRv7aMu47+/DOKOQDLjt9d+QVnX9RT9LrjL1rcH6
 f+dTiZc3RqAxFExkxR0jkha6VmhztoH/BrwMVDt/zd6pXGrtd5hzgOXJpCZphEXm/eJ3Xwp6lkn
 7Wxupw0MFax0xQDUfVh0beBvBEabNp6lL7szqTn0oeETvdnyHbWDMwLGo7SM4zeHaT5X/I09p0s
 HOqkJjFaKBvRp3BwI9boBHeULIB3jjza5c0cJd3s=

On Thu, 18 Dec 2025 10:31:29 +0800, Miao Li wrote:

> If scsi_test_unit_ready() returns zero,
> command TUR was executed successfully.
> 
> 

Applied to 6.19/scsi-fixes, thanks!

[1/1] scsi: core: Correct documentation for scsi_test_unit_ready()
      https://git.kernel.org/mkp/scsi/c/1523d50abad0

-- 
Martin K. Petersen
