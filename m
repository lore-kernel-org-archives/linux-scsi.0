Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA801F5858
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 02:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552665; cv=none; b=u687oDOWvoLISjgcfWj2xXIw9sFIxAocn8Gf51YiXYk5jrchFv15jLS2CE7RF6jy8KJLH70s7MbPkjqTGomqCmXxrwrVC5dY1eWDSJs3Bpm6uUDCoSLquP5EzMdSX+0YlEbCmLDhHAtbmBTjk5ncGBWI4I4h4LFbwKt5My55v+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552665; c=relaxed/simple;
	bh=b8YfFjsu+dsnrcSChZm33erP42UXNWf3/zjiAmp683I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PypHFO6TMGqoyWIxzvTxCBq9UIKA7WOsbzumli72T+/0Sot6iMIG7fso/1R8ZmKy09C1WALq8/XFVZrrNYZQyG+pP9HBKy6kcD++B74F67PEpJif5rmSF5AnIlLiCalo7M1zllpQ1HCvXR//qaNlm6zzdCXbVKJomKsljru2ayA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nSi/c6Bu; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nSi/c6Bu"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1ffrQ001675;
	Thu, 14 Nov 2024 02:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0erffQGWhshsbcwClS8DNmi6byGdA4kZb4ThaLB4FUU=; b=
	nSi/c6Bu9z0brDmCAMXuPv5rW41PbjQ2iDhYSk/07jGObpSi4Uu0jXUx76rknFxE
	d34xp6HWsp9PZL8FUV0OTxQH5XHmLJY69bGJl7NcRF6bJ4hcDSLj/BkGHbA+/k+E
	MPQuqcNlm63YHAWL1tmVx3Qf9GK4r2Vz/eQ1iAGJPlR+Pqq6zMHLPi5qKhdJZA/2
	TwCmqFwxgpONunmrDDqF6GMcyC2s9VR1xlfCrlp5XxaoHqVYEMnR4zAvDYN95zW7
	S14wUafNy5p9Pj6FcJ7fe4kvaKDROGfDvpIjV0ukmyWQly21aHyomLPMH2zH2q0Q
	WyjUXT5UPyPm30FIFzxaLw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0mbgaxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:51:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1AUWJ022725;
	Thu, 14 Nov 2024 02:51:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p24v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:51:00 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojZ8003527;
	Thu, 14 Nov 2024 02:51:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-13;
	Thu, 14 Nov 2024 02:51:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Switch back to struct platform_driver::remove()
Date: Wed, 13 Nov 2024 21:50:06 -0500
Message-ID: <173155154787.970810.15378353898462989120.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241028080754.429191-2-u.kleine-koenig@baylibre.com>
References: <20241028080754.429191-2-u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-GUID: QmBNyoEqNXDTkkLA1r_nFWJNIKF-prSo
X-Proofpoint-ORIG-GUID: QmBNyoEqNXDTkkLA1r_nFWJNIKF-prSo

On Mon, 28 Oct 2024 09:07:55 +0100, Uwe Kleine-König wrote:

> After commit 0edb555a65d1 ("platform: Make platform_driver::remove()
> return void") .remove() is (again) the right callback to implement for
> platform drivers.
> 
> Convert all platform drivers below drivers/scsito use .remove(), with
> the eventual goal to drop struct platform_driver::remove_new(). As
> .remove() and .remove_new() have the same prototypes, conversion is done
> by just changing the structure member name in the driver initializer.
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: Switch back to struct platform_driver::remove()
      https://git.kernel.org/mkp/scsi/c/f8da4c1cad5f

-- 
Martin K. Petersen	Oracle Linux Engineering
