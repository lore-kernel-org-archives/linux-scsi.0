Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF41E34D4F9;
	Tue,  9 Jun 2026 01:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969170; cv=none; b=MApf9420DQ17FWEV+QLUj4p/loYWIrbSl50FWokgFB4gODfOXpgVCTWXcy9NEkuHBFUqe0TmQatS3mmAInfo2FtNmShy2onu7bX+WrOIeNCYb4lTkWWWDenIs5+ERI4B5CoL6qfLoSiX/pKjDNGKfJTxemX8Q7q/L7Nunj91LRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969170; c=relaxed/simple;
	bh=fgHf7j8KdXiF1L7NSqhrVDMtvEX80dIHVIYSvRddHnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d3Hxm2narie0Gze6Ht1U7Hn2qCkzC6KbATsvXUAG1lxyBaHfrAFt9TZl1tfCNMXyEA5RUc1GZj/uhC503Cdq+2lFEWjC0WOY6DRQGv9o7e7Ft44p1muEhrj752WF6NN8LEJzKz29RV2vA+VG/SQ/UPBeAutZI1o0snlMI0n81f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GGbwNv7e; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GGbwNv7e"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSdNV3977595;
	Tue, 9 Jun 2026 01:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Bd/b0O9GgSy42q7fCAREv5nl/xaqPmKYF+HuGzNhGT4=; b=
	GGbwNv7eV7nVif4fH6VIZRl0C7LB4MzxnOg0J/qjg2t2EuC+8rOdBM95QF0uHx03
	fT8STKeyGEkD7eL+uYYY9QOZt831i+BSOy2fZbN6qF+lNKfeO0oxvYDRAINKDswR
	7vSaFth5cpY3K6Sxpng+nnOO69ixW1ZdKW+2LZvIu8oqbOqsqozHLCQD/eNP4J+d
	8UUtSF7d4WT2u7UZ+HpT/uuVCHIKFdmjfhIJ+Qj/H1QYS3fnu7b5uh7xnVjBttOB
	61v+JyzozQyN7kWT2McW2E0OpXu+/gJIOli115BfQs9QqidD+Lg1OF6aL4O2OAEJ
	UM72mu1mwb4Zc8r/n1YXYw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4embkjbg65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591cbsq028166;
	Tue, 9 Jun 2026 01:39:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pger5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:08 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591d6Aj030153;
	Tue, 9 Jun 2026 01:39:08 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pgepy-4;
	Tue, 09 Jun 2026 01:39:07 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Can Guo <can.guo@oss.qualcomm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        vamshi gajjela <vamshigajjela@google.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Lee <cw9316.lee@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Remove unnecessary return in void vops wrappers
Date: Mon,  8 Jun 2026 21:38:57 -0400
Message-ID: <178094912095.1810714.9510209271661286788.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529061503.301182-1-cw9316.lee@samsung.com>
References: <CGME20260529061506epcas1p298f7ccf8e65e713c3cc2b8fc07549dbf@epcas1p2.samsung.com> <20260529061503.301182-1-cw9316.lee@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_06,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=924
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfX4U6awL9UUI31
 clZC/WniH1LqWeSOZctG+XdluOoiPYozpO2kF/qqciw6e/dCX9M9cC2xlPANMiW+LTlazwkBElV
 Hr3nAyWN9/0Yt5l6tp55GUx/QyxUHU1xsInZBD6+hmk1OeBuAqu9Q5YYTN6W5jWjXmBDpIdPiMC
 NW4fimDVDaFNQBKqvqcy3yTE1gBZKheZg9UqqgWRmQ1s3BscDWdmLtQNoaKx8m+Q6nQFlltiS/y
 Rgfhxf2++o8LkwNnVPXU+iAZpk9qVNFSQ/olekYsiKQ/qQ/B5b9bBS3rQYDAA11R/lhw2ljCYAz
 Gn0OQ8NFUQLDSNfVUbb6lK9lx0zf/jFN97hZlXcTkl2DMhbPxhuBNOsBLEyf26IpPIxPKH8Kb1k
 o/vVi0aFt7Uj9J2YVjlW0MCCKmXtcSAqF0HVd1nod9hWRPflepcQ3yhQTYBRzOwAd7/iB8IaO/C
 0wXbubw75vLkJcRyZQ0jDN2uSPcXC+c2n1pXd0kk=
X-Authority-Analysis: v=2.4 cv=ROSD2Yi+ c=1 sm=1 tr=0 ts=6a276ebd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=f2h2jpDOjGIjgqReiPwA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: 9f8BCOvfnpTjF3HjqxrGuB1jJdw-APH7
X-Proofpoint-ORIG-GUID: 9f8BCOvfnpTjF3HjqxrGuB1jJdw-APH7

On Fri, 29 May 2026 15:15:00 +0900, Chanwoo Lee wrote:

> ufshcd_vops_exit(), ufshcd_vops_setup_task_mgmt(), and
> ufshcd_vops_hibern8_notify() use 'return hba->vops->xxx()'
> while other void vops wrappers call without return.
> Remove the unnecessary return keywords for consistency.
> 
> 

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: ufs: Remove unnecessary return in void vops wrappers
      https://git.kernel.org/mkp/scsi/c/6bfc4bfd041d

-- 
Martin K. Petersen
