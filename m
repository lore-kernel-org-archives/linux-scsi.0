Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBEB3BFE44;
	Tue, 16 Jun 2026 02:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781576795; cv=none; b=Ko/NGm1o83BpDFZOc8Nu7Ysnlf2KhrjuOreLL/KfaW77aCCC2KLd8/RSOe6c1ylgPJ1qqXKh43Zxp62moqsKd+KEMnU5c5auMyPRVFE0C2u0zsNvJTo9SQri5m5EB/xq3svrhN2g4q3PqilFMwkHtiUiCSukVCshSxxQlXTnMbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781576795; c=relaxed/simple;
	bh=cG0EuXVGXSxLkPuozcdJn2kxEg5RMoBX6A36A4DqoG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPwTMezgZBz3sjhYSpwuKxCHqM2tB33Thzm7+h4hpudy9M8Px+6ys0RzTFbBbOpg6ldGoG396F/oN5mXSIxq07HDrOr26zsyJexieAlXD2vvi0iENP2vxjiOD3ngNkISpOlfheWf7Kr5qzmrN3vhL5B9hOXV6WvJOvkYPAn4YQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RyEctOr4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RyEctOr4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FKD8Vo1383089;
	Tue, 16 Jun 2026 02:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mST5KgBWb0I6s/YYwg+sRU+nRKqj7zvWFt9dMBpRqbg=; b=
	RyEctOr4AKutQOc/kfLRLSPEXXyfWSNUg2yjDOq8hw1C9o6L1IKv3oS5lD0FcWWj
	TxNWBkoKr1GV9VUdQhS9JL9rHR5racvtUACRiXGSKWKi1J5z7hDjvA99Viibvl07
	sY+8ihZ3MYz5aY5UrHdLciqtky048/305X1Ztienyi+mzxEImVhToeGJeE79hjTA
	cFGY+lt6262pVj2aH9NRR/9QWgRZM+ZAGh6uS0qTZbviBPuNDYh/BI5yll1Q3MzL
	+t7KYIpQbOliID3QQ7ug3V8tqNtvg1jlV8DG9R35km27h5L34Bvsbu01k8JnM76d
	NM/QKQ3oZ6/piw3w2wshqw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4es1ay3nyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65G2NYiM016455;
	Tue, 16 Jun 2026 02:26:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4erwnpnykk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:15 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65G2QE2D023822;
	Tue, 16 Jun 2026 02:26:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4erwnpnyjt-2;
	Tue, 16 Jun 2026 02:26:15 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, peter.wang@mediatek.com,
        beanhuo@micron.com, Avri Altman <avri.altman@sandisk.com>,
        Hongjie Fang <hongjiefang@asrmicro.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] scsi: ufs: core: handle PM commands timeout before SCSI EH
Date: Mon, 15 Jun 2026 22:26:06 -0400
Message-ID: <178157184619.1899010.3843917113263921662.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605112034.3802540-1-hongjiefang@asrmicro.com>
References: <20260605112034.3802540-1-hongjiefang@asrmicro.com>
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
 definitions=2026-06-16_01,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=893 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606040000 definitions=main-2606160021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfXwoh7Qg/buZAE
 6C2VShRUZwa+nhUDLGxiOhF8vQBIfTUMxcJiPc6XO0Z7ibEvWPdiUCPMIhM4JJV8qE79SgRBQT4
 ALfRUz5Ul67uUchIZpJ3xuM0qGaHAw+W/6RR/a8rVkCDMfC2fmDj
X-Proofpoint-GUID: rVDGbcokiqkKP6zSXVU-x6rHuLmbDUfl
X-Proofpoint-ORIG-GUID: rVDGbcokiqkKP6zSXVU-x6rHuLmbDUfl
X-Authority-Analysis: v=2.4 cv=PazPQChd c=1 sm=1 tr=0 ts=6a30b449 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=vPCGqMi4joEAeBXqsVMA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfX/HS20TCs20ab
 GfgOowke/p964oM3BHYFnPSntOshU6douAOaSmL9MT9m4RvcQ3QYAg7Z8NRcqMyefqd5hc2fR+N
 MI9atEBFo8js21LTuXLK/yWlQhQ9/meRFKUhcEUqH+63Ndx+QIO3YGjqpii1yezVmqSvsgDDQr6
 9pa5ciQbm42sTfCi6s0FankdwSE6EmEIP5odDLVF+PWRnvlKpk3+tw8IxJR20bSfdou99ctoZHA
 /XxyVMAVomkKnI38hy8uiLSg5ggWnFb9ctZpfZrZrhLW7rgrlz2nM1kkZZNXMmO/oA7BDYVxTEX
 IBAbryFwz48FMSgxNiz7gBRKrOJi0TtJhyMi68X4z3pL9ctJY/aKZ7Pa4TbE1TmVH/pfS99RrZt
 IfnoQWUhP0AEkXo0Kwyan6PKCIPqIRPSuMrAWeUxwit8r6wWFM6t7wzqevVDX59vGPrvC4T9mD4
 AC96RyZtH7irQi7kgKlqoLRiAtG6nDUYQMM0QT4A=

On Fri, 05 Jun 2026 19:20:34 +0800, Hongjie Fang wrote:

> A PM START STOP sent from the UFS well-known LU resume path can race with
> SCSI EH.
> 
> The "wl resume" task flow is:
>   __ufshcd_wl_resume()
>     ufshcd_set_dev_pwr_mode(UFS_ACTIVE_PWR_MODE)
>       ufshcd_execute_start_stop()
>         scsi_execute_cmd()
>           blk_execute_rq           <-- wait
>           scsi_check_passthrough() <-- may retry START STOP
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: ufs: core: handle PM commands timeout before SCSI EH
      https://git.kernel.org/mkp/scsi/c/01d5e237b339

-- 
Martin K. Petersen
