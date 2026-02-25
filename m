Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230B32309B2
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 00:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771980410; cv=none; b=KyMYH0jVhQRU/hOodVH0ueOatNbGUMRpcODB0QbuJSFbDfW0+u6hDPUGN8Xp3WhdFgU/HLYUIJPT2ncsHAIFWFler4dOEf7iKFrPo+wieNy0NlwHl2yypt8k4vUtJT8YP4ZCvFjlwJexIZpQ37nJKqs4EgCGd6edSmsaFjTYU8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771980410; c=relaxed/simple;
	bh=9GHiBkrPxDxT4gm/0NFYVvV91kzXbVO7+7SdoSElsUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WaXVyXrj7YrDIW4RlKNTDzQ6eo0bw695wLX7Z66PbfPoSt7rw/o4gJwsA5F2tABYlNuPyoqbeJjlPzt726NEsVO4FGpQIr85VwLfacTdnmFve6krgr4ow3y4HUblLFJk7QJ9+cxTP8+5X9FifVwSBmCapfo40j1+mjzu+Yawahg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hZnbumvh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hZnbumvh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771980408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wu6e7y6744AKrfSalZoNneCouriwnPLCWnCIppXtUnk=;
	b=hZnbumvhRqa8J0PLDDpTW0gmidYa0WKvlCC8pDqApCD9K1ecja9mAPG6jmQzxS9/K6PxET
	/SYdiBgVe89eJZZAasYdhCoZVDswO7KRmgViMjtRR1jlQEfjXkdzD5vbCpcGFboOWWaK2K
	zwDM4use1UTidHNjNaFBt+MDaEWuiek=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-4PJYxqWAM6iAB9Q5q0qJVQ-1; Tue,
 24 Feb 2026 19:46:41 -0500
X-MC-Unique: 4PJYxqWAM6iAB9Q5q0qJVQ-1
X-Mimecast-MFC-AGG-ID: 4PJYxqWAM6iAB9Q5q0qJVQ_1771980400
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B5AD1956052;
	Wed, 25 Feb 2026 00:46:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 266451800348;
	Wed, 25 Feb 2026 00:46:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 61P0kbjW1637572
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 19:46:38 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 61P0kbXS1637571;
	Tue, 24 Feb 2026 19:46:37 -0500
Date: Tue, 24 Feb 2026 19:46:37 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, lsf-pc@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
Message-ID: <aZ5GbVxDT3gcS6WE@redhat.com>
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <aZnuSC0qYfw0hiwM@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZnuSC0qYfw0hiwM@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Sat, Feb 21, 2026 at 12:41:28PM -0500, Mike Snitzer wrote:
> On Fri, Feb 13, 2026 at 02:19:11PM +0000, John Garry wrote:
> > At ALPSS 25 I presented a proposal for Native SCSI multipath support. Let's
> > discuss this topic at LSFMM.
> > 
> > The idea for this is that SCSI could natively support multipath, like how
> > NVMe host driver does today. It is intended as an alternative to
> > dm-multipath support.
> > 
> > I have been working on the implementation and I plan to post patches in the
> > next cycle. I am looking at a 3-stage approach:
> > a. create a driver-agnostic multipath library, very heavily based on NVMe
> > host multipath support.
> > The library would support features such as path management, path
> > selection/iopolicy, failover recovery, PR, delayed removal, gendisk
> > management etc.
> > b. switch NVMe over to use this library
> 
> I can appreciate that the kernel to userspace interface of DM
> multipath is clearly unwanted (hence NVMe multipath and now SCSI
> multipath).
> 
> But you should really be switching DM-multipath over to using it too;
> or at least detailing _why_ the core of DM multipath
> (drivers/md/dm-mpath.c) cannot be updated to use this common backend
> library.
> 
> This line of work makes little sense to me if it just ignores
> dm-multipath.
> 
> Mike

Thinking about this work from a DM multipath perspective, I'm more
interested in how much it plans to handle the more annoying niche cases
of dealing with SCSI devices, like paths that confidently report that
they are able to accept IO, only to fail all IO sent to them. Also, I
wonder how/if this is planning on handling Persistent Reservations. The
arrays, I assume, are still going to see this as a collection of I_T
Nexuses (some of which may be down and unable to accept commands at any
given time, and to which new ones my be added) instead of a single one.

I also think this would be useful to talk about at LSF.

-Ben

> 
> > c. add native SCSI multipath support based on this common library
> > 
> > Thanks,
> > John
> > 
> > 
> > 

