Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B43B1E130F
	for <linux-scsi@vger.kernel.org>; Sat, 20 Sep 2025 02:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758335117; cv=none; b=qr1rXNh2bFY9of598vr3QMydkk8QBP5J11tQqd4PUmokb/P86RYztBH0B42/Se95iUPB0Hh4bJYn3Jqoex6VZy7MCqtqDNjGKsMvBdpb1UzpxY4eWKywG4Rp4akqdraVTGDiSFoLFAcwXFWeDdHRiY/CjzSdYIQCc4M+06Z6kmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758335117; c=relaxed/simple;
	bh=xWpv0hJVrsc3Xrh1fYGvVoZvOOXzTF0YkNYLbvJidGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mcPyD8EHPg4C9jTnAvT9j3djzYl2kysXhEn1XejnIHGPEzwqW//HZPdEJ3j+3J2PVY0AQ9lutsnhvQv2q+R0uYaPUPCSB9WrK6c5aTkOZRDIEaucF8JJYoO+NoDdTUYjwuq+W1Jzlg/ao1qZ/Gp/ImGngvL/p49f2t9+AUgmkME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HTNnNTGn; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HTNnNTGn"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58K1j2lh025156;
	Sat, 20 Sep 2025 02:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cKRgoirO3nu3f7uzYLqmRPizqZDEe3/71xti5zhqtF4=; b=
	HTNnNTGnLFntnyyGw9mZHFu8agR+sW3T51w4d/9hXpVXoOCQFgZfv9QvtPBIMIB3
	Vud6rjHMjAhmD1l2LzDbOBeAtofgWQbY+cw0TEUrzWuEgMHrYDNrm+VqEQyLuamB
	jX151cME1bn4sFO97mHmsOI8edb+WAR+zEkPar2EBaXq7QarUgVDcSFPAFhTRPqT
	BxHwnD2vg+A3Oj0yFYY+K/Cov4Hx67AMQpzQWzGn3mY3EyQDgoaWERY2Oy4H6nvU
	ludvtnYvarLdfYQXsVvGzZZ3fTYy1catgNgP+qpW53E9w+bleanD91sHkSvAF08b
	IBvbBCvo1HwR4Hb08dEBSQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499jv100mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 20 Sep 2025 02:25:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58K1XftH019565;
	Sat, 20 Sep 2025 02:25:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jq50p39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 20 Sep 2025 02:25:01 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58K2Lxgf016735;
	Sat, 20 Sep 2025 02:25:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 499jq50p2b-3;
	Sat, 20 Sep 2025 02:25:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Manish Pandey <quic_mapa@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: Re: [PATCH] ufs: core: Disable timestamp functionality if not supported
Date: Fri, 19 Sep 2025 22:24:53 -0400
Message-ID: <175833431697.3341211.10938634506537737461.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250909190614.3531435-1-bvanassche@acm.org>
References: <20250909190614.3531435-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_01,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=656 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxMyBTYWx0ZWRfX4t88fzfdW+jM
 GExsVQJg+okPD4dDMYxczbzi8NWV1u2NwUJEesr1QTKab+oyrvTHOd9ksn7I3vU2v1j/9jzYqPf
 NojGGOAEszqpC3cDL74VBzxgbl7kE8/IUX+3vk2cvtgLqQgnj+U6CrTxPPZuCiG9PUoRROOfDZ9
 EnvgWhEdUybRCKW6jwWiodlOAJa4RFojQ0dM/NG4duiYFox5+7KAcOjUCYakxzqwQXxx3xrqFWq
 jJc6CJHYgkIM4lhmbshcyFTIbvjTNfWir3duu/MXaXLHc1Sr4zJr5PU/+9i7ZrV2Hw+JuOyWTUG
 rZWkX3uYoU7kgS+TiUogBlYPY4lJGMvo27FRNjYsjqdJ79UfwhCeMx6o6OLA4zx+6hfLf60kXbx
 HIXb2bc4TsGA5RYHx0UPsqiVR4ou9Q==
X-Proofpoint-GUID: kV57EtO2E7ItXtJcGxdJ-RwFjTS7GW08
X-Authority-Analysis: v=2.4 cv=YrMPR5YX c=1 sm=1 tr=0 ts=68ce107e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=_eP5YmSwGrn8XW2F17UA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Proofpoint-ORIG-GUID: kV57EtO2E7ItXtJcGxdJ-RwFjTS7GW08

On Tue, 09 Sep 2025 12:06:07 -0700, Bart Van Assche wrote:

> Some Kioxia UFS 4 devices do not support the qTimestamp attribute.
> Set the UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT for these devices such
> that no error messages appear in the kernel log about failures to set
> the qTimestamp attribute.
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] ufs: core: Disable timestamp functionality if not supported
      https://git.kernel.org/mkp/scsi/c/fb1f45683461

-- 
Martin K. Petersen
