Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C3D2BE057
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 02:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772418138; cv=none; b=njY7fbHZ9rG8kaIWQhju6joQpejHK86XV6YsD+8OZtwzcdcmeBvOH4zuO34gKc0f4weT2IR5aHNhOfR4uGZ023SxU+wKHAEmgjH28AVlIrb7X9EgZS05QCRrA0BHbbKyBLO4YKdwLhDz34TLWBhq5yepdrVtf5HTsYLdwrnrNOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772418138; c=relaxed/simple;
	bh=ogZhrs+ynBdOLbuwoQfaSSFuscOtyuIWJEVebHfaTWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mml08bI7juJ5dYbQBeGmQa++Oow64Hk17NnXraxRptuzRx4fGmwTSVCZhFNOrY5xRyq8tcpI3hqLdBDO1N7U+vBomWh12W2dShELJSbOoauM8z/3XvGpDYJh4xIG4WnF74LTxovaBZj/ZjSAclvGcSademWcEahiOMp5+A+rEJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZXluLmYy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZXluLmYy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772418135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ubPJujatj4+N2BOY/aHQ9FwR3IIuPKfIVVUU3eyTFAA=;
	b=ZXluLmYyi4cYoYWebc+iOB29ylgofFuMYPl9S0hfHKsniQrxOVYIvk6ZUMdIn8xXW/4RRv
	Dcax2pDkjPAfCUnj3qSilKcKN0pyqtfjVNfa2d8H0zD47YBDn0I1PYLdkKhxEnMnYSWCzp
	xXxtbOx+TYSkboE31CPgHvUhU3G8+1A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-656-grVdMD9COr6kZybo6HGCZw-1; Sun,
 01 Mar 2026 21:22:10 -0500
X-MC-Unique: grVdMD9COr6kZybo6HGCZw-1
X-Mimecast-MFC-AGG-ID: grVdMD9COr6kZybo6HGCZw_1772418128
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07C2F18003F5;
	Mon,  2 Mar 2026 02:22:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C3CA1800666;
	Mon,  2 Mar 2026 02:22:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6222M5DR1829264
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 1 Mar 2026 21:22:05 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6222M5SK1829263;
	Sun, 1 Mar 2026 21:22:05 -0500
Date: Sun, 1 Mar 2026 21:22:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
Message-ID: <aaT0Taxs6WgX6m-j@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225153627.1032500-3-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Feb 25, 2026 at 03:36:05PM +0000, John Garry wrote:
> For a scsi_device to support multipath, introduce structure
> scsi_mpath_device to hold multipath-specific details.
> 
> Like NS structure for NVME, scsi_mpath_device holds the mpath_device
> structure to device management and path selection.
> 
> Two module params are introduced to enable multipath:
> - scsi_multipath
> - scsi_multipath_always
> 
> SCSI multipath will only be available until the following conditions:
> - scsi_multipath enabled and ALUA supported and unique ID available in
>   VPD page 83.
> - scsi_multipath_always enabled and unique ID available in VPD page 83
> 
> The scsi_device structure contains a pointer to scsi_mpath_device, which
> means whether multipath is enabled or disabled for the scsi_device.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/Kconfig          |  10 +++
>  drivers/scsi/Makefile         |   1 +
>  drivers/scsi/scsi.c           |   8 +-
>  drivers/scsi/scsi_multipath.c | 158 ++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_scan.c      |   4 +
>  drivers/scsi/scsi_sysfs.c     |   2 +
>  include/scsi/scsi_device.h    |   2 +
>  include/scsi/scsi_multipath.h |  55 ++++++++++++
>  8 files changed, 239 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/scsi/scsi_multipath.c
>  create mode 100644 include/scsi/scsi_multipath.h
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 19d0884479a24..cfab7ad1e3c2c 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
>  
>  	  If unsure say N.
>  
> +config SCSI_MULTIPATH
> +	bool "SCSI multipath support"

At least until this supports ALUA, it should probably be marked
EXPERIMENTAL, just so people trying it out aren't surprised if it
doesn't multipath their device in the way they expect.

-Ben

