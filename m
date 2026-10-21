Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792593194;
	b=CmAesQoUMOCyG44nucBmvHB4YL0DbbKdJ0MaMEmHJpW/Z08miq8XgWE0mS2T4Gk9O/d6
	 agrk/rSgLs7+RAvVkySgSI2sniZvRCMlXeUUHI861zkHziJ4XJnC7ntrEWIMedepjoP/C
	 gcQNxGK92R1r/MdWXGJqCn27z957T7HdW+95HhPDmJFOKiR39uX+Z+JTZj3NJpZkR7BzH
	 IjmQzG/0QmAaSSg9zWx/Kh0Q1/GeIlkv12qAzfI1HhEVAobWwypDiRiRVuQ9YvBgyxj1C
	 BAdGkqddTmeorftUTUewzICtUe9c8aQC8UhpK/XSHHmwGMOrJEG3Wuqsn9nzLHWpuug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593194;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rT0attzH75pVivpmDOXUpw4nbiY5gyDFmPZRpVhJyJA=;
	b=Hk4WluQZa8t92Yo9rqP4Y9+Ehxvrt8zxD523QDkxb2kHHR3MYfhyOmCi6dQGBlBhtkCk
	 PoAHbKpZghawDTRZ54xe/oOGBZMjvjvyR18axTSultLGnOovtOigdXs8I/wcw/nkAd3nq
	 /adTVZJ39eyebq772svAAIOCWv5bwi+faX/wfM9MeEcuX+EGnCQhcxqQxarh3BnSMnQIF
	 nT1jEWSaJyUuTLhvvMlE+9q2Uhg9d6XWve3fitmqPAq3Z+UYQ6rbMIfgpx5spPvJjbMOP
	 XKnE1dHRfUfqWiy9U8jVoy7qnFilvYIqbRzSHzqHklX7OAAgdX5dA0mFB6HJmHq0HeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=WC4wSCQ8;
	arc=none smtp.remote-ip=209.85.210.178
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA7F606A325
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 14:33:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EA7F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=WC4wSCQ8
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a06210b29fso323988b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 07:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792593193; x=1793197993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rT0attzH75pVivpmDOXUpw4nbiY5gyDFmPZRpVhJyJA=;
        b=WC4wSCQ8IBwhhl+eC3sq5GnHMVsUiN2/Qh/0fQ2HNj7a5ZjnhjyoxMb960eGoVE9GJ
         4F+Q+N7jCRk3Xao7tzIO8i8dLQNoNLi835ckMZT4lZX3/Yw6jGrEz7cuOEXY6C9rI5nw
         HlBpLO5UWS+MhHbS24Yxgur+B4/pO+liQoM6W17S3ET3VbEWlDtHRBcYAlPlgVKm81E6
         EdvVwB4kW8r8eWh0vkFhORiE34VcBLAdLg5OhRuOTKdelrGqjSeRTuew6TgYn23YXruS
         nVaLZExLbxQtw9k5u8gifNEGRsbxlVkNSxL17rDOP5UsYAA0RuH8ymF6nxyOAXlRlwkM
         Vcdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792593193; x=1793197993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rT0attzH75pVivpmDOXUpw4nbiY5gyDFmPZRpVhJyJA=;
        b=qm9sBIS3vafNGfmR0n5IzgVkxyvh70FTsYYf9YLYX/Mpp8SvJ3W8GlcDCRSBfvT/VT
         /UljzP7K+zrf7J4CZTcCm9y+N19Ej0jkx+o2OXqHR9j8/u3Bhj9nqC5pEcSo2S5XoWRi
         t9bew/zFfn6QpEyTC9IV+CJ1qx+AK6QxvCKjvIHrBoBJkMhUdNnaYPNtg1HWB0F5328T
         KBAMqunSqaL3wchdCG8n4zjCjJC+C2/UhLrAipwwMNG15c7fvCVK1XAWMJ/AV0Olj/rL
         VPueWK0jdL+MgqVOKI7L64CqdeER+aTgJFb3iL6Qx1IRXj0aWtUVw1NDCzepKPn9vK1C
         Nlng==
