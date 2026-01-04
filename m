Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF29316184
	for <linux-scsi@vger.kernel.org>; Sun,  4 Jan 2026 21:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767563015; cv=none; b=mA1eTJZQc4UKa4zs5UYucjc9ehV71PfXv3vvP3zuO/6y8mKmMbiGIMyG0tJ+UDEEnUxJQP6cQgPMdzW41c3rBz5DFOk5mU541RSap7m3453SjVrAgeSsD8O/g5tJOzD0Eh+rilTaMSZTZLVObx5Skk6dmbmUslhXDrZd0ad9e8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767563015; c=relaxed/simple;
	bh=PXQkk7Sul/+yz11K5KkWkmxRzzTXT98sjHQ25hGUt5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=imW+ZIDkFGtvpFW0kqe+k5FE5lLHPbKeaSXOExRc8dxeR94/hBTc0zU5BvTa6IVYBLACmX4rarJ1TboiiQoEjz+W5PHJqnNINRBAnOBRi+RCJ0XHvFeRe+34YTe/Sb8+VAOXpH6vWLI94AjgCCWyN5nIio+HjVuRWZyxdJy8ii4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WcX0ZAqu; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WcX0ZAqu"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LPMq8460378;
	Sun, 4 Jan 2026 21:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iyK0RJ6g/Ps2wjnAYjAovVoMp7xwnW0VJpFjGqjED2E=; b=
	WcX0ZAqudC9523XRiHrl29AiKE3tpahupd3Vc5859vq6B4WHb+DMGPn9J4KQXVuK
	3jmwGMtTUhUrKnAppO4uHUq3GD90EAUt/HFBn9ntQ7BIVvx3Uxq+jpoTWriyN5S0
	NfPiqJ4qHtQyCp/gApo64gjIEfynHlZtMNUbo24eMoIS5xO9awrgI4s0FKMoo0Xz
	DdDMriCMO73BO8IvpiVtmLvsDqX5PrbRzdWX8EvShV6OrNHEmYX1tzCKu6RCjEcW
	sos2MDFaDjh+XaXPZ3ufystShH1XgiQW72FJz8Icf7h5DlFN1l8UUQna+V7K5Mdn
	fS73gnyJRVLHKp+wToesrg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev2jgyp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604H58Fw027384;
	Sun, 4 Jan 2026 21:43:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj6gbhb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:30 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LhPoX007658;
	Sun, 4 Jan 2026 21:43:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4besj6gbf9-6;
	Sun, 04 Jan 2026 21:43:29 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
        chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com
Subject: Re: [PATCH v2 0/6] mpt3sas: Improve device readiness handling and event recovery
Date: Sun,  4 Jan 2026 16:43:12 -0500
Message-ID: <176755562247.1327406.738583615959202552.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
References: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040200
X-Proofpoint-ORIG-GUID: bulh5-7RiXMZxv-UxXPVcEbTLYBKlTJ1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfXxy76bLJ9VSgk
 zqAHhDeSVt7Ek2nNwhrvzm3Xt8j8JHMuuXOT8bcXXcP6hV+qrAz9WGW9BxDyBcNgnyZ8KuxLIDB
 DyRec8XdSpGpdt0AdaMUPJslXqJmwnTFAlYuQM3JKSMZ+lH3p55kp4DXdEM8QTgpwzQBT0r65dH
 utVJSQi4rJz9DMsTaRJQhAjuLe+MZMBXRYHyStf0f/7p+jHwYvaqGsTlVk+5IGQNkYNysEhgauw
 YMY7Pia4v+oN1wjsyd297QuhN4zn+49/bVdPZEBRK763eqtq8LwvICW0sU4SCuj6LrbBscGLNlb
 JmzpR4KaYvYNFGV+n/tMlBhVAHIBYfUzJXswRJkDf3MbYY4XrtGHrjknhUo9hJqU56PsP94TEzU
 OoNFHL9LiQP3lrypCuVt8e1hUDGJ+0JHl1xth9BknqQtbW4za3odQv1zXX0xyg3pgOo+V908w8m
 cpgG8PcbZNKaKluouEA==
X-Authority-Analysis: v=2.4 cv=A9hh/qWG c=1 sm=1 tr=0 ts=695adf03 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=NU0Hyk3IxulSulSHgqEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: bulh5-7RiXMZxv-UxXPVcEbTLYBKlTJ1

On Thu, 13 Nov 2025 21:07:04 +0530, Ranjan Kumar wrote:

> This patch series enhances the mpt3sas driver’s device bring-up,
> readiness detection, and event recovery mechanisms to improve
> robustness in environments with slow-responding or transient
> SAS/PCIe devices.
> 
> The series introduces optional control over issuing TEST UNIT READY
> (TUR) commands during device unblocking, configurable retry limits,
> and a mechanism to requeue firmware topology events when devices are
> temporarily busy. Together, these updates reduce discovery failures
> and improve recovery reliability following firmware or link events.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/6] mpt3sas: Added no_turs flag to device unblock logic
      https://git.kernel.org/mkp/scsi/c/6b553f2a5c84
[3/6] mpt3sas: improve device discovery and readiness handling for slow devices part-2
      https://git.kernel.org/mkp/scsi/c/aee682fad6cd
[4/6] mpt3sas: Add firmware event requeue support for busy devices
      https://git.kernel.org/mkp/scsi/c/ad5957193107
[5/6] mpt3sas: Add configurable command retry limit for slow-to-respond devices
      https://git.kernel.org/mkp/scsi/c/72340fecd0c8
[6/6] mpt3sas: Fixed the W=1 compilation warning
      https://git.kernel.org/mkp/scsi/c/39680c59f10c

-- 
Martin K. Petersen
