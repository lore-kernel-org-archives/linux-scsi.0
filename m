Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC9037EFFC;
	Thu, 27 Aug 2026 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787839767; cv=none; b=b/bZrtoWe8SSH8bP3qmrob/Gw7SXpXBflWNVFWGywOKmjN5yjvm7eDnnEFb/xTWoVktSuRB4QZJGTci7ZzyK9KigaqpBM+QhanjNxGPOfpQ75ZX9xCq70TsY/yaJ8BxeeHYRKC7i0pHhh9aENCo9MGnDitj68sGh7XWCaldUnJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787839767; c=relaxed/simple;
	bh=bJmHR+jM82Vh+uUSr3JWAUhCl5Fw0TzXMF+EszTuPSk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Bc07tUMcjaiRByR/omSgCRAA6qAcwHyV5xO4TRxBHzkfAot0zVjyDBbQRCKlNcBdQaIPg24VkB3B3FASVc/HxVjTouWUdswegTeG5BAcRn8MVDAhMtxMzUiPy6ChH/pa/sZe6DHNGh8LwWA7tHTp1dxkkOGbzHkkhEkw5rBFMx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XeOxH0Ba; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XeOxH0Ba"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RCVjgA2892044;
	Thu, 27 Aug 2026 14:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=jUv72F1CZ2VZ+muiH7wSHWEPJWb0Nf
	GiT0vKTZxrsRs=; b=XeOxH0BaPo6EierO/OxycqYOzcQRTwh4WU1oC4Xv7n09DQ
	fgOZXSK4w6d4p0LmaWR3lhyNmlLqRMzRzVyzyu+PbyZGdNElSlT54ffN6wXsMpgj
	0kucTuCH541MWXUPjHgA7whfCi+7dtSNyFfcoElTYdF697B2C6f7TBSs1Wcqa86m
	7Yj3dhvVa6pNWBKWKV3EASu3bMZDjjnJcjxM6DmCetI14jaIFUggeD+7tRTS/0kg
	PNc3rpAp2us15UVRGERphlEF8e1HC8xzgMCFIAHZu4X4nhNPbguyLlGz41rmmjVE
	dnHnqtWznxDdVeyt08/ijLWmbgWAyH3Akc1Jl2Jg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g716j5vc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 14:09:06 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67RDuSn2014432;
	Thu, 27 Aug 2026 14:09:05 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7qkhgcpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 14:09:05 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67RE94lq31326892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Aug 2026 14:09:04 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CD7558056;
	Thu, 27 Aug 2026 14:09:04 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 602C258050;
	Thu, 27 Aug 2026 14:09:03 +0000 (GMT)
Received: from d (unknown [9.61.140.220])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 27 Aug 2026 14:09:03 +0000 (GMT)
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
Subject: Re: [PATCH 2/2] scsi: ibmvfc: document protocol parameter of
 ibmvfc_alloc_target()
In-Reply-To: <b073968ae020b6ae0240e91341a92f428587ebd9.1787828961.git.falakreyaz@gmail.com>
References: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
	<b073968ae020b6ae0240e91341a92f428587ebd9.1787828961.git.falakreyaz@gmail.com>
Date: Thu, 27 Aug 2026 09:09:02 -0500
Message-ID: <87tsofzmdd.fsf@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExOCBTYWx0ZWRfX/V83t/o+zq3R
 zDwfzHkmU61fHio0j/y6bbG1SCUiwNMf1JY9mftiEO8h89sNELgcSRpoMyARoGPxEwBvt61ahvt
 vZLU6aSpEkOaW+LFogmdWF3bVadtY+E=
X-Proofpoint-GUID: kxfrtCgwlP2vG6ucvy97NfEMHp0Zm1uQ
X-Proofpoint-ORIG-GUID: 3ursgP67x9H7o8WqP8Ch_7MBJ3WlNbDg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExOCBTYWx0ZWRfXwri3qrqzusuE
 /LrABrdGgAJHGwS2siHeRZpv9LQFsOGk2sPKDxk3XZEpPoEc+QGhuDcYD2DsZz9tEroJEVp+HC5
 5o7k0NhQ0qcTDV8ETENIecgb3HH8CjRPmhf5CWgbqlut3wKNRwg8j/C2iyjJpsegNmeGVx2tn5v
 STjQDldOgOkNnpu9PGFPsoy3Wkt2wTfV4iNW3J+LCgaiZPJJjbbKk34AF7Ml/ASIoxVlcxQagXv
 gEMDtvxtQu+Lm/xEzE/VHKehzx457N56ZtKKM2zjLKTkQ8rHbTu7PMFu8em7Nw8Spq61lZNGCPD
 dCduy59D7iBT+APeYhJXjpI0HcozkCVa59i0ADQEReLMcPCchleRKvvw+0FYSY+TRiGQgD9bJAs
 +x4NolvjKniI+rBZYyZoXfEiXGvDblXFJ5ukGVgdLFEDtrP6XvkyDWtnfCe3dXYe+mr3TO7eHPh
 zJOclFFvRfJIFU1uc1w==
X-Authority-Analysis: v=2.4 cv=H7brBeYi c=1 sm=1 tr=0 ts=6a904502 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=kifdfqukGkPUHOnBEzIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270118

Muhammad Falak R Wani <falakreyaz@gmail.com> writes:

> Commit 249313b3f7b5 ("scsi: ibmvfc: allocate targets based on protocol")
> added a protocol parameter to ibmvfc_alloc_target() but did not describe
> it in the function's kernel-doc comment, so a W=1 build warns:
>
>   drivers/scsi/ibmvscsi/ibmvfc-core.c:4996: warning: Function parameter
>   or struct member 'protocol' not described in 'ibmvfc_alloc_target'
>
> Add the missing parameter description.
>
> Fixes: 249313b3f7b5 ("scsi: ibmvfc: allocate targets based on protocol")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202608270829.lHI1FAdO-lkp@intel.com/
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc-core.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> index d1956552698e0..6fd4c601f978c 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -4987,6 +4987,7 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_target *tgt)
>   * ibmvfc_alloc_target - Allocate and initialize an ibmvfc target
>   * @vhost:		ibmvfc host struct
>   * @target:		Holds SCSI ID to allocate target forand the WWPN
> + * @protocol:		protocol of the target to allocate
>   *
>   * Returns:
>   *	0 on success / other on failure

Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
