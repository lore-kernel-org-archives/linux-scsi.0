Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CCA1FC7C2
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 09:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741079274; cv=none; b=Vfdbe31bv4G95JIigfwgFsFx7XPq3+UdV5TqW09sUXBd9+eH/NcPpohVmuHxGYCNxl1/KyNuOIP1hVnQ7QgcuapSRk8W/cc1ZXruPgVviysErRq4ii4rvhYzCZ41WYMaiC1oJJJtt2XsG10Cap+GSZufEkGEtVq9nK8/b23puVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741079274; c=relaxed/simple;
	bh=HlRuJsObdmTIXLy2gntSExiNIMT953QBK+Wk2BF7v2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=tA00W3bZ3fJKpBurlLVkJvwrJbYkN3YYTB5X+7Z2rLdA8rG2TS27fBpA/bM937H680wjab1HCPXApgTE+gX3JSyff5qvTQp3prfTa33azDUkbtgp4HotzMBUaN1uEBxQIqY9gdb9sq4hkIYMzA14EZEZBXa/j+i1a1RIVsWUulc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=j6JYOB95; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="j6JYOB95"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250304090749epoutp037c010e5806be108faf6f6df0c40d6231~pjl7ps-I41299912999epoutp03J
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 09:07:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250304090749epoutp037c010e5806be108faf6f6df0c40d6231~pjl7ps-I41299912999epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1741079269;
	bh=lYUkzFUtjAJu2r8Sfk/2FkWYl0bsmp8WMCZ3jAWLAa0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j6JYOB95C/pmvw7Lmp7RFuqvzaptCW8a9/e/eh1cjwACWwUFTUh8zJNeGiCj+aRcd
	 M1UbDAX8qxxoB5BOsso+b0OQ70SCbcEJdVcUPdDG1o0hPcv0PErw3TIKXq6blTtSYf
	 fJrAtzO4jqV9+/FiLqIHH+a03F04FgS8QvvpCzZw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250304090748epcas5p4eb357b126b85673c8abd3224e4e5ccc0~pjl7QfCAo2922629226epcas5p4A;
	Tue,  4 Mar 2025 09:07:48 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Z6VFZ34t7z4x9Q3; Tue,  4 Mar
	2025 09:07:46 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A7.0B.19956.2E2C6C76; Tue,  4 Mar 2025 18:07:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250304085652epcas5p27939cc1666c3c792c972ce357031cd52~pjcXyiPfK2121921219epcas5p2U;
	Tue,  4 Mar 2025 08:56:52 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250304085652epsmtrp12bc988aa8f22d49630f449dfb733c945~pjcXxza2n0410804108epsmtrp1a;
	Tue,  4 Mar 2025 08:56:52 +0000 (GMT)
X-AuditID: b6c32a4b-fd1f170000004df4-08-67c6c2e22fbe
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5B.AB.18949.450C6C76; Tue,  4 Mar 2025 17:56:52 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250304085650epsmtip1023e35fb0295564b7ea289ac153165d0~pjcWV0cRw0129801298epsmtip1N;
	Tue,  4 Mar 2025 08:56:50 +0000 (GMT)
Date: Tue, 4 Mar 2025 14:18:33 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, anuj1072538@gmail.com,
	nikh1092@linux.ibm.com, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	dm-devel@lists.linux.dev, M Nikhil <nikhilm@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] block: ensure correct integrity capability
 propagation in stacked devices
