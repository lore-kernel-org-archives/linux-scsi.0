Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C79367B8F;
	Fri,  9 Oct 2026 14:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557156; cv=none; b=N6zta6Gwsp+6MuUpTI2wcoO0nKU67lyc8OOgkgqNZ/4J8XbpqbQAXhAdMVXibxlJsI4qPK0vkSsviG32SoG8AoRSGnZ28JDJIHwNKOZJEAAjsSAvpVk1IMCq9vSKl2qKhsuS+wpmyZFVSvrNwM6fcPIAuddmrKYUxPrd47cdbcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557156; c=relaxed/simple;
	bh=rZ5ywZaCEw6+1RM/+8VAilaE7Y/LV1fZVknlMB9PGFg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bTRh8PxxdYNPVOevHKN78JNeSon3DWb/GkpaE7kZSePtw2J4JUz9gwLA1TPSuanvPSlKHvyZU41LcnZrGINqLmmvkp0s99WB5Fo6ZroW545DcLQnkO4zSas7WXEXQyZgsvHjiRQnUWR6n/lW3m3hTuM+cqi1UP8jRvmzcjZbZ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BuVvntKJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BuVvntKJ"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699DZtsN3214290;
	Fri, 9 Oct 2026 14:45:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ZJ2P/ehtfYR76otRuiUkFjUlIWNYpL
	z4lj6YtBrjrkw=; b=BuVvntKJVZl/2049mEym7N/04BXIsgOfmLyS24ttCdERm6
	c3XeV/gTZ3i4ua7+ivf1N0lHsf7YsPS8jeMilBpkIVd99LVAjQKRLMEl7p0fDnnR
	J8Jg0sHo7i+a+JpsyNWNuDWu/VnvTlZV4iRTggWwuXRVKQrBPQy58ZWWkrPEfLGL
	eHOEt8hsLZdsaTE++nMnKQkR0LkNJgMvSTFxSFXsQC9JJ5x7NhFzD3r8om7fXYwX
	Vym4cTf9jspNL6Y6ci0yvIffMvjqW6BpHO99LP3mcyZ+sTNd8jrcthJTblLUrb4l
	tUrqKOQllcDD8ZAf7N6jHSOBoEokMpXVWCd/LO7Q==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xk1jh0d-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 09 Oct 2026 14:45:36 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 699DWVQD965690;
	Fri, 9 Oct 2026 14:45:35 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h6x1y8xtj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Oct 2026 14:45:35 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 699EjX8v61473268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 Oct 2026 14:45:34 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D12AB5805A;
	Fri,  9 Oct 2026 14:45:33 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F47D58056;
	Fri,  9 Oct 2026 14:45:33 +0000 (GMT)
Received: from d (unknown [9.61.186.115])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  9 Oct 2026 14:45:33 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: kernel test robot <lkp@intel.com>
Cc: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman
 <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe
 Leroy (CS GROUP)" <chleroy@kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
 <mkp@kernel.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>, oe-kbuild-all@lists.linux.dev,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 04/11] scsi: ibmvfc: add basic FPIN support
In-Reply-To: <202610091350.pfimX8kZ-lkp@intel.com> (kernel test robot's
	message of "Fri, 9 Oct 2026 13:20:05 +0800")
References: <20261007-ibmvfc-fpin-support-v13-4-b816abfa4fcc@linux.ibm.com>
	<202610091350.pfimX8kZ-lkp@intel.com>
Date: Fri, 09 Oct 2026 09:45:33 -0500
Message-ID: <87a4onlype.fsf@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YtCa1IYX c=1 sm=1 tr=0 ts=6ac8fe10 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=DpkWlw5QTZI3BuQtO8gA:9
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA1OCBTYWx0ZWRfX1DMBQvZ1oV9B
 7K4kf2thLqLcsmX+xF+cju3DKnw+pPMd6SzJR/c6iHHvV/Kwozu0vx328Lnljp2Pg5MLc7eCNmk
 7oV24YBYVA+qGuSYnkFKy0C+tgI9kjM3alEsNefBQlaD3nsSEMjzfGuSwegDBjCgddZGTMTEd06
 E9/QOO+nr4HZz8d8neudpyfZ+x4chUNn2UKDdojI0ayqz8XWrFhE0qkbhWZpvGbAsGCjv1ku+oH
 +JDrxVv91VIiO3vvLzN7O1SC94zi08PAVcgN5KTGhrSSfGr5JhobT7xNkmYE1fSOdap6f6KzxmJ
 IMqW1jiQS2Aap5AKtDcPEZv76LkK/ad3GzHpNyk8UxqKYNXJ6TKUKj2+6ld3U9AXZ2Zv/fAp62t
 My+MfXVoAmsBHvshu7+tXQ8SwoGL1WbSfGs10RW0aXIy4qUa7CRcb2ehR/fL/A0/1Cjc3rJnRf5
 cFrijtfoc7dFQcbNRng==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA1OCBTYWx0ZWRfXyaK1dWi2ofc9
 k1X8YhHuZbTXhbAlWTqAvWSp0tWPHIG3af7B8ObMZp6gQXNqGDV0yhJcP8KNug+6zBTopO+monS
 DhxGCp+FWomo7oilnatHeaW2q7BOxnY=
X-Proofpoint-GUID: 4fX-i6NOi1__0d4TrwOlYkjldxZcFa75
X-Proofpoint-ORIG-GUID: OT9yZWI9hT2Xar28hNGoK32M5rS05EoP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_04,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090058

kernel test robot <lkp@intel.com> writes:

> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on c3cff7fac01638ab58e85fe7df41a04fa25c5bae]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Marquardt-via-B4-Relay/scsi-ibmvfc-fix-IRQ-leak-and-guard-deregister-on-channel-reg-failure/20261007-142545
> base:   c3cff7fac01638ab58e85fe7df41a04fa25c5bae
> patch link:    https://lore.kernel.org/r/20261007-ibmvfc-fpin-support-v13-4-b816abfa4fcc%40linux.ibm.com
> patch subject: [PATCH v13 04/11] scsi: ibmvfc: add basic FPIN support
> config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20261009/202610091350.pfimX8kZ-lkp@intel.com/config)
> compiler: powerpc64-linux-gcc (GCC) 16.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261009/202610091350.pfimX8kZ-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610091350.pfimX8kZ-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:1905 expecting prototype for ibmvfc_relogin(). Prototype was for ibmvfc_scsi_relogin() instead
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5258 function parameter 'protocol' not described in 'ibmvfc_alloc_target'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3319 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3401 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5258 function parameter 'protocol' not described in 'ibmvfc_alloc_target'

Thanks. I will fix in the next patch series revision.

-Dave
