Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B4118EBF;
	Sat, 11 May 2024 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715454042; cv=none; b=Rxhm2FLZknILZlFtq+inuZPNl6fCYMSDJzJ1hjO6A/ezEtDTjFXzwkByqxAWSH9uE2Vhj/Fwu6lDTjbLrSjvumqxchSqWnSOZGJrF79P1oUmYql8HemJ6Sk+7yfq86XyyOaGQKHKrTVa8bq8c5TNRS4Cq4rXzZV8XktLwP1Kow0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715454042; c=relaxed/simple;
	bh=g1p0fcYuj6Vmv6EravnVzqiDOl2tHcv3wZAdG0Cs3TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K2BqSEHqQvAE3qliZCsQSeliVcSciw61kOMUwhbpPEdqB/oW8TJh+TJWzDhFyQjW3UZIXb5V9XEwshzCoLK0zqhm4oJY65Ac5s8i3jv5WECVltdDr+Y27IPS/n05FFZtjCKvaXYeddcKwZ+pqzYsGrCStH8wO2PaLyaJZO+2bUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L5kCz3c6; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L5kCz3c6"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44BIbdYX023817;
	Sat, 11 May 2024 18:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=V6g8oKn6rig+zs765hUUYo3FL3WRsS9mpUom0ai8PII=;
 b=L5kCz3c6MAFuvjwHXxSN80HLlCHhMi8kw2XYu3pCPFMu0dLU9umpVv5pz0ys/hwoKlgM
 ku074/oaX76Xw3MJCrvXzQsXHyZeX6pxAhFNtuajAwoFjs5FmZ+JM/T5J1ZCV4NcFdyQ
 qPF8uWPNgB1vSsOHt7/dJIJbOCe3g7xhyNrOpRWMTCRCQjgspt7cTQiaXgbGKpEpS3Ku
 h08iKB/n0S6pwiKQStV23Ss/bMJrLnJdQ/f4moTAgsAUd1Tb4Px/PocmW+hqZiqJL8xP
 GXG/rbzHgBPOFjz/ikxDR3Frn3h+XFTL0bm9HZQrThXfoKa3nrN57LSamjfpFzbVWrCQ gA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y2c2cg2w6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:55:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44BGN5Dn022420;
	Sat, 11 May 2024 18:39:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y44fn7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:39:58 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44BIZYPU028255;
	Sat, 11 May 2024 18:39:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y1y44fn5r-4;
	Sat, 11 May 2024 18:39:57 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Fabian Frederick <fabf@skynet.be>,
        Saurav Kashyap <skashyap@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <nilesh.javali@cavium.com>,
        Arun Easi <arun.easi@cavium.com>,
        Manish Rangankar <manish.rangankar@cavium.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>, Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Bui Quang Minh <minhquangbui99@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Saurav Kashyap <saurav.kashyap@cavium.com>, linux-s390@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: Re: [PATCH v2 0/6] Ensure the copied buf is NUL terminated
Date: Sat, 11 May 2024 14:39:10 -0400
Message-ID: <171545260076.2119337.3238318559945813238.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424-fix-oob-read-v2-0-f1f1b53a10f4@gmail.com>
References: <20240424-fix-oob-read-v2-0-f1f1b53a10f4@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-11_06,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=986 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405110139
X-Proofpoint-ORIG-GUID: JSR1LgQlB64XVUSSquWoWZNhZ3hLuE8Y
X-Proofpoint-GUID: JSR1LgQlB64XVUSSquWoWZNhZ3hLuE8Y

On Wed, 24 Apr 2024 21:44:17 +0700, Bui Quang Minh wrote:

> I found that some drivers contains an out-of-bound read pattern like this
> 
> 	kern_buf = memdup_user(user_buf, count);
> 	...
> 	sscanf(kern_buf, ...);
> 
> The sscanf can be replaced by some other string-related functions. This
> pattern can lead to out-of-bound read of kern_buf in string-related
> functions.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[3/6] bfa: ensure the copied buf is NUL terminated
      https://git.kernel.org/mkp/scsi/c/13d0cecb4626
[4/6] qedf: ensure the copied buf is NUL terminated
      https://git.kernel.org/mkp/scsi/c/d0184a375ee7

-- 
Martin K. Petersen	Oracle Linux Engineering
