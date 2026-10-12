Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C7A3D1709;
	Mon, 12 Oct 2026 19:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791834662; cv=none; b=IGRFvQGk0xW0e8/5rCgdL3yVHyajsjqyR4VAFv5QnSDiwXPEucNyii/vvakT7pe0TyTsuaHInwLiMlqr1JXjcndB8ERLRd5S5vmJmuNywRgMJJZRCDtiXAFymm0B3yh12sG5w25ZMfCLCfS8MF3HGc28CQQKW4U70q+lMZ2khGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791834662; c=relaxed/simple;
	bh=euZArWPCxXX0NM64FAHlBzPtv86UhVFRwSCEZUr3cn0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NLNECd4luzgbv2YmY78rZFkcCGEkXriMQeFj4ntjoD4OBm9gTjcHPCbNC2T8V1Z9TYnhjAGxEelm1fZI8zi76br/aPBlfJ5rZfdCf/qjIzlBFfcEgcpZxAVZZK74wiUxDhodHG779BQCE631VzjEciXovFVeBtsWwgQyLYc5hb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YzBR/JXx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YzBR/JXx"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CJiHps992347;
	Mon, 12 Oct 2026 19:50:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=J+O3fVyOO2ZbFKIlKlHMfnu+b7bqqO
	98EcUBEWl2d28=; b=YzBR/JXxLZrlOQ3JW26c7OuLMB/TLb9OHSvVpV1F9bCpck
	A0Rje676Zm7NzN8utwneLBdhlKuZ+wEVHmo7Te22JsTN5C/eojXdUd1OjZ6XBI5Q
	ICUjNeXLkLBVtBj5lYpOy2RwKGdb12H1aT882pH+4WUw1OJISCZB/RvHZeOeilZy
	Az9PcLCIk6z9MwMVU36Gy6oubsk9kJMQMyCwqIuev3lrmzSH2zu7Xn/El6Y2O4to
	LSWBN+/Nz9ICYrC4fJUU1vlS1IhKvIKk0CKdpCwyAyuS2hnEsMf6Q4dF1OaKj3le
	mVOx1OuetJ+77774hvCkXA3kXbTHchSuanJtPiPw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dwhtanx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 19:50:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69CJdLMm1828949;
	Mon, 12 Oct 2026 19:50:41 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h802vpt72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Oct 2026 19:50:41 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69CJoeSb2359936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Oct 2026 19:50:40 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2873158060;
	Mon, 12 Oct 2026 19:50:40 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D216A5805E;
	Mon, 12 Oct 2026 19:50:39 +0000 (GMT)
Received: from d (unknown [9.61.18.84])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 12 Oct 2026 19:50:39 +0000 (GMT)
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
Subject: Re: [PATCH v13 11/11] scsi: ibmvfc: handle extended FPIN events
In-Reply-To: <202610100443.UCrGdTXp-lkp@intel.com> (kernel test robot's
	message of "Sat, 10 Oct 2026 04:29:11 +0800")
References: <20261007-ibmvfc-fpin-support-v13-11-b816abfa4fcc@linux.ibm.com>
	<202610100443.UCrGdTXp-lkp@intel.com>
Date: Mon, 12 Oct 2026 14:50:39 -0500
Message-ID: <87ik36vgts.fsf@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA3OCBTYWx0ZWRfX1808nKSq3ova
 cGnqJkKDalWn3VLqoK8CfbVvwXLYKrKogkmmck9azYq+Nf+HuqG6q4AOcX/lj1lUQsifZiuMYKt
 Kk7J4Au/rbTeHEJalU8plNadoSpZZ+8Yq5oR/4JwiHagDp9eretaoy6zWZhUXt6+7LSkQsEsGaw
 R6xIFdTGXeQg+XJ/FA0zdeh1+8/SDZag6YsD92uOv3SS6wE2CqZDR2soIyKEYOvsXDFMKtB131W
 /N2wbjIbv7REuJeTNEVTuSdT8bdLdlJsEoJ9lS79XeKcJGnm1lyhOOmHp+AysENz/3txnx28VXC
 72+XnX3XkiVTJR6oxD+LhHSTa7/niyhWR/S3WPyks8W6avpXA87ZKQhipr4LqfmN6C14869Jvtc
 rw5cNHyK9sGm9pOARaVRMT7OKS2Cie9QV+fKwUQvwV4lHb/C3ybySMG/Foot/KanARql10Urrxd
 f0hLP39yw+2fNcQwK2Q==
X-Proofpoint-GUID: prRqJ9MVp5KbEE0uwBEzkzMsS4JRZ-B6
X-Proofpoint-ORIG-GUID: 0tsrNUyzzcmw0gUPB74Vd-PPPZZ881fP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA3OCBTYWx0ZWRfXzgEnpH3Nk94X
 5aI4p+wwnDzV1t2Yh/VWp6oSZIpE9z9NHbbKitTRkEFruwhOPJgvBwx/xOrYC5jHuMzX3kVmEZA
 uR1ukJw9q89Jb2KPZA4IkGroPAFW698=
X-Authority-Analysis: v=2.4 cv=btHZl0ai c=1 sm=1 tr=0 ts=6acd3a12 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=rGKbgntH6m_7XyyKOiwA:9
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_06,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120078

kernel test robot <lkp@intel.com> writes:

> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on c3cff7fac01638ab58e85fe7df41a04fa25c5bae]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Marquardt-via-B4-Relay/scsi-ibmvfc-fix-IRQ-leak-and-guard-deregister-on-channel-reg-failure/20261007-142545
> base:   c3cff7fac01638ab58e85fe7df41a04fa25c5bae
> patch link:    https://lore.kernel.org/r/20261007-ibmvfc-fpin-support-v13-11-b816abfa4fcc%40linux.ibm.com
> patch subject: [PATCH v13 11/11] scsi: ibmvfc: handle extended FPIN events
> config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20261010/202610100443.UCrGdTXp-lkp@intel.com/config)
> compiler: powerpc64-linux-gcc (GCC) 16.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261010/202610100443.UCrGdTXp-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610100443.UCrGdTXp-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:1914 expecting prototype for ibmvfc_relogin(). Prototype was for ibmvfc_scsi_relogin() instead
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'severity' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3449 function parameter 'wwpn' not described in 'ibmvfc_full_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3488 function parameter 'wwpn' not described in 'ibmvfc_ext_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5505 function parameter 'protocol' not described in 'ibmvfc_alloc_target'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'severity' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3449 function parameter 'wwpn' not described in 'ibmvfc_full_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3488 function parameter 'wwpn' not described in 'ibmvfc_ext_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5505 function parameter 'protocol' not described in 'ibmvfc_alloc_target'

These will be fixed in v14 of the series.
