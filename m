Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10690364E95
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 15:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774367335; cv=none; b=Veqlr9LAP7t5IGyjwSfNHP7BEFw/0t0DctSINGaQu+W8c3Xk2zDWgGxeswkPuJUo5tKiGonvLRQDhi+wFAkCetrcKa/Lt8Xpz4DTlJCyjHlE4QlOFFeLlK6eXiprD3E30H0kTTwpuEhUS4QQApK78fjbsdi1kdbx7u4UmPgU4TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774367335; c=relaxed/simple;
	bh=nPKJzSlPKmzZDrLZ6540Z4pthdImph+ML90NBW1cebY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8hEw7YwBCWJ95sfch5o/xCnkhdCnXAec1WQ7QMO5fX4PAvn3mUT7sh+JyS15ZUx5zai+pkP1ZR3495395b3GdkaA6pmAcO9COH9jpGXGIaoZ1s3bAqAAo39pkZRrUGCmLU3+F2V5O/IcxPrpRt7IoGkBsAxDWOiJB4MdJ2a0JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JN0Qd5KI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JN0Qd5KI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774367333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6sYTQsR4r0P90gD1IPGxk5ceU2E1+b/EiFHPyg0IyOI=;
	b=JN0Qd5KIaYAzfmDAFJjki4RABft7VWwjh3TejwQXcfv1YeJ/hdp3RlmmiMzm4ePBxMTj51
	iVLFSxh7Igr/+/D+J/j/Nnzek2jwoKv7emZR+lLPPyOlfaZ505vyj9ACIQU9/2SnbhcVDU
	NtNm0A56AW7EhFOZH6nhBdpdYgoZbkc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-548-cztVxnP1Oe6ut57dclxDRA-1; Tue,
 24 Mar 2026 11:48:47 -0400
X-MC-Unique: cztVxnP1Oe6ut57dclxDRA-1
X-Mimecast-MFC-AGG-ID: cztVxnP1Oe6ut57dclxDRA_1774367326
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43B8B19560B1;
	Tue, 24 Mar 2026 15:48:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 906FC19540C4;
	Tue, 24 Mar 2026 15:48:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62OFmimg1062653
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Mar 2026 11:48:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62OFmhsp1062652;
	Tue, 24 Mar 2026 11:48:43 -0400
Date: Tue, 24 Mar 2026 11:48:43 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
Message-ID: <acKyW6IPMhhZ_eF8@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
 <acKYbwGlfgWKDxnF@redhat.com>
 <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Mar 24, 2026 at 03:12:38PM +0000, John Garry wrote:
> On 24/03/2026 13:58, Benjamin Marzinski wrote:
> > > > If it allowed device handlers to get attached, these two
> > > > developement efforts (native scsi multipath and refactoring the alua
> > > > support) could go on in parallel.
> > > > 
> > > > Or am I missing something here?
> > > It just seems to be about this DH stuff is that there is bad history there
> > > and no more users are wanted.
> > Just to be clear, if the idea was that the Native Multipath code
> > shouldn't use include/scsi/scsi_dh.h, I completely agree with that. But
> > I don't see why it can't make use of the results of the existing
> > implicit ALUA support, since IIUC it doesn't need the scsi_dh interface
> > to do that.
> 
> We would need something like the following to ensure that DH ALUA is present
> to update sdev access_state:
> 
> @@ -80,6 +80,7 @@ config SCSI_MULTIPATH
>         bool "SCSI multipath support"
>         depends on SCSI_MOD
>         select LIBMULTIPATH
> +       select SCSI_DH_ALUA
>         help
>           This option enables support for native SCSI multipath support for
>           SCSI host.

DM_MULTIPATH doesn't force the device handlers to be built. You just
don't have their support if they aren't there. Granted, it does make
sure that if they are built, you can't build dm-multipath directly into
the kernel, if the device handlers are built as modules.

> 
> And that is even enough, as Kconfigs should only specify build requirements.
> 
> We really should be also calling something like scsi_dh_attach() for scsi
> multipath to ensure that DH is attached (and running to update
> sdev->access_state).

That isn't necessary. If there is an alua device handler, kernel will
auto-attach it to any device that supports alua (see scsi_dh_add_device
and scsi_dh_find_driver). DM-multipath's calling of scsi_dh_attach() is
mostly a historical relic.

> And I am not sure how the dh alua module is even autoloaded. I think that on
> my ubuntu machine the multipath-tools.service does it - something like this
> would not be nice for native SCSI multipath support.

Fair point. Depending on how the kernel is built, there could be system
configuration work that needs to happen if implicit alua support
wasn't in the generic scsi code. But as far as the kernel code goes, I
still see them as parallel efforts. 

-Ben

>  That shouldn't interfere with any refactoring that people
> > want to do of how the scsi layer actually handles ALUA support. Again,
> > this is more for Hannes than you, John.
> 
> Thanks,
> John

