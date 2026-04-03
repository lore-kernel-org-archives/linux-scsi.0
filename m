Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F2C34EEED;
	Fri,  3 Apr 2026 02:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775181952; cv=none; b=tXy/BrG6hzpzJUVQMyKFbGdQ5VeJOTBJagtCXpqxmx6VlwYeTPWu0TZ63sonKt3/BH+r7mx9rPm+1x9I2BkCcFcAZdigoLUoUYvdtEJUbRt5uZGfb1tUzimFA+KMyJu410XG2qp5SUI1nViG0vxnpgBV0GvJfAHyTRrZWxm7o+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775181952; c=relaxed/simple;
	bh=eaCcfsqQeEz09XbHGljuOKpgFS7kHZhREdNc+Cgj7vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UU78caNyoduA+2t9UI5Ir2gf+u1YdFZidD78zyzJQnvkOffRLGTW4Boy4Nnb+AIDvprgaVFRj+1Sw4sIeATCza/6O3UsbEiUQWrNlMY0MVKFR9hbNUlzwmdK5oqamBbSnmoxA+6Ct6+mgin9oEr4ZM1ba5Ss2AtnLmxtBtYyoJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n4Fk6BmJ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n4Fk6BmJ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6331tjHB3352247;
	Fri, 3 Apr 2026 02:05:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dbL8DPCPfuBjA2tdM4zpeLWVjLV1ez+T/gaJsc4Ynq0=; b=
	n4Fk6BmJIUte6tHwc3V7fZr0JF4fD/R5N7RecCgIXVE9vQqFf01qAOunrvRR5p17
	NLnl3zagb0djzcB7U/dCnp4iOvHLIyqCU40G09ov1X9V4NduQCd+Wd2ZIckux2Q7
	mCanSUuZ60XFGRyvwuf2IgZp0uzUubEE22N67qnZvZ33lG6RuGLQhncBoKhUaTyW
	gWy2uZr5UdptqRTyL2DpBwuU5hppbc3IdoVfvf6bH9S8ltLDKlA+7j/fnFA5T/iK
	kBkMbCjuBcSDxnnbZcRnJk8x7BAOVxEvTN9oJcP8NEjRQ+lQ9B5xu3aNt6b+yqOl
	+RB9/5TBBvNx+3EPWXAj/A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65w7hgew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63313VnZ029102;
	Fri, 3 Apr 2026 02:05:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eddp5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:44 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 63325cqf017364;
	Fri, 3 Apr 2026 02:05:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65eddp33-5;
	Fri, 03 Apr 2026 02:05:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Joshua Daley <jdaley@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com,
        James.Bottomley@HansenPartnership.com, mjrosato@linux.ibm.com,
        farman@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v4 0/2] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_probe
Date: Thu,  2 Apr 2026 22:05:28 -0400
Message-ID: <177517593441.3522679.16294248305538999842.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260325180857.3675854-1-jdaley@linux.ibm.com>
References: <20260325180857.3675854-1-jdaley@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030017
X-Proofpoint-GUID: TfSpiJb9Ynd09kTO66-VP66KDKLyf8HN
X-Proofpoint-ORIG-GUID: TfSpiJb9Ynd09kTO66-VP66KDKLyf8HN
X-Authority-Analysis: v=2.4 cv=DKSCIiNb c=1 sm=1 tr=0 ts=69cf2079 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=8wEe_oM4oWijXggTasMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNyBTYWx0ZWRfX/J9FmuorzI4r
 45kse0J0ZZPZV8ZJvoFa8eMblG2f0wU/2RMBGtYLtuiep2z91La9yHYaqkSNE0B7rbPYMI1nxr1
 4lYTLGhxdeRGGQXZ9+FoeuFvQcP5Mu+rR4MLSf9r/h/3tLCpkva4qX3EDNM/ffnpfBDM3nHP2hy
 daXjI+a2bves4ScdAPkPukJeN9x1MZMF07hnp0wg1XXJ5zG5gyJnD6EAqEd3QBKGfPmyyaX7fsN
 jXzEPT+bUb7ijzFbGoNtjZEZSMK3vUWI30Cnrkf/aaIMbTyCD6eSPHFRBNDSsvG3oplRQ89/f95
 BoDyrbZJkTVSlXBfE8nPJy9XDqVK3YAq+dbNL8BaNmbxy1cGS6NCrq6ibqoED1x2CIcuWRmT5Fy
 bY3PSyk+YXl9qIoZYv1RyPccWN1ysMYhJeosK4Z/3ikqvyYjwzIvpxba8n3eWRJEr/5ryA148BS
 uANwcLygvRrKJ4nYedw==

On Wed, 25 Mar 2026 19:08:55 +0100, Joshua Daley wrote:

> TITLE CHANGED! Original series title:
> "scsi: virtio_scsi: move INIT_WORK calls to virtscsi_init"
> Previous version:
> https://lore.kernel.org/linux-scsi/4a93583c-47a1-4700-a7bb-da75fbd231dc@linux.ibm.com/T/#t
> 
> Changelog v3 -> v4:
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/2] scsi: virtio_scsi: move INIT_WORK calls to virtscsi_probe
      https://git.kernel.org/mkp/scsi/c/da3159a3b3fd
[2/2] scsi: virtio_scsi: kick event_list unconditionally
      https://git.kernel.org/mkp/scsi/c/0019a3a5756b

-- 
Martin K. Petersen
