Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fe8y5oOs"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C94131
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 20:29:42 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE0TXJ2005880;
	Thu, 14 Dec 2023 04:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=VOhCrRQI6v15uPT9tN8m8h8I4mP1moBbAIF9emlD9hQ=;
 b=fe8y5oOsQfRgEgKRd7hjVUyEeUbc5psX5ze920lpXVC9pJoJ4qQrd+JXnjvtDvMqEF++
 yzsT59DhD4M2n8GAUJ9I9HuBOmPyI8OUiRzsfLmOU1+Kq/UyxbjHowJowz9bd4F2M8l7
 vwWCUNnxchFIdkNHoejd9n9NiHybbUsPAa7vZZI4fu5MjCUyMpy2+E7ErbRcasaefpzH
 oseoJNztN79E/kSsrqyzdE7nx8PPQVC5Q1+I541qtOJm38r5qBRJ6iAG0qIsD896qSU5
 7/LeKH62rW9Z24fu9mMfx+woltOyrE+lF70LL2ws3//zzFiZY6cvp9pKNmqng4eiea/l uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uvg9d9x69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE3aPbW009868;
	Thu, 14 Dec 2023 04:29:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvep9ev2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 04:29:28 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BE4TQME035965;
	Thu, 14 Dec 2023 04:29:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3uvep9ev0g-6;
	Thu, 14 Dec 2023 04:29:28 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: hare@kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] libfc: fixup command abort handling
Date: Wed, 13 Dec 2023 23:29:11 -0500
Message-ID: <170205513106.1790765.4775577640203759673.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231129165832.224100-1-hare@kernel.org>
References: <20231129165832.224100-1-hare@kernel.org>
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
 definitions=2023-12-14_01,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=981 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140024
X-Proofpoint-GUID: pLG2Usg6GwO1shBx_fmsXAqj-NbEdGHn
X-Proofpoint-ORIG-GUID: pLG2Usg6GwO1shBx_fmsXAqj-NbEdGHn

On Wed, 29 Nov 2023 17:58:29 +0100, hare@kernel.org wrote:

> when testing command timeout with the help of XDP I found
> that scsi_try_to_abort_cmd() would always return 'SUCCESS'
> for FCoE, even if no commands could be sent over the wire.
> Which is not only surprising, but also can lead to data
> corruption as commands were never aborted.
> Root cause was that aborts had been sent twice, once
> from FC error recovery and once from SCSI EH, with the
> former inducing the latter to assume that the command
> was already aborted.
> 
> [...]

Applied to 6.8/scsi-queue, thanks!

[1/3] libfc: don't schedule abort twice
      https://git.kernel.org/mkp/scsi/c/b57c4db5d23b
[2/3] libfc: Fixup timeout error in fc_fcp_rec_error()
      https://git.kernel.org/mkp/scsi/c/53122a49f497
[3/3] libfc: map FC_TIMED_OUT to DID_TIME_OUT
      https://git.kernel.org/mkp/scsi/c/be40572c22cc

-- 
Martin K. Petersen	Oracle Linux Engineering
