Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C69C343887;
	Tue,  9 Jun 2026 01:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969157; cv=none; b=TtIsr8CT9Zl52I4xux5JeKAXRH46jelkgb6o1Nw1Y0i1DL6lToGkVAeSv5JM+4QxSeacBe0LWmVHkOSvIHAHr3L9TVfwzzO6fW8a0P6MD8cKmFwZsjx9xa3o0EZC4kqzLSUCjtg/jtGUxAfclpDvjRgYC/mYfMDiQY56LZ8yYpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969157; c=relaxed/simple;
	bh=QZHZYbGu84cOydak1Ox6IWAJRjg0bKzM65BT1qfCAXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dZF0VpQRJ0okq5t4G8Hx0ELcUWYGagq/Ikd4avFWvxDGtGBy1++Uex2JaoRZ6DXl3S2yYS1qt/E1KOmKYUUtAC9zRXrHwZK3LomcQnJbCOI/VanutDToOCT5kXWPYLgfsn+H9yFUARlJ1SA5S2KndHCQ8iGnzwW79PasfiGL024=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KlzJ+xOe; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KlzJ+xOe"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65900LdD2349178;
	Tue, 9 Jun 2026 01:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1RDJHqu5UCfzdqM5D9L4RWGi6RgMIMpwSb8Lxt6e1kE=; b=
	KlzJ+xOeV+79BJnb+aOkd6iWW/MOP/NqTGKT7rDelOgB7o8W5ydUqRI9miM8HKX1
	GBVstMdfSvlrp4jXrVUFC0wt33dILichpuEz1lESHqz97NzFE2/GMT8+dz0fTEEa
	lxgxS9pKwXcZYLbNq9QCQUsSqtQGcMvy6MSI56zbwnyYIWbS//UvfhzcETwd7ITS
	f3JrxHJOlo+omJ2Df2vQflDVJQJX5b2v8F+/4stZbSSrO8FEkjxXhFy/55wtBL7W
	llRsthx35hawKSRuHDSspPnkWityKPo+9T0pxyv7e3xH1tzXA1GXvA02fEFLXfTY
	s1/Oo4gcv/va2v0HD/0mqQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4emab4kh1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591cZ7d028043;
	Tue, 9 Jun 2026 01:39:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pgeqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:07 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591d6Ad030153;
	Tue, 9 Jun 2026 01:39:06 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pgepy-1;
	Tue, 09 Jun 2026 01:39:06 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dan Carpenter <error27@gmail.com>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_mbox: avoid double kfree()
Date: Mon,  8 Jun 2026 21:38:54 -0400
Message-ID: <178094912089.1810714.3060074625639666696.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601210216.846809-1-arnd@kernel.org>
References: <20260601210216.846809-1-arnd@kernel.org>
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
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=654
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Authority-Analysis: v=2.4 cv=cL/QdFeN c=1 sm=1 tr=0 ts=6a276ebc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=w5vSYF3J7pBbT-m-6eMA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: WCg-kAgj9li3BDEm06KyW88WJ97NvtMa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfX/6ZcnxuPBdAw
 ZYdEbZ33XfDrOXmkbof2Qd98OftLx7Kikyunjz6dhDQdp1NX7gkZ1yc4Bgdlc0YCJl3uuT/OhUK
 sMDwuOZHxKa0BqC7qWAEVt6LpzFZA1uoFdHiWzVK870Qci2ThrbSpigZfVdwKkjf2mLXp4HKu6f
 CNB2v6944MasCWe4FiS+IR060wva8ZVjJ8DQOqTKT8rTz14nlqPNpN2h+wu4gTHOd5D0TpvHEmQ
 s6FBGxYXv41/zQg6mZZIEIXu7NenmQM1NzQJRgqWQhizIizK15J1IQbJFF8ImBUp1Y3xY4Oiajl
 iXWHg3DYx4RnnpkWpdnLMrwG8LRIWjPXfqoz4koTyMnhK7iHQhV9w48uQ2TZPRepgRNQI+8/LAv
 MU6laxrJS3SgeJE5iacAggGcw5gTAyV60WMoCYQdxdmfFfN5cUo6GQrnibVVprXX3s+W0nzd8AK
 SjER+CpTyaLlkUPbCiQhoSsQBMkDi+BdSZdSVUJw=
X-Proofpoint-ORIG-GUID: WCg-kAgj9li3BDEm06KyW88WJ97NvtMa

On Mon, 01 Jun 2026 23:02:04 +0200, Arnd Bergmann wrote:

> Smatch found a double-free after my recent change:
> 
> 	drivers/scsi/megaraid/megaraid_mbox.c:3474 megaraid_cmm_register()
> 	error: double free of 'adp' (line 3468)
> 
> Since the object is no longer allocated in megaraid_cmm_register(),
> remove the kfree() as well.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: megaraid_mbox: avoid double kfree()
      https://git.kernel.org/mkp/scsi/c/c39a9a02bc5d

-- 
Martin K. Petersen
