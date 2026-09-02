Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC073374A05;
	Wed,  2 Sep 2026 08:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788337511; cv=none; b=kOc1stqjo+lu+AtvqyoS3NELQpoaqsGCeyjNI3ToE0DIN7M6Q/DxAzYeIb7S3xC9SsC3ThOF1juRgbnRjZBbmqJTqkWT92MbPyJ7fdAHHkaLEt2jrgLzDTF9EXsft2QOkVXMcaDcQ5J4iyzYHEhmKSPaXIfq9G58PfaS9m5G6qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788337511; c=relaxed/simple;
	bh=UdyrN3/U8VdGp4XXCzCeYZ4Uz4lJJNwfz48AuzS9i+E=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type; b=DBSkkXZabLqT2mQXISWeFEM8Ww+BADZSyAZFxUfkC2sKo/MEuMZKQ2Vf2osEgOemnhrENso6yp+3PHB1gbR9yvcPAlWgt6nDA7050iGOjcxuEgt5ub31rjcmV6IBuiOmKWG1oQXgdc3G6K2O9si+WIRD8n8OHm2OkUgRWPx0Drc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dAs9rlFs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dAs9rlFs"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6826VZNm3443019;
	Wed, 2 Sep 2026 08:25:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=DCJq27sFTDzJkMBr8Lu1Ideau/rT
	iYJ3E2ClQz6IU8Q=; b=dAs9rlFslmpKYyo2aTYnwuRngGQb2I+SaiR3G0a3eAcl
	CrlR7hiCSaXmI1GIYqq/fgQmO1Gb94mD8d+ee1ZKqp+Fkx8EoR7kdtQJkRV1MoL9
	RCpvDMSJdaFM1zVQQzoxKQkKmgFwgKmWXSryDhdTBWYa4kCvFsbOLLQOcSeqniFY
	cKsNRc3rvT+vppoNqD4AP2upNqe+6p+3FnoRf8+/Bk84Y/rHbKcz0utNMt34743f
	4EHbgNAtZj5g2m70H1Yci8tlEOiVy9ozMziDPWUIZzfaux0Z7JLwdvMD0BEUkgNC
	QJkLIjcGfv3OisPH5gZ3EnRH9jl522KbjaPbtT3rHQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx5n82y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 08:25:06 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6828BGTH013076;
	Wed, 2 Sep 2026 08:25:05 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcark8kkk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Sep 2026 08:25:05 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6828OMSh25690828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Sep 2026 08:24:23 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A348B5805F;
	Wed,  2 Sep 2026 08:25:03 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4514058051;
	Wed,  2 Sep 2026 08:25:03 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Sep 2026 08:25:03 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 02 Sep 2026 13:55:02 +0530
From: pavrampu <pavrampu@linux.ibm.com>
To: tyreld@linux.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        brking@linux.ibm.com, linux-kernel@vger.kernel.org,
        davemarq@linux.ibm.com, venkat88@linux.ibm.com
Subject: scsi: ibmvfc: Add Kconfig dependency on NVME_FC to prevent link
 failure
Message-ID: <327877a29337aa526cc50ac88fbddb86@linux.ibm.com>
X-Sender: pavrampu@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a97dd62 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=KV0qnSzFbSyW-vh9ucgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: tVV4hL0Nx_aFmcknFOSdAeFQJgeMtYoD
X-Proofpoint-ORIG-GUID: tVV4hL0Nx_aFmcknFOSdAeFQJgeMtYoD
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA3MCBTYWx0ZWRfX2osMd95r+Px3
 KQd9t2Yp8Z0EOrYpLweiWzK1YEKrmqmWcMUmGmZdE009NVY6IeQZSeb/uReOJU4BGc+idEQXtO5
 oyJOuyUdRKdXz2dYC09T/m3lGgNDP88=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA3MCBTYWx0ZWRfX/ai1d3oEoLd5
 Z1rLe+QbZeYvlqNcQvsUlduuRWPenEIetc/oZpZ56CxI/NSDbjQLZG3wfqcU0ka6TpCZ3f1u4gj
 0CnNrKl0wUDG8AVKtH/uxtuQEZBGhVX5N480Sm+qEGBfhNBOH1Je5jK3PYRP6FnPSojago9i84K
 Cusm8b7hiVCtUeal4wI2gwYqrJb87kd4x5k8sUtqW6HHt2viqNPVTcCAb2vOa1vkoVR7TwNRGrC
 B6c4s0A+KkvqzTJ3hfr+8tKD7vh6wQzLLSr1PLVJCq6RJyoPYrSuhx0P3FblZEWtQvad4plrJCQ
 RvZWRrME8WwHm19fY52unMdkJ8kgiJaB96CSzNZBfucaRFGGQw0e4rR74TUKnCyBX4QlDDxh5XT
 ooBighHECuF1uEOr6LImi4ZUgfVMYOsT1nB1LTMYvimXKPBCY0xQeVw6vZiluxAk+/Tej0hlrpP
 UM0VM5XkjSrLMXQpgSg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_01,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020070

Hi,

I am seeing below build failure with latest linux-next repo.

Description:

Building the kernel with CONFIG_SCSI_IBMVFC=y and CONFIG_NVME_FC=m 
results in a link failure when building vmlinux:

Build failure logs:

ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function 
`ibmvfc_nvme_register_remoteport':
ibmvfc-nvme.c:488: undefined reference to `nvme_fc_register_remoteport'
ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function 
`ibmvfc_nvme_unregister_remoteport':
ibmvfc-nvme.c:515: undefined reference to 
`nvme_fc_unregister_remoteport'
ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function 
`ibmvfc_nvme_register':
ibmvfc-nvme.c:536: undefined reference to `nvme_fc_register_localport'
ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function 
`ibmvfc_nvme_unregister':
ibmvfc-nvme.c:565: undefined reference to `nvme_fc_unregister_localport'
ld: drivers/scsi/ibmvscsi/ibmvfc-nvme.o: in function 
`ibmvfc_nvme_unregister':
ibmvfc-nvme.c:565: undefined reference to `nvme_fc_unregister_localport'
ld: drivers/scsi/ibmvscsi/ibmvfc-core.c:6798: undefined reference to 
`nvme_fc_rescan_remoteport'

If you happen to fix this, please add below tag.

Reported-by: Pavithra <pavrampu@linux.ibm.com>

Thanks,
Pavithra
