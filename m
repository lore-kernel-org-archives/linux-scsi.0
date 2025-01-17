Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125281ABED9
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 21:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737149266; cv=none; b=LS1XryDxwM4iMMDRewOuY061IjqL66H7AnDoTddRM7P8Zja/A3/BBThyYWo96RltCbf0KlBdAyz8wa4HBBUxgSNLGBOap/Dq7ZydLk6FADGztAbZmhM+36nefMbOeGUyJ9vHOEd9vv+l3ohx06Lf5UjqTaSPRkyw4YfmqFSvt+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737149266; c=relaxed/simple;
	bh=gHtROKOtw49TMpUTn1AbSc7CDbzBv0kMZ9gHKZs7a4M=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WvYEvMgGY6RVw775eiTUJNFcUiqjDaH6CHjT9G21nxy/Pm56frQgeYtisKzSgnQZ/8jJaau8keZxjm7ZJWTFLvUXlKpQABO/CRRdQCNf93UZ/kmRzh0ysti8Orw9GQg4vXHoZ7W2grOYVJZOn81Y+mPPtbnPzsWMESfHum7gpoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AXlTGvQ+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AXlTGvQ+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737149262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pgV+zu79hN75oKX15LFXTDKwUbzMzhPDf2yqirzHSkk=;
	b=AXlTGvQ+id81FKqHAC9NB4GPqt8vGoOZcibuAqhInHLw51unTMyiihSSJMKLQgJuAssabO
	QVvpRPp6HYiwO75FRoGw+Oir8/o0ZwuNmAGHLf8e73P3xnSDi6XYa38drDEfiGTuo1rCwM
	T1AlQcWVouKzVQgG7Dvd3v4YPrGX8gg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-662-WwH0T1MENuyUjWdIi_lucQ-1; Fri,
 17 Jan 2025 16:27:36 -0500
X-MC-Unique: WwH0T1MENuyUjWdIi_lucQ-1
X-Mimecast-MFC-AGG-ID: WwH0T1MENuyUjWdIi_lucQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 635381956050;
	Fri, 17 Jan 2025 21:27:33 +0000 (UTC)
Received: from [10.45.224.57] (unknown [10.45.224.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A764019560A3;
	Fri, 17 Jan 2025 21:27:26 +0000 (UTC)
Date: Fri, 17 Jan 2025 22:27:22 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, agk@redhat.com, 
    hch@lst.de, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, 
    sagi@grimberg.me, James.Bottomley@hansenpartnership.com, 
    martin.petersen@oracle.com, linux-block@vger.kernel.org, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, 
    linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/8] device mapper atomic write support
In-Reply-To: <Z4q45sjEih8vIC-V@kernel.org>
Message-ID: <4c5d02d6-a798-a390-2743-088c31c8965f@redhat.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com> <Z4q45sjEih8vIC-V@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12



On Fri, 17 Jan 2025, Mike Snitzer wrote:

> On Thu, Jan 16, 2025 at 05:02:53PM +0000, John Garry wrote:
> > This series introduces initial device mapper atomic write support.
> > 
> > Since we already support stacking atomic writes limits, it's quite
> > straightforward to support.
> > 
> > Personalities dm-linear, dm-stripe, and dm-raid1 are supported here, and
> > more personalities could be supported in future.
> > 
> > This is still an RFC as I would like to test further.
> > 
> > Based on 3d9a9e9a77c5 (block/for-6.14/block) block: limit disk max
> > sectors to (LLONG_MAX >> 9)
> > 
> > Changes to v1:
> > - Generic block layer atomic writes enable flag and dm-table rework
> > - Add dm-stripe and dm-raid1 support
> > - Add bio_trim() patch
> 
> This all looks good.
> 
> Mikulas, we need Jens to pick up patches 1 and 2.  I wouldn't be
> opposed to him taking the entire set but I did notice the DM core
> (ioctl) version and the 3 DM targets that have had atomic support
> added need their version numbers bumped.  Given that, likely best for
> you (Mikulas) to pick up patches 3-8 after rebasing on Jens' latest
> for-6.14/block branch (once Jens picks up patches 1 and 2).
> 
> Jens, you cool with picking up patches 1+2 for 6.14?  Or too late and
> we circle back to this for 6.15?
> 
> Either way, for the series:
> 
> Reviewed-by: Mike Snitzer <snitzer@kernel.org>

Hi

I rebased on Jens' block tree, applied the patches 3-8, increased 
DM_VERSION_MINOR, DM_VERSION_EXTRA, increased version numbers in 
dm-linear, dm-stripe, dm-raid1 and uploaded it to git.kernel.org.

You can check it if it's correct.

Mikulas