X-Forwarded-Encrypted: i=1; AKwUvBynmbkwBrB9WfO1ZphiS7FubLd2QWZNUihGf6uVSg61LvYeKlIQcOAEPlZtkSDcc6YRemGe3B/fGF64@vger.kernel.org
X-Gm-Message-State: AFq9FYIVD+DgM5JmGu0vNkwILg9ThSPAmfuLXpuTYg7ZC/0bCjfToJUp
	cV26bqT3eYX3zo3iFKu1b4+WO5Fnt878PaFmQCnlyXhAbR/spZ3/dT7p2DFrNJM04sg=
X-Gm-Gg: AYBFou1OiK1IfJE/BqMvyOxaZDqI70kEV97hyVNDNducjdFrSLnD48gjJRXdg86++XF
	aDvmk+JPRWgTEvpwKB8pizvuT+9s5FNG0YYUPtN+xtBOo4kVL+tiqtKXPM5Br5j6m8iyoO3x2tm
	Ml13kiBTd8ZHdntAEPxHxfU05TewMTQZxwHgnAPiE9e26rY5ycOC5gVg8NamfksjsvTgEotsS0l
	5Mum4MUIcpsb/3ROK/eMFSCShZ5lNopvifKEE84xg5YFBzKktUQ6PmzR+9xeRR7BJE7c02kjCRp
	KQLE6ThGSZCWq+igaV9sRjO1fipL8bmd1U7MJTKyKNCoObZ1kSl2/nXMi6CpC7a5snpIMDoacIZ
	Rwf4Q6s/wo5wZMI3BSqldVCQZAAClGvcE373N4hw1UuezLAHMFCBtld2uYgiZfYOkynMxgX7RVl
	EB52QtQX2Vnoogk7oMW4CvY6yRxIyKYa1E9OhiQSfd+np46vp3GS0IMtpleqcowWkyMUAOPolWf
	3v+QqCCDGQqCyO4Gt/09iz61HZgMgFodJ0o/fzVd5g+X59ZfpsQAHN2ft4W/R9h9DfF3CG7tDxU
	xBk=
X-Received: by 2002:a05:6a00:17a9:b0:881:be70:448e with SMTP id d2e1a72fcca58-8a089ebb6f8mr1941007b3a.53.1792593192467;
        Wed, 21 Oct 2026 07:33:12 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:2813:c015:8111:4bd6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895fa967sm991720b3a.47.2026.10.21.07.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 07:32:58 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: James Smart <jsmart2021@gmail.com>,
	Hannes Reinecke <hare@suse.de>,
	Mike Christie <michael.christie@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v2] scsi: elx: efct: fix target session lifetime against node teardown
Date: Wed, 21 Oct 2026 23:32:40 +0900
Message-ID: <20261021143240.2782323-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
References: <20261021130802.2691833-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review. Two of the three points are right, and v3 fixes
them.

Both came from the backend reporting a synchronous completion while the
setup work was still in flight. efct_scsi_new_initiator() returned
EFC_SCSI_CALL_COMPLETE for a duplicate PRLI, and efct_scsi_del_initiator()
returned it when it handed the in-flight setup to teardown, so
efc_d_send_prli_rsp() and __efc_d_initiate_shutdown() advanced the node
before the work had registered or unwound the session. v3 returns
EFC_SCSI_CALL_ASYNC in both cases and lets the setup work post the one
completion it owes, through efc_scsi_del_initiator_complete() or
efc_scsi_sess_reg_complete().

The third, the window around efc_scsi_sess_reg_complete(), stays memory
safe because the work now holds a node reference across it. The second
efc_node_free() it describes is a pre-existing path in efc_node_free()
that this patch does not change.

v3 is at
https://lore.kernel.org/r/20261021142818.2782104-1-yhlee@isslab.korea.ac.kr
