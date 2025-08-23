Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6092231A32;
	Sat, 23 Aug 2025 08:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755936870; cv=none; b=a6vHFXaZJ1Jkoju2XUqsxNgyU0lh/TkXJ9ielUWiCUh3UQ6ti4lTVS2KH6w3lPmsMXAn9K8h3ZyFAwWTzLzFrh3tLTgS3pFxVImHH5uRb3zLa2mWMKCfhZw9Ajf5rVUXqSXnG2e1BOWt2oWjViIgd59JXMjzoGCEI1ikxPmGGk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755936870; c=relaxed/simple;
	bh=dxbgPj2WSmNGRKQX4DEJhrhNPFLcKvf7CKt0ay2TmD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fs2vVlI3iRUhVUiCvXGnTX9fUHMilH0NOGMb8e8o1nh6cx2YaohBpds0uJmB8/CA8EmQg0I8P5JROdCXK07zf3AwoYTDTF+cLJVedY2ify88/rd1V68MZnw7VktX52mCdBNACMFS2J62gpCkvJzlCPKB2Gk2yxnLfY2o0Wkws6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.us; spf=pass smtp.mailfrom=gmx.us; dkim=pass (2048-bit key) header.d=gmx.us header.i=len.bao@gmx.us header.b=RGz93H1b; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.us header.i=len.bao@gmx.us header.b="RGz93H1b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.us;
	s=s31663417; t=1755936860; x=1756541660; i=len.bao@gmx.us;
	bh=NadVbNOZvP57Qjm5pDZYb7j3cFvj0cBzNg1TlUgAQ18=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=RGz93H1bhabBJj2D9CHrtVEP5KsLEimYLelicX4mB/aLSbU72w6gaJU43uWMiPpI
	 HcnNmIEM0jpW/yri9ejh7jAq63ZVlV3wSLyyUWSFtODGeJe3RIlag9ddu9ecRC91k
	 6fXplfDiq3sInhKeo5HvTUN9y1ditm/lBm8poWeUhsfopJh69koYM1hTuXk0B6d0o
	 Ad/qhtQUGmFZvAqADmALLh1bBDeIkcxLXgWqEUC84E2/zUWQABiAHGJDon9eZBIs3
	 WrfJW2ulO+ckaDjuwlOXlD8CjQmOiVhH1XVxJuEWvj8bnVbLvlC8Ka5qvOx/XWpPx
	 BeUCXauL9wSJwU08ww==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from ubuntu ([79.159.189.119]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N8GMk-1uTkZ11Lm4-015y3f; Sat, 23
 Aug 2025 10:14:20 +0200
Date: Sat, 23 Aug 2025 08:14:02 +0000
From: Len Bao <len.bao@gmx.us>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Len Bao <len.bao@gmx.us>, Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: Replace snprintf() with sysfs_emit()
Message-ID: <aKl4SticSmkNo3CP@ubuntu>
References: <20250811170639.65597-1-len.bao@gmx.us>
 <yq1qzx6wy9r.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1qzx6wy9r.fsf@ca-mkp.ca.oracle.com>
X-Provags-ID: V03:K1:fXplzqrq7//QuJR5pXd4BOyAEb9LqhOC52Ozni8A1p6nNDELcLr
 lVD7m9hNBuRl9Ypp5NssqiXKZRziTmbmS/KTrNzN5Cm7QHeudVvBxaJxZykAB2KZ0wrC5qq
 IOpTnZWWHPkMhhjji8pyRpmFlpEnQxuCqQPBm/1+iouKXdgpBstMjOeoxVNM0YkdhSEquKL
 nI8Ltqvdgd0Mef9kIP8Ew==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:g+ryC04X3TM=;GlLxQma3jmpn9CNMcD6CcRg1GDE
 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
 3Xribfg++jgRVJcSPK2SHmvAXyOQcCstDxbNN
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Tue, Aug 19, 2025 at 10:08:31PM -0400, Martin K. Petersen wrote:
>=20
> Hi Len!
>=20
> > Documentation/filesystems/sysfs.rst mentions that show() should only
> > use sysfs_emit()
>=20
> It's a "should", not a "shall".
>=20
> sysfs.rst was recently amended to emphasize that this suggestion applies
> to new implementations only.  See commit 2115dc3e3376 ("docs:
> filesystems: sysfs: Recommend sysfs_emit() for new code only").

Thanks for the guidance. Sorry for the invonvenience. It's my fault.

Regards,
Len

>=20
> Thanks!
>=20
> --=20
> Martin K. Petersen
