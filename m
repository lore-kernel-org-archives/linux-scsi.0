Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918CF2D47A2;
	Tue,  6 May 2025 04:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746505562; cv=none; b=guNRkTV6jokV7NvGthUq8m4Hz6mSqjZWr/A0czPa1uZSEnLSS8VfRLTJEcoSRlDupXsXhFj4bwnMr1IQXphOsWjE0zd7/8uQkXfhH/x0gpf9ELH+W95u6va6Ef1aL3H9VwbaMCbAFc/JL3d6oeYpKJI9lr4db+L38Edp51sjmKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746505562; c=relaxed/simple;
	bh=Shiy2lQKdOMsen2fuhK2vAJ6/T1Jm1YxdVvGrPZgYYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jQeW070nAnSBBLQBt3Ti8SklgPoR9w+zUUOAnuuTVnwmLO60Jx+qpWqHoIOnj+jCcV0PICKJ60V6XDwvU5+zlv3cYBxIX+bKF44FLjVINrWW8tRxd2pWHp+IA1ArGubHeHDldI4NYx74K1w0t0Ifsm+oTTG84T8JdhioAYzZumo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z9p82i6/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z9p82i6/"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5463bO8w030301;
	Tue, 6 May 2025 04:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CDDz4g7/rVndesm02zIObMA+GiB2YSh08dBfpENwTIo=; b=
	Z9p82i6/JXd5t9o+MthD7jl6hXpjUHCx811ff2ZVWLlpEakRGVuB88wORWWtibqi
	4JH755VGwmYrxheYlnvO1B2f2TUk4xs5fuFfAwmR58pIhd8zsWaEo6vj6cOtb4AR
	GNaFfUFWvQ2HIP9L9ZdUAgrzdzOpZTiIbBgUQNiQLQAaS9I8Ui/EJunxo3XvD1YZ
	ITVmWx0HchPYVb6SkCNYHkvR/UvpgeViNOSeDQQaqKO2F00/rwik2K/57u77I1OH
	8gGwPtsNHyJPK/dmXzLNPEqq0EYGk7rqZx4IjubZ7cg+dPFWNXZUo8Kj9y7UvG4T
	8GYkb9wdxLUdfOc84tICAA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46fap1g1an-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5461hr3k035320;
	Tue, 6 May 2025 04:25:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k8gppq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:58 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5464Pr4E012838;
	Tue, 6 May 2025 04:25:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46d9k8gpmt-5;
	Tue, 06 May 2025 04:25:57 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/2] target: Remove atomics from main IO path
Date: Tue,  6 May 2025 00:25:23 -0400
Message-ID: <174649624852.3806817.14248579008511251110.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250424032741.16216-1-michael.christie@oracle.com>
References: <20250424032741.16216-1-michael.christie@oracle.com>
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
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505060039
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAzOSBTYWx0ZWRfX+ivqmrrs+N0N T408rZ9+2W8GBGkYXAxaKAgJTGnUXzV/0XKALPUY3RPpVh1ETApSMwkODpOPRN91E4Adgxx/oXS NSER1xGSWpMx6G9sPyYWip9rmGW1kfE7ec7J15nYoQCz0KCHi+k+d/ZwNkCClrCHETb4nznfobm
 LSC/2boxZ+yUCm+mRurrT37uycJe4K2fuzRbK8OWpDyY2oPrCCS/mPU9FfmTUZOpEZG4AcJMm22 1PSgibvJMeRZ1yKazhBm4ZGCPQQLZuoYS1j0ucDaRCZwJI86c+bHB3lOAvoYcyC8gUwujFsmk01 DOQIgOly2ALRZljD3Jbv7C/t1Wjz/KuJDWNeUEQicl4vIT+3g5RoRzW9wmQRqxgorfbbYyoE8+3
 WzkzyM0L5QoeZeZyDV4FeBwBnftsO4pzKOcLZ9mwc25ilXBSRO6CtC2ZuXG4g3pJtC9yqADX
X-Proofpoint-ORIG-GUID: 8CdGMytQ1k9RFfTTuyfEpVFwn65FoflD
X-Proofpoint-GUID: 8CdGMytQ1k9RFfTTuyfEpVFwn65FoflD
X-Authority-Analysis: v=2.4 cv=ZYgdNtVA c=1 sm=1 tr=0 ts=68198f57 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=XpW3ApKRIVQcKetVdykA:9 a=QEXdDO2ut3YA:10

On Wed, 23 Apr 2025 22:26:31 -0500, Mike Christie wrote:

> The following patches made over Linus's tree remove the atomic use from
> the main IO path. There was a handful of atomic_longs used just used
> for stats and a couple atomics used for handling ordered commands. These
> patches move the stats to per cpu, and moves the ordered tracking to a
> per cpu counter.
> 
> With the patches 8K IOPS increases by up to 33% when running fio
> with numjobs >= 4 and using the vhost-scsi target with virtio-scsi
> and virtio num_queues >= 4 (jobs and queues match, and virtqueue_size
> and cmd_per_lun are increased to match the total iodepth of all
> jobs).
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/2] target: Move IO path stats to per cpu
      https://git.kernel.org/mkp/scsi/c/9cf2317b795d
[2/2] target: Move delayed/ordered tracking to per cpu
      https://git.kernel.org/mkp/scsi/c/268975a87c7b

-- 
Martin K. Petersen	Oracle Linux Engineering
