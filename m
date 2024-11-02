Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF6D15623A;
	Sat,  2 Nov 2024 22:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730585356; cv=none; b=pH89WJbn4/76lMp0BSG5Ge/Yw59316W4YJwMDNJHKw17pnc/UTnpGELcCtPEXJ/zmfx6lp4vUSSCsIx1mMYs043YK5qPgxj6Gd2gMS2JFewNRSJ6qBT65B4f8yYjwckZioMpUTBpVS1peAxFLrtIyGa/Fe4Z12qCBZINkZzBn/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730585356; c=relaxed/simple;
	bh=kikpwqI//uyYfSsse1xjYLmU45mmiKnCb1MCiKi43/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNV5+J1UpaFVccVVFlSzRMo8IcJllIj2k00fzp+j5OpBNYqX4HZQ9JoCrJg9wy6YuSDWuBwHQ3mBWpPzsoxHVsLPWYzDTafuyADGZwCZIvgDtGe7PuTaGMVjSX/ChR8chSNhUtDudoIkbH15phFOdI+H7zJq7SauIMOn5VOzlxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=UvU7xkB9; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="UvU7xkB9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=AycwtpPKy3WyiL43tzTobf844buvtjAigNy6uC85R24=; b=UvU7xkB9gxXDeg3y
	UtWzKpRYNG3OlLoS8bXN4dkkXsDR4WpoiX3a6HxlX8l3GLUohI99boj3drFgOGG/xGNUlmqhR8VZ+
	NBrHIaQ7GDgejaAfAfMso0YP18fUOQpgUpmQthIvEEw3xBn+plzfPdm0usyvrNmmOg++P2lIveOYC
	EECuo//zV2iCPjm3jU8ila6U9LOwNafwzmxsWpOz3k6qjaR8f+O/r67Uukz5+pbkp2tuIXY0ARR9d
	UHfbRrTIWs4v6BM5fMYaSL6Pr2zkEm8f/6r2BQ5Kd2bVlzJYtIYfjm8ALy0pJEWhisNlBRQlPrKn9
	dVT9QjflBp19G5J+Nw==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1t7MIw-00F7ys-0d;
	Sat, 02 Nov 2024 22:09:10 +0000
Date: Sat, 2 Nov 2024 22:09:10 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: linuxdrivers@attotech.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: esas2r: Remove unused esas2r_build_cli_req
Message-ID: <ZyajBhCcMv865wLZ@gallifrey>
References: <20241102220336.80541-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20241102220336.80541-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 22:08:08 up 178 days,  9:22,  1 user,  load average: 0.00, 0.01,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

FYI: Bradley Groves, the driver maintainer's email server didn't like the patch with:

  Action: failed
  Final-Recipient: rfc822;linuxdrivers@attotech.com
  Status: 5.0.0
  Remote-MTA: dns; mx-01-us-west-2.prod.hydra.sophos.com
  Diagnostic-Code: smtp; 550 5.7.1 XGEMAIL_0011 Command rejected

Shrug,

Dave

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> esas2r_build_cli_req() has been unused since it was added
> in 2013 by
> commit 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA
> RAID Adapter Driver")
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/scsi/esas2r/esas2r.h     |  4 ----
>  drivers/scsi/esas2r/esas2r_vda.c | 17 -----------------
>  2 files changed, 21 deletions(-)
> 
> diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
> index 8a133254c4f6..1e2d7c63a8e3 100644
> --- a/drivers/scsi/esas2r/esas2r.h
> +++ b/drivers/scsi/esas2r/esas2r.h
> @@ -1045,10 +1045,6 @@ void esas2r_build_mgt_req(struct esas2r_adapter *a,
>  			  u32 length,
>  			  void *data);
>  void esas2r_build_ae_req(struct esas2r_adapter *a, struct esas2r_request *rq);
> -void esas2r_build_cli_req(struct esas2r_adapter *a,
> -			  struct esas2r_request *rq,
> -			  u32 length,
> -			  u32 cmd_rsp_len);
>  void esas2r_build_ioctl_req(struct esas2r_adapter *a,
>  			    struct esas2r_request *rq,
>  			    u32 length,
> diff --git a/drivers/scsi/esas2r/esas2r_vda.c b/drivers/scsi/esas2r/esas2r_vda.c
> index 30028e56df63..5aa728704dfc 100644
> --- a/drivers/scsi/esas2r/esas2r_vda.c
> +++ b/drivers/scsi/esas2r/esas2r_vda.c
> @@ -444,23 +444,6 @@ void esas2r_build_ae_req(struct esas2r_adapter *a, struct esas2r_request *rq)
>  	}
>  }
>  
> -/* Build a VDA CLI request. */
> -void esas2r_build_cli_req(struct esas2r_adapter *a,
> -			  struct esas2r_request *rq,
> -			  u32 length,
> -			  u32 cmd_rsp_len)
> -{
> -	struct atto_vda_cli_req *vrq = &rq->vrq->cli;
> -
> -	clear_vda_request(rq);
> -
> -	rq->vrq->scsi.function = VDA_FUNC_CLI;
> -
> -	vrq->length = cpu_to_le32(length);
> -	vrq->cmd_rsp_len = cpu_to_le32(cmd_rsp_len);
> -	vrq->sg_list_offset = (u8)offsetof(struct atto_vda_cli_req, sge);
> -}
> -
>  /* Build a VDA IOCTL request. */
>  void esas2r_build_ioctl_req(struct esas2r_adapter *a,
>  			    struct esas2r_request *rq,
> -- 
> 2.47.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
