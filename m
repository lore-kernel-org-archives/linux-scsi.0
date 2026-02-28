Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740142571D7;
	Sat, 28 Feb 2026 22:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772317346; cv=none; b=dwocXHw73jSw20S4XLdUQpgnaAXRK8nPeF1bXRA0x122T66RPCzApjYN62pwzR1CJ8mzfto0B8rE0zQ8HSudzvR4TgkzB7qpiorwOLsxMd+6Oh8/ti2w3g99GEQg+evNC8MgtKda1FjHMk3WIQJlNu+nHGuZGFTgql+P3CBvgJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772317346; c=relaxed/simple;
	bh=fJZTwkE3P3m2ok+sM+wYSuZiMIzmevdJuIvhbT5f9k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aXPxbnkvf9dxMVs3XUb4Cv/XG3/sPi50+K7PxX5PzDw25HYfDbX7orAExMrSK4ypoCoRVQjgJP9eqK/vvO8C7P/ur15BbTiDCAK5CA90SpKf0ky8QaxUjHQlQDBSrRYGP/vy2h01OkZaxheRVPnbO2GE86l14HlERMudLXN6tdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=STEEit80; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="STEEit80"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SJJ6E92145042;
	Sat, 28 Feb 2026 22:22:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3vuVSVh28n28th73eyGAjigTNMpQssx3NIOnyrKZKA8=; b=
	STEEit80jmO2b+oYtVifbXP/foEnA1OYnf2jgFDeMf7VfySLpnm8MP2BuWrNUk6F
	J5tXj4wCgSh6vDYrfzzIGzJmwmuN7HEZ13Cle+dwqv7MoS5uEBiMkzy8WUF7smnp
	PMv2jaXYudoauhjlJfw+djyJ1bxk/9dKngiBl+r4mwGFb4YhIBuATNJUX7HL0qNK
	iYG/gIbYJ755t6YcUsoACv2T5881ytPQbOJ8LB2m++3MMq9k2oiI6cJBc82hl5W4
	qK3qtzyHFQoG09ycmsIIZldpd9/VDMz9GjjttiSVCjMaGvhHipEVWDQE4KNCCTx9
	5RK4lq30ZsonEppFsEUxQw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ckshn0k6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:22:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SL0iv3037177;
	Sat, 28 Feb 2026 22:22:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7bhdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 22:22:14 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61SMHlvX018394;
	Sat, 28 Feb 2026 22:22:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4ckpt7bhc9-3;
	Sat, 28 Feb 2026 22:22:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sebaddel@cisco.com, Karan Tilak Kumar <kartilak@cisco.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, arulponn@cisco.com,
        djhawar@cisco.com, gcboffa@cisco.com, aeasi@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmeneghi@redhat.com, revers@redhat.com,
        dan.carpenter@linaro.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH 1/5] scsi: fnic: Use mempool for receive frames
Date: Sat, 28 Feb 2026 17:22:03 -0500
Message-ID: <177231727985.1778274.8891985262905640044.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217223943.7938-1-kartilak@cisco.com>
References: <20260217223943.7938-1-kartilak@cisco.com>
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
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=936 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602280208
X-Authority-Analysis: v=2.4 cv=RsPI7SmK c=1 sm=1 tr=0 ts=69a36a97 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=MKO0JlC4SyYoFBfRIWkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: vCAcJpouNKqrgLl1XBNEd9KpXObgxJvX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI4MDIwOSBTYWx0ZWRfX6zN1fghHSfqm
 QOyKJO1exQdxTnZ+N3vNl8lnXsCDWHQv1URIGlxqSvpjp2P52YskRpNJLWhSh6wRSxI37v3nykA
 Dm2VnxHnshp5iJpyF//kKFxlUsco9eKGm1bvkH3u3ksuDC0vhGTByLcrst4La1kgP4AykV0OTx3
 6oDHuUhw32NwN7nlN++oXenm2Pasy+fsNdQnoBSKfdE4QHVKVRXj5ZSfupVBaqDbehmSoU9SxMt
 fOfVZpwuz+Y9qLojuCp++D/XcYXOQdd1H68ZroYM5ZQQqmBXLvgrG2v/aaJAaQe4VP/rWa4fLeb
 aFvfNMOzE/JWQtOl/V8MVoAVgJy0nrV8K2IQidzdZMHpyIyG45WYkOLjTgtIvFQNYejAAehAtyH
 KpTg+WHwpjHdWU89FC/CvK0eg9U6gNKkWoWtB/Bvlpf39XEyVFeDCsEzSeDawX8e7iemOqXUcSX
 dE+RMLrxnDXuIETDpJQ==
X-Proofpoint-ORIG-GUID: vCAcJpouNKqrgLl1XBNEd9KpXObgxJvX

On Tue, 17 Feb 2026 14:39:39 -0800, Karan Tilak Kumar wrote:

> The receive frames are constantly replenished so we should rather
> use a mempool here.
> 
> fip_frame_queue is an rxq. De-alloc it in fnic_free_rxq.
> Incorporate review comments from Hannes:
>     Modify fnic_free_txq to have same arguments as fnic_free_rxq
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/5] scsi: fnic: Use mempool for receive frames
      https://git.kernel.org/mkp/scsi/c/0e07baae55bc
[2/5] scsi: fnic: Do not use GFP_ZERO for mempools
      https://git.kernel.org/mkp/scsi/c/a59d1caf1ded
[3/5] scsi: fnic: Rename fnic_scsi_fcpio_reset()
      https://git.kernel.org/mkp/scsi/c/31eda39bfd46
[4/5] scsi: fnic: Refactor in_remove flag and call to fnic_fcpio_reset()
      https://git.kernel.org/mkp/scsi/c/927b5282df64
[5/5] scsi: fnic: Bump up version number
      https://git.kernel.org/mkp/scsi/c/47e088c9d1a0

-- 
Martin K. Petersen
