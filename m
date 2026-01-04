Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D462F616C
	for <linux-scsi@vger.kernel.org>; Sun,  4 Jan 2026 21:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767562980; cv=none; b=PzAIQzcHJJ8jTRzH3Wmc6dMACV9N5BuNOo159EOxHeJuFelbF1bhD6WFh5uuL+LfwxlEThdXhZFcYsNG3ZrMvEeyyMo7M6HnyN7aWZHfoGNBfzKtis1DOmUjGFrDETqZ3WVtJwlfEEB/av0IMr8vBWBWlS6+tdzMvCMAfbWV7ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767562980; c=relaxed/simple;
	bh=c/lp7JFlwfbNBc4m7QrTCPaeqmA0HndxVdpCxYbD/lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OeQPXmwLlieY9PeQHTw79Qa3r30aqzbbAzUoYpclGZn9ONEXb6xLrF9JqcqkErvYrVNJ41A1Qr1bqM9jc+z1r2kQ1dioXzMkLiy4S5NgHpW+Klv5ENaw+fMG9MyBq8c77csKbFnpKKduyd/BCu1bl/9kIJzwDFoj+1TFshgveiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p0wkJf4L; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p0wkJf4L"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LdLah4166512;
	Sun, 4 Jan 2026 21:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7gDHvfc4OOz/vW5cqRurXee70Y4edNWdP0/uTxLKlZU=; b=
	p0wkJf4LFopkPwZoMDD9rh6QXwoEt+06yFH2CWa6uyR47LBIGOd2i+K1BqhCQfzB
	bKuI2rYMwevhuNg55YR/2HKRoEY+HFMa4wzZ+rwF2/eYJWsx9155w+NimXf9jabM
	SYe0kogfC/3DizkuUK1mP9Kb1P4+IEoR4Cu/umFEQ0tWOxPBdWWi3yZ93L12YaLU
	G9QVXC3HthlWeZQlapoMdEY1qErAkJSnFR8YE/alBpB9Tp7eb2cjXz39qMnL/G4v
	wfErIcUxto4CNv1WHmbt8Nvqa/AJOvYEqeNbhm+jXg4ISXHmJBcfV7zaafyKAL5g
	m45ZBDl//6T+rEkwS6yr7g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37ry2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604H4isN030738;
	Sun, 4 Jan 2026 21:42:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjarf3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:42:53 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LgpIw034017;
	Sun, 4 Jan 2026 21:42:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4besjarf2n-6;
	Sun, 04 Jan 2026 21:42:53 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH v1] mpt3sas: Revision of Maintainer List
Date: Sun,  4 Jan 2026 16:42:46 -0500
Message-ID: <176756271701.1812936.4465199091056134399.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251223104721.16882-1-ranjan.kumar@broadcom.com>
References: <20251223104721.16882-1-ranjan.kumar@broadcom.com>
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
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=899
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040199
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfX9+oIxCs+Y0/j
 sM7ZHM6TgUz0+mdrhJ/HSWKrjNGdCILn5eIUGSdn5xCHeK3jAIlE+veDbSB6nWoqVAtZxbdsRw3
 shfCZqvTgdunSHlaWNCcdqmQE4Xma6Tt5IRPNJUaq4bcAqWAWlbEkofojoqtb6/3E3OJdBmevXc
 tzi029fvCU/BDaoKYPf98eMhler55+zHcIVoUEcpMiTGirNO6NvWM+TFotQq8vtzL8iO44Hv28C
 8P97lqETUblCZzNgJS6jLuWH19t4HJD5b8l7fNni/0P0+4S0pukV0xlKLJOwibuC6dOtkIni2jd
 BxjBIAaRsxWUlbWZAN3P4XbroUi6tEua7xKH72HYh7IJhsgY7oSGu+LsUZfMvvvgMTIJxXYAoj3
 Mg0KCNwHkau5qpBAgWKJ82fWXleuzFgviilnL750KTfzZlX45T+lu7j6za5dkapKc5I5VuJQHmW
 Y/ahfEbN+iQxaZBUhmvg4Omap5tjt+jOz4SOXwuw=
X-Proofpoint-GUID: bYx57UXdDSuVm0jgUMamK_trEihzjK5W
X-Proofpoint-ORIG-GUID: bYx57UXdDSuVm0jgUMamK_trEihzjK5W
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695adede b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=rUaecSpxiisJSfCix94A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13654

On Tue, 23 Dec 2025 16:17:21 +0530, Ranjan Kumar wrote:

> As an active participant in the development of the mpt3sas driver.
> Added myself to the maintainers list.
> 
> 

Applied to 6.19/scsi-fixes, thanks!

[1/1] mpt3sas: Revision of Maintainer List
      https://git.kernel.org/mkp/scsi/c/001556d29872

-- 
Martin K. Petersen
