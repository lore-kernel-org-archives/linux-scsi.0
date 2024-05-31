Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEA0200B7
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 21:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717189610; cv=none; b=Loeo+tjoAlsQU9CjgkVdV0pN25XTYbMmQ6VvP2OZbqr/rGPf0GuwgjSRaYMoOv8XFsuqSLjvWSppdNwkxbVxPM4G13vfyebgUPKi/imWYmaj+7LvK0DEIQBg9xR/HF2LMhGBuOFrhLuhsiv/W5NDANzJdvElVzChpxzY2UMTetA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717189610; c=relaxed/simple;
	bh=30ELdth7WZicC/vpAKe5PHSVhm4ww9cLgul2n4KcwnE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=nHDlSMNArea32OHRt8zj+PWJpzcio3MnATodjUxjBple39NziiyCk842L30mnRHmEe5IfrWXl74QHAL87YUP8/w2YC0KQKDn7pyoEKbZPCurfMyH/Et8TZZxdeyWKYcbhbiacag8NYcBEYK415dbN5AcCJ3oeDhzmliEcLVhWlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=U7Z59UU8; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="U7Z59UU8"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240531210645epoutp03056952616d13938861565af9af379837~UrtkLXmbd3044230442epoutp030
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 21:06:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240531210645epoutp03056952616d13938861565af9af379837~UrtkLXmbd3044230442epoutp030
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717189605;
	bh=1tNjP7sssd68InhNCGdfvXyfrkMDNeQ2G4gpmxYHLjQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=U7Z59UU8tAnDij30JgyIY40B+lfJl2gWs+ldvT3OjUZSOGy48K+1eweITVszR8Fsi
	 tlZULGOz/xBiQb7D18dpySjBhXAM2BW5xEPGytCg9/CeOjozrtWdNiRsuOD/TP1MsA
	 +PyGiNemXvGG2TUnviCrARTVRLdVl0r+whMqUnlU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240531210644epcas2p28bbd8f3a12c5f0ac259d318cc77c6d42~Urtjr3xG82023520235epcas2p2o;
	Fri, 31 May 2024 21:06:44 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.70]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VrbJz5nF8z4x9Pv; Fri, 31 May
	2024 21:06:43 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	20.A1.09848.3EB3A566; Sat,  1 Jun 2024 06:06:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20240531210643epcas2p28898ec306853744e728e3cec880b29b1~UrtiN0zPm2002720027epcas2p2j;
	Fri, 31 May 2024 21:06:43 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240531210643epsmtrp12df85af8968fd0dace703310a5b43d1a~UrtiNQbaM2169121691epsmtrp1w;
	Fri, 31 May 2024 21:06:43 +0000 (GMT)
