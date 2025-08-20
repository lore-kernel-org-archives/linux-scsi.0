Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964DF2E11B8;
	Wed, 20 Aug 2025 12:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755691991; cv=none; b=GaIRjit4NHuYGFGi+VHvDIZry2t/DlJhootNx/h0bNc1kO+SFiTeAskkVTxECaAC2tit33BupmDEurCWB7H3d++760tzgyEMzSeQceLCYIsJrS4sDaUv8jESjW2DrBrbxOxUH2QpZRm2/Vo/6Erq/jl6newrKs2j7Kc+qtGQxhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755691991; c=relaxed/simple;
	bh=c92iWyVwQj+arCHVqYiotxgaquc5VivpQtnPYYTsW3w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YlWRAkeWHNH7kmMtQ8/b6+xHHhFPjC08FjPnBidPaClWzuOmAhXSBKt50HG97Yb6/Llxg7FviAJCtKXhd6+iHb2ivolK229FuN9QCkIGGztgshEGM3pXC14xUvuJJnk5Ui9uEB0wJm8eGCQEzv2riHItZOQeWeBttMFItGSi2RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EnRHkb4F; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EnRHkb4F"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45b49f7aaf5so3595395e9.2;
        Wed, 20 Aug 2025 05:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755691985; x=1756296785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3fF3VtgPJPt8GcyHffEJ4GYfZjXgpyLMvEqUzDnMYQ0=;
        b=EnRHkb4FyrwwrkwUyye3u5HSaAOqIVdAGTv6tD6r63xwDJQPPZorkLpaqtfG8PLngz
         7sFjhbx3KUJvw03BXL2vsycaeVbUkiJ7CapPqons9FzI1DoNX6LmEAxgedyMs9lq9Up3
         +7f/8Y5Vy/P7pGQnBfn13MfJsplI65XJgCRKnw5egDPv5YcrsRcV9SVYpOsnbMebc04h
         pJ1U/fkYVDpahtvBxVCSZALHJA3QHLPY5ZLvOE9y3E7QbhPveGLCYR6a/U2qIYBmBM62
         pPeoImTPwXL7Im4/6wZAkLFlQO52bczKYeB9g3V6gzUvDH7dV9SpNxhGpbMOzanG9ghQ
         MLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755691985; x=1756296785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3fF3VtgPJPt8GcyHffEJ4GYfZjXgpyLMvEqUzDnMYQ0=;
        b=Igr8o8/oLlauWZ8tP5D674JkQI+e3iRNJk6Sr0XSIjB3eTlH9IwoqzNJa1iH0mmMxl
         yOlppww0xNjzCjORcbOEC5oxfl4mSTcwyafPKEyioxRIRgOfz/ywG1XuAdIEa4Lj8RAi
         RXikaffirQ9PSpklnh9z9rWimXd7NX3fLS8CdTbvqsDxXY1fHtEGoNScC3hb5PER/N3E
         KHxY1X8qjoirMl6TbdpbaB21x/LNhIyiJiC6fV84h6h0CX1pauVEvm2Xv6YoAJVmRlAh
         h243Cz4ZQsRYaQgZPt+YdlEqQi1i6qsMdUgRjFaVxzTBapUrCzYGOo/lJG7JJ5/H7gLY
         Tw0g==
X-Forwarded-Encrypted: i=1; AJvYcCUQoVaUclfuI7MpBN3EwTWds8uhONl2hFjvq9wtHCFfYZsBccEfVVKVf3tAoOFQLy9E6f7kYKB2YPV/qIo=@vger.kernel.org, AJvYcCV96ASvK9pgKNrkG5/QEjR/wXOVd26DtgJvLnYo5oS4rS5i6p7HaF/b0HTffNf8763A1+eFMA5Z9p5z0g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2UekwCNs2bRBQTFSNvo5QGOTedGZnW0ukcA/8Vx90S7y6Ez0M
	3MGSHUwFKgrbPLkuNVY76DQM5Gl/hIgSmpw0MBLBa08Pq0lY92QVTXNt
X-Gm-Gg: ASbGnctvVUAyH9M1Le8az+M1I8hqGdbYQn8Z6jVzaTN8+rqUysJ4HT1/1bHxGXEZS17
	W9QYrWP9IGFWqkJfQTdiigfK/ITneFM6hOG1CysF3YGqfVMWxZllA7GHn3cRQhswWP4RX7rzEqH
	cWXa2VsEZbK6lweZYFyEcVAARpZnjPXOZdy8RMTaJc5MUs4ip2YG6E62VZ4K2AMCfts4kS/tP/Y
	fqIWJNPdbvBF+/x7ehibzIH8xfMK7vB2V2duB4YYxgnJ2VRMPnM2Uitf76qkU3NZnwI+Klkn4QX
	M/FKxj5KoUSJiitRCZcheOoRlS+AJ33FdECCKUodl1BXQVxkWMR+43UW8Sap71GFwpcptshRysn
	Jg9ZOhr5YAsTdzFUbPxjItORjHY/EEPbJLPwEmMXvjlpg0YrmXNMtVuH5FzgxdXOf
