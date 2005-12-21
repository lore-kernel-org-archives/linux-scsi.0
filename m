From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc:   Timer fix
Date: Wed, 21 Dec 2005 12:39:29 -0500
Message-ID: <43A99351.4090100@emulex.com>
References: <1134767813.5539.18.camel@markh1.pdx.osdl.net>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:27319 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751144AbVLURj5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2005 12:39:57 -0500
In-Reply-To: <1134767813.5539.18.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Agreed.

-- james s

Mark Haverkamp wrote:
> James,
> 
> I've been doing some testing with the lpfc driver and started running
> into some BUG_ON problems using add_timer in lpfc_els_timeout_handler.
> I'm not certain, but I think that the add_timer call should be a
> mod_timer.
> Please take a look.
> 
> Signed-of-by: Mark Haverkamp <markh@osdl.org>
> 
> ---
> 
> Index: scsi-misc-2.6/drivers/scsi/lpfc/lpfc_els.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/lpfc/lpfc_els.c	2005-12-16 13:14:37.000000000 -0800
> +++ scsi-misc-2.6/drivers/scsi/lpfc/lpfc_els.c	2005-12-16 13:14:53.000000000 -0800
> @@ -2935,8 +2935,7 @@
>  			lpfc_sli_release_iocbq(phba, piocb);
>  	}
>  	if (phba->sli.ring[LPFC_ELS_RING].txcmplq_cnt) {
> -		phba->els_tmofunc.expires = jiffies + HZ * timeout;
> -		add_timer(&phba->els_tmofunc);
> +		mod_timer(&phba->els_tmofunc, jiffies + HZ * timeout);
>  	}
>  	spin_unlock_irq(phba->host->host_lock);
>  }
> 
