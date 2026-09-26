Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B572BE03C
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 00:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790383337; cv=none; b=mrUk0/B1P+d3l9CXtNm+MRVTjFgrfE6j4s0zN+gDNqI2bgYhB1OUiuBrr0laCPcXplFjW4CB3sP0L1yBlBXK0VXFDjSnm1UzJRltfsOcU+toUpR+wd5o8bJjWetGJZ6pMTcwx/JZ2zZyoKH0m3jnZfQwPHm8CBvfYfMu+hMJWEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790383337; c=relaxed/simple;
	bh=JKXWmwEiLHQyx2HNDpRLaHL4eHIDzknvSEPUbhyRFjQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WbhDGS7IC5TNztCs3fVeF7I0WP6ADkEV34i/E3faFqhSqReMa5sUSNLvhbEq0zm2sXu0lLHrwccrqVk/8hq6G0Ban1EazpBbOj+OaQFnTx0AlGoJe1ye855xg10JF1Baiewg2VIaERpRzqGRxi6LNYzlSYver0874mCCumegY5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Jbty1uRx; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Jbty1uRx"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id EE0241D000D8;
	Fri, 25 Sep 2026 20:42:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Fri, 25 Sep 2026 20:42:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790383332; x=1790469732; bh=TS1/RCLQ2qAB9ZjJHaigI1YaNQ1WTcExAbY
	VChAqXZA=; b=Jbty1uRxiRnpjyhY3k7Z533bTaW8XLvQKsf82Pw8GWZjmYsgDtZ
	/bWMiJFcbIEeWy4743I4BnOp+6c8vPxg0sTFeDzWjmNT9bMLQtERyL72zNOL0M9c
	tAwvDeQ0e3m9QwlGjXynyfjx3OFy7tNLVpjg7TVdwG0ZawDBz6oDMGOrZqqIeLpZ
	WU9XDgaeEkTlrDl4gwI+psWGHPp8bpYa+oLFg28ZiCO6DLclr8J0lfULoQFT/gT5
	kYNCmputVVlu2blNc9BguexYZpjeSkEJYvbF0Gz2skPi/7CLvS6ISQ/Tv963+F2e
	Yhd0HzCVq4h40vTTew342vSgt2QM0yaQ19A==
X-ME-Sender: <xms:5BS3airYz18_FRQdWUHluyygDfjMduNets0V_AteX6xoIz_EVcaCfA>
    <xme:5BS3akUH3jEm1eVAq_ZOpZ-TBnCW3hYBVVt_teZBwJJ6OU1TUSpAf9TdUvxaD4Bsm
    6YPihLunhnmaAVHdbra9clp9CC49xgo9YZLzyGFhUy_cFIddvLwv73M>
X-ME-Received: <xmr:5BS3ahBxcIh7aBvtqThUpg8_Pt-XBegTAzZrPQG09jUNk7aGyVVYupnEp90w>
X-ME-Proxy-Cause: dmFkZTEnZ56RPVcDYvE++y2AyLTFIV3gRsCgIIZ0hRGkns+XF0GutYhQr7OgFAiG5tk3DD
    9l+jYhbAjUAxtMCZtPpgsrvRE3pvIIs+sxffWbc5xeo/NqdSxMrz/j2R+AekX8rbnIYqnK
    ihoWd811OrzIRbz/D6ZFe3p5omFmcxboN6GioPoIwr5H8Tbrls4Bw4AGPKF8tgExQNxXA8
    nwdw8N/VHQmP1J8HXMgAPakJLtYX6rId0gNzn8cEdOdGr9ZUZ45NOUYM2MExGJ3LNhtLh/
    +HK2T4qYQmaMJon8q8fz5ag9zAOFkVS9Lt/MIqcEXQ8fT40puU/T9Dcl6NzfTCSjtOlCqw
    8ZIjiAZO0Vy4SeZOlqQoPZylrNdax8JQDhGhcIcDwddDEwJYrqyy1OMhgJswPjFgr+h98d
    +5A2m9cK+qq68mbtgnMu3r0j1nf+sD0IZYGBM28FyekEM2D4Tb7OBYUUrGdFROvLu81N4V
    2qhGSxKeKoPfsVFRUaeAnnYdaXIBuR3itovypbLCe+6MqI22tiWK1hPpit/B4r4a4CQ0aB
    s9NqNLvXX2PYklLT05KMqiZwG5KVUwrdx9zRGJyHS7u4jU9ggJe9Co/T/iDbnIVsYXfYdk
    66uWEPHg+BxACMXDk/txPEd5UhCNQZtAtmJOnhT7/ltMMDDiUQyRQCCAPINg
