Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEB0847A;
	Mon, 17 Jun 2024 16:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718641629; cv=none; b=nhvLdTi08nG7xl3KlhRG9FV1nDU8fjaNHm96L9WO47eNz4QObq/Kh5LZsFcV8dKiFjDBvLBq0dEubIeX22ek3Q4aCtEyg8A/sHHjQiM0b+bw5zX86oUzWy7AqB4Vw5x/iS68Ys3HSSQLGMT+rfYLz1ghoRUL3T4FSJTBqYl1i0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718641629; c=relaxed/simple;
	bh=0/6abZk5ZE85wavkIEAyzY4LlQExR0Y2+tLnbsqpdmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jAblHkeuJ4v/ARTf+ypPRc9LvK8E8ikLlidFGs4ifzWQBR6JslMRsb1lxt1dZ2tVFs+OQ8SkDsSxCAUjYyf8Cl2bV/xka3cmN5XJPOVWFt1zuKmkxmz5BGuw2NDQI4crdLCZlpDqsGxibu8n7HHTrnVfB6xnXaxk4qwS/SC6xFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=V0nx8uWD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V0nx8uWD"
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HFBmBI017348;
	Mon, 17 Jun 2024 16:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:sender:content-transfer-encoding:mime-version; s=
	pp1; bh=VTc09ubFYqY6mCTK5Mk8Kez39VZQ2PV5LBLtFCzOVY4=; b=V0nx8uWD
	kFGPsDNj7Rw3yBs4lvqLPXS2I0cDA7HUT0NcLagwXA3o1HOyQbZu8UD/Xd/FYPyt
	KNBgnf9wvB0HZUy2ccuW6F0EYV3IKlPYTOyq3qlpZWMq/cCn7BPx2L+Rhoy/HOA+
	4p6cjV2n3VW15woFe8FPymf4yjuxLQ7ZosMhirY5eyUApxjb94sPFaaD2NxuM+k/
	d7DvcvtLdCTAUb8b8jFypb08fU/NjJ+LIBoyKplawzh6IY24QYUUbXOZc6TpEw0q
	qUc6N0lFLqrgkEU4BjcJn6uzuFlBG0sqtmQZFIONBgXY2aQLifBqDo9oZSgVgQVR
	IkmBT0+RohwPFA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ytqjsg6bn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Jun 2024 16:27:02 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45HF59hL006189;
	Mon, 17 Jun 2024 16:27:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysn9uc077-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Jun 2024 16:27:01 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45HGQvv329360852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 16:26:59 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B24382004D;
	Mon, 17 Jun 2024 16:26:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DFB520043;
	Mon, 17 Jun 2024 16:26:57 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.0.249])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 17 Jun 2024 16:26:57 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.97.1)
	(envelope-from <bblock@linux.ibm.com>)
	id 1sJFC5-00000003rsM-0mY0;
	Mon, 17 Jun 2024 18:26:57 +0200
Date: Mon, 17 Jun 2024 18:26:57 +0200
From: Benjamin Block <bblock@linux.ibm.com>
To: Li Feng <fengli@smartx.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Keep the discard mode stable
Message-ID: <20240617162657.GA843635@p1gen4-pw042f0m.fritz.box>
References: <20240614160350.180490-1-fengli@smartx.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240614160350.180490-1-fengli@smartx.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: irVYAC7UR5bD72So1S2kM96demW93PoF
X-Proofpoint-ORIG-GUID: irVYAC7UR5bD72So1S2kM96demW93PoF
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
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 clxscore=1011 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406170127

Hey,

On Sat, Jun 15, 2024 at 12:03:47AM +0800, Li Feng wrote:
> There is a scenario where a large number of discard commands
> are issued when the iscsi initiator connects to the target
> and then performs a session rescan operation. 

Is this with just one specific target implementation? This sounds like a
broken/buggy target, or is there a reason why this happens in general?

And broken target sounds like device quirk, rather than impacting every
possible target.

> There is a time
> window, most of the commands are in UNMAP mode, and some
> discard commands become WRITE SAME with UNMAP.
> 
> The discard mode has been negotiated during the SCSI probe. If
> the mode is temporarily changed from UNMAP to WRITE SAME with
> UNMAP, IO ERROR may occur because the target may not implement
> WRITE SAME with UNMAP. Keep the discard mode stable to fix this
> issue.
> 
> Signed-off-by: Li Feng <fengli@smartx.com>
> ---
>  drivers/scsi/sd.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index f6c822c9cbd2..0165dc70a99b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2598,7 +2598,12 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		if (buffer[14] & 0x40) /* LBPRZ */
>  			sdkp->lbprz = 1;
>  
> -		sd_config_discard(sdkp, SD_LBP_WS16);
> +		/*
> +		 * When the discard mode has been set to UNMAP, it should not be set to
> +		 * WRITE SAME with UNMAP.
> +		 */
> +		if (!sdkp->max_unmap_blocks)
> +			sd_config_discard(sdkp, SD_LBP_WS16);
>  	}
>  
>  	sdkp->capacity = lba + 1;

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Wolfgang Wendt         /        Gesch?ftsf?hrung: David Faller
Sitz der Ges.: B?blingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
