Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEA932B107;
	Sat, 23 May 2026 03:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506143; cv=none; b=AbkD1ajrSeuENZ3GoRpCTjVV6v37/Rc1MgsnLtslZvWjnS6K/CqOjL44uT4UrvrlCd3x89ld0xuEqmzKr+ykioS+97BrzxhYGFskyfjmf7opcA5K9tjO/Tg9FCmtX1s6AjEXP+kEnETMU7Iv6aOyS1SYveG4jr3C0MtgWEa6I7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506143; c=relaxed/simple;
	bh=xdmQDaZPGAjb+WmlUPN4urm3O40ToZSm/iJMOSCKLFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FqsRVcnzEYJNWZniG2sqdHdr+tiCBZORvPDTTHx2TPDfIi6v+2XdSVEY08xLJeDJpQ6fy4i0wkZYnRR10l1IE/tGdtRdaC7PzaQ2WeLxhkNXPYJQr6UwQ86Fx1iRtLKqGMJY7+g+Lwvxg96QbZpPvm3BdBcbXmpQvS0Vw+sk/dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UZfyu+WD; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UZfyu+WD"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N1hU1D771423;
	Sat, 23 May 2026 03:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vR/isyuyP4vIGDp7X6qgVUcwX9FEcW2li2TtHSMdSjs=; b=
	UZfyu+WDFaOOEvy3UiGnacnqAAutf5wBbQZaVR8fqNShStGENyCXP0HQPc/clnBL
	vLhmOyksmCISjkV0RAzchDNTLhDsgHwM722ZJkcE1Q93VfoTk2hs5VT57hIP6X23
	JUXabWqRYBGNe9OmrWbd9+WBy1z9G1QAJNKnR57UBL+uYB28dUYyqI0LkpUecC2P
	NDJH4oqcPm3TlHRi097tvWiA27frissYO+s3e1RvTv2JK7lZgLoed8UAKE7NSqJm
	B9w61/nwRA3kpobB5WduZpQo+XmZPn7L6XLY4npzIO1Ma2Pc3mz4wPeXkCtYwQ2O
	WiUiphWjFRWMNeasdECU+A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb2tyg72b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6O7032436;
	Sat, 23 May 2026 03:15:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:17 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9e8032824;
	Sat, 23 May 2026 03:15:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-8;
	Sat, 23 May 2026 03:15:17 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH] scsi: scsi_transport_srp: Move long delayed work on system_dfl_long_wq
Date: Fri, 22 May 2026 23:14:22 -0400
Message-ID: <177913641775.1181900.3921727355907955217.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260507143410.337267-1-marco.crivellari@suse.com>
References: <20260507143410.337267-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=SoCgLvO0 c=1 sm=1 tr=0 ts=6a111bc6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=aYGLzZUFCA-z_BF5oZ8A:9 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
X-Proofpoint-ORIG-GUID: arYjaVoizl5udncvjvVwYSaq9sh9AZso
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX1bpF6pWfW3si
 cK+cpE2qsRNsYl9qOWwSOaEhdNcFU1GC1rn2YVJ3D10gy4pZr34+L/Kd2Y/9DTFaPqkhfdy/bFZ
 CYU/WfsBEk17Lo84b7XZlUS11QIijjWwdmtaDkLjmZY93imrzzwmFyZ0yWznimh+kBywB4kPLcD
 VB1yWjsmHz8hRjDvkYTZYBeHj9KTjTrU1336o0nTQJ8J0PzB//ApNaiyLlrlIA7kn92GjjPYeJE
 JYNUpg7vJlVGAFFey23WiQFqKBB7esUgqwNJ4lIWgGuA6fcPN4vsl/1QE190USXF8JVrZhjVgIj
 3rrXYli3bvfwirM3FramqvxLOd9KoL43eMeGsJcQo7cOc+FS5XdMFLi3BDe8rTQhy8cyvZwZDCL
 cbVYJGSkK8vjb1DcagQg/wTbcbATNozqo06EiLBnt71JPUx0Ddfw9+ZOhHR/UQWDwTvkLhGS9XJ
 4qbWSMggxuRGGJQzJXA==
X-Proofpoint-GUID: arYjaVoizl5udncvjvVwYSaq9sh9AZso

On Thu, 07 May 2026 16:34:10 +0200, Marco Crivellari wrote:

> Currently the code enqueue work items using {queue|mod}_delayed_work(),
> using system_long_wq. This workqueue should be used when long works are
> expected and it is a per-cpu workqueue.
> 
> The function(s) end up calling __queue_delayed_work(), which set a global
> timer that could fire anywhere, enqueuing the work where the timer fired.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: scsi_transport_srp: Move long delayed work on system_dfl_long_wq
      https://git.kernel.org/mkp/scsi/c/1039939c52f2

-- 
Martin K. Petersen
