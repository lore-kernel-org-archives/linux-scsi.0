Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294C214D451
	for <linux-scsi@vger.kernel.org>; Tue,  7 May 2024 09:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073140; cv=none; b=ooJ4reZJkW1/kMb0Blt3wnP5Aq/mA8f+2beKSnnDwqZBj1aGuc1aRdiTJv/A/5/lKDm9yw7qW2lKQGtvrDa2nXJhycl+ZcbvDxB8FESmJ+0ILM+HFBprsIHnppnP5JqetZkNHqwg8drVlzvnVKFXNKci34AHQe2SO1+AxsLuoMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073140; c=relaxed/simple;
	bh=VJYq9hH6rq1H8WWmpEWC39L8qDwxA3D67QJ9JSQkURs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tAygclpiu9U4nk7WpjRSR1iMX5J0Wo20x0SL/5kqbe10RKnmGaPzb8HzsqX08ZmTOVFE/h0umYwSKsOh+WhibEFf6j/S+AClzfvXy6clWyho3+iaD3AMW8w2z8mHOydtWLzweNhTOsHGAlA9jf3qILRTj0prIMiLvktB8xGBszs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mL1iNdOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mL1iNdOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75938C2BBFC;
	Tue,  7 May 2024 09:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715073139;
	bh=VJYq9hH6rq1H8WWmpEWC39L8qDwxA3D67QJ9JSQkURs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mL1iNdOa7du3foqjfyM/uapbnM1NnIvGhSLtspOIC4lDwmxrDpjmlNzJNJYUzu5YE
	 kcWhBL42vHf56a9e8ZiZW5VIWFFkxJVGvlWDFDyoIipdy5HS8YO8bqNrPsRJAv725V
	 XY7dFvtFOiIa2m/6+5J1is/5aEEBDCPI3/sJMLvH10FO9dVL5vhAhbLJG0wrO8Utga
	 nxvsIG8AzWTtCZcA/IcKjD1XuOFNhFzG049OLGIRzrQfhGRE5G9SbNiuCyh2EU7YeD
	 4hdS1jACfxL5/GLG3JrwcJwupTJ0gvZEW1whgTX0R0eDokKrVMRJP3VjfhL5nwgN6k
	 B41DERXj7ch5A==
Message-ID: <f342709a-6a7b-4cc0-973d-62efd2d32277@kernel.org>
Date: Tue, 7 May 2024 18:12:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] I/O errors for ALUA state transitions
To: Martin Wilck <martin.wilck@suse.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
 James Bottomley <jejb@linux.vnet.ibm.com>, Ewan Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 Martin Wilck <mwilck@suse.com>, Rajashekhar M A <rajs@netapp.com>
References: <20240503195606.13120-1-mwilck@suse.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240503195606.13120-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/4/24 04:56, Martin Wilck wrote:
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
> mwilck: Resending a modified version of this patch, which was originally
> authored by Rajashekhar M A from Netapp, and submitted in 2021.
> Moved the changes to alua_check_sense() as suggested by Mike Christie [1].
> Evan Milne had raised the question whether pg->state should be set to
> transitioning in the UA case [2]. I believe that doing this is
> correct. SCSI_ACCESS_STATE_TRANSITIONING by itself doesn't cause I/O
> errors. Our handler schedules an RTPG, which will only result in an I/O
> error condition if the transitioning timeout expires.
> 
> [1] https://lore.kernel.org/all/0bc96e82-fdda-4187-148d-5b34f81d4942@oracle.com/
> [2] https://lore.kernel.org/all/CAGtn9r=kicnTDE2o7Gt5Y=yoidHYD7tG8XdMHEBJTBraVEoOCw@mail.gmail.com/
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Co-authored-by: Rajashekhar M A <rajs@netapp.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 34 +++++++++++++---------
>  1 file changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index a226dc1b65d7..682d5bb53d14 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -414,28 +414,34 @@ static char print_alua_state(unsigned char state)
>  	}
>  }
>  
> -static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
> -					      struct scsi_sense_hdr *sense_hdr)
> +static enum scsi_disposition alua_handle_state_transition(struct scsi_device *sdev)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
>  	struct alua_port_group *pg;
>  
> +	/*
> +	 * LUN Not Accessible - ALUA state transition
> +	 */
> +	rcu_read_lock();
> +	pg = rcu_dereference(h->pg);
> +	if (pg)
> +		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
> +	rcu_read_unlock();
> +	alua_check(sdev, false);
> +	return NEEDS_RETRY;
> +}
> +
> +static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
> +					      struct scsi_sense_hdr *sense_hdr)
> +{
>  	switch (sense_hdr->sense_key) {
>  	case NOT_READY:
> -		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
> -			/*
> -			 * LUN Not Accessible - ALUA state transition
> -			 */
> -			rcu_read_lock();
> -			pg = rcu_dereference(h->pg);
> -			if (pg)
> -				pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
> -			rcu_read_unlock();
> -			alua_check(sdev, false);
> -			return NEEDS_RETRY;
> -		}
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)

Please keep the comment that spells out what this asc/ascq is.

> +			return alua_handle_state_transition(sdev);
>  		break;
>  	case UNIT_ATTENTION:
> +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a)
> +			return alua_handle_state_transition(sdev);
>  		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
>  			/*
>  			 * Power On, Reset, or Bus Device Reset.

-- 
Damien Le Moal
Western Digital Research

