Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702231C3C0A;
	Tue, 14 Jan 2025 16:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736872856; cv=none; b=JZTgFuH8kK+IDytXPLccQ+yU9TxpTLvV7jtIueFIlokHVhGjFnPhQNjhat8dIy5BQk2qZkQZeBC12Tdh/1TK0cVqFPqZWvk7QM9toVeQprmf9GCO25V4ao+71slhsP2CB4mHoHTjL1ArVQEJeUtwAcAgZTWZC4EMJlN4QFi9tHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736872856; c=relaxed/simple;
	bh=lq+/z837AJ+Kp3yFSR1wGWEuFiQ6oXX7V6uG8OVj2Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NxwNPWqsrgE1cTToe2pn6/A0HWMyQfVQ0kGJ0rAeyUxxRpC+P4FJ5jaZyNvkl9cUy0gBgKdJP7PoT2zOnG9oPOPDgrCppIE/as1YowUqENlkq9Z+eoXj8btqhGWOCqAPey8BHas7OVIFcdb4RVaBIFjuyuUpcV6zQ4USlLHeYc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rlze2865; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rlze2865"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EC0luh020686;
	Tue, 14 Jan 2025 16:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=wtrdQfEuTbF+3IQ2vXxNa7Fu9eAD9KJdup9DlDirwWE=; b=
	Rlze2865UzUTms2Ncs9AHPgT2t5uN8d3ZpMT4KE87o0ELZy9XrHCwgIp4+iUu6PC
	oAUCmuJQ3SUwHIZJuscXhuL9ZJK8DBBN0KicFA2hTTApAYjnF59pgRqfx1iD45QE
	w18Haf9hgLnQebaOoH0DYkD1ceuNDVx3cv3EGB9BWuDemeTschMBxsj5j5tGBGlH
	B7x2aDwPjhrWw+oDuZ67hSzn43myoxdRkLD66NJJDNmCvJGKWHQemOsUjJCAbFID
	a/daZItZQVfphmPh1D1OCnoBj6rI37fF3PDhq9dfv6cu2Xtr84BjzgE53KY1k5N6
	lsSV65mdKzAX6IGf3DJVAQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443gpcp8xj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 16:40:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50EG78kg036392;
	Tue, 14 Jan 2025 16:40:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 443f38vb6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 16:40:44 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50EGegei005685;
	Tue, 14 Jan 2025 16:40:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 443f38vb57-3;
	Tue, 14 Jan 2025 16:40:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, jmeneghi@redhat.com,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, loberman@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: st: Regression fix: Don't set pos_unknown just after device recognition
Date: Tue, 14 Jan 2025 11:40:12 -0500
Message-ID: <173687227224.1044893.5868878901297954415.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241216113755.30415-1-Kai.Makisara@kolumbus.fi>
References: <20241216113755.30415-1-Kai.Makisara@kolumbus.fi>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-14_05,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxlogscore=716 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501140129
X-Proofpoint-GUID: A7vcy-ycBZjaAGdG-IdHlU7QE3HjSH-z
X-Proofpoint-ORIG-GUID: A7vcy-ycBZjaAGdG-IdHlU7QE3HjSH-z

On Mon, 16 Dec 2024 13:37:55 +0200, Kai Mäkisara wrote:

> Commit 9604eea5bd3a ("scsi: st: Add third party poweron reset handling")
> in v6.6 added new code to handle the Power On/Reset Unit Attention
> (POR UA) sense data. This was in addition to the existing method. When
> this Unit Attention is received, the driver blocks attempts to read,
> write and some other operations because the reset may have rewinded
> the tape. Because of the added code, also the initial POR UA resulted
> in blocking operations, including those that are used to set the driver
> options after the device is recognized. Also, reading and writing are
> refused, whereas they succeeded before this commit.
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: st: Regression fix: Don't set pos_unknown just after device recognition
      https://git.kernel.org/mkp/scsi/c/98b37881b749

-- 
Martin K. Petersen	Oracle Linux Engineering
