Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D263587BC
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768227209; cv=none; b=pzqjnKp5kAT7Ct72Q1XoP8EebSbTg7+hH+TADT0PYDkgBeg9N4EKfV8+uc1M92TMwUGDJF9BrnpFn0xgnelvXS4WxvI7u3yWsfhwn3e1u7vamuAAO9jSaUzqfrqtZGuzojFxIh1Uyi8gWT0B2Jbqs2tYTueOuha9IHSAlHcjCPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768227209; c=relaxed/simple;
	bh=rHA84m8dNmTZTce9phBJR8Uaev6tnIhlyU6L7XaxVHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z7/6je2vkU7CHO431pBiGNu6UNJxAjb+Acn3lx6kLd1Vx0jz+g1PYGoaLEi4SuYlVb0qAmcXjxPKyUddWHbN57SbJ07RdChKKn+lf9PqNhVgWQhylcDXyJ53+BhExPqcOGDrKdtrnDMPtUvHEa88UnYqk+s99d0SwnCN0u8o4yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESLXicTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESLXicTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49ECEC19424;
	Mon, 12 Jan 2026 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768227207;
	bh=rHA84m8dNmTZTce9phBJR8Uaev6tnIhlyU6L7XaxVHo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ESLXicTWv978DTmSdY6neAWbiIHY6Umnfg/g8SHNXL0OdzFYPDcAFsixhtytQD4J9
	 4yHHIZJCx67SLP13epRZqtVsxLC4Q6CESHnCXv74JWNKAgbUvFeIz860kQ3MZjw8Mt
	 pSXtIdxjQ6OO60Oj7m3Flj9oC4wAFR9lZ8FdehztJq5/MuaBCjr+iuJFWto53QsSKv
	 65iZj+v6i8/t1ZolJfEZpZYBnIpK0d9TJNsWS6jhyRV4t2Bvef3U7Ebbu/nh4Em6Sa
	 l1NX0Yez0maclsiyIyT23C8iyeurHS+yDTd8MxV+BAjq4Flvyo7E4MvDjYh+odU2hh
	 mP3aYLzQ8J1hg==
Message-ID: <ad1547ce-7a44-4fdc-8bcf-670ce069fe5f@kernel.org>
Date: Mon, 12 Jan 2026 15:13:23 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/7] mpi3mr: Rename log data save helper to reflect
 threaded/BH context
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
 chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
 salomondush@google.com
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
 <20260112081037.74376-3-ranjan.kumar@broadcom.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260112081037.74376-3-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/26 09:10, Ranjan Kumar wrote:
> Log data events can be processed from BH and threaded contexts.
> Rename the save helper to document its intended usage and improve
> readability of the event handling flow.
> 
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h     | 2 +-
>  drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
>  drivers/scsi/mpi3mr/mpi3mr_os.c  | 8 +++++++-
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 31d68c151b20..611a51a353c9 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -1508,7 +1508,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
>  	struct mpi3mr_drv_cmd *drv_cmd);
>  int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
>  	struct mpi3mr_drv_cmd *drv_cmd);
> -void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
> +void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
>  	u16 event_data_size);
>  struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
>  	struct mpi3mr_ioc *mrioc, u16 handle);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> index 0e5478d62580..37cca0573ddc 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2920,7 +2920,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
>  }
>  
>  /**
> - * mpi3mr_app_save_logdata - Save Log Data events
> + * mpi3mr_app_save_logdata_th - Save Log Data events
>   * @mrioc: Adapter instance reference
>   * @event_data: event data associated with log data event
>   * @event_data_size: event data size to copy
> @@ -2932,7 +2932,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
>   *
>   * Return:Nothing
>   */
> -void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
> +void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
>  	u16 event_data_size)
>  {
>  	u32 index = mrioc->logdata_buf_idx, sz;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index d4ca878d0886..4dbf2f337212 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1962,7 +1962,7 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
>  static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
>  	struct mpi3mr_fwevt *fwevt)
>  {
> -	mpi3mr_app_save_logdata(mrioc, fwevt->event_data,
> +	mpi3mr_app_save_logdata_th(mrioc, fwevt->event_data,
>  	    fwevt->event_data_size);
>  }
>  
> @@ -3058,6 +3058,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
>  	}
>  	case MPI3_EVENT_DEVICE_INFO_CHANGED:
>  	case MPI3_EVENT_LOG_DATA:
> +	{

The curly brackets are not necessary.

> +		sz = event_reply->event_data_length * 4;
> +		mpi3mr_app_save_logdata_th(mrioc,
> +		    (char *)event_reply->event_data, sz);

Do you really need the cast here ?

> +		break;
> +	}
>  	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
>  	case MPI3_EVENT_ENCL_DEVICE_ADDED:
>  	{


-- 
Damien Le Moal
Western Digital Research