Message-ID: <20250304084833.GA29801@green245>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250303141236.GB16268@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBJsWRmVeSWpSXmKPExsWy7bCmhu6jQ8fSDV5sFLL4+PU3i8Xqu/1s
	FgsWzWWxWLn6KJPF3lvaFvOXPWW36L6+g81i+fF/TBZ3Lz5lttjZfozRgctj56y77B6Xz5Z6
	TFh0gNFj85J6jxebZzJ67L7ZwObx8ektFo/Pm+QCOKKybTJSE1NSixRS85LzUzLz0m2VvIPj
	neNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOALlRSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX
	2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGfs23uCqaBJuuL+9z72BsZusS5GTg4J
	AROJky/esnUxcnEICexmlPh75hYjSEJI4BOjRNN2CYjEN0aJ+//PsMF07DwxhwkisZdRomNS
	AzOE84xRYuuNBUwgVSwCKhJn3xxgB7HZBNQljjxvBRsrIqAk8fTVWUaQBmaBn4wSy+69ZgVJ
	CAukS7z9fhTM5hXQlZh/ZAkLhC0ocXLmEzCbU0BHYv3paWA1ogLKEge2HQc7Q0JgKYfEg09n
	2SHuc5F4PbGLFcIWlnh1fAtUXEriZX8blJ0u8ePyUyYIu0Ci+dg+RgjbXqL1VD8ziM0skCGx
	/V83M0RcVmLqqXVMEHE+id7fT6B6eSV2zIOxlSTaV86BsiUk9p5rgLI9JJ7MOsUCCaLbjBIv
	HvYwTWCUn4XkuVlI9kHYOhILdn9im8XIAWRLSyz/xwFhakqs36W/gJF1FaNkakFxbnpqsWmB
	cV5qOTzKk/NzNzGCk7CW9w7GRw8+6B1iZOJgPMQowcGsJML7+cCxdCHelMTKqtSi/Pii0pzU
	4kOMpsDYmsgsJZqcD8wDeSXxhiaWBiZmZmYmlsZmhkrivM07W9KFBNITS1KzU1MLUotg+pg4
	OKUamBbz5Mf/OMi9VvfrPFU35f8rnctnWxs/7m+5ypp8v/Tpiu9/eZbwdgTly8nFpunXHp/U
	91p3j5+fzmUfXsYPoucvmIryznk9ud/thQnjQ2GDqyUHc450HHSr6lqjLTXrd3PNM5aX1dnH
	3319cs+o0re7Sb8mWnLBka+2fvkHdPY890qW6ZJfFa+2rKLTIrj4drL0I4ejOoWMHpF9RW9O
	PkzIN13hIJF8ZYUNg1DQlTTPfp9G70WfklfqvjG1sv685op00L1p8psO/HMW2V6dGDelS2tt
	t+/shQLH7mqI2zkdKo173LI8bFH6FAezqtvFyXWxTcGbVm5tSjBTXH82yTao5JD3EcWV7r8L
	H8xRYinOSDTUYi4qTgQAsFzcp0sEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSnG7IgWPpBr9+cll8/PqbxWL13X42
	iwWL5rJYrFx9lMli7y1ti/nLnrJbdF/fwWax/Pg/Jou7F58yW+xsP8bowOWxc9Zddo/LZ0s9
	Jiw6wOixeUm9x4vNMxk9dt9sYPP4+PQWi8fnTXIBHFFcNimpOZllqUX6dglcGX/nHmMrOCRR
	MXtPYAPjE+EuRk4OCQETiZ0n5jB1MXJxCAnsZpRY/+05E0RCQuLUy2WMELawxMp/z9khip4w
	Svy6vA8swSKgInH2zQF2EJtNQF3iyPNWsLiIgJLE01dnGUEamAV+Mkosu/eaFSQhLJAu8fb7
	UTCbV0BXYv6RJSwgtpDAXUaJLzNzIOKCEidnPgGLMwtoSdz49xLoIg4gW1pi+T8OkDCngI7E
	+tPTwMaICihLHNh2nGkCo+AsJN2zkHTPQuhewMi8ilEytaA4Nz232LDAKC+1XK84Mbe4NC9d
	Lzk/dxMjOHK0tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeW+1H04V4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzfnvdmyIkkJ5YkpqdmlqQWgSTZeLglGpg4hXTvTK7rqtX5fyrfwJuurnreo2N6/5UsAkF
	lpjziltcYShaMuFXYfm/qyudFKqj2na8Kkk4O3vGOfcg/W/7Hc/9+bXbPVam+wdL5IX33IlM
	K9i95ob3/mtOPqoUcezgdaHdn7qZCmaF18Xfs9tSY/fR5/+kzHY+vVqh3pI0dgHzv5wLxEVP
	vZJjVtaJ/LT4UmnLtucbLsYVxmfMNQ1hT/vxtzhl1waZ6voAxw1HDmsduuQ04cnh+Pioddvb
	7r1QOrsveevm5RPTY//zLpQKDN0+KydYjfucYbl8TrLjwsOMU+a7ekw+bvw99PLOrekfot3V
	LNmf2myb/Sf5XVPhwyfqkevyHuslHDix78EsJZbijERDLeai4kQAaye1TAsDAAA=
