Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45147DA95
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 01:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927291; cv=none; b=Y3rt+OHsvVhdp/8tV6NlT900nQ8wZ0uzeaWiWplYTutZRaMNUWPdcw2Q5tJFEX7eDm8gsrACuwp4N+FWUTiiTjxbEf3UtCsg0xrx0CV8zZ3KBtxDHWntDKxpkFbJA/YpPfXgLGRwP4z7JQVRlIHKqxpE7Eh18bzdqLq6UUlHUCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927291; c=relaxed/simple;
	bh=kBVDcpYaLzwESWmUPwumgDYJ+QM2Td5VI2j3nKDBr8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d6wfnOFSTpV8HKuluXz3WktBN+mPpbzfE4UnBy5HvlZAZ3djrhxzIf7/3dr3gsIgdBoK9i9KcmKmdnXC3EhVjPC2RUvANXZ4xGMYwnMlKM4g/DNuM+mKxttnvlPsObGR0H4gcrNujpEHIiHF6OPb+uyKwSSNNMqyGvoLSxAXZ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oZaZgQ/G; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oZaZgQ/G"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IMfZ8B026780;
	Wed, 19 Feb 2025 01:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=aXv95X3RE6HwkL+ENcyauBE1y1wT3OE2uG1y/Mm9fOY=; b=
	oZaZgQ/GRivNdRBOUYU1nvE6U0RJUpeafkfGZWT0HzxgbRu1jHo62W/dtt3MVl5P
	EFtIrRVrsx+0EwkwJtYHeDp2Dd8y63UDsmWTXs+eBazR0OpkWnwc/zbQfGfRGN6D
	z05K3u4CsV1848WLSdqSwNU5hfZ57bipisn1nPFPpJMdjTaJ/HHPB4nwxFDPN+st
	eo6wdXeoahxsNskYaRXh1T5+g2uxoI1CEz4LmaQd6akpBMcUCgLGsy8PAagBXjvW
	tHDdL5ZfO/rjwOATswKcL16VlwiNVOA5TC5CqtaQdo7QoxNY2627qMQKtAYxmHeb
	tqOW/YcPzseNQtdpvAlnTw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00mrjsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51J0CE4K002145;
	Wed, 19 Feb 2025 01:07:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0tk1rr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:23 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51J17KeP000669;
	Wed, 19 Feb 2025 01:07:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44w0tk1rq5-4;
	Wed, 19 Feb 2025 01:07:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Russell King <linux@armlinux.org.uk>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        Hongbo Li <lihongbo22@huawei.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        John Garry <john.g.garry@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>, Takashi Iwai <tiwai@suse.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH] scsi, usb: Rename the RESERVE and RELEASE constants
Date: Tue, 18 Feb 2025 20:06:52 -0500
Message-ID: <173992713087.526057.11179535515516533138.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210205031.2970833-1-bvanassche@acm.org>
References: <20250210205031.2970833-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_11,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=835
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190006
X-Proofpoint-ORIG-GUID: 3_2d9bUh6rObLlIcSdBrgPEKJC0IAUu2
X-Proofpoint-GUID: 3_2d9bUh6rObLlIcSdBrgPEKJC0IAUu2

On Mon, 10 Feb 2025 12:50:09 -0800, Bart Van Assche wrote:

> The names RESERVE and RELEASE are not only used in <scsi/scsi_proto.h> but
> also elsewhere in the kernel:
> 
> $ git grep -nHE 'define[[:blank:]]*(RESERVE|RELEASE)[[:blank:]]'
> drivers/input/joystick/walkera0701.c:13:#define RESERVE 20000
> drivers/s390/char/tape_std.h:56:#define RELEASE			0xD4	/* 3420 NOP, 3480 REJECT */
> drivers/s390/char/tape_std.h:58:#define RESERVE			0xF4	/* 3420 NOP, 3480 REJECT */
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi, usb: Rename the RESERVE and RELEASE constants
      https://git.kernel.org/mkp/scsi/c/0ea163a18b17

-- 
Martin K. Petersen	Oracle Linux Engineering
