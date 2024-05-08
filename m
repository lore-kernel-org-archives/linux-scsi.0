Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429D31A2C17
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 01:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715131838; cv=none; b=No4YcXHFSp5G+W7mwHrm+IXSAsz+E/VQhUMmSK6AZaSZyqLQLDSFMeKKNm+PlVIhQq0vVfh0g+Bbg9UB8BjjN9+wDWT/2hIlHvf1JJdu2muh+zrf5UtgZFHJKhnOMXh+mMWFzXNnch0S6HZX1oJu7dnkWIjVfsvciAVHtpOke+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715131838; c=relaxed/simple;
	bh=jdJDZKJdsgvk3YuSXDBTZS+7mincWLYme4q4TIgdzLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bHb5tJD6/ncBBpOuOD6FMvdLxGUXVYjZeewqbsifaD7UE+OqpULPxQInQMhnL6nfSPObKB1qdipwkz+F5xDxxfsdV4nDpj63uppK55y6Y5bkoocWwfbMltUGzYM/Kv7U07/YZX85hwnARrMsh/glf0SYelk+ghQA059b69/tjp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0ArTkxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0ArTkxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FD2C2BBFC;
	Wed,  8 May 2024 01:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715131837;
	bh=jdJDZKJdsgvk3YuSXDBTZS+7mincWLYme4q4TIgdzLU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V0ArTkxcl1LJd3TATg9qix3xikRZJZ9161sHP70jOZY6zeTpusGYb9O10t/yn/fp8
	 T6KESDWl6XfuCGuCGof80jhbc2Ab5a+yBlBGDlHStdbs33UibipQ20DwKMyRx1im1F
	 DKJFKP45wP06gxKZCRnfrWXka7F2sEPWFD2K+/43y/9NL6WemyyaE2bYBq/GZP5eXc
	 dBhnMim5zv+zJovVxITp+EZUAcnAxs9HtFycTyTE9hujST7w9eibOr/iXJ2oUUFzN+
	 lWU2W4kRJ3xsalDmae+sxNSEnKvfdUsf8jcC5yUkF1qRBsBYgx03JKmCXz10a0VqdY
	 Sb8/oCW4DnTDQ==
Message-ID: <0b32bd8d-e407-465f-b021-c862419e6160@kernel.org>
Date: Wed, 8 May 2024 10:30:34 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] I/O errors for ALUA state transitions
To: Martin Wilck <martin.wilck@suse.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
 James Bottomley <jejb@linux.vnet.ibm.com>, Ewan Milne <emilne@redhat.com>,
 Mike Christie <michael.christie@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 Martin Wilck <mwilck@suse.com>
References: <20240507092837.21463-1-mwilck@suse.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240507092837.21463-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/24 6:28 PM, Martin Wilck wrote:
> From: Rajashekhar M A <rajs@netapp.com>
> 
> When a host is configured with a few LUNs and IO is running,
> injecting FC faults repeatedly leads to path recovery problems.
> The LUNs have 4 paths each and 3 of them come back active after
> say an FC fault which makes two of the paths go down, instead of
> all 4. This happens after several iterations of continuous FC faults.
> 
> Reason here is that we're returning an I/O error whenever we're
> encountering sense code 06/04/0a (LOGICAL UNIT NOT ACCESSIBLE,
> ASYMMETRIC ACCESS STATE TRANSITION) instead of retrying.
> 
> mwilck: Moved this code to alua_check_sense() as suggested by
> Mike Christie [1]. Evan Milne had raised the question whether pg->state
> should be set to transitioning in the UA case [2]. I believe that doing
> this is correct. SCSI_ACCESS_STATE_TRANSITIONING by itself doesn't cause
> I/O errors. Our handler schedules an RTPG, which will only result in
> an I/O error condition if the transitioning timeout expires.
> 
> [1] https://lore.kernel.org/all/0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com/
> [2] https://lore.kernel.org/all/CAGtn9r=kicnTDE2o7Gt5Y=yoidHYD7tG8XdMHEBJTBraVEoOCw@mail.gmail.com/
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> 
> ---
> Changes v2->v3:
> - drop return value of alua_handle_state_transition() (Christoph Hellwig)
> - handle UNIT ATTENTION in alua_tur(), too (Mike Christie)
> - restore comment in alua_check_sense() (Damien Le Moal)
> 
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 33 +++++++++++++++-------
>  1 file changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index a226dc1b65d7..c6408678e7c4 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -414,28 +414,40 @@ static char print_alua_state(unsigned char state)
>  	}
>  }
>  
> -static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
> -					      struct scsi_sense_hdr *sense_hdr)
> +static void alua_handle_state_transition(struct scsi_device *sdev)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
>  	struct alua_port_group *pg;
>  
> +	rcu_read_lock();
> +	pg = rcu_dereference(h->pg);
> +	if (pg)
> +		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
> +	rcu_read_unlock();
> +	alua_check(sdev, false);
> +}
> +
> +static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
> +					      struct scsi_sense_hdr *sense_hdr)
> +{
>  	switch (sense_hdr->sense_key) {
>  	case NOT_READY:
> -		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a){

You removed the space before the curly bracket...
With that fixed, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

>  			/*
>  			 * LUN Not Accessible - ALUA state transition
>  			 */
> -			rcu_read_lock();
> -			pg = rcu_dereference(h->pg);
> -			if (pg)
> -				pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
> -			rcu_read_unlock();
> -			alua_check(sdev, false);
> +			alua_handle_state_transition(sdev);
>  			return NEEDS_RETRY;
>  		}
>  		break;
>  	case UNIT_ATTENTION:
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
> +			/*
> +			 * LUN Not Accessible - ALUA state transition
> +			 */
> +			alua_handle_state_transition(sdev);
> +			return NEEDS_RETRY;
> +		}
>  		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
>  			/*
>  			 * Power On, Reset, or Bus Device Reset.
> @@ -502,7 +514,8 @@ static int alua_tur(struct scsi_device *sdev)
>  
>  	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
>  				      ALUA_FAILOVER_RETRIES, &sense_hdr);
> -	if (sense_hdr.sense_key == NOT_READY &&
> +	if ((sense_hdr.sense_key == NOT_READY ||
> +	     sense_hdr.sense_key == UNIT_ATTENTION) &&
>  	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
>  		return SCSI_DH_RETRY;
>  	else if (retval)

-- 
Damien Le Moal
Western Digital Research

