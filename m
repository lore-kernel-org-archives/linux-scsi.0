Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A8C3A7F7E;
	Tue, 24 Feb 2026 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951720; cv=none; b=cMhrM5lxG27n15Zv1IkSjWJPpYfQxYBmwXu5bNDdaOwu5LxeYZ6m4bPimkROVncB9Z2vER819n32UhR72mSoHzqW/Tu0q26dE6SGYKP+aGyuFQjXG0P8/0JUhJA0cPwacmThs0L1l2v6wih1uKZD4cz2tbINwgdZC8KowYcqPqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951720; c=relaxed/simple;
	bh=/Bbx92x0K7HFpSr8o+2CeRbn9rgpHzeWwp/fozgf7R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVej0FZOL2TM3f+IrvBo1QdkMwbo4RmRp1UwkC6N/nNMfqdk7RxpFtdro8FyzyRffJXKDXi4+UXeqkOa2H9lhMxQABReEfnL+SnoAzcybsX1Mqo+fsEw0Zf8jwA/BFIrjbYCPsKijRszNJznV2hCLQ+jsPSYZRmGsBkG1HHXXiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RsR6pJpx; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RsR6pJpx"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMso11492618;
	Tue, 24 Feb 2026 16:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WjxCu6j7YMYBEqOgWhRLbIVX5nunm7djuub2DqHyEAY=; b=
	RsR6pJpxbDcHFPj3ndcvttROgP5viR4TT4SZYeVmGUVnlscMnvg6aKv3BE6umgTC
	1WA2fnXo87i5TcjPmmR+CBMsLkOUdtf9unRYT81ETTBW0hkTgR85SGXbb2EuBDGi
	Can0kFIksle+L8kN1C3FkSkvSnrMPQ/oJrs1ysNu2x51W6G6f9tXbc0OkflvxNyy
	sQt/R77S/PbpJa8RfcAwbmCwUwG/YW9F+9wk2MO/slNK7v7L6RKMH9G6U96RGqHI
	31TM6KDdz9/QMvOSOBxGdXWpx/gJrvIFSE0r0gPFZ/BW7v/WoCn+NYxEhTZ/FZxZ
	Mt6X97rmbVEMnimfs/asxg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbcmu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OG12BA015532;
	Tue, 24 Feb 2026 16:48:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35a6m4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 16:48:32 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61OGlt4p012936;
	Tue, 24 Feb 2026 16:48:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cf35a6kjb-7;
	Tue, 24 Feb 2026 16:48:28 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Salomon Dushimirimana <salomondush@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com,
        damien.lemoal@opensource.wdc.com, dlemoal@kernel.org,
        jinpu.wang@cloud.ionos.com, john.g.garry@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3] scsi: pm8001: Fix use-after-free in pm8001_queue_command()
Date: Tue, 24 Feb 2026 11:47:46 -0500
Message-ID: <177195161233.1154639.7951083083040173223.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213192806.439432-1-salomondush@google.com>
References: <20260213192806.439432-1-salomondush@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=800 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE0MCBTYWx0ZWRfX+iKD53hFLWsG
 6opSHdApE7U6+5guoRvMm7eSuCw6aRCPaDd1azAa/YKzW/mfzAcMifEhw1hiXiz0jMMvq1XXgAN
 kfanMAcYeSKw4EyXDsdxGkdt9xtWINFWzftI/OQamAxoHYyOZhiWVoeAmjXO4MYBtq0TqLaCnkU
 EAPOFMaEH4fdgrCkINsWyJRHfzwhAiapjqAWtVLrKy9XoW4MjUPhlGf9G7DoSd8VYjPf00mxHii
 U/W0leeNCAN6LFxTlYKARPO6k82EvsvlelgrZRvmNhE0a/QM0F8yZb2zsvGENWkrTvFd98mtgo1
 HAGv2jSW6Gex+77qabZ0m2rBciLK46Kg0oEoGwHK3ei6DnPz1tJmgD8uFKRAb1BMEdO/ZeZ9Rqa
 3u0eqTb4OMR6Jmbi6ctwb3xAJPOaBpyTxXXvqxzO6I9do/BQ+xQUoqHBPb6Gol3CV+GmmFkFcuk
 tV5yDkslVpakU+ISn3w==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699dd661 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=J9_3lIIJs0hlrCRY9FoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: QCT-ee7Dnzjq2nALou5iZ2LAG1Z7qmYd
X-Proofpoint-GUID: QCT-ee7Dnzjq2nALou5iZ2LAG1Z7qmYd

On Fri, 13 Feb 2026 19:28:06 +0000, Salomon Dushimirimana wrote:

> Commit e29c47fe8946 ("scsi: pm8001: Simplify pm8001_task_exec()")
> refactors pm8001_queue_command(), however it introduces a potential
> cause of a double free scenario when it changes the function to return
> -ENODEV in case of phy down/device gone state.
> 
> In this path, pm8001_queue_command updates task status and calls
> task_done to indicate to upper layer that the task has been handled.
> However, this also frees the underlying sas task. A -ENODEV is then
> returned to the caller. When libsas sas_ata_qc_issue receives this error
> value, it assumes the task wasn't handled/queued by LLDD and proceeds to
> clean up and free the task again, resulting in a double free.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: pm8001: Fix use-after-free in pm8001_queue_command()
      https://git.kernel.org/mkp/scsi/c/38353c26db28

-- 
Martin K. Petersen
