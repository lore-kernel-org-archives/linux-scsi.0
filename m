Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870FF2D47A4
	for <linux-scsi@vger.kernel.org>; Tue,  6 May 2025 04:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746505567; cv=none; b=qt9zg1Teu08NqulNhrm8/0wBn4AwHRuEyuulnSC/KO0eZeS2J5mOtBSXixNU48qa+Pd0sHf9Twh06EChSmnq1rCKlSA4cc1BjONj/WucnTx55AwA5ZC74j4DjaiD7trKWEoX0ys+stBcgr6AxJaE9Hs/Hamk+DNgs8Ef2WyQhmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746505567; c=relaxed/simple;
	bh=AiGU0Om70yDOIcnIYVHKFVXsU9PA6x5H+yFEvogKCn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bx7BvIoQHpPvoVfYaOCj5XBIrfrd+UOw9LRe41Nq1fdInUOcX/ys/gZTtD+VOeTfDfBWDu5W/T+6HsAEKrnlyU8IllrwRSMDlBCYm12wXZOFwASC5lBQBC2XEbq9ALhuzCTBcDv6Bth5G5Zs/leGbPiIygqguhxYtIqBpkdzaFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PicFP+eQ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PicFP+eQ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5464Ecjm022991;
	Tue, 6 May 2025 04:26:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8aIT/eyZnIPL80lmiXBD1mONksEKFceulbvm4zAiujE=; b=
	PicFP+eQHKVU06nkh7A2nwkzp4gDO3PrEQRHpimWUUBAQ9Id0j8vf/skmmKw2pCb
	MJo8irIjHk64tg79Hyn4jsyYFMlQxpE0Q9lRqp83OjgOipvixQIPHlN6rFfIwfhz
	aI756mQZgqwns7WAGwf4nk9xly+XiX4Ux1aRRYpR9wwwPMhnLf+oDrDW3aiatvLE
	Kn/jVKaCk0Shv/K84nwdJpLs+aj5MsPt9JoQ9Wtesvgv9PjMGArLCTgQzhfXXoYc
	ChapQQok2gyp6AhwmI3FpE+bt4sBWjlIl+ew7PoEEEPbZ+72IVnFS/Np4VXI7+Bt
	+cAzwXL7RPWfjBzxhDEglQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46fb7h00bd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:26:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5461ajva035324;
	Tue, 6 May 2025 04:26:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k8gpr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:26:02 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5464Pr4K012838;
	Tue, 6 May 2025 04:26:01 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46d9k8gpmt-8;
	Tue, 06 May 2025 04:26:01 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1] mpi3mr: Event processing debug improvement
Date: Tue,  6 May 2025 00:25:26 -0400
Message-ID: <174649624855.3806817.11268426476410963260.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250423092139.110206-1-ranjan.kumar@broadcom.com>
References: <20250423092139.110206-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_02,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=877 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505060039
X-Proofpoint-GUID: 4gD2Fxv_D5JHcPkf606g6_zlfKIoO7sk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAzOSBTYWx0ZWRfXwmULN6rns7uk AOO5BPqOp6TOv7f+iA/UIS+w92wzFX73Z5yIi7/81M4xmKI19tD/xDy1QnMfVwD45uvzOp/Yrpj 25T4nTd7nlh7PxAVkrpILbOeAxRHy/fPBf6TJwgU/i9u90aNTogc+iYpL0U87fMBUEtHYyMWZTF
 GuNWLUaPO6fLK6iUzGFhPY9dTHqZ1+ercAtsBSXeEM7JRu5X/Vbe4d4bwHPQo9AB+4JcylNMCxP /Lb1NjPRUkQeke9C78lG8x3b3zTYH+0sGgGUZRVHiJ7meJamSh95grixNlzDxJN3Pmy60ktGdVT zUYuBLiiVtOUJmw/5bgVVXBI7o8h9mog3L7DcW29FAW0N/w3bQRB5UCLVwXUkgPq3WliQYVQgD+
 HX3rJtJ6ae4rc6HZ9TaxYkiZ1+JyP/3MMRCbPbb5uqJtX5T40G4BtaLcqhTb11XC4p12Wrq6
X-Authority-Analysis: v=2.4 cv=e6AGSbp/ c=1 sm=1 tr=0 ts=68198f5b b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=IIPFho-9OOEZcHFwwVcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 4gD2Fxv_D5JHcPkf606g6_zlfKIoO7sk

On Wed, 23 Apr 2025 14:51:39 +0530, Ranjan Kumar wrote:

> Improvising event process debugging.
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] mpi3mr: Event processing debug improvement
      https://git.kernel.org/mkp/scsi/c/04f79c113ae7

-- 
Martin K. Petersen	Oracle Linux Engineering
