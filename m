Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F9F42F56E
	for <linux-scsi@vger.kernel.org>; Tue,  3 Mar 2026 14:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547657; cv=none; b=QaiNqPInM6BE4KCMk28K6aX0pEZSRvdCUsy83dQHG45pj9Q8PsNl8MbIh1ufeHXgEXvV7TI4ogYysDamCX1FtESLTJ4l7f3IdE9wf9ETxb4VMzM9tquKfosCTijLKxF01U1MZk5a8Xgw95xhf6uhm6AwdLdqyu8SiB9IPVxY/qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547657; c=relaxed/simple;
	bh=IkQ7/gyK0kZ4FalknuXom3D+eyJvw5c+6TIGp5/qhI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eej/lJeKAJhiLJRZW1pjd081Mw+sWz8KlSJI9HXylZoB+VbNekNO095Dk2kMp8E7YmmgP+Fc1yfY8snVIKbq4q4KqovpQT9VpX6Snnv7xsygeNl+j+ab664WX9i1Ja25HnCHGqqjm1YKjdyvTPlnlzJ9RwVuFFW8NnSRCz4BwL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CUvUYXgi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUvUYXgi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772547655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hpscGlqtT0S5hsz/lvyVjD4lT80PmJ0j11LCHkWNSX8=;
	b=CUvUYXgigXubGNHGgiMATtQquc0X01JXnse/JSrxcs75h86ojlpnE98WkSqQPWSqm3YTiD
	tsbqQXlkeW31ttRZBvvvUBjsxoRN3vVTu9BNfKStS6PH91j6nT20FExk11cKHg9Wi/Wfvj
	glFXogcxpuW2rDe9vzR7sE+wniPCx0M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-3ehT5qksMqaYvuvFq6SAhg-1; Tue,
 03 Mar 2026 09:20:52 -0500
X-MC-Unique: 3ehT5qksMqaYvuvFq6SAhg-1
X-Mimecast-MFC-AGG-ID: 3ehT5qksMqaYvuvFq6SAhg_1772547649
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B940B1956095;
	Tue,  3 Mar 2026 14:20:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 632EE1800590;
	Tue,  3 Mar 2026 14:20:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 623EKkZo1889507
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 3 Mar 2026 09:20:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 623EKibS1889506;
	Tue, 3 Mar 2026 09:20:44 -0500
Date: Tue, 3 Mar 2026 09:20:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
Message-ID: <aabuPClNgSC6uO93@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-3-john.g.garry@oracle.com>
 <aaT0Taxs6WgX6m-j@redhat.com>
 <784abca8-9dc1-4fca-b72f-62d55b4cc3f1@oracle.com>
 <aaZ0Kf9n79QF4gbR@redhat.com>
 <003612c1-ff07-466c-93e8-d7766a9ec2db@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <003612c1-ff07-466c-93e8-d7766a9ec2db@suse.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Mar 03, 2026 at 09:01:04AM +0100, Hannes Reinecke wrote:
> On 3/3/26 06:39, Benjamin Marzinski wrote:
> > On Mon, Mar 02, 2026 at 11:39:28AM +0000, John Garry wrote:
> > > On 02/03/2026 02:22, Benjamin Marzinski wrote:
> > > > > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > > > > index 19d0884479a24..cfab7ad1e3c2c 100644
> > > > > --- a/drivers/scsi/Kconfig
> > > > > +++ b/drivers/scsi/Kconfig
> > > > > @@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
> > > > >    	  If unsure say N.
> > > > > +config SCSI_MULTIPATH
> > > > > +	bool "SCSI multipath support"
> > > > At least until this supports ALUA, it should probably be marked
> > > > EXPERIMENTAL, just so people trying it out aren't surprised if it
> > > > doesn't multipath their device in the way they expect.
> > > 
> > > I think that ALUA support will be mainline acceptance criteria, and I am
> > > looking to add it now.
> > > 
> > > BTW, Hannes suggested to not use the DH ALUA support, so that means to
> > > separate out the core ALUA support from the DH stuff. So you have any
> > > opinion on that approach?
> > 
> > I would (perhaps naively) have thought that the device handlers would be
> > a useful abstraction for dealing with ALUA devices. But, Hannes knows
> > this code much better than me. like I said before, I'm no scsi expert.
> > 
> The main point of the device handlers was to inject a 'start' command
> whenever paths needed to be switched (Like you need to do for some
> active/passive arrays).
> But that really caused quite some issues with complexity, as you easily
> can get into array path ping-pong on path failure with no I/O being
> transmitted.
> 
> So for this implementation I would stick with implicit ALUA
> (most modern implementations have done so already anyway), and
> then there's no need using the device handlers.

That makes sense. Limiting support to implicit ALUA significantly lowers
the bar for getting ALUA working. AFAICS, It should just require getting
the path selecting code right.

-Ben

> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

