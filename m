Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8722533F36B
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 04:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773463707; cv=none; b=E9nm/CvV7iO1qwVK0o2ImrXpzEzwyCzTiRjzEewrzL9lUuPg13jIXXfIw7Bf8Hzl7o6Ikl17sIaSrm3H6NmTLQrFtj6i29uklogpD81VH7AWg13NhctZNZJf8VrazPLVKSgQfciPflCRwNjWCyqePkCa7fVtm42m30sPVi8cnY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773463707; c=relaxed/simple;
	bh=PvWuwG2ywc2R+2/rXmy+XRztrkHFDWnmbplPAc1hxCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXUKpzC4PgBNS5NUYrmkM0LPxl7Iy7E+XRTEXYVshvBZHVHLjFS+B6Pv0zSqZTZlAGL4sapwt11UBLvHXiHodCwJrqGeiolOCq0ZMdSYkct1muBRZK+h2igKWQs/Z+mHin0+NE5VtYjs9rGzEo+E7d7eMBlim9y8hw4K9tMronY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ig1rqm35; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ig1rqm35"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773463704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NM6J8HoFmRLN9ev8VxIJyNIjesoGyOX5ZDk4Zr06EMU=;
	b=ig1rqm35Ll2x1kATqjtv9MUMP/neEbJiOjTj56ZAzALi5FCCiVJ6iUYbxGkxzEwz3eVYTc
	YpMLk7Y9PHTIUwbR7h7g/T+5NRz5CxbzbuUXjByFXLRLGXj9MgLrl3lDmXoFgcZPSUp2TJ
	w2N/tK3UTFFjpEtIvErJn0O6cLOonA4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-WrV4USFbPD-qxcsVm-OAxg-1; Sat,
 14 Mar 2026 00:48:21 -0400
X-MC-Unique: WrV4USFbPD-qxcsVm-OAxg-1
X-Mimecast-MFC-AGG-ID: WrV4USFbPD-qxcsVm-OAxg_1773463699
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A10B01956088;
	Sat, 14 Mar 2026 04:48:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E247D19560B7;
	Sat, 14 Mar 2026 04:48:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62E4mGJm688491
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 14 Mar 2026 00:48:16 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62E4mGBt688490;
	Sat, 14 Mar 2026 00:48:16 -0400
