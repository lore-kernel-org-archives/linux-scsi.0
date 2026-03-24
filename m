Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E5A3914EC
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 13:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774360697; cv=none; b=i7N87TK//wTEiHuln3W6fUe7sSKSL+usV0ACyJMEpDeoBYHKQGUWeKaRyO77xlfJHoUNP70K0CQclrsXtl9Ssi43Ab/vHx/95qB26hOG0pOmmLZSNBkDiilrMgUN2Ees1+WM4Mwov+FYEpn55hw8NoOpPx0CScLAj+wq/FjsV0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774360697; c=relaxed/simple;
	bh=uvdkLwDsMSti7ol18jfvGRenTzdfcEKrv7l0vDyF6q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIaSywLCBB90YrE1YtHWNw4nBHrt2qi8rrN8ZwrWgEsckN1ZsPwEqeuIhmNp4oFNUUP8up2pLcU0FEX81bIip5ZmnAaN0LdWWNYmqGLLHUi0ehyKrAn4Es/5b7Jwr6U4oP9wvqCnzoan07wnKlGOef7DJiMHiZErsfWG2u9ZkPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CYnJPwXP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CYnJPwXP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774360695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N+Vl01L8mFypGqINWjr7aMlQHsMAMVO/OQk80MDWE8s=;
	b=CYnJPwXPYI7tvIZmnXSr9K13L2BuzgyHLX2/46G1t7uFChEKZ7bxGPDx0u//0uFlYO91eI
	YGNs8L+AOvSHcpqwI82Wdj3a3adReNVuE5wALhIfclk7g5Sxg9fxy+CBLZJ3jIjmQGmmAj
	ivku5pSogkjN0frrlhYwUpWrokIrdXE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-3-4Q9i1N89O2G1Wtw8t7Q9oA-1; Tue,
 24 Mar 2026 09:58:11 -0400
X-MC-Unique: 4Q9i1N89O2G1Wtw8t7Q9oA-1
X-Mimecast-MFC-AGG-ID: 4Q9i1N89O2G1Wtw8t7Q9oA_1774360690
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57F811800371;
	Tue, 24 Mar 2026 13:58:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2AD9180058C;
	Tue, 24 Mar 2026 13:58:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62ODw7Yl1059793
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 09:58:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62ODw7qI1059792;
	Tue, 24 Mar 2026 09:58:07 -0400
Date: Tue, 24 Mar 2026 09:58:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
Message-ID: <acKYbwGlfgWKDxnF@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Mar 24, 2026 at 10:57:20AM +0000, John Garry wrote:
> On 23/03/2026 19:45, Benjamin Marzinski wrote:
> > > > I don't
> > > > think the Native SCSI multipath code would need to actively interface
> > > > with the device handler code to support IMPLICIT ALUA. IIUC, looking at
> > > > sdev->access_state should be enough to pick the correct path.
> > > We also have the functionality from alua_check_sense() to consider.
> > But the multipath code won't call that directly. Right now, the scsi
> > device handler will, at least for every scsi device except ones using
> > the Native Multipath code. My point is that this would just work, except
> > that the Native Multipath code goes out of its way to break it, by
> > disabling device handlers, and I don't really see the point of disabling
> > something that every other scsi device, multipathed or not, has enabled.
> > It's not like leaving it enabled makes it any harder to move the
> > implicit ALUA support from the device handler to the generic scsi code,
> > if that's the goal, since the Native Multipath code doesn't care who is
> > issuing those rtpgs and updating the state.
> > 
> > I guess this is more of a question for Hannes. Is the goal to turn off
> > automatic device handler attachment in general, and go back to making
> > dm-multipath attach device handlers to the scsi devices it is using?
> 
> I'm not answering for Hannes, but I don't think that is the goal.
> 
> > If
> > not, then I don't see any reason to have the Native Multipath code
> > disable it.
> 
> It was just disabled it as we now had another method in the scsi core code
> to get ALUA info.
> 
> My plan would be - based on this series - to not attach DH just when using
> native SCSI multipath for a device.
> 
> > If it allowed device handlers to get attached, these two
> > developement efforts (native scsi multipath and refactoring the alua
> > support) could go on in parallel.
> > 
> > Or am I missing something here?
> 
> It just seems to be about this DH stuff is that there is bad history there
> and no more users are wanted.

Just to be clear, if the idea was that the Native Multipath code
shouldn't use include/scsi/scsi_dh.h, I completely agree with that. But
I don't see why it can't make use of the results of the existing
implicit ALUA support, since IIUC it doesn't need the scsi_dh interface
to do that. That shouldn't interfere with any refactoring that people
want to do of how the scsi layer actually handles ALUA support. Again,
this is more for Hannes than you, John.

-Ben

> 
> But now I am getting bogged down in this ALUA support because of that, which
> I feared would happen.
> 
> Thanks,
> John

