Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0C540DFA4
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 13:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773149009; cv=none; b=QHyJWOPhVF0DVFE5ET3+umBt5sQ0iB0+iiHdlajutGLJUxrW9Uj+r2msPfgD07eWnzHsHBWI0aW/Lzwa9M6GkXOUUZQO2c9h/9kSxnq7tuhQAnA03Aroj+apY+3M157ttIGEGsDBHPJJ8QQLT0HddRFfUOWqVshdaq2d4pkY6Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773149009; c=relaxed/simple;
	bh=5ZkPijgQN4KXnk9r92p5mndkiQxzAUVaMxOkUm2D3Nw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EWwKWK+nLR1S5NY1pUubsogPJOLZrAtfOKroCva23KIMB+peqMQva/DBPKVPNcQPkj1AsTCIWpRWgNiWqoqBRkaoq1CiqmwcFxjunu5WQCKOUzBUuF8Gn7z6CdzxOylY0cFhaU7w4byv2EyXUyv4iUxNNKgBP0Dqn8AWuoC9Ikc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CNx0j5Cr; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CNx0j5Cr"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-439c9bdc1eeso3384735f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 06:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773149007; x=1773753807; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6aXU/df6s78vw2pBGP8k1zdxSRnKxHzcsOWIx63U+WA=;
        b=CNx0j5Crh0oGfMyNu7YFeusV1FKFYRTbhwkB/9aDMtfmWG7VXeBcYRK4fl/EdJPFJG
         DYeN886JoRZa5jneZHSaH+ichQ40BxhYc+5l0jr75pNgQ/0YJbFBGNBCMDz9A3/uCzFz
         pkR7tv4cxuCJhKb6udS+4vDicxiz2WkFA1txhCPKKpw3+EQSVsqn2KClpAhOowNIXmGG
         9n0Qm2Q/ij5u/K3xNUgLwssWgwROHR0IBwjMLlEm1KAWswArLLr9weu2pajw9GDqfd8c
         BZjannoKubRWfzmXUkHwqEkP1FTsMI6uE33IXlQCksHBN+WmALXVp/SddzXV9rGv++4Z
         Idzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773149007; x=1773753807;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6aXU/df6s78vw2pBGP8k1zdxSRnKxHzcsOWIx63U+WA=;
        b=Foeum0PL/lgq+xLOT3hKcpY38gs527P9jLkUg042BLuqh+8Rr38BQHnOuEhcDE0DKH
         p6pnlfWKOotM8nLVJNY6rnmm0lBkNe7C2YcCYU8khmOV4myDVUPFhpLGAIjQtyeAQK0y
         JHqBuumIaEYmWwmG8kAFcGYxqhGEpt+kyiAmFsymZrhjgMh8pXgQ6fSfIQ3ljReuZvDk
         VRknWfgx3iZfD9PH/s9uUM6ZvOwqqmJJyGyeUyKZFIUsnsgZfF77d5pQB5pjsyA01AbX
         +tdfMDgVHW7iLfMWjYacbfAv1YLPsxnXw3SblNkvLQK3ccsz4EAPBXpWFr190FVxl222
         d+pw==
X-Forwarded-Encrypted: i=1; AJvYcCUOQ4MZ0vI167wokiX2gu/JhHUybZzc1o5SBTQJrIJOHt/A0Z4CGqu+tKDpee9PhvyU8T5MJOwVH9b1@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7AK8PN0jLPK8W5FQc3cjkIVweDmYdk9uY7lnZFJda+iLinHgS
	QgL75rSko2nfvheh6EE8sg+Tc2sbGdbYx39nf+mJTOSPz0YKq+wZcgHuO8ZuxX58WjYJf9vt0Pm
	tVkucAM8=
X-Gm-Gg: ATEYQzw13WZ4ksLs5I8i7Zffj+dKToTwuIZ/rb3JWUjC9TZe99I1HfMRUGEDZKt2uTi
	KhCvycDL0Gq53q3Z4gsMGhcy2X1AMPh/uoEd32VO8OctPQBQ6EvYhmVGrgjeNRzoWPbhw9n3vcy
	9cCx1QB9uwAmaLx0sG67gXAyellHv5XrsOpAaTX89qXRRH3KsO/mjVjXGQWE526nTqTtFPhB9vN
	d60Um4ppBz4RHPzSCiw++aLA9Jp8dfpQ25FktBvESonSj56KZyCJgibC+DHsjWb+EYj1V4Zm9Qy
	HmpDtUGgLrZHtFrBg6urcalFRYP8QRcXHzzCEBMLBAj+ocGdOtbuvF2sGtRoF2Obr2LYKWPPzgN
	kJwcBgu1MCXQoKeTN/XuEeDCsXsNzYD0PdiIw7cJNYOfcApFE/yO4S5Yp78foLDC7T0X3boZ6jm
	UCSGJb89f4LaAib7lV/65MHzxA/TYl4CAw9WEkZqX4yu37ZvKpXxYfqfP5
