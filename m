Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5173A28642A
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 10:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750845825; cv=none; b=SnEHSul8pwWGKJF8+zN0YsRTsgCSdl0/WgnP4gH3KGNnMxb1EfAkd7tIqjng9X7iRdyx5q3SPboxRCCdZbSl5vVuHtR64p+pSUwgxeBVFrYhD64zzGAVFqA9Qaig1ucov5ANUVpBDUAVt3PxacTSRGzS+x8zavTTQTI9JCyphys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750845825; c=relaxed/simple;
	bh=d2hcLFkNmVm474Y6OI3+3sMNw9iwSuH4rb69WxQIdMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IvIWaMxAhCcIEcjzI8hI0bqqPOX7qfQrd3pPYEpY7xutNHRjOu9lstXaIGfXQZoeCv7FSezeAXECB8rIPSqJaI2Qkg5RBmHy4TwF87aivWjZdA0CCGBWEL++MVVrVlJHhodE7Iqi+EDOulV1iTQlMwYS+EYLBRL5BHXwonj45ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lf8aKEGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lf8aKEGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE96C4CEEA;
	Wed, 25 Jun 2025 10:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750845824;
	bh=d2hcLFkNmVm474Y6OI3+3sMNw9iwSuH4rb69WxQIdMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lf8aKEGvxz6jjtMtl/u+CkJ8VYKF53nu6CllnZVLs7nTkDDPOTB9LLS4l8BV04lL7
	 2OJwcK3WrbCYeK+KkaXbcg8zT2BzcP11Ge8dg5Z2Yar71DYLT8wOA2RdHOEt26/wp7
	 Oj/bHZKeJfNdSoc3vBkr7Eaujd4cYdQtLPvz/XTM=
Date: Wed, 25 Jun 2025 11:03:41 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Avri Altman <Avri.Altman@sandisk.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Bean Huo <huobean@gmail.com>, Huan Tang <tanghuan@vivo.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Keoseong Park <keosung.park@samsung.com>,
	Gwendal Grignou <gwendal@chromium.org>,
	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Message-ID: <2025062520-glitch-jacket-c607@gregkh>
References: <20250624181658.336035-1-bvanassche@acm.org>
 <2025062523-cheesy-engaged-88e9@gregkh>
 <PH7PR16MB6196ED0C10AB89377E33F18FE57BA@PH7PR16MB6196.namprd16.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR16MB6196ED0C10AB89377E33F18FE57BA@PH7PR16MB6196.namprd16.prod.outlook.com>

On Wed, Jun 25, 2025 at 09:18:27AM +0000, Avri Altman wrote:
> > On Tue, Jun 24, 2025 at 11:16:44AM -0700, Bart Van Assche wrote:
> > > Change "resourse" into "resource" in the name of a sysfs attribute.
> > >
> > > Fixes: d829fc8a1058 ("scsi: ufs: sysfs: unit descriptor")
> > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > > ---
> > >  Documentation/ABI/testing/sysfs-driver-ufs | 2 +-
> > >  drivers/ufs/core/ufs-sysfs.c               | 4 ++--
> > >  2 files changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> > > b/Documentation/ABI/testing/sysfs-driver-ufs
> > > index f3de8c521bbd..a90612ab5780 100644
> > > --- a/Documentation/ABI/testing/sysfs-driver-ufs
> > > +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> > > @@ -711,7 +711,7 @@ Description:      This file shows the thin provisioning
> > type. This is one of
> > >
> > >               The file is read only.
> > >
> > > -What:
> > /sys/class/scsi_device/*/device/unit_descriptor/physical_memory_resourse_cou
> > nt
> > > +What:
> > /sys/class/scsi_device/*/device/unit_descriptor/physical_memory_resource_cou
> > nt
> > >  Date:                February 2018
> > 
> > As you are changing the name of a sysfs file that has been in the kernel for a very
> > long time, what userspace code is now going to break that was using the old
> > name?
> AFAIK none.

So if no tool needs / uses this, why not just delete the attribute
entirely as obviously it's not necessary :)


