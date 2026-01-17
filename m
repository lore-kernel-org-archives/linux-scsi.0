Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D8A50094C
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 04:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768624657; cv=none; b=QAE5MfadxJqcDT4ZFmQlloFfiGeRlQbEJ3g6HjTB7LVOWvdtFezSdm4XzgxjAu/kuXse11soQdYqqEKQFLobeZkNF6ExyELSPSnF48QMuxw6wy3ZAh+fmVDc2XCLy2j+NQBPjKPB3LvM6qgYKfIyFA0oHzpkAQVipivQv6S0mEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768624657; c=relaxed/simple;
	bh=c5BLzQIzOFdqHEysiy4e/pT+o9FQGPfpQiyAHlS2XY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dFwhRnKxUc3y4X9gzGHaleadvb2REiAzDVNaWDThtY5X7FU1mLfshmDRBDkS1oqvZSChskCAmflqL+7/GdiR1inpvJYr9laH9it1+VEXBMONgNnUE1+Eq0c9nw/zgXVQumiRhM3YAW34EvxSmGwuA3Gc0UCOi9nvH9OC7ghc1FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YGcaSSi3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YGcaSSi3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60H26Zbk107231;
	Sat, 17 Jan 2026 04:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QhFqOoUzZlkcRIWKFMqEdTV3qlP4lEfllwW9lbbfmWI=; b=
	YGcaSSi3Lz6rthvVDr57z4cgv1NJE+bh0GopOBRpqwr6EU0qY6eJgYXSRoZn0OJR
	V0XvhX2dmgNVtYUnwPvJgPREBf5QAYyZUc1D/T09fNDK1zSIQySrBpDPjrjt5UMk
	xZVUA2WM0UK1SQIFgkyhs18RXx4kBAJBCTraWWpd94r6yTSN21+51sulutinwMxF
	g1x6+akO12+oCnSCgBdG/4zMGwUwWFUQdctOV89XHPRcxrv86aK6LSbo7u4oKS8R
	d67FDYAMHpRpKxnt4dAaQhAsqpMmG4Y0rGIGPDNs9DyAojQb24mf+6jNH5fXVGpX
	ZtJrmtqwjJE2B62jHBPfdA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b883au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:37:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60H1XeoL007621;
	Sat, 17 Jan 2026 04:37:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v6bk64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:37:00 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60H4at7P005851;
	Sat, 17 Jan 2026 04:36:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4br0v6bk4d-5;
	Sat, 17 Jan 2026 04:36:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 0/8] scsi: Make use of bus callbacks
Date: Fri, 16 Jan 2026 23:36:49 -0500
Message-ID: <176862008991.2331811.13666589282791316750.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
References: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
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
 definitions=2026-01-16_09,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601170034
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=696b11ec cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=LY8flSgGw48rVUN8yYkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE3MDAzNSBTYWx0ZWRfX/tnNG0SmQwDh
 cB69ZQUjYiczw9LKTYK47rdcD5FgpPmR3t3SdJ/BCEgWw4izvURCM/hpAm4x6WYE40bXOBA62zQ
 oHBSa+RkQSK3aOnTAoCluzSYz8lGRgxJ5FW3C+r+JgTDIg169y4yI6SBVQTDyEqUttTFB0bsw0f
 h6GpOw42C7Rv8DniukvKvvEzzpgp8FFbFUBhhXNwZiT1prFz2s4r8QuCqhVZ9P86bXiSseryZ4O
 AdBSmuwsC3TJeQ387I82pP9l4QWdjoTblOoXiqCkGCbOmshjYd2BB917fNMeIlDFit0uev94a5I
 576TVQ9In2IjjIKB95+2rc9YSL0xlmSQnmm793NBgIRLqfZ+Xf3JPVwHmfGIMbtREcQr1VGa4xr
 IG5zrY2eINe1GWV7C9pSOAvrQYgzRx8c6uZfyGRiPJBlh4eJvM88KpBkGEwL0bcdgJ/2LjCu4sj
 xkyJfE3W2pPmGH4uArA==
X-Proofpoint-ORIG-GUID: M1kVZeeNGj4bxSHU3Z8YGo8I68sXRoQG
X-Proofpoint-GUID: M1kVZeeNGj4bxSHU3Z8YGo8I68sXRoQG

On Fri, 19 Dec 2025 10:25:29 +0100, Uwe Kleine-König wrote:

> this is v2 of the series to make the scsi subsystem stop using the
> callbacks .probe(), .remove() and .shutdown() of struct device_driver.
> Instead use their designated alternatives in struct bus_type.
> 
> The eventual goal is to drop the callbacks from struct device_driver.
> 
> The 2nd patch introduces some legacy handling for drivers still using
> the device_driver callbacks. This results in a runtime warning (in
> driver_register()). The following patches convert all in-tree drivers
> (and thus fix the warnings one after another).
> Conceptually this legacy handling could be dropped at the end of the
> series, but I think this is a bad idea because this silently breaks
> out-of-tree drivers (which also covers drivers that are currently
> prepared for mainline submission) and in-tree drivers I might have
> missed (though I'm convinced I catched them all). That convinces me that
> keeping the legacy handling for at least one development cycle is the
> right choice. I'll care for that at the latest when I remove the
> callbacks from struct device_driver.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/8] scsi: Pass a struct scsi_driver to scsi_{,un}register_driver()
      https://git.kernel.org/mkp/scsi/c/7d42bcea57ae
[2/8] scsi: Make use of bus callbacks
      https://git.kernel.org/mkp/scsi/c/f7d4f1bf5724
[3/8] scsi: ch: Convert to scsi bus methods
      https://git.kernel.org/mkp/scsi/c/fba333569c8a
[4/8] scsi: sd: Convert to scsi bus methods
      https://git.kernel.org/mkp/scsi/c/63b541f054e7
[5/8] scsi: ses: Convert to scsi bus methods
      https://git.kernel.org/mkp/scsi/c/a71d5deea6e9
[6/8] scsi: sr: Convert to scsi bus methods
      https://git.kernel.org/mkp/scsi/c/9ccda35df7d5
[7/8] scsi: st: Convert to scsi bus methods
      https://git.kernel.org/mkp/scsi/c/4bc2205be460
[8/8] scsi: ufs: Convert to scsi bus methods
      https://git.kernel.org/mkp/scsi/c/44859905375f

-- 
Martin K. Petersen
