Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3362175A8D
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 02:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772417814; cv=none; b=hIbKolXFAWeYZNs9MvV1v0N+uZENUQWGQW+jee8DzjNd2bi021/808Csluoi+rXSvtX7rydYTFONTT3lOMv0Xc26pXcnhNMwJPTcKBN6SyhZ3wDurZJbmsbHE7QeVBmc45UoA+q8LhaYpogeNcxoRF2Ydjp9/EdgNDuCpKV/V6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772417814; c=relaxed/simple;
	bh=cVUQ+s9aBdJOPWf0dOVbIo2IZw9Ax0z/YXdjyJs0I8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvwVtoLeO3n251O9kKrJW/FY0JMeVaAkyigMffnXKTSFU0M6VjZW5+j3PLHIibMilf2Onn1OzzRuQUEjnYYcW7E6CLkbXGJcYJws6P0alW7gTwvHwc5U4RqvsPMcGS6XLrEBBI80vlpPBTu+k2N4Edujdszy6FvgVNWFbs75AxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HK9qi+JE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HK9qi+JE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772417812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TKRBAHBhGf33PeUUogtnMtfD26THedM4RUsbkwW8suQ=;
	b=HK9qi+JEk5gAjoe9dBZqjlz2STJMTT2Hgq63EB3Jgzu2UHghm1XWreKzqK8p2sQ0ZhO1f+
	xP1pepXCwn4cOTRGmTJ6lfNTKQVTkkkJNfCyL54uo2S4ZGlxw6JuSvC/vVjM6BcKG868wO
	fSAqjA50V9dxIoN3ODhBY0oJ2PHaL7Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-LCW3ziGGOgyxShhomJFY4Q-1; Sun,
 01 Mar 2026 21:16:43 -0500
X-MC-Unique: LCW3ziGGOgyxShhomJFY4Q-1
X-Mimecast-MFC-AGG-ID: LCW3ziGGOgyxShhomJFY4Q_1772417801
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B87E1800451;
	Mon,  2 Mar 2026 02:16:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C33030001BF;
	Mon,  2 Mar 2026 02:16:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6222Gavh1829082
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 1 Mar 2026 21:16:37 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6222Gaxo1829081;
	Sun, 1 Mar 2026 21:16:36 -0500
Date: Sun, 1 Mar 2026 21:16:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/24] scsi-multipath: introduce basic SCSI device support
Message-ID: <aaTzBNPE7lDEyxd1@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
>
> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
> new file mode 100644
> index 0000000000000..ca00ea10cd5db
> --- /dev/null
> +++ b/include/scsi/scsi_multipath.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _SCSI_SCSI_MULTIPATH_H
> +#define _SCSI_SCSI_MULTIPATH_H
> +
> +#include <linux/list.h>
> +#include <linux/types.h>
> +#include <linux/rcupdate.h>
> +#include <linux/workqueue.h>
> +#include <linux/mutex.h>
> +#include <linux/blk-mq.h>
> +#include <linux/multipath.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_devinfo.h>
> +#include <scsi/scsi_driver.h>
> +
> +#ifdef CONFIG_SCSI_MULTIPATH
> +#define SCSI_MPATH_DEVICE_ID_LEN 40

Is there a reason that this is set to 40? scsi_vpd_lun_id() can return
ids larger than 40 (struct alua_port_group uses 256 bytes to hold the
response), and I don't know of any guarantee that the id will be unique
within the first 40 characters, although it certainly seems like only
pathological devices wouldn't.

-Ben

> +
> +struct scsi_mpath_device {
> +	struct mpath_device	mpath_device;
> +	struct scsi_device 	*sdev;
> +
> +	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
> +};
> +#define to_scsi_mpath_device(d) \
> +	container_of(d, struct scsi_mpath_device, mpath_device)
> +
> +int scsi_mpath_dev_alloc(struct scsi_device *sdev);
> +void scsi_mpath_dev_release(struct scsi_device *sdev);
> +int scsi_multipath_init(void);
> +void scsi_multipath_exit(void);
> +#else /* CONFIG_SCSI_MULTIPATH */
> +
> +struct scsi_mpath_device {
> +};
> +
> +static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
> +{
> +	return 0;
> +}
> +static inline void scsi_mpath_dev_release(struct scsi_device *sdev)
> +{
> +}
> +static inline int scsi_multipath_init(void)
> +{
> +	return 0;
> +}
> +static inline void scsi_multipath_exit(void)
> +{
> +}
> +#endif /* CONFIG_SCSI_MULTIPATH */
> +#endif /* _SCSI_SCSI_MULTIPATH_H */
> -- 
> 2.43.5