X-AuditID: b6c32a45-447fe70000002678-38-665a3be3a4e9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	71.37.18846.2EB3A566; Sat,  1 Jun 2024 06:06:42 +0900 (KST)
Received: from localhost (unknown [10.229.54.230]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240531210642epsmtip1779b289e9d7f12eddbce420a4ac9f8c8~UrtiAsoMU1427614276epsmtip1f;
	Fri, 31 May 2024 21:06:42 +0000 (GMT)
Date: Sat, 1 Jun 2024 05:55:23 +0900
From: Minwoo Im <minwoo.im@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>, Minwoo Im
	<minwoo.im@samsung.com>
Subject: Re: [PATCH 1/3] ufs: mcq: Add ufshcd_mcq_queue_cfg_addr helper
Message-ID: <Zlo5O3NDlsX089Xz@localhost>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d3d2d848-e70c-462b-bbb2-f5a2308646fd@acm.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmhe5j66g0g087tS0ezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBfo
	FSfmFpfmpevlpZZYGRoYGJkCFSZkZzybPI+lYLNYRevek4wNjEuFuhg5OSQETCTe3v/H3MXI
	xSEksINR4sDia+wQzidGiUXX+lngnF1Hb7DAtPye/RuqaiejxLSXa9ggnOeMEq077wA5HBws
	AioSS0/6gDSwCahLNEx9BdYsIqAh8e3BcrCpzAKPmSQWP3rECJIQFnCXeHn4DFgRL1DR7W17
	oGxBiZMzn4DZnALWEjv+3AZbJiHQyiEx9dtsqJNcJHo+P2OEsIUlXh3fwg5hS0m87G+Dsssl
	fr6ZBFVTIXFw1m2wQyUE7CWuPU8BCTMLZEhMf3OcCSKsLHHkFgtEmE+i4/Bfdogwr0RHGzTo
	lCU+HjrEDGFLSiy/9JoNwvaQePjmCzTgvjBK/D12hHUCo9wsJN/MQrJtFtBYZgFNifW79CFM
	aYnl/ziQRBcwsq5iFEstKM5NTy02KjCEx29yfu4mRnAy1XLdwTj57Qe9Q4xMHIyHGCU4mJVE
	eH+lR6QJ8aYkVlalFuXHF5XmpBYfYjQFxsxEZinR5HxgOs8riTc0sTQwMTMzNDcyNTBXEue9
	1zo3RUggPbEkNTs1tSC1CKaPiYNTqoGpnnP6iWbefx6hLGoOe3ff0gs9vM1EZtaqwhtij1xu
	2+ie5oyTP7r7bscxfa7tIe+NV3fOir9/oPTY/1MZgRt16zot02Yd5U2/lcq7qMBNT+de7NZr
	6nURLTbOrNeuOrTWLb3msjancHfTv9Sbt2d8PqJ1lUOLbVWhQqHE0tkzjO1n+192uuYjcU03
	Z8XJ1MmvhO6u89zMGbuDdT5joPvkW9mzrTeY7Zm9ptfHZbtbzq5VZgHFXe2Z0SGT7Fa0WJcU
	bf26o/vV26WnCs9dVer5XV7rfOjaHOmFOz37VDODNrStvVZVlaMzL/zcE/+Kc9wWxTxJrzc/
	OVtoPlX4Zm57scCOhqr3ElwLjOZo71RRYinOSDTUYi4qTgQAdwfm8C8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWy7bCSnO4j66g0g4vfLS0ezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorhsUlJzMstSi/TtErgydr0tL/gmXPH70E7GBsZGgS5G
	Tg4JAROJ37N/s4PYQgLbGSW+NcVAxCUl9p2+yQphC0vcbzkCZHMB1TxllGif/YCli5GDg0VA
	RWLpSR+QGjYBdYmGqa9YQGwRAQ2Jbw+Ws4DUMws8ZZK4/nMtE0hCWMBd4uXhM2BFvEBFt7ft
	YYEY+oVRYvX7lawQCUGJkzOfgBUxA039M+8SM8gyZgFpieX/OEDCnALWEjv+3GabwCgwC0nH
	LCQdsxA6FjAyr2IUTS0ozk3PTS4w1CtOzC0uzUvXS87P3cQIjgKtoB2My9b/1TvEyMTBeIhR
	goNZSYT3V3pEmhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe5ZzOFCGB9MSS1OzU1ILUIpgsEwen
	VAMTx1vt2VPDTnZWTXl6TX3PZv3Km5eObmWr4/A7ZRXoqjVz4ZoyDpX0Y9FM3gyMsZv9Vus6
	iOv/lHWekZT1wjPtXE5Xw+Zey3tazSUMXr9b11+Ta1Y9c6RItd15k97E3WvPq2RtMDHP28e1
	O9PnsXuqVc/W9QIMjYe8728KnLvN45lGFkfrzufLn+lUrjCcWpK71/wSn8Punvna28R5Ji3b
	ejReYIaWlcAR5vyw/Ad7ugNnVJwS3Goz/Ubph8b4V74PZ8c0Z27KzONz/iUT/rGIzfEo58FH
	as0W6Tz++ZdPftO9lrs590qEXqxNTWnI3wvcuttmqPRwXtfU6Ei8d46vs58579C+ufFlTRsP
	myuxFGckGmoxFxUnAgDwLYJ68QIAAA==
X-CMS-MailID: 20240531210643epcas2p28898ec306853744e728e3cec880b29b1
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----He.yNZkzpBak.xuDKC9auljxNssTvAfbOgKyc16DCg-DQrdx=_28df6_"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531104947epcas2p1cd477921c1cd307d84f9ffc25b2c08a8
References: <20240531103821.1583934-1-minwoo.im@samsung.com>
	<CGME20240531104947epcas2p1cd477921c1cd307d84f9ffc25b2c08a8@epcas2p1.samsung.com>
	<20240531103821.1583934-2-minwoo.im@samsung.com>
	<d3d2d848-e70c-462b-bbb2-f5a2308646fd@acm.org>

------He.yNZkzpBak.xuDKC9auljxNssTvAfbOgKyc16DCg-DQrdx=_28df6_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline

On 24-05-31 13:15:11, Bart Van Assche wrote:
> On 5/31/24 03:38, Minwoo Im wrote:
> > This helper returns an offset address of MCQ queue configuration
> > registers.  This is a prep patch for the following patch.
> > 
> > Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
> > ---
> >   drivers/ufs/core/ufs-mcq.c | 14 ++++++++++++++
> >   include/ufs/ufshcd.h       |  1 +
> >   2 files changed, 15 insertions(+)
> > 
> > diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> > index 52210c4c20dc..46faa54aea94 100644
> > --- a/drivers/ufs/core/ufs-mcq.c
> > +++ b/drivers/ufs/core/ufs-mcq.c
> > @@ -18,6 +18,7 @@
> >   #include <linux/iopoll.h>
> >   #define MAX_QUEUE_SUP GENMASK(7, 0)
> > +#define QCFGPTR GENMASK(23, 16)
> >   #define UFS_MCQ_MIN_RW_QUEUES 2
> >   #define UFS_MCQ_MIN_READ_QUEUES 0
> >   #define UFS_MCQ_MIN_POLL_QUEUES 0
> > @@ -116,6 +117,19 @@ struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
> >   	return &hba->uhq[hwq];
> >   }
> > +/**
> > + * ufshcd_mcq_queue_cfg_addr - get an start address of the MCQ Queue Config
> > + * Registers.
> > + * @hba: per adapter instance
> > + *
> > + * Return: Start address of MCQ Queue Config Registers in HCI
> > + */
> > +unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_hba *hba)
> > +{
> > +	return FIELD_GET(QCFGPTR, hba->mcq_capabilities) * 0x200;
> > +}
> > +EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
> > +
> >   /**
> >    * ufshcd_mcq_decide_queue_depth - decide the queue depth
> >    * @hba: per adapter instance
> > diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> > index df68fb1d4f3f..9e0581115b34 100644
> > --- a/include/ufs/ufshcd.h
> > +++ b/include/ufs/ufshcd.h
> > @@ -1278,6 +1278,7 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val);
> >   void ufshcd_hba_stop(struct ufs_hba *hba);
> >   void ufshcd_schedule_eh_work(struct ufs_hba *hba);
> >   void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds);
> > +unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_hba *hba);
> >   u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
> >   void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
> >   unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
> 
> New functions should not be introduced as a separate patch but instead should
> be introduced in the first patch that adds a caller to the new function.

I will squash it to the second one and udpate it in the next version.

> 
> Thanks,
> 
> Bart.
> 

------He.yNZkzpBak.xuDKC9auljxNssTvAfbOgKyc16DCg-DQrdx=_28df6_
Content-Type: text/plain; charset="utf-8"


------He.yNZkzpBak.xuDKC9auljxNssTvAfbOgKyc16DCg-DQrdx=_28df6_--
