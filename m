Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72CA1993B7;
	Tue,  4 Feb 2025 03:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738640137; cv=none; b=kHElXLCZwvcW7JJFtrhNmzD+RYwaXoZJQEtrcVZPd3cNay3cAQpps7Zv1orE1sDXu9Ts78JOMWdS2EF6FbYuacuWKLdP4DaYe4aL+qQakVLlgDjUUrqfnbHPFobalvFvjHH3wso2198poh1TUZoK0L8BHwWfDqR6v20D66Xy3ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738640137; c=relaxed/simple;
	bh=0Ll1F7RRD2z3GOXd3FGLN+yR/BQkW6wN/lVl936ZHk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G5J4xW9mwI3SLNEv2X9Er3jF+/M1NOoF6rIoA+5zJLkvRPDM+1EwzkQLnx54wZKk6xPrD7x4Bb7yYrL4f91Sx7zWUKrUIVerzYDSaWkQTTwF/hUvLOb846vpLCc1ujdzlbzeiNEtzRvUTMLIS9FHIJSMHJ6ruXhIyQfmTyhRd/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BU3b8Cal; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BU3b8Cal"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5141NXsd025678;
	Tue, 4 Feb 2025 03:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Ud0hku0VRdekV4/OMpTt4XYxIBr5hANcg7z9LHW2Lw0=; b=
	BU3b8CalpXZE2fwDYs7E+MyYQR8nixMMX9IF54Vjq2GFLnOiWfOn5lgXPfyxU65v
	vZtmpwHDYYaFvQ62bhKbe6JvZKKfswM/OLIKrGsg7aIEIt3UeyarQoMZo/EDQHwH
	bWbToXravgT3Fm3Ff4RssGpbS4EBFg0zBENmxBkUWI5gchzfQ2OxGzu5o7wglXSg
	aVhkD1gk/qgafNMDrqhCp4uzPRwE2rSaw78ZWkwMej3RSI/aTTG+ZVS+7UL/17Fv
	2oqeEjVo7qCHKE/ihDbSJnHETWzYNfRITVK0aco/KxU5VdgWyM8C87k80dLV2QjZ
	+5g0E3NhsDNoppFDbuUshQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hj7v3uup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:35:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5143FjhF039048;
	Tue, 4 Feb 2025 03:35:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e76fy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:35:31 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5143VlxI009625;
	Tue, 4 Feb 2025 03:35:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8e76fxf-2;
	Tue, 04 Feb 2025 03:35:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Guixin Liu <kanie@linux.alibaba.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: core: add line break to status show
Date: Mon,  3 Feb 2025 22:35:07 -0500
Message-ID: <173864009033.4118838.165767248699255600.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250114025041.97301-1-kanie@linux.alibaba.com>
References: <20250114025041.97301-1-kanie@linux.alibaba.com>
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
 definitions=2025-02-04_02,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=808
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502040026
X-Proofpoint-ORIG-GUID: pxd2bJ6fZIA96hBxLWiZa5Lh8bDJNNn-
X-Proofpoint-GUID: pxd2bJ6fZIA96hBxLWiZa5Lh8bDJNNn-

On Tue, 14 Jan 2025 10:50:41 +0800, Guixin Liu wrote:

> To ensure the output is not tangled with the shell prompt, add a
> line break to clearly display the status.
> 
> 

Applied to 6.14/scsi-fixes, thanks!

[1/1] scsi: target: core: add line break to status show
      https://git.kernel.org/mkp/scsi/c/c9d2782988df

-- 
Martin K. Petersen	Oracle Linux Engineering
