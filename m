Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F459224CC;
	Tue, 10 Dec 2024 05:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809319; cv=none; b=RXduTE4VtqVly5RPUAycD+aEt9nzgI+SVNBudYZJv+uIfYa/eUFyMbryqfsaa8ZZ0vOuKX1Ynhy5j0eO0sRc7mw2O2qBXTz0dN3kRoBHlExPSjJdi+Pa587x71RHJpZjmSNL37fkHKVpzuaxK4me6p54Y34jJeLapsnIeKQ1bHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809319; c=relaxed/simple;
	bh=zwJyZKK94b+nYvZJonFFlJJPXj20lAl/lbiUGX4NdOk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=slVIRdPfZt8Lnz6PyOgt5MXOJlLnN/edfMvksLNTQqoLVdMEucEEgQJH2XHAdEpg2610K9ymTqRkhB8qEQJtpzdP7tnjKPWtPNdC1PXhtpv+xlU5K4uRDEfnr1MpN2NehBMeryZG1mpPJa4emtBP7fxJRWCFKbINi8Uk7OncxxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TD3oxNdW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TD3oxNdW"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9NcWlu032615;
	Tue, 10 Dec 2024 05:41:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=2P+jQaWUNjFuD4UCAcPCp5v1vlynyr+oJ6Z2P2dOL
	/E=; b=TD3oxNdWBoqRHX/MVLVygLR+K3+A+AjltyOXkSBROnrdptOlhOqXdKJsL
	q51xJrIjeWvzvuZ0KLgW2386GjMNBijiegqA5CAorbJTCdQkrMvTzkUyROWhrNbT
	esbq2XC60iXRJvF42D7p90HPfleQGlUgDVHn2K+Uotmnu9EUXIcxxc+KMF1XpT0k
	mO0pnvqhgEVaRSpnP5bAD1oY0oYhyTiVMDi5sxXq7MMFFjJ0HGRSVPkrwl1rh0jr
	5AE3fvV9k0mm2o0xLQPfmN+fBxel52wfJifFq7xVOLse1TzPlzWgtOiWTLrxFv40
	lCR8UTyw/sx4nPmM8BJJoFc7+PErA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce0xc7f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 05:41:50 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA59uJi017397;
	Tue, 10 Dec 2024 05:41:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43d3d1hu7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 05:41:50 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BA5fmfE18088346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 05:41:48 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CEDE20043;
	Tue, 10 Dec 2024 05:41:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B3F620040;
	Tue, 10 Dec 2024 05:41:48 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.63.197.14])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Dec 2024 05:41:48 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.5.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 5CC7760687;
	Tue, 10 Dec 2024 16:41:41 +1100 (AEDT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, fbarrat@linux.ibm.com, ukrishn@linux.ibm.com,
        manoj@linux.ibm.com, clombard@linux.ibm.com, vaibhav@linux.ibm.com
Subject: [PATCH 0/2] Deprecate cxl and cxlflash drivers
Date: Tue, 10 Dec 2024 16:40:53 +1100
Message-ID: <20241210054055.144813-1-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rKu_YlGomn6n8q2dRNRVIjGEXP3dN9uA
X-Proofpoint-ORIG-GUID: rKu_YlGomn6n8q2dRNRVIjGEXP3dN9uA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0 mlxlogscore=440
 priorityscore=1501 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412100039

This series marks the cxl and cxlflash drivers as obsolete/deprecated,
disables them by default, and prints a warning to users on probe.

CAPI devices have been out of production for some time, and we're not
aware of any remaining users who are likely to want a modern kernel.
There's almost certainly some remaining driver bugs and we don't have much
hardware available to properly test the drivers any more.

This was previously discussed at [0] - I've decided not to try to do
anything funny with the Kconfig settings as explored in that thread, as it
seems unlikely to have any significant benefit.

This series will be followed up with patches to remove the drivers and
associated arch code, which I hope will be merged in the following cycle.

[0] https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20240409031027.41587-2-ajd@linux.ibm.com/

Andrew Donnellan (2):
  cxl: Deprecate driver
  scsi/cxlflash: Deprecate driver

 Documentation/ABI/{testing => obsolete}/sysfs-class-cxl | 3 +++
 MAINTAINERS                                             | 4 ++--
 drivers/misc/cxl/Kconfig                                | 6 ++++--
 drivers/misc/cxl/of.c                                   | 2 ++
 drivers/misc/cxl/pci.c                                  | 2 ++
 drivers/scsi/cxlflash/Kconfig                           | 6 ++++--
 drivers/scsi/cxlflash/main.c                            | 2 ++
 7 files changed, 19 insertions(+), 6 deletions(-)
 rename Documentation/ABI/{testing => obsolete}/sysfs-class-cxl (99%)

-- 
2.47.1