Date: Sat, 14 Mar 2026 00:48:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com
Subject: Re: [PATCH 5/8] scsi: scsi-multipath: Add basic ALUA support
Message-ID: <abTokAgL5B8NS8ae@redhat.com>
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-6-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310114925.1222263-6-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Mar 10, 2026 at 11:49:22AM +0000, John Garry wrote:
> Add basic support just to get the per-port group state.
> 
> This support does not account of state transitioning, sdev port group
> reconfiguration, etc, required for full support.
> 
> libmultipath callbacks scsi_mpath_is_optimized() and
> scsi_mpath_is_disabled() are updated to take account of the ALUA-provided
> path information.
> 
> As before, for no ALUA support (and scsi_multipath_always on) we assume
> that the paths are all optimized.
> 
> Much of this code in scsi_mpath_alua_init() is copied from scsi_dh_alua.c,
> originally authored by Hannes Reinecke.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/scsi_multipath.c | 163 ++++++++++++++++++++++++++++++++--
>  include/scsi/scsi_multipath.h |   3 +
>  2 files changed, 160 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 1489c7e979167..0a314080bf0a5 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -4,6 +4,7 @@
>   *
>   */
>  
> +#include <scsi/scsi_alua.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_driver.h>
>  #include <scsi/scsi_proto.h>
> @@ -346,18 +347,29 @@ static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
>  				to_scsi_mpath_device(mpath_device);
>  	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>  	enum scsi_device_state sdev_state = sdev->sdev_state;
> +	int alua_state = scsi_mpath_dev->alua_state;
>  
>  	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_CANCEL)
>  		return false;
>  
> -	return true;
> +	if (alua_state == SCSI_ACCESS_STATE_OPTIMAL ||
> +	    alua_state == SCSI_ACCESS_STATE_ACTIVE)
> +		return true;
> +
> +	return false;
>  }
>  
>  static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
>  {
> +	struct scsi_mpath_device *scsi_mpath_dev =
> +				to_scsi_mpath_device(mpath_device);
> +
>  	if (scsi_mpath_is_disabled(mpath_device))
>  		return false;
> -	return true;
> +	if (scsi_mpath_dev->alua_state == SCSI_ACCESS_STATE_OPTIMAL)
> +		return true;
> +	return false;
> +
>  }
>  
>  /* Until we have ALUA support, we're always optimised */
> @@ -366,7 +378,7 @@ static enum mpath_access_state scsi_mpath_get_access_state(
>  {
>  	if (scsi_mpath_is_disabled(mpath_device))
>  		return MPATH_STATE_INVALID;
> -	return MPATH_STATE_OPTIMIZED;
> +	return scsi_mpath_is_optimized(mpath_device);
>  }
>  
>  static bool scsi_mpath_available_path(struct mpath_device *mpath_device, bool *available)
> @@ -579,16 +591,147 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
>  	sdev->scsi_mpath_dev = NULL;
>  }
>  
> +static int scsi_mpath_alua_init(struct scsi_device *sdev)
> +{
> +	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
> +	struct scsi_sense_hdr sense_hdr;
> +	int len, k, off, bufflen = ALUA_RTPG_SIZE;
> +	unsigned char *desc, *buff;
> +	unsigned int tpg_desc_tbl_off;
> +	int group_id, rel_port = -1;
> +	bool ext_hdr_unsupp = false;
> +	int ret;
> +
> +	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
> +	if (group_id < 0) {
> +		/*
> +		 * Internal error; TPGS supported but required
> +		 * VPD identification descriptors not present.
> +		 * Disable ALUA support.
> +		 */
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: No target port descriptors found\n",
> +			    __func__);
> +		return -EIO;
> +	}
> +
> +	buff = kzalloc(bufflen, GFP_KERNEL);
> +	if (!buff)
> +		return -ENOMEM;
> + retry:
> +	ret = submit_rtpg(sdev, buff, bufflen, &sense_hdr,
> +				ext_hdr_unsupp);
> +
> +	if (ret) {
> +		if (ret < 0 || !scsi_sense_valid(&sense_hdr)) {
> +			sdev_printk(KERN_INFO, sdev,
> +				    "%s: rtpg failed, result %d\n",
> +				    __func__, ret);
> +			kfree(buff);
> +			if (ret < 0)
> +				return -EBUSY;
> +			if (host_byte(ret) == DID_NO_CONNECT)
> +				return -ENODEV;
> +			return -EIO;
> +		}
> +
> +		/*
> +		 * submit_rtpg() has failed on existing arrays
> +		 * when requesting extended header info, and
> +		 * the array doesn't support extended headers,
> +		 * even though it shouldn't according to T10.
> +		 * The retry without rtpg_ext_hdr_req set
> +		 * handles this.
> +		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
> +		 * with ASC 00h if they don't support the extended header.
> +		 */
> +		if (ext_hdr_unsupp &&
> +		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
> +			ext_hdr_unsupp = true;
> +			goto retry;
> +		}
> +		/*
> +		 * If the array returns with 'ALUA state transition'
> +		 * sense code here it cannot return RTPG data during
> +		 * transition. So set the state to 'transitioning' directly.
> +		 */
> +		if (sense_hdr.sense_key == NOT_READY &&
> +		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
> +			goto out;

This check is odd. First, we don't set the state to 'transitioning' like
the comment says. We don't set alua_state at all, which ends up meaning
that it stays as 0 (SCSI_ACCESS_STATE_OPTIMAL). It seems like we should
explicitly set it and make the comment reflect that, if just to aid
understanding of the logic.

Nitpick: Also, this is the only place where we goto out. All the other
checks individually free the buffer and return directly. I realize that
all the other checks that exit early are errors, but it seems like we
could just return a variable at the end of the function.

> +
> +		/*
> +		 * Retry on any other UNIT ATTENTION occurred.
> +		 */
> +		if (sense_hdr.sense_key == UNIT_ATTENTION) {
> +			scsi_print_sense_hdr(sdev, __func__, &sense_hdr);
> +			kfree(buff);
> +			return -EAGAIN;
> +		}

If we get a UNIT ATTENTION, we end up failing scsi_mpath_dev_alloc(),
not retrying. Aside from the comment being wrong, it seems very brittle
to fail here, just because we got a UNIT ATTENTION.

-Ben

> +		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
> +			    __func__);
> +		scsi_print_sense_hdr(sdev, __func__, &sense_hdr);
> +		kfree(buff);
> +		return -EIO;
> +	}
> +
> +	len = get_unaligned_be32(&buff[0]) + 4;
> +
> +	if (len > bufflen) {
> +		/* Resubmit with the correct length */
> +		kfree(buff);
> +		bufflen = len;
> +		buff = kmalloc(bufflen, GFP_KERNEL);
> +		if (!buff) {
> +			/* Temporary failure, bypass */
> +			return -EBUSY;
> +		}
> +		goto retry;
> +	}
> +
> +	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
> +		tpg_desc_tbl_off = 8;
> +	else
> +		tpg_desc_tbl_off = 4;
> +
> +	for (k = tpg_desc_tbl_off, desc = buff + tpg_desc_tbl_off;
> +	     k < len;
> +	     k += off, desc += off) {
> +		u16 group_id_found = get_unaligned_be16(&desc[2]);
> +
> +		if (group_id_found == group_id) {
> +			int valid_states, state, pref;
> +
> +			state = desc[0] & 0x0f;
> +			pref = desc[0] >> 7;
> +			valid_states = desc[1];
> +
> +			alua_print_info(sdev, group_id, state, pref, valid_states);
> +
> +			scsi_mpath_dev->alua_state = state;
> +			scsi_mpath_dev->alua_pref = pref;
> +			scsi_mpath_dev->alua_valid_states = valid_states;
> +			goto out;
> +		}
> +
> +		off = 8 + (desc[7] * 4);
> +	}
> +
> +out:
> +	kfree(buff);
> +	return 0;
> +}
> +
>  int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>  {
>  	struct scsi_mpath_head *scsi_mpath_head;
> -	int ret;
> +	int ret, tpgs;
>  
>  	if (!scsi_multipath)
>  		return 0;
>  
> -	if (!scsi_device_tpgs(sdev) && !scsi_multipath_always) {
> -		sdev_printk(KERN_NOTICE, sdev, "tpgs are required for multipath support\n");
> +	tpgs = alua_check_tpgs(sdev);
> +	if (!(tpgs & TPGS_MODE_IMPLICIT) && !scsi_multipath_always) {
> +		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
>  		return 0;
>  	}
>  
> @@ -622,6 +765,14 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>  	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
>  
>  found:
> +	if (tpgs & TPGS_MODE_IMPLICIT) {
> +		ret = scsi_mpath_alua_init(sdev);
> +		if (ret)
> +			goto out_put_head;
> +	} else {
> +		sdev->scsi_mpath_dev->alua_state = SCSI_ACCESS_STATE_OPTIMAL;
> +	}
> +
>  	sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
>  	if (sdev->scsi_mpath_dev->index < 0) {
>  		ret = sdev->scsi_mpath_dev->index;
> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
> index 2011447f482d6..7c7ee2fb7def7 100644
> --- a/include/scsi/scsi_multipath.h
> +++ b/include/scsi/scsi_multipath.h
> @@ -38,6 +38,9 @@ struct scsi_mpath_device {
>  	int			index;
>  	atomic_t		nr_active;
>  	struct scsi_mpath_head	*scsi_mpath_head;
> +	int			alua_state;
> +	int			alua_pref;
> +	int			alua_valid_states;
>  
>  	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
>  };
> -- 
> 2.43.5

