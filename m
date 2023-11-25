Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X9s4NYDK"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003E4170B;
	Fri, 24 Nov 2023 18:53:58 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AP1Ywnt030989;
	Sat, 25 Nov 2023 02:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=kpDASwkgqRFYaSgUvJPeTXsHrkxsWXJjpt4UtH+0Ws0=;
 b=X9s4NYDKLWNCrXdmcZw+dvSYmKYBhPYyvEr9ZYL+zWx6MOenXLT1G5jYHsN3GTgeFhiS
 YRvH0ZYU6SYg2QGg8T/1qtBJCaHmcDUc/xjcoc8Q/HQiiFl2j5VHGQfUQg/QkGQ0BQOH
 5e90SzfQQloJ0aG7QyNSl2TQu6BMJudOYlpDTJsRlQ43b6Nsb561DVtKLKwj1cuTkJeK
 Z1FUFt2VIjcrUc4XYF/a6KdRPoMuSw0DnAriJ+mvSrg8dcCuCB5mTd8tu0SY0KtjQbaX
 F/KqBfgGt/UemzLM2vwHHZJRf8dDzrgCj1cwIv/lWoL+SE28+fzhpcV6B7xTfIEzuHp0 Lw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uenadv4uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 02:53:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AP1XkUv012634;
	Sat, 25 Nov 2023 02:53:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uk7c8sr3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 25 Nov 2023 02:53:46 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AP2rjMX036557;
	Sat, 25 Nov 2023 02:53:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uk7c8sr2v-2;
	Sat, 25 Nov 2023 02:53:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
        eddie.huang@mediatek.com, naomi.chu@mediatek.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] ufs: core: clear cmd if abort success in mcq mode
Date: Fri, 24 Nov 2023 21:53:35 -0500
Message-ID: <170088060606.1367702.18420626448439633309.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115131024.15829-1-peter.wang@mediatek.com>
References: <20231115131024.15829-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-25_01,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=752
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311250020
X-Proofpoint-GUID: -QfUzClTxcd8We44Mtqge1Pg6JSOpzBU
X-Proofpoint-ORIG-GUID: -QfUzClTxcd8We44Mtqge1Pg6JSOpzBU

On Wed, 15 Nov 2023 21:10:24 +0800, peter.wang@mediatek.com wrote:

> In mcq mode, if cmd is pending in device and abort success, response
> will not return from device. So we need clear this cmd right now,
> else command timeout happen and next time use same tag will have
> warning. WARN_ON(lrbp->cmd).
> 
> Below is error log:
> <3>[ 2277.447611][T21376] ufshcd-mtk 112b0000.ufshci: ufshcd_try_to_abort_task: cmd pending in the device. tag = 7
> <3>[ 2277.476954][T21376] ufshcd-mtk 112b0000.ufshci: Aborting tag 7 / CDB 0x2a succeeded
> <6>[ 2307.551263][T30974] ufshcd-mtk 112b0000.ufshci: ufshcd_abort: Device abort task at tag 7
> <4>[ 2307.623264][  T327] WARNING: CPU: 5 PID: 327 at source/drivers/ufs/core/ufshcd.c:3021 ufshcd_queuecommand+0x66c/0xe34
> 
> [...]

Applied to 6.7/scsi-fixes, thanks!

[1/1] ufs: core: clear cmd if abort success in mcq mode
      https://git.kernel.org/mkp/scsi/c/93e6c0e19d5b

-- 
Martin K. Petersen	Oracle Linux Engineering
