Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F12C274FDF;
	Fri,  9 Oct 2026 14:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557455; cv=none; b=OwpGpBtoYw76n9BWVuRtvcY3A4A6rJqCdb717i7pm+77BmXKUnTfCAD6XaIuE/RV97zuqkjmySxkHodYMSv4My4sEfd8zjoHIwKqhMRHscFx1uvQj0H7OILDmComCX1ErDwA5pL53AZavqBNTmhp5vKEK4pw0W+lVcdU9h9QU9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557455; c=relaxed/simple;
	bh=6wbzKMWxgT315TuR5uN0BexXHb+Pk12ELgwC4PVXAhg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=b8ub5AmYLx89uXHtc1On5TME/fVz7O4ADeXlsYEoTqellduJlW3Knw3jJgBmbWaNPMXbeiBrjXKjnr6Svyx+RLhnPMzfbKbDtM5TpZiY7QtE87ERezg/n/9edPwqQMacsg54aqu7aWctGNlMOqXEwzlM1rKmF8FSalp18oRosLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VzDX1gGw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VzDX1gGw"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 699DZsKq2626909;
	Fri, 9 Oct 2026 14:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=CJXY7Wnk/7r0imvs3VbDOFACgy+asO
	+sAGljWpb2cBc=; b=VzDX1gGw5cKzSNW6cEw+x2AqjQjFp5QSFrUlyX24bxCHJ3
	F2YaHHq+Z735ynv1UmIkzFfe4Tr49cG2VtPSLT51PKS0TVDNIkyfXKR121RlGpA5
	ppFE9u9EG0OexIhsOusNlOnZtwkfDNC0bn9Ps3+Sa7jhc5dECatZd7LSAKiC0pnx
	1rvrTg/QoEjdL2C975VFnPtS3qStMjewJbORm6L4H0L8qYIVBddFRdEo38OYSSMj
	juHbWD9Ws0PZibiIe+c8jissNR8R5AjETfPjLv28+i9ebAzfSmJqXRVvYlzexdzu
	JkPgJ9960yy3WmCYSTtXtBytIFc40I85CMQIgBIA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjwbct3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 09 Oct 2026 14:50:39 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 699DWUoF965664;
	Fri, 9 Oct 2026 14:50:38 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h6x1y8y6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Oct 2026 14:50:38 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 699EobKZ26215070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 Oct 2026 14:50:37 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D33758053;
	Fri,  9 Oct 2026 14:50:37 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8994658043;
	Fri,  9 Oct 2026 14:50:36 +0000 (GMT)
Received: from d (unknown [9.61.186.115])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  9 Oct 2026 14:50:36 +0000 (GMT)
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
Subject: Re: [PATCH v13 07/11] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
In-Reply-To: <202610092107.e7gHIyl7-lkp@intel.com> (kernel test robot's
	message of "Fri, 9 Oct 2026 21:22:57 +0800")
References: <20261007-ibmvfc-fpin-support-v13-7-b816abfa4fcc@linux.ibm.com>
	<202610092107.e7gHIyl7-lkp@intel.com>
Date: Fri, 09 Oct 2026 09:50:35 -0500
Message-ID: <875wzblyh0.fsf@linux.ibm.com>
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
X-Proofpoint-GUID: Nvi8lBDXgLGbGAFoydLxx0EscaXw_xi7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA1OCBTYWx0ZWRfX8nhSGSMU/o6+
 rmr9gSHC+SodgI5RWlA4mrTcQP6JU8t0dLe32LvKneJL4G5bUUDiormkMqhwrY3lhfBY1fxqe0Q
 ms/7DK4FUMVm7biDyyvuVGvCwgdjsL8fh86iKRo97IG61TJ4A3nq+psL9EwsqeudAWNvY+BgEYv
 OvGDy/5uJR1vCkGc1w5LVxhxVtPApCzoCLwszY5hNr/OVJBQas/99jtrisd8IAX6BHaof2OLE3h
 oFynOI/P8ZApY+J1Is+gP+eh8xM1CyBfHwV9Cy1EyKJ2+y6qdJkobRZ//zRnoMJMvTNxquMMMUE
 EN/uTyj4Dbx6+yQoOruhIZuhBYJ1DIkRVEInSTSTPLgnUzBi9mY5muV6jBHsXkF3MPKpzrTJg27
 1YEDqzgq+QkvLR4FOjKUWmIkFxVTeIpPlN1jLxQSDFsK/OWycABRIA/3pUMIdPy2R3ANGYX0h7V
 JvGJyyKjY/JEmNLWUWw==
X-Authority-Analysis: v=2.4 cv=cIt1IVeN c=1 sm=1 tr=0 ts=6ac8ff3f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=rGKbgntH6m_7XyyKOiwA:9
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA1OCBTYWx0ZWRfX1bEajKfC1G4Q
 SPFIbnRjR5caIsuif+cYSU8rlldy4suQ8O4b2upwjH+HqZDGBLJQwpRz1ErQvRA9uqvFycCfYXW
 vnKDo7Izzab+MFg7Hvs5r/Pa53Uvcxw=
X-Proofpoint-ORIG-GUID: 7oODzyogXSXTS9Ypw9Bebr8UGgJUofp5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_04,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090058

kernel test robot <lkp@intel.com> writes:

> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on c3cff7fac01638ab58e85fe7df41a04fa25c5bae]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Marquardt-via-B4-Relay/scsi-ibmvfc-fix-IRQ-leak-and-guard-deregister-on-channel-reg-failure/20261007-142545
> base:   c3cff7fac01638ab58e85fe7df41a04fa25c5bae
> patch link:    https://lore.kernel.org/r/20261007-ibmvfc-fpin-support-v13-7-b816abfa4fcc%40linux.ibm.com
> patch subject: [PATCH v13 07/11] scsi: ibmvfc: extend async event handlers for async sub-CRQ events
> config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20261009/202610092107.e7gHIyl7-lkp@intel.com/config)
> compiler: powerpc64-linux-gcc (GCC) 16.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261009/202610092107.e7gHIyl7-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610092107.e7gHIyl7-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:1907 expecting prototype for ibmvfc_relogin(). Prototype was for ibmvfc_scsi_relogin() instead
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3442 function parameter 'wwpn' not described in 'ibmvfc_full_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5367 function parameter 'protocol' not described in 'ibmvfc_alloc_target'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3321 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3403 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
>>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3442 function parameter 'wwpn' not described in 'ibmvfc_full_fpin_to_desc'
>    Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5367 function parameter 'protocol' not described in 'ibmvfc_alloc_target'

I will fix this in the next revision of the patch series.

-Dave
