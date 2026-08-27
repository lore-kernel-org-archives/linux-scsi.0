Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81C144E66E;
	Thu, 27 Aug 2026 14:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787839712; cv=none; b=SJweFSIq7KxgGqYjvkHMXm+zfvmO2SgM7T5kE6FhZg8dg2vC98WrkVu7HycLGpwSfaHJV8sKR2IdFxWAsQwfCJ1GS87aT/aLZ9j8DExdj43dl1+8rqv6E4VvIGtfnSn5p760dv754szdPoHP9Gh3SXXFiU5DlfS6gUOfpL9pV3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787839712; c=relaxed/simple;
	bh=p/LqV0bbwyDsg+Teqe9VVXwzQt8QDI+o4xo4+zEZdhY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=f9GviZQzc+o5nP0L8iIWwQh9ydkEJTJpuhpixjzlx3HLjgnFKQl0V9pzQxk7omvt9uliCzjjPxY8s+gP+GmVMy6Arr+AflnZa+r0uESvNvCdMzHYCi17mVCuMK01ZIC1FlxuRf6AWeqvvb89SoU0lDPd+w9SOBTGSjLg9hCn6Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X9ABe5Fw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X9ABe5Fw"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RCVcFe3056420;
	Thu, 27 Aug 2026 14:08:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Gr6VTsDhP5mHAQff+FL5cCHF2fgJyH
	3ushQq6Ob/Ax8=; b=X9ABe5FwmxZYZlbJRNXLhg7cU04stnrlZNLGWga4n+QBQH
	31saIqI54N/6FHQZVBmSoHGINsgDPpbsViHBS0gjJnKP892qaL1HRIIx1uG8Oh9K
	lSuSU0ZJ2D5A9U/EouXMLO6Gy1YLoUcdm7abi3+seANbaTaUoPh7YyKsbH2zRof4
	bNFUAbEldyGpctHYC0VQ5/YKKjynhiJWMQ9mXUwUh88Itg60eVog5PKxMzES+LxZ
	fJmx4WOjuRMBfX5z+aMeWMytJvrCcp0B4HoBAP8hubBxfKZwW8qGHDkKM27667mO
	NvUNaRR7Y8p5SX9Fd4s1nyxQiZbFR2OuTgImTNHg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73dxnf9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 14:08:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67RDuI18019547;
	Thu, 27 Aug 2026 14:08:04 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7p3qgp1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 14:08:04 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67RE7MJQ62456068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Aug 2026 14:07:22 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DE2558065;
	Thu, 27 Aug 2026 14:08:02 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 67BB858068;
	Thu, 27 Aug 2026 14:08:02 +0000 (GMT)
Received: from d (unknown [9.61.140.220])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 27 Aug 2026 14:08:02 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman
 <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe
 Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/2] scsi: ibmvfc: fix kernel-doc name for
 ibmvfc_scsi_relogin()
In-Reply-To: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
References: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
Date: Thu, 27 Aug 2026 09:08:01 -0500
Message-ID: <87y0drzmf2.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExOCBTYWx0ZWRfX3Mu8K0uwr7Yy
 6raJCVJCkjMUQuTazwvW4KKzdOIX2A+Qeq+F/3/2DjTQuvaMTuJPh3YAaxo9R24MVgV9VusrqxQ
 ocK60JDECVyW5Npvjy3KdvO035FFKGQ=
X-Authority-Analysis: v=2.4 cv=AYuB2XXG c=1 sm=1 tr=0 ts=6a9044c6 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=LaLp-TgcLTumg1K0mcgA:9
X-Proofpoint-ORIG-GUID: FGzuC-Mg5Z0A8r0RO_I2C8yYttgrH8uS
X-Proofpoint-GUID: Yk6kvfDurN4qEJumbiDg4jpIbL2H8Tlq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExOCBTYWx0ZWRfX0urEu6bEsxcB
 aIVGiN7BKQaVOU3Wn4gfbElxLUD85qiRKzIFy5CLgaCgN36sehh1GSa9nd8pI0SUZmAThG4My+7
 /QxheLRi70o5kGn1nXfnuf1YdHCL1/B03fB9JfyUXhbhhbGXm1HgnEUGVS2dGpvCAF6791DQZHW
 L0YhaL+OcokcQkvVkSip794U9YomuTnIIlXrbB5ubsrYqL/leoKhvobHe3g+Z+Yh49OPJHkD0ra
 ReeKSqrznzj32omKSGq/jx9IaGUkOy0jSV6JsZZBA6TmLPrXZ14d5m33DkPoPnU1vaWOTX1t+0I
 r55/HmBzJVEgwpUSp0BdDPx2y+7CTPkPBS9aas7iNNWTSPws+lBk69j/7Y1plfbEAgMvnSpOEjM
 yQUd3VqMvuu+6idexhIAEjPFei8LpR76gxErjKiUY/ifuTg2+6T+tPsO0rgj8Ur4u0dnQQOxhDk
 B3EvQVjFyM2MN5wHw7g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1011 adultscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608270118

Muhammad Falak R Wani <falakreyaz@gmail.com> writes:

> Commit e0fca728a89f ("scsi: ibmvfc: delete NVMe/FC targets as well as
> SCSI") renamed ibmvfc_relogin() to ibmvfc_scsi_relogin() but left the
> kernel-doc comment referring to the old name, so a W=1 build warns:
>
>   drivers/scsi/ibmvscsi/ibmvfc-core.c:1901: warning: expecting prototype
>   for ibmvfc_relogin(). Prototype was for ibmvfc_scsi_relogin() instead
>
> Update the kernel-doc comment to use the current function name.
>
> Fixes: e0fca728a89f ("scsi: ibmvfc: delete NVMe/FC targets as well as SCSI")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202608271026.iMLmrwz4-lkp@intel.com/
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> index 93b9f699c2e53..d1956552698e0 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -1894,7 +1894,7 @@ static void ibmvfc_log_error(struct ibmvfc_event *evt)
>  }
>  
>  /**
> - * ibmvfc_relogin - Log back into the specified device
> + * ibmvfc_scsi_relogin - Log back into the specified device
>   * @sdev:	scsi device struct
>   *
>   **/

Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
