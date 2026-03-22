Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF83F3290CB
	for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2026 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774201052; cv=none; b=WdFFciPJMnKi86K7JyHrAOciPcqcYLp6184TOJE5Wbu0C0RfNqZb/3xuoeSGd2z7gk9lDmHLe+iwp3ETBde2OOLnR5M2dla+3it61NkfIxGa6vgGkWhE+P4+MKHb/a9DljIVb0NK3x/BDC7VUmZ2YqzTTa87G0OjvB/RTv8NsIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774201052; c=relaxed/simple;
	bh=TTu4lJgxhibuurTZpqUttxTI7sCGbIC0nTImyM9/vks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B6uI90kkPS/KxXGQVUJ3DZUYXudPgw15pWBhWREAEGXv1iCfbYufO4mHFxK4QFVX+Q0s8rTqBnXCLveOis2ILMGKRkq2TxjiROQxxro3JzltTV4PNHFKSKbTXYe1ucYFd+ilkm53ZIeQI3/s231+Xa8VPCrR6njWqvRdfjEF1j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W+nvV5EU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W+nvV5EU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774201050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wn9HwJ53vQerMx3CLkFtUxg5VipN/z4E4a1AwUACaF8=;
	b=W+nvV5EUxGJOjzv4/hN0NmkT01RWyiE3qckjnpGm8F1IkLfeo87mhlqukYh49e+WFshypb
	xZTbXf9t8PV5J9fvWUFyMsuZdx9ost3ym/qxanI2RvGEjmhgDZhTakipdQYt8tXUpysxoL
	+Z2m4fPeAfNfWPkNk7sl+hkFHe1g5X4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-hcCwQwlBPXO-v9YsJqOzgw-1; Sun,
 22 Mar 2026 13:37:27 -0400
X-MC-Unique: hcCwQwlBPXO-v9YsJqOzgw-1
X-Mimecast-MFC-AGG-ID: hcCwQwlBPXO-v9YsJqOzgw_1774201045
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35AE11800464;
	Sun, 22 Mar 2026 17:37:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 397241955D71;
	Sun, 22 Mar 2026 17:37:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62MHbMDs990852
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 22 Mar 2026 13:37:22 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62MHbMte990851;
	Sun, 22 Mar 2026 13:37:22 -0400
Date: Sun, 22 Mar 2026 13:37:22 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
Message-ID: <acAo0hr4BxXueQFM@redhat.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Mar 17, 2026 at 12:06:50PM +0000, John Garry wrote:
> Following on the back of the ALUA support for native SCSI multipath
> proposal at [0], this is an attempt to move to a SCSI core ALUA driver.
> 
> Essentially this series move the bulk of the ALUA handling from
> scsi_dh_alua.c to a core driver. We still need to support ALUA for DH, so
> the scsi_dh_alua.c is still responsible for driving ALUA support and the
> SCSI core ALUA driver just provides a set of library functions for that.
> 
> The SCSI core ALUA driver also provides implicit ALUA support for no DH,
> like when we would be native SCSI multipath.
> 
> This series is just really an RFC quality work and its purpose is
> to decide on the direction of ALUA support for native SCSI multipath.
> 
> I think that this work is a real regression possibility for
> dm-multipath, so we need to be careful.

At the risk of showing just how limited my SCSI knowledge is, I need to
ask, Is any of this actually necessary to get native scsi multipath
working with Implicit ALUA?

If the goal is to limit this to IMPLICT ALUA only, I was expecting that
you could just leave the scsi_dh_alua code completely alone. If native
scsi multipathing didn't disable the device handler, it seemed that this
would basically just work. With the device handler attached, when the
array updates the ALUA state, that should, at least I believe, trigger a
unit attention that will fire off a RTPG command. That should update the
sdev->access_state, which the multipath code could use to pick the
correct path. Right? What am I missing here? Is this just a parallel
exercise to overhaul the ALUA code?

-Ben

> 
> [0] https://lore.kernel.org/linux-scsi/20260310114925.1222263-1-john.g.garry@oracle.com/T/#m9c054433076812dff464d0e3b50a00620cfe0af1
> 
> John Garry (13):
>   scsi: scsi_dh_alua: Delete alua_port_group
>   scsi: alua: Create a core ALUA driver
>   scsi: alua: Add scsi_alua_rtpg()
>   scsi: alua: Add scsi_alua_stpg()
>   scsi: alua: Add scsi_alua_tur()
>   scsi: alua: Add scsi_alua_rtpg_run()
>   scsi: alua: Add scsi_alua_stpg_run()
>   scsi: alua: Add scsi_alua_check_tpgs()
>   scsi: alua: Add scsi_alua_handle_state_transition()
>   scsi: alua: Add scsi_alua_prep_fn()
>   scsi: alua: Add scsi_device_alua_implicit()
>   scsi: scsi_dh_alua: Switch to use core support
>   scsi: core: Add implicit ALUA support
> 
>  drivers/scsi/Kconfig                       |   10 +-
>  drivers/scsi/Makefile                      |    1 +
>  drivers/scsi/device_handler/Kconfig        |    1 +
>  drivers/scsi/device_handler/scsi_dh_alua.c | 1003 ++------------------
>  drivers/scsi/scsi.c                        |    7 +
>  drivers/scsi/scsi_alua.c                   |  748 +++++++++++++++
>  drivers/scsi/scsi_error.c                  |    7 +
>  drivers/scsi/scsi_lib.c                    |    7 +
>  drivers/scsi/scsi_scan.c                   |    6 +
>  drivers/scsi/scsi_sysfs.c                  |    7 +-
>  include/scsi/scsi_alua.h                   |  103 ++
>  include/scsi/scsi_device.h                 |    1 +
>  12 files changed, 977 insertions(+), 924 deletions(-)
>  create mode 100644 drivers/scsi/scsi_alua.c
>  create mode 100644 include/scsi/scsi_alua.h
> 
> -- 
> 2.43.5

