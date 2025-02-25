Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49B3CA6B;
	Tue, 25 Feb 2025 00:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740443625; cv=none; b=Bw9bk2T5dJ9C3/EFQcrASuEUE5jff02GQUXP/8kW/AsJEChsAWF5pB7sYwHIcARLlr9kDNyO0hAoYNSlEf09yF0SxPpWAjUAjTM9irgDxQKyGQECHP+teMI/QwZJsGqcE5PRDei32XwXvS9uWdW7E5TYYDLNUJ62oR7HkoAANcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740443625; c=relaxed/simple;
	bh=VPjW16HL/MR0kbNuqCgGzR0y0tEBnAh/4k5KF+hpfl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ra4J9qkZ2V3c/BXRS4M7+gw7JWXWBx3WYi9ViwOwOfmdw7R4E0dPhlQeaLJvU3xB0+zA6qBOvGZJ15qG3hLZZabiCAw+i32QSuMW7FUR96dn9u8T+MgN5sH/4p77UjaAQsswExkVJVK+KC9NBwvoX1z0VDLvwzbCd5qum6OtWlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V7q4Myp/; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V7q4Myp/"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OMKN0t031493;
	Tue, 25 Feb 2025 00:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6F7GSf7y872wvokfJjv8eyOl3WB6d5p+t9ZkC3/DwSs=; b=
	V7q4Myp/e3iCAvgdB9nwWOCqZNm5RE+G6tDCBEK56t/WqnBg8ftlFnaZy9d79+lD
	nwsArIZS++1LHrJ/SY24fTCjd3EeFv0KqlwS5wCM+/lQapOsRd3XldV7YalH/jG3
	7FEnVyTgITkRzo/exslA1d5jAIksQCWaCUuKYZlXlKnG1QwWfXXq6yL8GoQUoGTt
	rhOVEWyLEI4LrrK3oSAeamdM9iUJQiI+ztAM0s5nBR2qYyvFN/p/lft4+X89GE9G
	7Jpa4WJyk7u28gx2kDWJjdEfie9Y26Kx7y9vGpWb2VPh/HiAcpuyl0q1u/KVBQ3Y
	SNwJnkAf0buouBYvquuJiQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y74t3vwa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 00:33:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51ON3jRi025221;
	Tue, 25 Feb 2025 00:33:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51f0q9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 00:33:21 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51P0XI23025171;
	Tue, 25 Feb 2025 00:33:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44y51f0q87-6;
	Tue, 25 Feb 2025 00:33:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>,
        David Laight <david.laight.linux@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: hpsa: Remove deprecated and unnecessary strncpy()
Date: Mon, 24 Feb 2025 19:32:51 -0500
Message-ID: <174044345120.2973737.13335141842683533992.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250214114302.86001-2-thorsten.blum@linux.dev>
References: <20250214114302.86001-2-thorsten.blum@linux.dev>
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
 definitions=2025-02-24_11,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502250001
X-Proofpoint-GUID: 2hUhov6sZMqw84mRY405nNKbs2O_PR_s
X-Proofpoint-ORIG-GUID: 2hUhov6sZMqw84mRY405nNKbs2O_PR_s

On Fri, 14 Feb 2025 12:43:02 +0100, Thorsten Blum wrote:

> While replacing strncpy() with strscpy(), Bart Van Assche pointed out
> that the code occurs inside sysfs write callbacks, which already uses
> NUL-terminated strings. This allows the string to be passed directly to
> sscanf() without requiring a temporary copy.
> 
> Remove the deprecated and unnecessary strncpy() and the corresponding
> local variables, and pass the buffer buf directly to sscanf().
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: hpsa: Remove deprecated and unnecessary strncpy()
      https://git.kernel.org/mkp/scsi/c/d69ddae194ca

-- 
Martin K. Petersen	Oracle Linux Engineering
