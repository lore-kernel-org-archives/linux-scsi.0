Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCA138E121;
	Wed, 29 Jul 2026 02:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293725; cv=none; b=cRmd/LDexvIbBM5cEvBYGzQ3G4KfWzOD9n8FIA9/ZnLsKIWKtSG/OUm0xfbEL6jj4jYMBReD0lc2NWmlxH9Z8zlwPsh68WuaxGENq2RCFMaI1gFIFSZRUf3J8kaRXZCsGFefbiWN7rWdqBqN8OKw/Z8r7HOUteBEHr7J5PyT2Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293725; c=relaxed/simple;
	bh=UckLIlqhfKKaslobN3dZ4wlMj2Hoc5h514TBt3RewnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DZspwP11J5MmwhGBNDu/qq2DWw+xEwiA5l4v2DDrrRw7CfwKD3IyJOxGW2g0CmsXQMQUghl//m9Ay9c4qD0b8LXWrIT79b44a95EhBmGqbspfSdbf+4MVGUfCMQT9TLlAQE6/XlKsym1m/3x3jyQQb0I53XkPmKLBu3J3sTRsQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T8uukTBm; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T8uukTBm"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItXHT1401722;
	Wed, 29 Jul 2026 02:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OTlTjNNYHQrAskcL7R1fmG8X72mJnxZrNgUjH4lFJZY=; b=
	T8uukTBmfcHoMgTF7rkkOAJYfXfbMuE9OMICvtTTckF0qUQ+2yMMBVQ+5OIP1PNO
	0hKZq5Wh3LVoYmcKZlwVpvnuBrKFC1QE68s6Z8WFzqDkw+3W3ruKxoVVSRZxoM6O
	5OHu4XOZTFiYoauthgNq2Ni9tZaaEhImvLR7iGzOGyEiAk+KEbDSgN+6dUGJb5RA
	SccxozUO+gvPG3C4UE/yvl6/xYuiHHdXEx2ZS28JJpOFhmLwCV+ityHv70DPM0K6
	4ehKipR9QcE2EtN1c4khMcNPuA2njTYwvPFnpqyTInEVIZVbCCRtcS+tyoTJx8/+
	+jryCas4iSqIpI8xVkvFOw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr0158jw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2o5KU001381;
	Wed, 29 Jul 2026 02:55:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87p0jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:08 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2t8jL012133;
	Wed, 29 Jul 2026 02:55:08 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4fnh87p0jb-1;
	Wed, 29 Jul 2026 02:55:08 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Dooks <ben.dooks@codethink.co.uk>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: virtio_scsi: fixup endian conversions for warning messages
Date: Tue, 28 Jul 2026 22:54:55 -0400
Message-ID: <178508193489.4027291.18390105698883371484.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623132427.838900-1-ben.dooks@codethink.co.uk>
References: <20260623132427.838900-1-ben.dooks@codethink.co.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=849
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX20OmHy1TV5Kc
 UfdWfnFCorlDkxTO3zA/R3KKwk5fE4RezWw7+DzbSBUNOaqSgEZMZA7rzqQVo6VSJ44lnMCxjwY
 WqI82Llwhwf/13dVtWqKFqyakx5Mv/Nyiu4T6qZ/a4FyLar5VHKj
X-Proofpoint-GUID: lCTAr7mOFvFNIgn5EE3NKXKzij5lCEjE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX1D2yuNTKZ0gg
 hdxzU7hR/8cioMhbOvnwUGvB7bmnvo5AHRsuN+VCaJp0nZuUbwvHXyOThAES+RQ8CZrffwj365o
 dkR2iONssm4wgDT9XlrGJGYjO6b0yyd1rCqJY07it2gCKXIteQuuchLqGJ3JXtCutCqLr1fomVq
 QlvalAe7qUgkHsWOEnvXMAyyta/g00gEOfq0O4ckanuvXhCvr/V/GkNx/clnsdrTCozUWCVeydF
 uSC1lY5pqdhwP595ocJaP4xEkV471NoBlu2uJDpn7sF1tgKndTMHW/uRqFAHP2Gj58ksZjtBYNf
 SUsv95aLHWlErv/Y5X3t8/M3K1yrGQNI7CrdCISModUMsmZwIskn2/MhU4X5T06damUy1dOeT+a
 HMQuC2qnDJfR81WTl3P13p5wZlR7XJbAwX5MXO1C5Lw2rrks5qJjtt8fxIOgELr2LhLR2Yxz8CI
 Rz1+iqRLADL6JRdPJwQ==
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a696b8d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=2BmogTH5GeLrU7O6-44A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: lCTAr7mOFvFNIgn5EE3NKXKzij5lCEjE

On Tue, 23 Jun 2026 14:24:27 +0100, Ben Dooks wrote:

> There are several places where printing functions are being passed parameters
> that have not been through endian conversion functions. Use the virtio32_to_cpu
> to fix the warnings.
> 
> Fixes the following warnings from (prototype) sparse:
> drivers/scsi/virtio_scsi.c:126:9: warning: incorrect type in argument 7 (different base types)
> drivers/scsi/virtio_scsi.c:126:9:    expected unsigned int
> drivers/scsi/virtio_scsi.c:126:9:    got restricted __virtio32 [usertype] sense_len
> drivers/scsi/virtio_scsi.c:312:17: warning: incorrect type in argument 2 (different base types)
> drivers/scsi/virtio_scsi.c:312:17:    expected unsigned int
> drivers/scsi/virtio_scsi.c:312:17:    got restricted __virtio32 [usertype] reason
> drivers/scsi/virtio_scsi.c:412:17: warning: incorrect type in argument 2 (different base types)
> drivers/scsi/virtio_scsi.c:412:17:    expected unsigned int
> drivers/scsi/virtio_scsi.c:412:17:    got restricted __virtio32 [usertype] event
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: virtio_scsi: fixup endian conversions for warning messages
      https://git.kernel.org/mkp/scsi/c/1e9036e7580b

-- 
Martin K. Petersen
