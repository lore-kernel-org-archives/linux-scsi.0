Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF552136353;
	Tue, 17 Dec 2024 03:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734406695; cv=none; b=MdWBY/KfdjC6M8i9me8wF90tpo1ZhiQGNZAS4KM3CJVCcOzUhm2EBeCix51lPPWx/6VLga1lFdvI1Qdr7aqnv+DmEiGaBO5BDT96fgpnCa9etA6U/hwX9hZ3ORA12gGGJVs3JuBDBUqFq0qze5NQyhMW7rrQe/JNF3fqhWH4qRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734406695; c=relaxed/simple;
	bh=RBQ23pN+gWYrDGyVl18tDH6TRZGW4dAt7yodyBwsgyY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pQxXGJvJXxdyB7wEvXDEPz7akBnb1LBkOVPvsMWMMlLjXDAHP9FeNMjiSijAVBQfPgi0GOCGbQIns8xrs1Ap7Ou6Ea3FxnN+bN4Cg0CxwQMVRaKuzaYFv8aPmVwfNJr/pfWHqAnt+goimUgMNpQGtxLlK733KV4TK4Fb1AU1VBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DACmA3vP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DACmA3vP"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BH20V3W012693;
	Tue, 17 Dec 2024 03:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=W/EYEx
	Nw7bDLI6vxKJi1hTwK7cusd4HrTgeSMRBNl00=; b=DACmA3vPLI03Wiw9HnOMU3
	HYTXKNpNr+RRBbkirlSSj/eOp0N9gyif2UOC2evgYGK1Kv4Zly1qMXbl5qSRO0rd
	DXTJAk7/YlZjm9hYbaegOYKE8rR5/z7+ruafb0z6jZ3tOX9zrXBCmKmzORNd7PeG
	TgJyCU1aGPFOqvsjvwbpHUtyYeKjbPUZT4Q7shvaAMAk9sUhokIWUWvy2DSBd6hC
	vD169jIhoVwlyg0O7I5JwIeugK2YW7SBaoDE+WmyUwh7TXa51kDPXUhBQIV6I+H4
	RW2KzvnPbV7QMbLSAoht6bgvXJDwL/D93PxwCzIVs855gJfplR/+3V9mBqPICEqw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43jnp4k5gh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Dec 2024 03:37:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BH1MNct029329;
	Tue, 17 Dec 2024 03:37:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43hmbsh803-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Dec 2024 03:37:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BH3bvcK54133060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Dec 2024 03:37:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C8EA2004B;
	Tue, 17 Dec 2024 03:37:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91D3320043;
	Tue, 17 Dec 2024 03:37:56 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.63.197.14])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Dec 2024 03:37:56 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.9.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 778366012E;
	Tue, 17 Dec 2024 14:37:49 +1100 (AEDT)
Message-ID: <304976a5672d282dea6158725a49f5148790609b.camel@linux.ibm.com>
Subject: Re: [PATCH 0/2] Remove cxl and cxlflash drivers
From: Andrew Donnellan <ajd@linux.ibm.com>
To: Michael Ellerman <mpe@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fbarrat@linux.ibm.com, ukrishn@linux.ibm.com,
        manoj@linux.ibm.com, clombard@linux.ibm.com, vaibhav@linux.ibm.com
Date: Tue, 17 Dec 2024 14:37:39 +1100
In-Reply-To: <87y10f2do3.fsf@mpe.ellerman.id.au>
References: <20241210072721.157323-1-ajd@linux.ibm.com>
	 <87y10f2do3.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 (3.54.2-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3zvAuoMJTgqJv1zFjUgFGI8yN0Sjfntq
X-Proofpoint-ORIG-GUID: 3zvAuoMJTgqJv1zFjUgFGI8yN0Sjfntq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 mlxlogscore=667
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412170026

On Tue, 2024-12-17 at 14:26 +1100, Michael Ellerman wrote:
> It would be good to explain that this only removes support for the
> original CAPI interface - not the Power9 "OpenCAPI", which is still
> supported by drivers/misc/ocxl.

Agreed, will mention if/when I respin this

--=20
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited
