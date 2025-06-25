Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A25190676;
	Wed, 25 Jun 2025 01:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750816085; cv=none; b=co1CQWCGZ8etDJABfnGBZiKzcOnP7LrmjeqXfvpsP4XybVSqNG+0PEatGC5KK7nInHXr648WtZGgRfsChn4V7oj099LQMes3ST2m5jG7sH+MG/tDAqB5syHjeGLtyxvjdYHIwYvlwPdeNa9M+BYsyBvQpgJKpAxZAL6l2n0zvUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750816085; c=relaxed/simple;
	bh=Vg36sgZJ4kJ11pIh27ZlLuzdaMw2+b7SC7tyRZM05YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MSVVoNs+VbzOwr+02TkqJB6H6nZfvIS7vg35JEfRsqlnDyEZdz7q8F1R0LjwTUtyen/eaP8/Mhfou3n+IorHwoeZhkESOy8t/1MMyepK2g4ad7mc+zRu3j5O/PVmxuQYZZUhtP0/CKeWFZAx79Wr7/rjlwLHxMLJVRXET6m7b4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=in71Yfra; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="in71Yfra"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OMifF4030643;
	Wed, 25 Jun 2025 01:47:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=maRjegkGj+p+8JT+GAlJuz2t4Q+LseHsMXpSQWxPUXA=; b=
	in71YfrapQJzQWVrx2HDWq/hgBFhZfv26H+oajqhCYyRiLnp9mxEeTwzQ1L5avkv
	vBzH3G/gR5qbwiGoyYSxokFAshN5rHr2JC06ZhnkcOnNaVdvwTxOgPopp+Cmf7Oh
	jLyxi3ySWlOngLtWqUMzLJ/6CcSTQFk3R3wZY3Cm7R7FuNKvLNZEDMJXXRPh+Y5S
	z0JYdnX5ybeqWhN2UDRhoVgJBEBIFfZtgTKsdHJgeiN7sxeoH12W9NSmUlcs7Sp/
	s6uRK/E9mwmpfWrr6lRG6UdwrMbOeVtNmrfsQeLQX435Yz8eB0cCFfdpB8V3KxU+
	PzWB11dHN87Vb6i/bRz3FQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8mxasd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:47:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55P10SYI024179;
	Wed, 25 Jun 2025 01:47:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehkre6kf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:47:54 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55P1lr8b038193;
	Wed, 25 Jun 2025 01:47:54 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 47ehkre6k4-2;
	Wed, 25 Jun 2025 01:47:53 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <JBottomley@Parallels.com>,
        Lalit Chandivade <lalit.chandivade@qlogic.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: Fix missing dma mapping error in qla4xxx_alloc_pdu()
Date: Tue, 24 Jun 2025 21:47:32 -0400
Message-ID: <175081602592.2445192.3786894872303360757.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250618071742.21822-2-fourier.thomas@gmail.com>
References: <20250618071742.21822-2-fourier.thomas@gmail.com>
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
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=915 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506250012
X-Authority-Analysis: v=2.4 cv=IcWHWXqa c=1 sm=1 tr=0 ts=685b554c b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=OdultG54DZAtBdqKAdIA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13207
X-Proofpoint-ORIG-GUID: HduPisBt3KTRAR0hpBPrCJ0YWvePgsWm
X-Proofpoint-GUID: HduPisBt3KTRAR0hpBPrCJ0YWvePgsWm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDAxMyBTYWx0ZWRfX5VHDV06WfZVD ZjQAXuwl5jKdLo8WxjJ6P/dNR9s76VAcbXogzqt7caS9tFgaRTf0rOyz+Vz3YxEb3JzMwCb/nJp exsWRGVzZRJosDF5QEfzdno/WBbrsjd0u/UZlZeKp0QktB4Ir1tphmFaIFM5tNofsPB0hJTXh/3
 8pmOiQ57n/m9N5QYrI+Wjpl3KuxvECiStwlJHk2eCYQQIIIU8JYdkeG5hJVbRVCerI+uWcMw68m DVHQoVDzAAMtJ7s/hqH7wf1Aakj9QTRc0AA74EkxhixTYDpTrsDvACk/MYIKU4j4IVrBxUGK6ad sbArXx4hAn06rMZrm+l485pE4GPUaa7qRQKMdfNfeJOo2ol8nufkmcHtgrV0U3Yk4dEYAq7oc01
 ZU+yCYtLkvGY7qqVXMSl+igDs8UIT1xATc3+sddUX4g1HgaujixXmLrYAP87OTRd37ydokMo

On Wed, 18 Jun 2025 09:17:37 +0200, Thomas Fourier wrote:

> dma_map_XXX() can fail and should be tested for errors with
> dma_mapping_error().
> 
> 

Applied to 6.16/scsi-fixes, thanks!

[1/1] scsi: qla4xxx: Fix missing dma mapping error in qla4xxx_alloc_pdu()
      https://git.kernel.org/mkp/scsi/c/00f452a1b084

-- 
Martin K. Petersen	Oracle Linux Engineering
