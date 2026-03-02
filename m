Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C46C2DF151
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 03:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772423887; cv=none; b=Say/KQBLX0bZIGIW8Gnf9vg4OCemgWuPIQbBmsx56WYmdN3/NoxasofFcktjes0sJoircn7mZEgBbh6AHkdnXuRGuJYGTQqc3IKFEIxYPbTz+CNydwfVsv2HDUvpi+pUHen6BrwImpmtdb0YhdTraxHajsGywNIhcCEt9JjGlMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772423887; c=relaxed/simple;
	bh=dZCirF+d+Cw3tiWYV9u8CCreqoTN55Hii2si/BtHZUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jEWl2fNnF0CLuWvSYwZXwi8CkeimqDNC45NMKv5H7+lAtLqad9V0Uq0SbPgVB+fC8jl6FoV2g9LArhEfIeO/Y0nOd2LPVhSnNYgqjsCto5WBmnstL4rZVQdroegmdopBoCrkkA2vRoGIcYApAtoMZfsvG7TEhiTaDv6W8ExakgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CnAqHt+6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnAqHt+6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772423885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t17Mj1eHT4BQtcJr+lrLfPnsDWPF4OBSvXbUFhohcuY=;
	b=CnAqHt+6Mhl0puSaXPgswN2QdLebQwKLWb6iLKGZhO4/NE38wKinWzUY5cICd95o9MOQxX
	NJlxFGoyHJscTAUHwRz4Ywxn7qWY+gMslkEPW/g2rfbWukWiNZBivGdbpvDLUiYA6sMxgY
	YowZq9vNvc32uP8OnU4fXVXVh8UOb2U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-676-1u7MPTEFMsGtKZXuyyxYVg-1; Sun,
 01 Mar 2026 22:58:02 -0500
X-MC-Unique: 1u7MPTEFMsGtKZXuyyxYVg-1
X-Mimecast-MFC-AGG-ID: 1u7MPTEFMsGtKZXuyyxYVg_1772423880
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBF3E18003FC;
	Mon,  2 Mar 2026 03:57:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB20230001B9;
	Mon,  2 Mar 2026 03:57:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6223vve81831914
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 1 Mar 2026 22:57:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6223vv4F1831913;
	Sun, 1 Mar 2026 22:57:57 -0500
Date: Sun, 1 Mar 2026 22:57:57 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/24] scsi-multipath: failover handling
Message-ID: <aaUKxeoT69K435UE@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-10-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225153627.1032500-10-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Feb 25, 2026 at 03:36:12PM +0000, John Garry wrote:
> For a scmd which suffers failover, requeue the master bio of each bio
> attached to its request.
> 
> A handler is added in the scsi_driver structure to lookup a
> mpath_disk from a request. This is needed because the scsi_disk structure
> will manage the mpath_disk, and the code core has no method to look this
> up from the scsi_scmnd.
> 
> Failover occurs when the scsi_cmnd has failed and it is discovered that the
> original scsi_device has transport down.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/scsi_error.c     | 12 ++++++
>  drivers/scsi/scsi_lib.c       |  9 +++-
>  drivers/scsi/scsi_multipath.c | 80 +++++++++++++++++++++++++++++++++++
>  include/scsi/scsi.h           |  1 +
>  include/scsi/scsi_driver.h    |  3 ++
>  include/scsi/scsi_multipath.h | 14 ++++++
>  6 files changed, 118 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f869108fd9693..0fd1b46764c3f 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -40,6 +40,7 @@
>  #include <scsi/scsi_ioctl.h>
>  #include <scsi/scsi_dh.h>
>  #include <scsi/scsi_devinfo.h>
> +#include <scsi/scsi_multipath.h>
>  #include <scsi/sg.h>
>  
>  #include "scsi_priv.h"
> @@ -1901,12 +1902,16 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>  enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
>  {

I'm no scsi expert, but the checks in scsi_decide_disposition() don't
look quite right to me. You only failover in cases were it the code
might want to retry (and when the device is offline), but there are
other cases, when you don't want to retry the same path, where it would
make sense to try another path, DID_TRANSPORT_FAILFAST for example. 

As a more general issue, since you are already cloning the bios,
couldn't you just trigger the failovers in scsi_mpath_clone_end_io().
blk_path_error() can tell you which bios should be retried. That seems
like a much simpler approach than trying to intercept the request before
it completes the clones, and I don't see what you're losing by letting
the clones complete, and dealing requeueing there (again, I'm no scsi
expert).

>  	enum scsi_disposition rtn;
> +	struct request *req = scsi_cmd_to_rq(scmd);
>  
>  	/*
>  	 * if the device is offline, then we clearly just pass the result back
>  	 * up to the top level.
>  	 */
>  	if (!scsi_device_online(scmd->device)) {
> +		if (scsi_is_mpath_request(req))
> +			return scsi_mpath_failover_disposition(scmd);
> +
>  		SCSI_LOG_ERROR_RECOVERY(5, scmd_printk(KERN_INFO, scmd,
>  			"%s: device offline - report as SUCCESS\n", __func__));
>  		return SUCCESS;
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index c3e0f792e921f..16b1f84fc552c 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -518,6 +518,86 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
>  }
>  EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
>  
> +bool scsi_is_mpath_request(struct request *req)
> +{
> +	return is_mpath_request(req);
> +}
> +EXPORT_SYMBOL_GPL(scsi_is_mpath_request);
> +
> +static inline void bio_list_add_clone_master(struct bio_list *bl,
> +				struct bio *clone)
> +{
> +	struct scsi_mpath_clone_bio *scsi_mpath_clone_bio;
> +	struct bio *master_bio;
> +
> +	if (clone->bi_next)
> +		bio_list_add_clone_master(bl, clone->bi_next);

This is a pretty minimal function, but a request could have a lot of
merged bios, so you probably want to hande them iteratively, instead of
recursing into the function, and eating up stack space unnecessarily.
Also, this reverses the bio's order when adding them to the requeue
list.

-Ben

> +
> +	scsi_mpath_clone_bio = scsi_mpath_to_master_bio(clone);
> +	master_bio = scsi_mpath_clone_bio->master_bio;
> +
> +	if (bl->tail)
> +		bl->tail->bi_next = master_bio;
> +	else
> +		bl->head = master_bio;
> +
> +	bl->tail = master_bio;
> +
> +	bio_put(clone);
> +}

