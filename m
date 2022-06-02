Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210F9C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 08:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiFBIga (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 04:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiFBIg3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 04:36:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229602A5500
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 01:36:28 -0700 (PDT)
Date:   Thu, 2 Jun 2022 10:36:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654158980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ROygdK+CcQ/MYPE6CoxKUHKeFuBdww5jp7eA/LErBUw=;
        b=GzoP9HwI3Nfi2kRRfroPgiu80c8qd7XuSpn8YC/Ru3J1fW/bC7yQPaukp1YIYhKvEDM6B0
        HqejXHcF05xdenIhMTXQJiGeDt/tQcWlGJEQvr/5A/JiOqtQgZcY1KnXQnySCTZRxHfmQF
        44oTcv4FJerOL4PSK3WnchgPlP42k6SNox6l+QhdwG4elaMLwbwL93hda7pudJP0MLmQfi
        C9X5zDt+jFa1PeLDDlz2YTdymmIRifjgPjf7PEymytza988xeqIjRVz4I9rsewDeLgzdUe
        3l7Qpblws5BjD2BAPGCL8i9NFek/hakTPEpi2YXvul4SYL8dZmup9F0cnvwmsw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654158980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ROygdK+CcQ/MYPE6CoxKUHKeFuBdww5jp7eA/LErBUw=;
        b=ffD2ufRrarfJxCqBG5xs+J99UPbsXPQEQ9FQ+kJj37wlzsAHxLZO3Way6VpaHV3pnnqK8+
        UJGjzFVdccz1qSDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH 02/10] scsi/megaraid: Replace adapter->dpc_h tasklet with
 threaded irq
Message-ID: <Yph2gmXk1VUj7/9O@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-3-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220530231512.9729-3-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-30 16:15:04 [-0700], Davidlohr Bueso wrote:
> @@ -2036,7 +2028,7 @@ megaraid_ack_sequence(adapter_t *adapter)
>  	uint8_t			nstatus;
>  	uint8_t			completed[MBOX_MAX_FIRMWARE_STATUS];
>  	struct list_head	clist;
> -	int			handled;
> +	int			ret = IRQ_NONE;

irqreturn_t ret = IRQ_NONE;

>  	uint32_t		dword;
>  	unsigned long		flags;
>  	int			i, j;
> @@ -2124,12 +2116,7 @@ megaraid_ack_sequence(adapter_t *adapter)
>  
>  	spin_unlock_irqrestore(COMPLETED_LIST_LOCK(adapter), flags);
>  
> -
> -	// schedule the DPC if there is some work for it
> -	if (handled)
> -		tasklet_schedule(&adapter->dpc_h);
> -
> -	return handled;
> +	return ret;
>  }

megaraid_ack_sequence() has another caller, the
scsi_host_template::eh_host_reset_handler callback
(megaraid_reset_handler). With that change, that threaded handler will
not be invoked in the reset case.

> @@ -2144,29 +2131,27 @@ static irqreturn_t
>  megaraid_isr(int irq, void *devp)
>  {
>  	adapter_t	*adapter = devp;
> -	int		handled;
> +	int		ret;
>  
> -	handled = megaraid_ack_sequence(adapter);
> +	ret = megaraid_ack_sequence(adapter);
>  
>  	/* Loop through any pending requests */
>  	if (!adapter->quiescent) {
>  		megaraid_mbox_runpendq(adapter, NULL);
>  	}
>  
> -	return IRQ_RETVAL(handled);
> +	return ret;
>  }
>  
>  
>  /**
> - * megaraid_mbox_dpc - the tasklet to complete the commands from completed list
> - * @devp	: pointer to HBA soft state
> + * megaraid_mbox_dpc - complete the commands from completed list
>   *
>   * Pick up the commands from the completed list and send back to the owners.
>   * This is a reentrant function and does not assume any locks are held while
> - * it is being called.
> + * it is being called. Runs in process context.
>   */
> -static void
> -megaraid_mbox_dpc(unsigned long devp)
> +static irqreturn_t megaraid_mbox_dpc(int irq, void *devp)
>  {
>  	adapter_t		*adapter = (adapter_t *)devp;

that cast could vanish.

>  	mraid_device_t		*raid_dev;
> @@ -2188,7 +2173,8 @@ megaraid_mbox_dpc(unsigned long devp)
>  	uioc_t			*kioc;
>  
>  
> -	if (!adapter) return;
> +	if (!adapter)
> +		goto done;

return IRQ_NONE;

>  	raid_dev = ADAP2RAIDDEV(adapter);
>  

Sebastian
