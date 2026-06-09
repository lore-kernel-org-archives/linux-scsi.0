Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E8134B404
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 01:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969162; cv=none; b=bWCe7vVp5OlavLP3/xeYrXxmiW40bc8vYbFr3xCBnAqTFiyVUTo4p6q5N5sH8l1HI8QZsj8yFW2KXqzDOk2YRPFc4dAMZfkmrudg9Z21ETNOSIcoDcX2gZQJqXXYwQqsrxUhBb8kuAmet60h5DO2ufsPte274dfaNEuqGpPUxNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969162; c=relaxed/simple;
	bh=12lVf8q60K5nGzrd5RACAeFjIvlX7ZNmkcMP0TKlx6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MvtgtdI4lJzuMOiEu0qF+N5Pe92+8/6Pq0xsZMnhADlFqzuDxda/NGlT1IVXYUolcatmYzRyCvcoYB7H6QXioeVScoKXD6a6triWkhKYAW1E7vmh2zE1A0RQFBqTGwQZ0FXic7LCnlveCMiHPN0mvY1AsuL9Y8jaxFbeT/t3uso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V3QnJDVP; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V3QnJDVP"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSaYp1242873;
	Tue, 9 Jun 2026 01:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NIUfvR/SBj8kJSjVeMTehGErMH2OX4G1iZohI+hb+mA=; b=
	V3QnJDVPIMOPelmQotzPXuY0/W5WpMok4wMaToWFdL7p0MGDTsHF8ad6Uhc7ZIOb
	kkmkPgAEgGNn1oyT/PRqB09ba2G0y2bOG4Qd9sIfAbqTBmvihSE3NuRyWeYENHku
	0VRORs6kG3J8hpsZQpVl2mF87rmwieuacGHkfU+N9srafSgB8xUgzDy9XTQM4x8Y
	MZ6wUAUEOcovq6YWwwsmGEsL85MrxJ8uiPpGse5SJpRjGJEZ4blxWkd9jxFij6N2
	wsenAwWTFPgFXgo2hTqAlqNsTevZKiP4gwxhDTtN3FUc+dnSz5tqBotvd9QDg+l1
	uiWCxfw9oTrgj7y5ou+oMQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4em9ybbg8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591ca6w028136;
	Tue, 9 Jun 2026 01:39:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pgesb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:10 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591d6At030153;
	Tue, 9 Jun 2026 01:39:10 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pgepy-9;
	Tue, 09 Jun 2026 01:39:10 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microchip.com>,
        ranjan.kumar@broadcom.com, Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Lee Duncan <lduncan@suse.com>, Martin Wilck <mwilck@suse.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH v3 0/2] Fix SAS wildcard scan on smartpqi and other controllers
Date: Mon,  8 Jun 2026 21:39:02 -0400
Message-ID: <178094912063.1810714.10559454098064101572.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260513174236.430465-1-mwilck@suse.com>
References: <20260513174236.430465-1-mwilck@suse.com>
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
 definitions=2026-06-08_06,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfX8yfk/zRNcBb3
 S62owhyLnujUfPL/m1fuBEbfQ6CjoUDTD51jMMhjv8QGkduF7XLzr1is2L5oKetD6YwH8RMvAJV
 bGj+8e93Y0PoodS5ndevjtezuwtj51kPm0GtoL30QY9csE2wa8eONZsuFHpjlCo4WfNQDuiWzeU
 gAgRVFEOxc6iy7M/e0YLZZvq+4zV0f7JdnPRl6xkONyDkOwSs+2rbpNV1J9og7T234lHHrP0AhN
 JU98RXkqG5WzOBBdNlDcTWsJYEKnVuiNwUR0nhiJwFPsRrgFKHzhduB2jWbU9iJ2IcsUp0KWzko
 5ax5A5LjIEhSLfytB9AWUieRxsvsXMj/U/0BGeFA9LnA560jufeOvdsA+TEHSy9fPOZDmE4X1el
 iHzJOEZ2GwGeZkeqWVyuDxC/m01vP7PUALu/D+NhHRcXII+2YXBjkyizPfRYUhKAq64my2Dc13y
 FSq5Jj0YsagMqTF1j4JRzi6SEW8aPbY9fnOnI4fI=
X-Authority-Analysis: v=2.4 cv=IYK3n2qa c=1 sm=1 tr=0 ts=6a276ebf b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=wQxipbALQ8rLcOhLrkAA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: MaTaX5QO7tntgRfybwX5k8FxqpUUHKwL
X-Proofpoint-ORIG-GUID: MaTaX5QO7tntgRfybwX5k8FxqpUUHKwL

On Wed, 13 May 2026 19:42:34 +0200, Martin Wilck wrote:

> commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and
> multi-channel scans") modified the way SAS drivers handle the common way of
> rescanning SCSI devices using "echo - - - >/sys/class/scsi_host/host$N/scan".
> Before this patch, SAS drivers would only scan channel 0 for this "wildcard
> scan" scenario; after this patch, it would scan all channels up to
> shost->max_channel.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/2] scsi: smartpqi: use shost_to_hba() in pqi_scan_finished()
      https://git.kernel.org/mkp/scsi/c/57db1307afb1
[2/2] Revert "scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans"
      https://git.kernel.org/mkp/scsi/c/8c292e89bd83

-- 
Martin K. Petersen
