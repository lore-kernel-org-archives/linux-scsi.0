Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309215223
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156063; cv=none; b=HBRXgUBKrF5hkOoM4sWUVuj5It5L8cRl3eh6JticRXcr0DPlVwvg3HCOdqOEFpfpjAUAkLkEqGYlzfsTJG0ps0DcTto0ZLZVPUCvm+btSyTCBt2C+EKcorbEdaYH5Rj8icqGxskuA50NFAFYmUFFKXXULnwoQMoZPdCLawF6uRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156063; c=relaxed/simple;
	bh=/41xy3xKlssttlN/ktTZpE2/9q8PkaJj2jscqg63pR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eh2miu9Wh4g/bzJIvMKYSELJ0uji+wU/wTJqHsd61ebvcr6iSKzua31H3nOtASb1ith2x2VOE9ADmWC7F9YnbuLIPm6LTPNpnzhHnlQnU9eIOxwUnkAq4MorhQjthifxRhofK5cuaYN/ZExlBQf7uTD/FFjb01h9FTIBFR874vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HPbomwFL; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HPbomwFL"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1BvZj008103;
	Tue, 22 Jul 2025 03:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/HQ4u71R67V96WfZpdpfRGqdISBnlUfI8inAnbXwDDI=; b=
	HPbomwFLoa98symOFedl8V4AHA5pEtY24s4ofyb6OwQCoUWiRLlaQCZnLrCwoTQ6
	Q/2dYkSHZd3WHAtz+iphAvaqe8cMytfZsxkwUIi4ZEyhk8a5n4QCJPZPD6qN4vIL
	QpdARjRKeQLzarexYO39lMhlMTlwateuLpdaF9fhpiL9nrS9XJ82fZLDWL+kAnSj
	DEmZNHSs7pH7HtyibWoae8dXBNfROjgUcxqEg8ffIM0u8GH60CoYDhLT1X3FNmIN
	uNq2foLXyQk+pWshmRjhyQqmTWZ5VpsimKEptpQOMwjF2ZeXFhWlDCquQAs0+XcM
	KUISEDVCjGaTcAbpT/RkdA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48057qvak4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1wRHY037671;
	Tue, 22 Jul 2025 03:47:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8te9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:36 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZj3031915;
	Tue, 22 Jul 2025 03:47:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-3;
	Tue, 22 Jul 2025 03:47:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: (subset) [PATCH 0/3] Improve const and reserved command handling
Date: Mon, 21 Jul 2025 23:46:56 -0400
Message-ID: <175315388512.3946361.14330514660159778668.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250624210541.512910-1-bvanassche@acm.org>
References: <20250624210541.512910-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=738
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Authority-Analysis: v=2.4 cv=MNRgmNZl c=1 sm=1 tr=0 ts=687f09d9 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=bzXJBGgjbli-7E_yArMA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-ORIG-GUID: g4FLHcQDfbKk5zc7CvuIYy0KEaaTVWvB
X-Proofpoint-GUID: g4FLHcQDfbKk5zc7CvuIYy0KEaaTVWvB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfX7rGPoOb7hfco
 R3Kw3v4dDfH3U+35t5bEtuT157uwXZz0LqoWGFN4e0vLpkv7U3C9vwuqLKVrxti5mdeY3AXHOTd
 YzfsVF4JckSkaaAtlSdpru6OX0z8AAv8+Tnnd07o4Pm1ZvNVNrFuqvbv6KbLHyxafO0X7GpMYgu
 OyHtbva7VIfOA9UbYjC8qzjZw6Lb5mXuVEJ0JTM6pvMAiXXTGpNoax9fRePjNCVjTWzoPOEYtyA
 IIUD+DhOqlOJ5tGqtMnYrU93sX0qAN+v7xGKp/IVZcZ8g+V6/5XTanDt6J4C9HoRKrkItLaYm/r
 laUPaMmTkKz5xI66M25Iqk0EOEbaLHSt4Dli7wmAbGvzdGT5fq/ErQs8AeYbNcN0Lp2utMGeVwj
 p1SQ1NkE5dNyCGGRScJlHZH9JOEfX7FnllM3TYtdifelm0frFNJIAKhMBGF1krdsejxQp+D2

On Tue, 24 Jun 2025 14:05:37 -0700, Bart Van Assche wrote:

> This patch series includes three cleanup patches for the SCSI core that do not
> modify any functionality. Please consider these patches for the next merge
> window.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[3/3] scsi: core: Use scsi_cmd_priv() instead of open-coding it
      https://git.kernel.org/mkp/scsi/c/8314312c5286

-- 
Martin K. Petersen	Oracle Linux Engineering