X-ME-Proxy: <xmx:5BS3ao3zIRwZebIU9gt1J259ieP905CT26KCYZI1NZhWi7xnOky43w>
    <xmx:5BS3aj0wt61FCZWn2wXNO-IM5DqaIfrK5muj8S5Dy_Fc5kcZGl5Ing>
    <xmx:5BS3atB2wnmAofTbnisXWfz27jCHL7bWCSn6bsg81tys64XRvSUXaw>
    <xmx:5BS3ai7tU4SIwTz4lQH6puoxOab2vhFv61qO3JI6jjdcTzwhX63hdA>
    <xmx:5BS3arzJ0vykfnOxJXdm65XuTv1ydL-PqI_pWtUJAh4aeK01Xjr2AGZX>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Sep 2026 20:42:10 -0400 (EDT)
Date: Sat, 26 Sep 2026 10:42:10 +1000 (AEST)
From: Finn Thain <fthain@linux-m68k.org>
To: Bart Van Assche <bvanassche@acm.org>
cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
    linux-scsi@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>, 
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
    "Martin K. Petersen" <mkp@kernel.org>
Subject: Re: [PATCH v4 06/54] scsi: NCR5380: Prepare for enabling lock context
 analysis
In-Reply-To: <a9d1b960868ac4dae9c5a9b98aea5dcf6713fb97.1790360262.git.bvanassche@acm.org>
Message-ID: <f2c1a279-088a-9e78-8b87-e5296950ff1d@linux-m68k.org>
References: <cover.1790360262.git.bvanassche@acm.org> <a9d1b960868ac4dae9c5a9b98aea5dcf6713fb97.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Fri, 25 Sep 2026, Bart Van Assche wrote:

> Pass the struct NCR5380_hostdata pointer directly to NCR5380_select()
> and NCR5380_information_transfer() instead of the struct Scsi_Host
> pointer. This ensures that the lock context annotations
> (__releases(&hostdata->lock) and __acquires(&hostdata->lock)) refer to
> a function argument. Update callers and function prototypes accordingly.
> 
> Cc: Finn Thain <fthain@linux-m68k.org>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/NCR5380.c | 19 ++++++++++---------
>  drivers/scsi/NCR5380.h |  5 +++--
>  2 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 006dcf981218..6afbd5936892 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -718,7 +718,7 @@ static void NCR5380_main(struct work_struct *work)
>  			 * entire unit.
>  			 */
>  
> -			if (!NCR5380_select(instance, cmd)) {
> +			if (!NCR5380_select(hostdata, cmd)) {
>  				dsprintk(NDEBUG_MAIN, instance, "main: select complete\n");
>  			} else {
>  				dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES, instance,
> @@ -728,7 +728,7 @@ static void NCR5380_main(struct work_struct *work)
>  		}
>  		if (hostdata->connected && !hostdata->dma_len) {
>  			dsprintk(NDEBUG_MAIN, instance, "main: performing information transfer\n");
> -			NCR5380_information_transfer(instance);
> +			NCR5380_information_transfer(hostdata);
>  			done = 0;
>  		}
>  		if (!hostdata->connected) {
> @@ -937,7 +937,7 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
>  
>  /**
>   * NCR5380_select - attempt arbitration and selection for a given command
> - * @instance: the Scsi_Host instance
> + * @hostdata: host private data
>   * @cmd: the scsi_cmnd to execute
>   *
>   * This routine establishes an I_T_L nexus for a SCSI command. This involves
> @@ -960,10 +960,11 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
>   * cmd->result host byte set to DID_BAD_TARGET.
>   */
>  
> -static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
> +static bool NCR5380_select(struct NCR5380_hostdata *hostdata,
> +			   struct scsi_cmnd *cmd)
>  	__releases(&hostdata->lock) __acquires(&hostdata->lock)
>  {
> -	struct NCR5380_hostdata *hostdata = shost_priv(instance);
> +	struct Scsi_Host *instance = hostdata->host;
>  	unsigned char tmp[3], phase;
>  	unsigned char *data;
>  	int len;
> @@ -1643,23 +1644,23 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
>  }
>  
>  /*
> - * Function : NCR5380_information_transfer (struct Scsi_Host *instance)
> + * Function : NCR5380_information_transfer(struct NCR5380_hostdata *hostdata)
>   *
>   * Purpose : run through the various SCSI phases and do as the target
>   * directs us to.  Operates on the currently connected command,
>   * instance->connected.
>   *
> - * Inputs : instance, instance for which we are doing commands
> + * Inputs : hostdata, the private host data
>   *
>   * Side effects : SCSI things happen, the disconnected queue will be
>   * modified if a command disconnects, *instance->connected will
>   * change.
>   */
>  

Acked-by: Finn Thain <fthain@linux-m68k.org>

Would you please update that to kerneldoc format? Something like this:

/**
 * NCR5380_information_transfer - respond to information transfer phases
 * @hostdata: private host data
 *
 * Run through various bus phases as directed by the target.
 * Operates on the currently connected command until it's either completed
 * or moved to the disconnected queue.
 */
