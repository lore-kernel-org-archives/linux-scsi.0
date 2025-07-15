Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5442A1AA;
	Tue, 15 Jul 2025 01:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752544472; cv=none; b=gJiJH0OBQHqrO9mYV8P0jlrZG6DduCTZq6cV4drJ2WsJnGdPBaUcVvl45Nq6JmozwtINy/org0eIa4uq4UzOZmejp8gak+SqhGDX1Fuj+Etk3oWdo2N9aYY/2tg4yVoqYU2rC57s9VSnhdGkHMv7d3FTlQnPhkP8Fe2WzOK5HS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752544472; c=relaxed/simple;
	bh=CfdxPuaJdedPFMgoKUCNWuv06skj6ZxzQjnR5/nZFb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tsItsPsd1Ib3VUgtalvEVL53b8AYAzAhk3lEl2dcuneaoRPoJvPXENoBOgD1Sq5WX0IpkIb9qN++mHADQkR2HloPRiinMqUkUHtdUBNHLnZy8wQw8iEw6y3JDaprevQIpzl+MZ1gzi6FMxL6xOshSixFl5pF+tOAgQs73YXCSpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g4vwiEmo; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g4vwiEmo"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56F1YsQ2019620;
	Tue, 15 Jul 2025 01:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oGpyF5dLYHf7qyxaXF2jBuRt14tdLM4npCR0yXxSNZI=; b=
	g4vwiEmonR8MYIDUDwAkUTCSdnuyIrsPLQnmG+WLIeJUIx+qI/URi6E31yHZPvsa
	mzEjsNfOg8oQvHlB5edq4pFL6TZuhDEpdj+3RUiXlNRrpBTknUjArluMywJtXRLn
	0UjttbmwD7D7ydvXBL+lVIntqvC2xhKnoaPYr/KntPU2C/SqLjxPMzZsDNYlXHJW
	GVi1xc8sYHz4y0d7/Ji2QlUbkUP/PvZd8IEVUWB8NwOUXbwHMokDjDB/mmBtxCMA
	QmpVEapdzNUsvzPOl+BHsG5EgFCDyeTEEZ2x+4TX2UGqxzgz5coQTcVtGIudEwLM
	HJ6IJXVP0CZRjOi+KfHeFQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ujy4nhwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 01:54:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56F18OEF028990;
	Tue, 15 Jul 2025 01:54:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue592dyh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 01:54:26 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56F1sM6c002175;
	Tue, 15 Jul 2025 01:54:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ue592dxd-4;
	Tue, 15 Jul 2025 01:54:25 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Salomon Dushimirimana <salomondush@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: pm80xx: add controller scsi host fatal error uevents
Date: Mon, 14 Jul 2025 21:53:51 -0400
Message-ID: <175193808966.2586181.3862011561872712301.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250616190018.2136260-1-salomondush@google.com>
References: <20250612212504.512786-1-salomondush@google.com> <20250616190018.2136260-1-salomondush@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_03,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=987 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507150016
X-Proofpoint-ORIG-GUID: feh93WjaadBogxyN-oU3FXu4oItl4kMj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE1MDAxNiBTYWx0ZWRfXyS5gNi6qivEE V621ebckbRFLqomP2KHQq4wM/S1Dq3XUjaKtwoV6Qem5a8rKDjJsOiA//ViLkanbmVw1l4tGizG pUR/IFuxbQd8mEYYYMmIs8TJdAjGDsyIWZKN4yGTGejnzGp7VQDSi7HjuMUhUKJGXg06MuTKx6X
 xa10EPgo8ceDpIUCypj0tk29hhwRqUbijElh5AjAI5uGLIJJ8wmVH8j0q/36qydD0cEapI3AzoE Z6F4rm7Ov7YBf1izQi8KF4iuLOQbA62mZsY+DG5VgvIYaJW1M4yNZe3ZbCjfIBqVCakvCwHOdGB GnPwLu4yvdKD+ZC2Gy3eomQFv+UynVFJ5fDVdTXsj0NB6IcdwnrklFLXp7DiIUJoNuZArA48wAI
 m5Y+1eJgrJ1oS23tFnzk/TNyGQEMaqGDKF6c8NpMC4c2ljFiM0Iz1Z16A0npTUXEYZfh/xbR
X-Authority-Analysis: v=2.4 cv=Xtr6OUF9 c=1 sm=1 tr=0 ts=6875b4d3 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=ryvppczj7JKekirGujcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: feh93WjaadBogxyN-oU3FXu4oItl4kMj

On Mon, 16 Jun 2025 19:00:18 +0000, Salomon Dushimirimana wrote:

> Adds pm80xx_fatal_error_uevent_emit(), called when the pm80xx driver
> encouters a fatal error. The uevent has the following additional custom
> key/value pair sets:
> 
> - DRIVER: driver name, pm80xx in this case
> - HBA_NUM: the scsi host id of the device
> - EVENT_TYPE: to indicate a fatal error
> - REPORTED_BY: either driver or firmware
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: pm80xx: add controller scsi host fatal error uevents
      https://git.kernel.org/mkp/scsi/c/c7ee6c8f2f1e

-- 
Martin K. Petersen	Oracle Linux Engineering