X-CMS-MailID: 20250304085652epcas5p27939cc1666c3c792c972ce357031cd52
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----MTAFpDJBIS7x0DorxmyomC-IKR7RHdtq514vGN5lDcSFRf5o=_a01c4_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250226112857epcas5p1654e62b5fff4551926622f19269c6ff4
References: <20250226112035.2571-1-anuj20.g@samsung.com>
	<CGME20250226112857epcas5p1654e62b5fff4551926622f19269c6ff4@epcas5p1.samsung.com>
	<20250226112035.2571-2-anuj20.g@samsung.com> <20250303141236.GB16268@lst.de>

------MTAFpDJBIS7x0DorxmyomC-IKR7RHdtq514vGN5lDcSFRf5o=_a01c4_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Mar 03, 2025 at 03:12:36PM +0100, Christoph Hellwig wrote:
> On Wed, Feb 26, 2025 at 04:50:34PM +0530, Anuj Gupta wrote:
> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index c44dadc35e1e..8bd0d0f1479c 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -861,7 +861,8 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
> >  
> >  	if (!ti->tuple_size) {
> >  		/* inherit the settings from the first underlying device */
> > -		if (!(ti->flags & BLK_INTEGRITY_STACKED)) {
> > +		if (!(ti->flags & BLK_INTEGRITY_STACKED) &&
> > +		    (bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE)) {
> >  			ti->flags = BLK_INTEGRITY_DEVICE_CAPABLE |
> >  				(bi->flags & BLK_INTEGRITY_REF_TAG);
> >  			ti->csum_type = bi->csum_type;
> 
> As mentioned last round this still does the wrong thing if the first
> device(s) is/are not PI-capable but the next one(s) is/are.  Please
> look into the pseudocode I posted in reply to the previous iteration
> on how to fix it.

Christoph,
Right, based on your comment modified this patch.
Does this look ok?

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c44dadc35e1e..d0469a812734 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -859,36 +859,28 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
 	if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))
 		return true;
 
-	if (!ti->tuple_size) {
-		/* inherit the settings from the first underlying device */
-		if (!(ti->flags & BLK_INTEGRITY_STACKED)) {
-			ti->flags = BLK_INTEGRITY_DEVICE_CAPABLE |
-				(bi->flags & BLK_INTEGRITY_REF_TAG);
-			ti->csum_type = bi->csum_type;
-			ti->tuple_size = bi->tuple_size;
-			ti->pi_offset = bi->pi_offset;
-			ti->interval_exp = bi->interval_exp;
-			ti->tag_size = bi->tag_size;
-			goto done;
-		}
-		if (!bi->tuple_size)
-			goto done;
+	if (ti->flags & BLK_INTEGRITY_STACKED) {
+		if (ti->tuple_size != bi->tuple_size)
+			goto incompatible;
+		if (ti->interval_exp != bi->interval_exp)
+			goto incompatible;
+		if (ti->tag_size != bi->tag_size)
+			goto incompatible;
+		if (ti->csum_type != bi->csum_type)
+			goto incompatible;
+		if ((ti->flags & BLK_INTEGRITY_REF_TAG) !=
+		    (bi->flags & BLK_INTEGRITY_REF_TAG))
+			goto incompatible;
+	} else {
+		ti->flags = BLK_INTEGRITY_STACKED;
+		ti->flags |= (bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE) |
+			     (bi->flags & BLK_INTEGRITY_REF_TAG);
+		ti->csum_type = bi->csum_type;
+		ti->tuple_size = bi->tuple_size;
+		ti->pi_offset = bi->pi_offset;
+		ti->interval_exp = bi->interval_exp;
+		ti->tag_size = bi->tag_size;
 	}
-
-	if (ti->tuple_size != bi->tuple_size)
-		goto incompatible;
-	if (ti->interval_exp != bi->interval_exp)
-		goto incompatible;
-	if (ti->tag_size != bi->tag_size)
-		goto incompatible;
-	if (ti->csum_type != bi->csum_type)
-		goto incompatible;
-	if ((ti->flags & BLK_INTEGRITY_REF_TAG) !=
-	    (bi->flags & BLK_INTEGRITY_REF_TAG))
-		goto incompatible;
-
-done:
-	ti->flags |= BLK_INTEGRITY_STACKED;
 	return true;
 
 incompatible:
-- 
2.25.1



------MTAFpDJBIS7x0DorxmyomC-IKR7RHdtq514vGN5lDcSFRf5o=_a01c4_
Content-Type: text/plain; charset="utf-8"


------MTAFpDJBIS7x0DorxmyomC-IKR7RHdtq514vGN5lDcSFRf5o=_a01c4_--
