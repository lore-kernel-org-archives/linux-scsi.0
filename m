Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F0015383C;
	Tue, 18 Jun 2024 08:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718700439; cv=none; b=cnPrkGg7f1+XWupyvi5750UzqiCHRpy5RhVS3Nfs442Wv5o8QRT/Z5y4nUing99GJRuSTgcTnL+tH6pYM7IToFscuP1I3a4S23aw/3OvjMUYmJ5oS2Lg828mMwM8cjYW5SMKQEz3TTI8jqLEWfmLmB0y/OTRE20dKM90mTPv0Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718700439; c=relaxed/simple;
	bh=IJBABfjAh0ttcgppmfOXhHAXlhKIIJ7UV1d5Jx+ypyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kUL1lgUPpVAxZnYJCxrnSoUokev+xyeJc4Flp0WgAOM38ubx0lTRbmKPB4wi/N4Mn5L4HBAX3Qr5KSD/NrJJDdvyBtvIAowDb/wUXz0f3C35H+jnoJa6mwUK9WvQH1rZa6F4uyWu0j/5yNF6AGfD23pcFbX5HkaHKH2gA8BZt8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=shhjpxUb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="shhjpxUb"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45I7VsCa027658;
	Tue, 18 Jun 2024 08:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:sender:content-transfer-encoding:mime-version; s=
	pp1; bh=XwFJTtSJoTEXJS1zghGN7Es3hsEk5ci2iZ/dPo3C2Gg=; b=shhjpxUb
	fYnjnZDC4IwoSLxeS/KBklBllUaktkKzcArY6BlLtep3AJ2CSeytPIh/vLM6V2i7
	kBXEw95o5836dSqiQpOGEbXJpBGh00lM+mWcxZdMISyjGFF5ps371i8u5kWqd+LL
	83fpZJ4KHFlgd3Vyp6BOFlC22cZbbOtnkLOVLgwM9rThmYCN1/9AR2HRDZ8GowG7
	OJ6OOOg/ebLob/0qp02fRlijL7Z3OjHYypnamzfLPd7ldXsly+WoflEHqrFMZZWt
	YPDsn9wuRtrUZBVAmKziJmtyhdwFLaSREaneqY8W7XyKu+AJwNSNjQVrAZ5JJRLX
	zjZYoRvbifwnQw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yu5wx85yr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 08:47:11 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45I8iD7g006189;
	Tue, 18 Jun 2024 08:47:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysn9uhmut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 08:47:10 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45I8l6gn51511714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 08:47:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D930D2004B;
	Tue, 18 Jun 2024 08:47:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7F4D20043;
	Tue, 18 Jun 2024 08:47:06 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.219])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 18 Jun 2024 08:47:06 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.97.1)
	(envelope-from <bblock@linux.ibm.com>)
	id 1sJUUc-00000003vRt-21hT;
	Tue, 18 Jun 2024 10:47:06 +0200
Date: Tue, 18 Jun 2024 10:47:06 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Li Feng <fengli@smartx.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Keep the discard mode stable
Message-ID: <20240618084706.GB843635@p1gen4-pw042f0m.fritz.box>
References: <20240614160350.180490-1-fengli@smartx.com>
 <20240617162657.GA843635@p1gen4-pw042f0m.fritz.box>
 <DBAA6B83-E60A-437C-A8D8-B854E625F6CD@smartx.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DBAA6B83-E60A-437C-A8D8-B854E625F6CD@smartx.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AETSN814Q2MFHvUzJ7pjTcE0pEM1GzK4
X-Proofpoint-ORIG-GUID: AETSN814Q2MFHvUzJ7pjTcE0pEM1GzK4
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406180061

On Tue, Jun 18, 2024 at 11:06:13AM +0800, Li Feng wrote:
> > 2024年6月18日 00:26，Benjamin Block <bblock@linux.ibm.com> 写道：
> > On Sat, Jun 15, 2024 at 12:03:47AM +0800, Li Feng wrote:
> >> There is a scenario where a large number of discard commands
> >> are issued when the iscsi initiator connects to the target
> >> and then performs a session rescan operation. 
> > 
> > Is this with just one specific target implementation? This sounds like a
> > broken/buggy target, or is there a reason why this happens in general?
> > 
> > And broken target sounds like device quirk, rather than impacting every
> > possible target.
> 
> This is a common problem. Before sending a rescan, discard has been 
> negotiated to UNMAP. After the rescan, there will be a short window for 
> it to become WS16, and then it will immediately become UNMAP. 
> However, during this period, a small amount of discard commands 
> may become WS16, resulting in a strange problem.

Ok, interesting. Do you know why this short window happens? 

> >> There is a time
> >> window, most of the commands are in UNMAP mode, and some
> >> discard commands become WRITE SAME with UNMAP.
> >> 
> >> The discard mode has been negotiated during the SCSI probe. If
> >> the mode is temporarily changed from UNMAP to WRITE SAME with
> >> UNMAP, IO ERROR may occur because the target may not implement
> >> WRITE SAME with UNMAP. Keep the discard mode stable to fix this
> >> issue.
> >> 
> >> Signed-off-by: Li Feng <fengli@smartx.com>
> >> ---

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