X-Received: by 2002:a05:6000:2506:b0:439:ae2a:755e with SMTP id ffacd0b85a97d-439da35fa91mr26956544f8f.23.1773149006537;
        Tue, 10 Mar 2026 06:23:26 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae3c80esm32266361f8f.29.2026.03.10.06.23.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 06:23:26 -0700 (PDT)
Message-ID: <f46807c2-0266-4143-9caa-ff938293f7b4@suse.com>
Date: Tue, 10 Mar 2026 14:23:25 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] scsi: scsi-multipath: Add basic ALUA support
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
 axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
 snitzer@kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-6-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260310114925.1222263-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/10/26 12:49, John Garry wrote:
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
>   drivers/scsi/scsi_multipath.c | 163 ++++++++++++++++++++++++++++++++--
>   include/scsi/scsi_multipath.h |   3 +
>   2 files changed, 160 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 1489c7e979167..0a314080bf0a5 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -4,6 +4,7 @@
>    *
>    */
>   
> +#include <scsi/scsi_alua.h>
>   #include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_driver.h>
>   #include <scsi/scsi_proto.h>
> @@ -346,18 +347,29 @@ static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
>   				to_scsi_mpath_device(mpath_device);
>   	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>   	enum scsi_device_state sdev_state = sdev->sdev_state;
> +	int alua_state = scsi_mpath_dev->alua_state;
>   
>   	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_CANCEL)
>   		return false;
>   
> -	return true;
> +	if (alua_state == SCSI_ACCESS_STATE_OPTIMAL ||
> +	    alua_state == SCSI_ACCESS_STATE_ACTIVE)
> +		return true;
> +
> +	return false;
>   }
>   
>   static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
>   {
> +	struct scsi_mpath_device *scsi_mpath_dev =
> +				to_scsi_mpath_device(mpath_device);
> +
>   	if (scsi_mpath_is_disabled(mpath_device))
>   		return false;
> -	return true;
> +	if (scsi_mpath_dev->alua_state == SCSI_ACCESS_STATE_OPTIMAL)
> +		return true;
> +	return false;
> +
>   }
>   
>   /* Until we have ALUA support, we're always optimised */
> @@ -366,7 +378,7 @@ static enum mpath_access_state scsi_mpath_get_access_state(
>   {
>   	if (scsi_mpath_is_disabled(mpath_device))
>   		return MPATH_STATE_INVALID;
> -	return MPATH_STATE_OPTIMIZED;
> +	return scsi_mpath_is_optimized(mpath_device);
>   }
>   
>   static bool scsi_mpath_available_path(struct mpath_device *mpath_device, bool *available)
> @@ -579,16 +591,147 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
>   	sdev->scsi_mpath_dev = NULL;
>   }
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
> +
> +		/*
> +		 * Retry on any other UNIT ATTENTION occurred.
> +		 */
> +		if (sense_hdr.sense_key == UNIT_ATTENTION) {
> +			scsi_print_sense_hdr(sdev, __func__, &sense_hdr);
> +			kfree(buff);
> +			return -EAGAIN;
> +		}
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
>   int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>   {
>   	struct scsi_mpath_head *scsi_mpath_head;
> -	int ret;
> +	int ret, tpgs;
>   
>   	if (!scsi_multipath)
>   		return 0;
>   
> -	if (!scsi_device_tpgs(sdev) && !scsi_multipath_always) {
> -		sdev_printk(KERN_NOTICE, sdev, "tpgs are required for multipath support\n");
> +	tpgs = alua_check_tpgs(sdev);
> +	if (!(tpgs & TPGS_MODE_IMPLICIT) && !scsi_multipath_always) {
> +		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
>   		return 0;
>   	}
>   
> @@ -622,6 +765,14 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
>   	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
>   
>   found:
> +	if (tpgs & TPGS_MODE_IMPLICIT) {
> +		ret = scsi_mpath_alua_init(sdev);
> +		if (ret)
> +			goto out_put_head;
> +	} else {
> +		sdev->scsi_mpath_dev->alua_state = SCSI_ACCESS_STATE_OPTIMAL;
> +	}
> +
>   	sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
>   	if (sdev->scsi_mpath_dev->index < 0) {
>   		ret = sdev->scsi_mpath_dev->index;
> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
> index 2011447f482d6..7c7ee2fb7def7 100644
> --- a/include/scsi/scsi_multipath.h
> +++ b/include/scsi/scsi_multipath.h
> @@ -38,6 +38,9 @@ struct scsi_mpath_device {
>   	int			index;
>   	atomic_t		nr_active;
>   	struct scsi_mpath_head	*scsi_mpath_head;
> +	int			alua_state;
> +	int			alua_pref;
> +	int			alua_valid_states;
>   
>   	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
>   };

Is there a specific reason why this cannot be in the generic code?
After all, if the device reports anything else than ALUA_STATE_OPTIMAL
or ALUA_STATE_ACTIVE I/O will fail, irrespective of multipath being
active.

I would love to see that in the generic SCSI code, independent on this 
patchset. It would allow us to simplify the device handler code, too,
as then device handler really would only be required for explicit
ALUA. (And could be ignored for scsi-multipathing).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
