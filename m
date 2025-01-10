Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BF5192D9E;
	Fri, 10 Jan 2025 21:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543797; cv=none; b=LT57ZWHjzUrEZGjNhqo08YU47xtNMl/aphuedBVD0w94Wh20W8ewP/A1XoO4qbJFfEunoZuOXvovwE4jo00mhoozML5Z+qZQkQnnWtR8hEK36wC6gO+fb78ZmMqI0Ms6XhXzJGXA72qOty6x8ZwYYKeFsM4ziIRduTC82GHdBx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543797; c=relaxed/simple;
	bh=vJ2dITMhtmUhbiA6h/OejQ6x/cH9ESsAh0ZNs8yJy1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSEeM8cd8OvyjzaZdvyX5vbzM1jisNq7ZkgSd9vrzkIbo/TGHIwMAYUxFaUmanGN0W5TSdHcwYCPjZV7LMiFoS87OLT+zF9hSSR/DpTYruZCETl4JW5oBzjQgpeboQr8fTPkkQJRpnbHjN2Tk8xozreRe5Is6U9I0THR9ASsvXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LuezBWnK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LuezBWnK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBofw029012;
	Fri, 10 Jan 2025 21:16:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=PcrKpWHQutbYtzHy473GU8EtYOWc7ALxVzHc2/8Eu0c=; b=
	LuezBWnKMeoz2JfEBoE1XOonjVf6rJs/k2J/BKd2oB6tvfZEQCN1NEMhk4Tuqi0H
	lTvjR0dopxw44Zxhni4OlibCHihKQq9gJik0xbumFJFmUDkMRC2TW107NVTKfC5Z
	TIda0NBqU1Rnt8Z3X6nkMjASf/9qN6Bpfkau+iXuKFVnorAM9aAZlLdQWyp2OAs0
	Mm3hiQhg+3aIt3weVcprYv/C/g4LgUOMuT1klXaRhy8SYztGoBt8/3KVGYINaiKF
	P9rqdwM5r5sVeKApsmURuwNdGmPmcykVDwow2pAO2B9HuMBnqnwHLxg4MnF9RZqm
	T29vTWF15fyeSzA+VxGnrw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk0c381-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:16:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKvM8U019872;
	Fri, 10 Jan 2025 21:16:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xueka8rd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:16:16 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALGFfp021917;
	Fri, 10 Jan 2025 21:16:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43xueka8r5-1;
	Fri, 10 Jan 2025 21:16:15 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: michael.christie@oracle.com, Xiang Zhang <hawkxiang.cpp@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        open-iscsi@googlegroups.com
Subject: Re: [PATCH v3] scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request
Date: Fri, 10 Jan 2025 16:15:48 -0500
Message-ID: <173654052312.609313.3667426682604028029.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20250107022432.65390-1-hawkxiang.cpp@gmail.com>
References: <d9be3663-f6f2-4a1c-bd88-2a3978f92bb1@oracle.com> <20250107022432.65390-1-hawkxiang.cpp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: 8tjU2TWDPjTiTb6sziGKMF4RIyGFh0wU
X-Proofpoint-GUID: 8tjU2TWDPjTiTb6sziGKMF4RIyGFh0wU

On Tue, 07 Jan 2025 10:24:31 +0800, Xiang Zhang wrote:

> The ISCSI_UEVENT_GET_HOST_STATS request is already replied to
> iscsid in iscsi_get_host_stats. This fix ensures
> that redundant responses are skipped in iscsi_if_rx.
> - On success: send reply and stats from iscsi_get_host_stats()
>   within if_recv_msg().
> - On error: fall through.
> 
> [...]

Applied to 6.13/scsi-fixes, thanks!

[1/1] scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request
      https://git.kernel.org/mkp/scsi/c/63ca02221cc5

-- 
Martin K. Petersen	Oracle Linux Engineering
