Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B738138F940
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 18:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773168161; cv=none; b=JUH+bcTA92oMcNnaLC53lp1JqYMj0xwdVjJOtFCy6qNRMgDtgUxlIEf3Z4snF0xx8tzfc/f766eoq/PFeP7z5SyVwsmj/3fBsrikHN8Xqb/9vuVD1WfH6ZVSQ722QzPcOL2Mh6uwjUlQkGe6BMy30tNizL0UMc0atCqD1c9/taE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773168161; c=relaxed/simple;
	bh=vAuO8LdLXgYjvO+f5USILfCGUhTqB4BPLoq9TY2aNWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gGLRj3jlyO6Nde+dgEZtfJfWEZpZ/fRkXCImTzqU3PBPeGIEKn9PQNOHslMzDSfff65UXxROyP+0LOVEQUwRvxlDqqAio0KJFfz98z1C12ZhiA7+SD8IdKI33fo33cz1Adr+BcIUykOOR2H+2W1fq1bz/D5zxvlDcwMak8COk90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DiyAtYVg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DiyAtYVg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773168158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sk8lhoihK5pIbuF6YimmbJRBp6IudW+NAGwHbxnhgvE=;
	b=DiyAtYVgcqFC1SadKJWVP6VlRiw/CyvlIOHKva8kNMWfYa7njgvRECdpwWpS61e9hhpu8h
	kJVAiAgQuD/YYFFhSv3aF8IVnSJnmPN0mmUmYAPQoC3FNilpQOnWh0utD72f5b6UCRC3by
	Hrp/DxuD1IAdRW9MViaqDiqjhVauom4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-4JQjCTqxPS-DB04r5hcr5w-1; Tue,
 10 Mar 2026 14:42:34 -0400
X-MC-Unique: 4JQjCTqxPS-DB04r5hcr5w-1
X-Mimecast-MFC-AGG-ID: 4JQjCTqxPS-DB04r5hcr5w_1773168153
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07E041955DAE;
	Tue, 10 Mar 2026 18:42:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7D3B19560A6;
	Tue, 10 Mar 2026 18:42:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62AIgVla030181
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 14:42:31 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62AIgTDO030180;
	Tue, 10 Mar 2026 14:42:29 -0400
Date: Tue, 10 Mar 2026 14:42:29 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Snitzer <snitzer@kernel.org>, lsf-pc@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
Message-ID: <abBmFZY9PhGoZu7o@redhat.com>
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <aZnuSC0qYfw0hiwM@kernel.org>
 <aZ5GbVxDT3gcS6WE@redhat.com>
 <0a6ec8d3-7623-4809-b275-3eccb94419d4@suse.de>
 <a1e5c1ac-fb5f-46f7-ad7c-e21a545e128d@oracle.com>
 <CAGtn9rnreF=AjejdZ_66Wicc6dhQjbjkK3BY4wdaRm3_bgC8tw@mail.gmail.com>
 <949c3319-1938-410e-8796-8e8bbdf59103@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <949c3319-1938-410e-8796-8e8bbdf59103@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Mar 10, 2026 at 06:05:29PM +0000, John Garry wrote:
> On 10/03/2026 17:12, Ewan Milne wrote:
> > Hi John-
> > 
> > Sorry, I was out for a couple of weeks and have been catching up...
> > 
> > Re: sg support, there were issues in the past with people attempting
> > to do SG_IO through dm-mp
> > assuming that DM would handle retry on other paths, which it didn't.
> > You also have to be aware
> > that non-idempotent commands don't work right if retried.  My
> > recommendation would be to avoid
> > implementing it, although there has been interest in a better way to
> > do multipathed "generic"
> > commands (e.g. virt pass-through) I think that is a more involved
> > project than you want to do here.
> 
> Understood, my current plan is not have a multipathed sg driver - we will
> still have the per-scsi device/path sg device.

The sd devices still handle SG_IO ioctls. For instance, the persistent
reservation ioctls are SG_IO ioctls. But like I said elsewhere, getting
multipathed persistent reservations working safely is going to be a
large effort, better left for later.

But even without them, to handle things like sending SCSI WRITE commands
over SG_IO ioctls, in an ideal world, you would want to be able to retry
on other paths in the ioctl code. However, like Ewan mentioned, there
are times when you don't want to retry the ioctl. Just sending SG_IO
ioctls to one path and letting them fail if they fail down that path is
the safest way for now, even if there are times when that SG_IO ioctl
could complete successfully down another path.

-Ben

> 
> > 
> > I see the discussion has progressed re: ALUA support in your later
> > patch postings, which is good.
> > As Hannes said, a Native SCSI MP would be useless without it.  You
> > don't have to support the
> > older non-ALUA mechanisms though, those arrays are way, way old.
> > 
> > SCSI does not have the equivalent of NVMe's AEN, so you need a way to
> > ensure that your
> > ALUA info is up-to-date.  DM-MP's path checker normally does this by
> > sending commands on
> > which the Unit Attention can be reported so that the code can fetch
> > up-to-date ALUA info.
> > Hannes made some optimizations years ago to avoid excessive RTPG
> > commands with large
> > numbers of LUNs which we would need also.
> 
> Hannes is suggesting to not have a kernel path checker, so let me know if
> any issue with that.
> 
> > 
> > It will be necessary for the functionality to be enabled via a module
> > option, at least initially.
> > Introducing this in general use will be a big change for people who
> > have Enterprise SAN
> > configurations with their own custom path monitoring tools.  I believe
> > we put some functionality
> > into usespace multipath tools so e.g. Native NVMe devices can still be
> > monitored/observed
> > which made things a bit easier for people.
> > 
> 
> Sure, if you check my patches, we disable by default and enable via a module
> param
> 
> cheers

