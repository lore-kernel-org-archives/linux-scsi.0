Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF825386
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 02:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UvSL2fyQ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ0J0CB031069;
	Tue, 19 Dec 2023 02:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=4UbwudAxtpB/uhm1MZYMw+AYuZ7NkIWzV0oItNp1sZc=;
 b=UvSL2fyQcyXqsNMjHVXznFicPhOiP0JstRev7AnpTaHSj0fMoLUoWYE56TkccIu9ZYQN
 xzkVyMAAhrMNgvokSlb81Z+mbDfzOxIoQGeJb8cba5unhe3NmhXzsjs4iBIJNKKs3MRI
 3XlMxtQxiscu/DegJjQKZ7wWMGWoGGXV6ySS23bcnjFuK14fYB3GW+1SeGx1ApEotkQh
 cr/ulSrXacbDqpsTeKLZHrxo2w8TJXwR7CZvb/z7TjlSBffBBwAcLp8MGo76L6kE/9d7
 yRwLeJ3BndTiw976l2T6OPLZlWwFGH6ytADYKDbDrXvw4ArhzqbL8Q2LS04IlBnbLHty aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3v12aecs6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 02:19:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ1UfLx027635;
	Tue, 19 Dec 2023 02:19:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3v12bc5j46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 02:19:45 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BJ2EbhT009328;
	Tue, 19 Dec 2023 02:19:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3v12bc5j3x-1;
	Tue, 19 Dec 2023 02:19:45 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>,
        Alexander Atanasov <alexander.atanasov@virtuozzo.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, kernel@openvz.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] scsi: code: always send batch on reset or error handling command
Date: Mon, 18 Dec 2023 21:19:35 -0500
Message-ID: <170295223225.2870516.464535112683552096.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231215121008.2881653-1-alexander.atanasov@virtuozzo.com>
References: <20231215121008.2881653-1-alexander.atanasov@virtuozzo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-18_15,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312190017
X-Proofpoint-ORIG-GUID: vWtWlZflJysZtcYhmStqNRpQk581y0rD
X-Proofpoint-GUID: vWtWlZflJysZtcYhmStqNRpQk581y0rD

On Fri, 15 Dec 2023 14:10:08 +0200, Alexander Atanasov wrote:

> In commit 8930a6c20791 ("scsi: core: add support for request batching")
> blk-mq last flags was mapped to SCMD_LAST and used as an indicator to
> send the batch for the drivers that implement it but the error handling
> code was not updated.
> 
> scsi_send_eh_cmnd(...) is used to send error handling commands and
> request sense. The problem is that request sense comes as a single
> command that gets into the batch queue and times out.  As result
> device goes offline after several failed resets. This was observed
> on virtio_scsi device resize operation.
> 
> [...]

Applied to 6.7/scsi-fixes, thanks!

[1/1] scsi: code: always send batch on reset or error handling command
      https://git.kernel.org/mkp/scsi/c/066c5b46b6ea

-- 
Martin K. Petersen	Oracle Linux Engineering
