Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC95B2233B
	for <linux-scsi@vger.kernel.org>; Fri,  4 Oct 2024 02:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728007737; cv=none; b=GkpeP0OcYLIVlmjtcf3hJAkfj/b66KSBSt21Pvt2qeVQ1WVw2dwPSWnmN/4P4lcOqddcD4Z8P/qigybC1v61uY/LSFCdzSNuW/YaJkApeRgqr8hvBypcvCnMNi9PLeSqdtVyM56xhtMwh4d3udxG9Zw3uw5xvL9we1dYrBkf6/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728007737; c=relaxed/simple;
	bh=EGWR3j52dtfa2Lt4+du0hy5r7KlN5ulNJ6fYbPTojp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UeehW/7k1IExaJWNHioDFYKjQm3VWjaMfKei55oWMbrDRxRG7XMVn4Ia6gPrrs1M1AiTg76pisQgnTQ72cKhwBpqw6UzrIpvbEe4HCOa5w5cqn3xyZY39MSpAEEb/CVoXtfGyemzoA5S23ofGVjn8PVhOm8XwMvYE1+3W6tITcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ox3c2ofQ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ox3c2ofQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940teqm007652;
	Fri, 4 Oct 2024 02:08:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=vx9+klNqPX8/tJHidV7ntFpaFP42R2MOPgcT7qgfq9s=; b=
	Ox3c2ofQPV6RO8lwn6JzEeUOaDlbSuCIcC11LVKy5vX2ixxisJmyMKST7REs+uNE
	5OwIspvPxC0AX0lluXWvILou0w/3ACi2xYdJzAA+uIU0ID/krCfujB3PVTNT8LwF
	Y/6SuITtZa14McJmc/USKTPvHfAfZzWqUKUC2xewvtzk2G1dnh/2+F6KQRUC04i+
	1YuSqEQLMER/a7LH2lXqViDR5lBmMindL209DkeLJwWUN//4fdD4DUJL+eO7sqvl
	auOIz1mgKZvgac5c2qGYsNx6OjC4dC7wIZqAqkTL5fHDI5zh4HXisnuYkZfJBRBj
	HSo0iz/idXwVyEQSskRIOQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4220498p41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 02:08:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4940Pa29039058;
	Fri, 4 Oct 2024 02:08:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422054pb1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 02:08:48 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49427ble036075;
	Fri, 4 Oct 2024 02:08:47 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 422054pb11-2;
	Fri, 04 Oct 2024 02:08:47 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Muneendra Kumar <muneendra.kumar@broadcom.com>,
        Benjamin Marzinski <bmarzins@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_transport_fc: allow setting rport state to current state
Date: Thu,  3 Oct 2024 22:08:07 -0400
Message-ID: <172800766877.2547528.3834426548801513483.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240917230643.966768-1-bmarzins@redhat.com>
References: <20240917230643.966768-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_01,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=824 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410040014
X-Proofpoint-ORIG-GUID: 6_ocwZDOgcdPqASDNxUO-v5_bA9vmafG
X-Proofpoint-GUID: 6_ocwZDOgcdPqASDNxUO-v5_bA9vmafG

On Tue, 17 Sep 2024 19:06:43 -0400, Benjamin Marzinski wrote:

> The only input fc_rport_set_marginal_state() currently accepts is
> "Marginal" when port_state is "Online", and "Online" when the port_state
> is "Marginal". It should also allow setting port_state to its current
> state, either "Marginal or "Online".
> 
> 

Applied to 6.12/scsi-fixes, thanks!

[1/1] scsi: scsi_transport_fc: allow setting rport state to current state
      https://git.kernel.org/mkp/scsi/c/d539a871ae47

-- 
Martin K. Petersen	Oracle Linux Engineering
