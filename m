Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFCD1B809;
	Tue,  2 Apr 2024 06:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712037737; cv=none; b=qzSnIDO1OUvePlwqIUj5GRY42ZxYFto31ySs03Tcq9qrzpQ4KCTghIaALvRvh3QV7BYojAw9y5Yfpeha3GCLdXEeft4wUFWM+1sPM2lrnp+8DPIcZUGacQFfA8/9cFnDv6RSzQFI3zd7L/sIpITZ3mRAN1wRp67Xn9PXBemo3JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712037737; c=relaxed/simple;
	bh=Cbgxut4mvPDkO4bygdas+MVVnDdH9sN6VZh/k+ADYuQ=;
	h=Content-Type:Subject:From:In-Reply-To:Date:Cc:Message-Id:
	 References:To:MIME-Version; b=hlS2aj6+W7HcqgwAlFJRiySmEREZ7c6NUayVrFDaA5i3Gu0SbWI9c7MRX9T0iBx47/u7GHEfnSvgCK3xn/7VchU/82W0iUyABmV5MB5J+TCE4vetInzwSpAS6RfWeKItKEQgh0bpfg+51n3A9+UbBOpMG1vG0DTsWr0LQMjHcwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ksdJFMMP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ksdJFMMP"
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4325SUUp027429;
	Tue, 2 Apr 2024 06:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type : subject :
 from : in-reply-to : date : cc : message-id : references : to :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Cbgxut4mvPDkO4bygdas+MVVnDdH9sN6VZh/k+ADYuQ=;
 b=ksdJFMMPm5uDIyHm1mAYDbxq4ffm8hp2k3PHdav1XwqglAcgASzMivNEDBvvV4TlC6vn
 3cwToVUemGug0RpNNaz7SMOhoB8sRMVzbekTgTNEV+e6wm8hP41vhfSVgEIc5mAJJ0kR
 FbyMwjo8CTFPqFpUYfN7fhcCoCI1G+GqTd1zfxmhsD8psq/sZeemU8nc6sdklMmTMp8a
 8DctYUA1rP65b4Md9433PKhJ6h1cr1dd33JEEVjmIyYIddMHAX3vB7e5qYyqGcEbq1Ux
 RhtQZChfz5HUHjdl9zmCLrHwT/K/5SjI1zapk124k7gZIuMmDQmAdiow+OVmVG1ye21T 1w== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x8bw4g22n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 06:01:57 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4322TAMc029563;
	Tue, 2 Apr 2024 06:01:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x6ys2v6yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Apr 2024 06:01:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43261hh654657390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Apr 2024 06:01:45 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15A2020043;
	Tue,  2 Apr 2024 06:01:43 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0419F20065;
	Tue,  2 Apr 2024 06:01:41 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.43.121.120])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  2 Apr 2024 06:01:40 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Subject: Re: [PATCH v3] scsi: sg: Avoid race in error handling & drop bogus
 warn
From: Sachin Sant <sachinp@linux.ibm.com>
In-Reply-To: <20240401191038.18359-1-Alexander@wetzel-home.de>
Date: Tue, 2 Apr 2024 11:31:29 +0530
Cc: dgilbert@interlog.com, gregkh@linuxfoundation.org,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org
Message-Id: <3FD93D06-41E6-4026-BCD9-574A724F18CD@linux.ibm.com>
References: <81266270-42F4-48F9-9139-8F0C3F0A6553@linux.ibm.com>
 <20240401191038.18359-1-Alexander@wetzel-home.de>
To: Alexander Wetzel <Alexander@wetzel-home.de>
X-Mailer: Apple Mail (2.3774.500.171.1.1)
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iSOHUPgrqfw7kjrX1LFMWl7t2lVCUUoC
X-Proofpoint-GUID: iSOHUPgrqfw7kjrX1LFMWl7t2lVCUUoC
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-02_02,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 phishscore=0
 mlxlogscore=922 lowpriorityscore=0 clxscore=1011 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404020041



> On 2 Apr 2024, at 12:40=E2=80=AFAM, Alexander Wetzel <Alexander@wetzel-ho=
me.de> wrote:
>=20
> commit 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")
> introduced an incorrect WARN_ON_ONCE() and missed a sequence where
> sg_device_destroy() was used after scsi_device_put().
>=20
> sg_device_destroy() is accessing the parent scsi_device request_queue whi=
ch
> will already be set to NULL when the preceding call to scsi_device_put()
> removed the last reference to the parent scsi_device.
>=20
> Drop the incorrect WARN_ON_ONCE() - allowing more than one concurrent
> access to the sg device - and make sure sg_device_destroy() is not used
> after scsi_device_put() in the error handling.
>=20
> Link: https://lore.kernel.org/all/5375B275-D137-4D5F-BE25-6AF8ACAE41EF@li=
nux.ibm.com
> Fixes: 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
> ---

Thanks for the fix. I tested this patch and confirm it fixes the reported p=
roblem.

Tested-by: Sachin Sant <sachinp@linux.ibm.com>


=E2=80=94 Sachin
