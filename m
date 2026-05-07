Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE5A2F1FC9;
	Thu,  7 May 2026 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778192155; cv=none; b=NNX7AzHlJYtm57qqAdJjb2tyKjuiqs2f3Mlru8gPB9Kcf/GZO6JVL36FOOfcPDYIFjDKW+Kqm4rudNL4DEbaYoAinilxi5VKp14zQRibE8XTCI0lk/14j9+XpH5D9+k7iQWo8y9XK2mKaDgsZuzg4crcZtvPClU4guWp+VIZX7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778192155; c=relaxed/simple;
	bh=pd82kARYfF/OWtzxBeksCCwC0hCxORVn9PbdtBQRWWg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GhuxoCX+jgfTTc1B1rLgd6JpSnpIZVISYMF8tLCBsS/B1X/j74XHWBI/Y1265zF6w7OpRjYpdrqY9AgGZalXWeSEaV4PncGuteIoj5Xa3TzKu+Bw0qH69Bml/SsoKC5kWVWv9B2VpVu5b41OqkAZKkb2tiUdwfQAq+0oByf7Ko0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=D4++BCZ3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D4++BCZ3"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 647L9v403352054;
	Thu, 7 May 2026 22:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=pd82kARYfF/OWtzxBeksCCwC0hCxOR
	Vn9PbdtBQRWWg=; b=D4++BCZ3D+7j2LA7GsJpK+bkl9wjKG1H2ZyFs65Rg90pqa
	uPnDbAnyF7UdzabhRFdBTgw8NSrnxb4CpS6k3Qb6Xyu1ZCyTWUGpcfuFpScHEEAk
	U2R8b1KFFUKVWiR552xAcIiUUqoTJddZux4MDd8ogtbK2FugeUxtJ6Js0ktID+Ci
	VIc0Dhh3NYgx4T/8vYvx3sIshdFDvgtwI24Z6AJYmDRpXFy0TprYpKytIEwseKUr
	PaQs46vZx1Ff2HJPGZw9vAz2oMUeTquoSjcSS0MqXrF6t3ZDpeFpJEoEIA/b/V7r
	5tP79wLqQipXlkLExgioBuZF8JbML+DJzJWQ2OyA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxyvyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 22:15:36 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 647LsYeO022588;
	Thu, 7 May 2026 22:15:35 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9yngc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 May 2026 22:15:35 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 647MFYA832768692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 May 2026 22:15:35 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B16BB58068;
	Thu,  7 May 2026 22:15:34 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F21A55806B;
	Thu,  7 May 2026 22:15:33 +0000 (GMT)
Received: from d (unknown [9.61.133.117])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  7 May 2026 22:15:33 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Madhavan
 Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Brian King <brking@linux.ibm.com>, Greg
 Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Subject: Re: [PATCH 0/5] ibmvfc: make ibmvfc support FPIN messages
In-Reply-To: <yq1a4uke7rz.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
	message of "Thu, 30 Apr 2026 12:25:22 -0400")
References: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
	<yq1a4uke7rz.fsf@ca-mkp.ca.oracle.com>
Date: Thu, 07 May 2026 17:15:33 -0500
Message-ID: <87v7cyeuii.fsf@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDIyNCBTYWx0ZWRfX+qjfXbOyhclf
 VezDIHFxM/2ZaMomx2kdC/GdRGbE1+/1yGnmBZLuMcWAz5Szd2przKfe4Hj47azl38hgGTmP1ek
 vdz7/QJShRsvVJ01EzwHquP9Yt6ArO+7+WvSQccpi+NMOfbX6vfadG05YPY2IIaDm4/vcQ2tu9p
 TKKFfS9YhvnQ3lhtUYsyjtOla8EjdYTw0w3CsaMuLOm6cbZVLVxe2jZof+O82nEARdF/X2qmYgE
 C/8wCNPP8B7x31IW7JW6rVsbNqZvfid5US5y49TihMCeSCDhO1sdrgkFuv7WESTKrwIU56YSUOr
 tk8G9r+NKBmV6gf1+WQtcGCxXf+OTXD8zsYIXLoJjO7RUE2Hne15G2Fmfb+yjh63oTWPxpMVa4D
 +fKvlrecgERwGilDJGTF5328qDkaJaL1ykl/stj4wrsyoUNpwBGc5Zv4KVTea9aAIHoJGHasRZ8
 vdfXBDMGFerIaz5K/VA==
X-Proofpoint-ORIG-GUID: Gy7avUC0bnSDmK0CpbJvLuEBhqReEdci
X-Proofpoint-GUID: epTfpkS0T04FAU6WcH2o3u4Rtv0FNcuX
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69fd0f09 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=c92rfblmAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8
 a=WTrqvD6glLJKJjPRz98A:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1011
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605070224

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

> Dave,
>
>> This patch series adds FPIN (fabric performance impact notification)
>> support to the ibmvfc (IBM Virtual Fibre Channel) driver. This comes
>> in three flavors:
>
> https://sashiko.dev/#/patchset/20260408-ibmvfc-fpin-support-v1-0-52b06c464e03%40linux.ibm.com

Thanks for this. I'm working through the comments and fixing things up
before sending out a v2 patch series.

-Dave