X-Google-Smtp-Source: AGHT+IF0uauUU/Y5F8dRa0cKTUduI6d1QMmDMV7wjD2DoamyTD4JTtPN3rLrDT46JbeDmAJXGLePYQ==
X-Received: by 2002:a05:600c:630d:b0:459:df07:6db7 with SMTP id 5b1f17b1804b1-45b4bb22bbdmr989365e9.6.1755691984707;
        Wed, 20 Aug 2025 05:13:04 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b47c29c9dsm32478005e9.4.2025.08.20.05.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 05:13:04 -0700 (PDT)
Date: Wed, 20 Aug 2025 13:13:03 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru
 <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org (open list:BROCADE
 BFA FC SCSI DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 1/6] scsi: bfa: use min_t() to improve code
Message-ID: <20250820131303.1fa8e046@pumpkin>
In-Reply-To: <20250815121609.384914-2-rongqianfeng@vivo.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
	<20250815121609.384914-2-rongqianfeng@vivo.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Aug 2025 20:16:03 +0800
Qianfeng Rong <rongqianfeng@vivo.com> wrote:

> Use min_t() to reduce the code in bfa_fcs_rport_update() and
> bfa_sgpg_mfree(), and improve readability.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---
>  drivers/scsi/bfa/bfa_fcs_rport.c | 8 +++-----
>  drivers/scsi/bfa/bfa_svc.c       | 5 +----
>  2 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
> index d4bde9bbe75b..77dc7aaf5985 100644
> --- a/drivers/scsi/bfa/bfa_fcs_rport.c
> +++ b/drivers/scsi/bfa/bfa_fcs_rport.c
> @@ -11,7 +11,6 @@
>  /*
>   *  rport.c Remote port implementation.
>   */
> -
>  #include "bfad_drv.h"
>  #include "bfad_im.h"
>  #include "bfa_fcs.h"
> @@ -2555,10 +2554,9 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
>  	 * - MAX receive frame size
>  	 */
>  	rport->cisc = plogi->csp.cisc;
> -	if (be16_to_cpu(plogi->class3.rxsz) < be16_to_cpu(plogi->csp.rxsz))
> -		rport->maxfrsize = be16_to_cpu(plogi->class3.rxsz);
> -	else
> -		rport->maxfrsize = be16_to_cpu(plogi->csp.rxsz);
> +	rport->maxfrsize = min_t(typeof(rport->maxfrsize),
> +				 be16_to_cpu(plogi->class3.rxsz),
> +				 be16_to_cpu(plogi->csp.rxsz));

I think I want to nak that one.
If you are going to use min_t() the type has to be one than includes
all possible values of both arguments.
Using the type of the result is just plain wrong.
There is also pretty much no point casting the values to char/short types
unless you need the implicit masking.
The values are immediately promoted to 'signed int' before the comparison.
I also think that min() will accept an 'unsigned char/short' variable
for a comparison against a 'signed int'.

So, all in all, min() should be fine.
Avoiding the extra be16_to_cpu() is probably a gain.
The compiler may not always know the value doesn't change.

	David

>  
>  	bfa_trc(port->fcs, be16_to_cpu(plogi->csp.bbcred));
>  	bfa_trc(port->fcs, port->fabric->bb_credit);
> diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
> index df33afaaa673..2570793aae7f 100644
> --- a/drivers/scsi/bfa/bfa_svc.c
> +++ b/drivers/scsi/bfa/bfa_svc.c
> @@ -5202,10 +5202,7 @@ bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpg)
>  	 */
>  	do {
>  		wqe = bfa_q_first(&mod->sgpg_wait_q);
> -		if (mod->free_sgpgs < wqe->nsgpg)
> -			nsgpg = mod->free_sgpgs;
> -		else
> -			nsgpg = wqe->nsgpg;
> +		nsgpg = min_t(int, mod->free_sgpgs, wqe->nsgpg);
>  		bfa_sgpg_malloc(bfa, &wqe->sgpg_q, nsgpg);
>  		wqe->nsgpg -= nsgpg;
>  		if (wqe->nsgpg == 0) {

