Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16224224220;
	Mon, 16 Jun 2025 21:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750111044; cv=none; b=UtbYF79vdEdbi1i19XOyzTo8MxbaLRAMtLvXopPTAgAALIkLOu68MW0FDT5307jDVU1+UqWovNRGNA8E1yDuhWZfaiXl7NVe3iJozghxWcYSLPj9Kuv3PXbVLRn/a/o/5bqniUBmnApZBpaT6eIYJoj9sL3Dtry6pab+p3Vk/wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750111044; c=relaxed/simple;
	bh=7TS0p/f28sMonjppjl+6BPGvktYp6GRFlrw1Bzd3f9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rzFbVr+FCCHeovqvb1suxvRO7f0pEIFOnuUeigdleqsbUhefIxhqvf6wLhKfKsx2c4kehtONbZWn5Rf831eC6X9yFI9j6ioaDxu0otmFz19ioMYuCrVUMaMtepLV1Dbeb94S05VyP/iyuME8uGFh2Glz3t8BTO85Or4ZrAmhFKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MKkLOTYa; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MKkLOTYa"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuT9f017622;
	Mon, 16 Jun 2025 21:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PMwWIrUc11oXLzPObJviTyltemz+aZsHb+HxI5P/va4=; b=
	MKkLOTYap6NU9xGhvm+SyNqaJqh7rekj/2/ASQTEdXpCp+u0v2Lm1WXOCGTyPoMA
	drykKaMGChGg7NEHtmAKCizkx08BssWwyUoCCc1zFGstf5ZEmEJR0a4oQyZFI7jP
	ZV5FV7UDZmuRZDuf/ndcJVFpZeaIKEH3GkVWst/biJQpNM0s452hv0DB0weab1mr
	2Uy9ucSE/rKAqgUgo19N06hamUEgqUxChVvhgKuJ6OJ52tlVNXNDqScwAXdLmsk8
	Y8+5BQlddVyTlk0bK86uz+fuMzNCaPZNZwoqImFSecN3CCUAz3lAv1F0AY2iJmMf
	xvNEH3CfSeT0HkzsXmp+qw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yp4m4vv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:57:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GLIn3K036256;
	Mon, 16 Jun 2025 21:57:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yheynyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:57:12 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55GLvC9b007737;
	Mon, 16 Jun 2025 21:57:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 478yheyny6-1;
	Mon, 16 Jun 2025 21:57:11 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Christoph Hellwig <hch@lst.de>, "Ewan D. Milne" <emilne@redhat.com>,
        Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: set max_segment_size as UINT_MAX explicitly
Date: Mon, 16 Jun 2025 17:56:39 -0400
Message-ID: <175011089419.1498478.5922832708527181729.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250616160509.52491-1-ming.lei@redhat.com>
References: <20250616160509.52491-1-ming.lei@redhat.com>
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
 definitions=2025-06-16_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=840 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506160155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDE1NSBTYWx0ZWRfX3aEtXaPw+q4N PfvHeOSp2YNbpvlVZ8XzCT+dJqXMhius1NUc6chnaxVWBtcOSpU95jjUCVXhH5/OYsvOQSGKKeT s9A4elpqTYRZWV6jSpXMgKYDc8asGD6GKTyvTNkdB7AJmXHbxG6jvFYJwt6HvyJYTWKvW6Y9hg2
 kMPxVNvI7UWmI6g5uA/vK+aY5M8WsyDCRt1fIb/7e+gUOHiwme2EBzi19KulwgjMOY4x1v1ybWk C8553sc8dGzWeBmn9vnwsi3qqT9a4hBK+kJy2cHESx9MLQW+0ZtvNReI6eXJBL9WUaZ+tMenvcb c4FpfX4l2IbZ/4iqaw1F755yEge64PSI7Qjn5rMMDlBwersyVALz0faCfA90ybvX5X4fHyTnrsl
 8ZpYA28ADK4EOLJG24mRGUZATxNP+t89odx1F/1odIjjbt6wHItbOh2Loeus1BJF7ba3oy69
X-Authority-Analysis: v=2.4 cv=K5EiHzWI c=1 sm=1 tr=0 ts=6850933a b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=j66YoJs0Zq6Owt4WPYUA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:14714
X-Proofpoint-GUID: 3DKOqNK4qXWK5iljsNO7iTxPWIr6jWcz
X-Proofpoint-ORIG-GUID: 3DKOqNK4qXWK5iljsNO7iTxPWIr6jWcz

On Tue, 17 Jun 2025 00:05:09 +0800, Ming Lei wrote:

> Set max_segment_size as UINT_MAX explicitly:
> 
> - storvrc uses virt_boundary to define `segment`
> 
> - strovrc does not define max_segment_size
> 
> So define max_segment_size as UINT_MAX, otherwise __blk_rq_map_sg() takes
> default 64K max segment size and splits one virtual segment into two parts,
> then breaks virt_boundary limit.
> 
> [...]

Applied to 6.16/scsi-fixes, thanks!

[1/1] scsi: storvsc: set max_segment_size as UINT_MAX explicitly
      https://git.kernel.org/mkp/scsi/c/19ec970841ca

-- 
Martin K. Petersen	Oracle Linux Engineering
