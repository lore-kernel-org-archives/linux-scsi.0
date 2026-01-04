Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E787D314B8E
	for <linux-scsi@vger.kernel.org>; Sun,  4 Jan 2026 21:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767563015; cv=none; b=Jvx90aR/N2UytltMo0hUYk8/m9GIisA8e250iX2Ia5xdzLteN6GSGQckVaIi8tmANZuhFJ8N4RSQrCW6oFDm4G9o5Oh2GRpUhb2Kjg1fbU9mbGxbV2UuczX+XS2tF/OpI/95jUklJx6HIx2e8cvNSWtrZvaSboUfNb7iIfIcQcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767563015; c=relaxed/simple;
	bh=v0E6o+t3iXkcUQJy7TzgbCYbVS8yaZonTAlgX1mBVsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c7G7KUUJp4Di4CctkGV0k/xSgY72BoK+NmGvQvzExfetkOqLIJLJICzbkfXivXeIDq6oRMqtMmMbsgZLQRzcXMeTTOQ3I37ypyL/nj0e0+QnXHA9q2M41kAgbtWIfuLk85rJFyBpCtN5o/NurvEmbjVy+S/sPNhyv24Q9e86GO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CFh1QSoN; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CFh1QSoN"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LfbM4071179;
	Sun, 4 Jan 2026 21:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WbUSdNjOONGLXaBfYpWvoEGsfcS0J0Q2BeVrSQEQfQ4=; b=
	CFh1QSoNMyY5RVGfSWuwr9D+3Di4xqxdEO0kF/y4smebgmNM3cifObmr8B6zM9f/
	SAO0jmOZtXbFQPUZT7VwVbgjurVY8kVZmkDdAlANRBokryqemxjrvGv0Wcb/xokB
	g4h3Wy2wznkjLN9KCKtdmgsPA5dFtGPd4PmRBMTgFfJBZN9/Ho5niUVc1QNqgx0R
	oEg0dCanMXZ+GwMqEsYwW9jdeSJTHZWCzqPLtnvYFQrwd9Kruk1M6f9OfK02xYo3
	2TRvvWFp5O0cl3DqEvQnuRXic3pMuCcFjhp0TXJushS/QmqAaeczWT9109mkFO+W
	5ikLu3NwVD0cyyVScuF5oQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev1qry23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604H0aPm026793;
	Sun, 4 Jan 2026 21:43:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj6gbgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:26 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LhPoN007658;
	Sun, 4 Jan 2026 21:43:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4besj6gbf9-1;
	Sun, 04 Jan 2026 21:43:25 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: Introduce an enumeration type for the SCSI_MLQUEUE constants
Date: Sun,  4 Jan 2026 16:43:07 -0500
Message-ID: <176755562249.1327406.4682859725529959025.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251113181730.1109331-1-bvanassche@acm.org>
References: <20251113181730.1109331-1-bvanassche@acm.org>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=916 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040200
X-Proofpoint-GUID: M10fBHJvaqSaqBsiNw4fSY8le7WLWQKv
X-Authority-Analysis: v=2.4 cv=Ec7FgfmC c=1 sm=1 tr=0 ts=695adf00 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=dcZ9_LPyjrzRaMayYEEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: M10fBHJvaqSaqBsiNw4fSY8le7WLWQKv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfXzqj7aC5g+MHm
 LD4bAsREGms3x4RSnrXChRoiarDy5P3LazwRX5SnpeqF08mdgYoWM2JPOGuXHmBQQj4UywbK4qZ
 IQ2z5e9dMm0+v6lkAO6+QxK63A3CF7h0jOA4XnXsYsFpegu5OM60TWTgWCyYT/WMVVpibR/wzru
 PLjvJqDMIaVelvyvpY2Fr5IPOgYWF7P7+cZLyxZk6Ab12z4sYgUHdkxwUuDV4FMgt4j3ty76hnS
 W4NscTXcbWXA3HqvQeIkE/HT5K8DbY3Vbqk74NYen1EsRF7zgase6Z3NwK1hgBfVuDqbLTC1p/l
 PGxn6EVod9zdNG1VaqHsZTwadYtPZAZlf35n898LCIbFYI63MRgeroE4jPamG2fyK9wTxGUsd1/
 vnPH86Sefazt4dy5/89ukUfRLz30ZVOihB40Oe82ogxv670NFuoS3tdQyjgeMb3G8mNFYTiEYIS
 OinMsEjzV459gDqOr3g==

On Thu, 13 Nov 2025 10:17:30 -0800, Bart Van Assche wrote:

> Multiple functions in the SCSI core accept an 'int reason' argument.
> The 'int' type of these arguments doesn't make it clear what values are
> acceptable for these arguments. Document which values are supported for
> these arguments by introducing the enumeration type scsi_qc_status. 'qc'
> in the type name stands for 'queuecommand' since the values passed as the
> 'reason' argument are the .queuecommand() return values.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: core: Introduce an enumeration type for the SCSI_MLQUEUE constants
      https://git.kernel.org/mkp/scsi/c/0f9c4be787f7

-- 
Martin K. Petersen
