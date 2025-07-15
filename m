Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32112C1591
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 01:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752544475; cv=none; b=ZEnkrk2F2QvCE6YK+/uzYfILAFC7m/jSZ7Ab+49X90pHLPycZ2jyhvwtqF+wDf9Uzhhs3gvme1yymlUUSVMQROpGuvJsbCRtnFLPDNQbNwlDXU9IttfHVI0Hj32NoG6fBqrV/pC3ZUNoIA6dT7Bl9pLFAjB0qwdy+C3O66viR2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752544475; c=relaxed/simple;
	bh=Rcupoe7fYQZuYpv6ugVEY3+hCY0QxClps72GCz6W65c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RxHTeklwS9iyDo8smGa5buMInV2Epdoq9OnlSQSS1RrX8UaLLbgt9eR7k9QvF4lyAaeaT08C8buyV/RQx9V1KCJnv/yASb+uigiaT6RqxLyjtjOtnQjhWxkl6jONuJX6Q+Xx7jtyUDpDN0VSqTuEWMi6i7FMIzHnJLgrreyzSGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d5XAQFUc; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d5XAQFUc"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56F1ZRDQ002261;
	Tue, 15 Jul 2025 01:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=R42qorC5dJDvay9kd7khbzohDRuGf3EdxjxcOaNadZ4=; b=
	d5XAQFUcaubzsy0RxvRiEMsMQiTdnGR/Q2PRVlPMylTWduOAQv50WBhGVfQyv4Ny
	QJA0ALzF4w5WVmRMfk9sumJT4PS5bTE17DMa9pLylztduReDNzPZIchyAepJ6GgI
	7jA+wrlPc9Xu4wbwwUS6QpBZ0qzxJCsb82zjFiXvkM1Q0uk8Rv4YOs0gdUyHh36W
	DAF43jOfVMrz2Q/P+luJt7UNMv4RqZ42T0GftKwmwq91oeAaTKvcvg0hAlLc36KA
	4pQ3S3kW7MSWA6LqDr8QD5ySkLUmPT3/NWaegRp4PAVKNYossaRW3igmVOBIFUu1
	DNKpG8sJEBecTwv5MkVNJA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk1awkmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 01:54:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56F0aEru029758;
	Tue, 15 Jul 2025 01:54:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue592dyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 01:54:25 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56F1sM6a002175;
	Tue, 15 Jul 2025 01:54:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ue592dxd-3;
	Tue, 15 Jul 2025 01:54:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: mpi3mr: fix kernel-doc issues in mpi3mr_app.c
Date: Mon, 14 Jul 2025 21:53:50 -0400
Message-ID: <175193808971.2586181.14590641324165896704.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250620162158.776795-1-rdunlap@infradead.org>
References: <20250620162158.776795-1-rdunlap@infradead.org>
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
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507150016
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE1MDAxNiBTYWx0ZWRfX3WG7fjGLIZq2 yDjCOP+qcTiWqIqstfkp/RQFx1leMDV7Y2xtkZg8r4C+S5JTSKN3vnWvgpJ1gPds1XdcPjiz5Lo DuSYkcJy4sAaMkdmgxnfvpZyYkiy0wqJNeoNW98KqlXFaV7CE/HPvVMb8xDJoQ5CyR2ORhjW7hp
 g73gsBy+5MNxsguIRcv+VyY9AoBR2vLpesfWJPnJmeA237RJeUGHK9JdDMAOJIh1uFe720dMBkR iVT3WqvtdRHnCgDOVMwO2H/XR0k0v4FsTDyj+031+9dQOJgzDahpI2nvP7QeKvlAEvVzfbDFV8c 2MaiO1+3gWfAUVISKdUuGOB3k/ljCql1ryplvwRC27vfb+Sts4ASA2tysY5rL3rCjPzYY2WRYDw
 bHDzWlj2ZRbar1GQ8VNauhloJpDvHzDozhUt4fXZPqzfQ8yY9lhsP5fSjpjDE3wWOI1oamhE
X-Proofpoint-GUID: qts5cb4NnR66RE9H-htwTNL9kdsU5OZs
X-Proofpoint-ORIG-GUID: qts5cb4NnR66RE9H-htwTNL9kdsU5OZs
X-Authority-Analysis: v=2.4 cv=J8mq7BnS c=1 sm=1 tr=0 ts=6875b4d2 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=iO_dN5lyKOUnjLFX37MA:9 a=QEXdDO2ut3YA:10

On Fri, 20 Jun 2025 09:21:58 -0700, Randy Dunlap wrote:

> Fix all kernel-doc problems in mpi3mr_app.c:
> 
> mpi3mr_app.c:809: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_hdb'
> mpi3mr_app.c:836: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_all_hdb'
> mpi3mr_app.c:3395: warning: No description found for return value of 'sas_ncq_prio_supported_show'
> mpi3mr_app.c:3413: warning: No description found for return value of 'sas_ncq_prio_enable_show'
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: mpi3mr: fix kernel-doc issues in mpi3mr_app.c
      https://git.kernel.org/mkp/scsi/c/ed575d4bca6a

-- 
Martin K. Petersen	Oracle Linux Engineering
