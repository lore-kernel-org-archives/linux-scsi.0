From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Fri, 2 Mar 2012 09:06:42 +0800
Message-ID: <1A8CC42AE967403AB159BA2489CE1CB2@usish.com.cn>
References: <20120301142225.GA9789@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:43189 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab2CBBHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 20:07:38 -0500
In-Reply-To: <20120301142225.GA9789@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Carpenter' <dan.carpenter@oracle.com>, santoshprasadnayak@gmail.com
Cc: linux-scsi@vger.kernel.org

Dear Dan and Santosh Nayak,

I change task_state_lock to spin_lock is OK. Please feel free to send patch
out.

Thanks.

Jack
> 
> Hello Santosh Nayak,
> 
> The patch bdaefbf580cd: "[SCSI] pm8001: Fix bogus interrupt state
> flag issue." from Feb 26, 2012, leads to the following warning:
> drivers/scsi/pm8001/pm8001_hwi.c:2400 mpi_sata_completion()
> 	 error: double unlock 'irq:'
> 
> 
>         } else if (t->uldd_task) {
> -               spin_unlock_irqrestore(&t->task_state_lock, flags);
> +               spin_unlock_irq(&t->task_state_lock);
>                 ^^^^^^^^^^^^^^^
>                 pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>                 mb();/* ditto */
> -               spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +               spin_unlock_irq(&pm8001_ha->lock);
>                 ^^^^^^^^^^^^^^^
> It doesn't make sense to enable IRQs twice.  I'm not sure if it should
> be the first or second unlock which enables them.
> 
>                 t->task_done(t);
> -               spin_lock_irqsave(&pm8001_ha->lock, flags);
> +               spin_lock_irq(&pm8001_ha->lock);
>         } else if (!t->uldd_task) {
> -               spin_unlock_irqrestore(&t->task_state_lock, flags);
> +               spin_unlock_irq(&t->task_state_lock);
>                 ^^^^^^^^^^^^^^^
>                 pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>                 mb();/*ditto*/
> -               spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> +               spin_unlock_irq(&pm8001_ha->lock);
>                 ^^^^^^^^^^^^^^^
> Same thing again.
> 
>                 t->task_done(t);
> -               spin_lock_irqsave(&pm8001_ha->lock, flags);
> +               spin_lock_irq(&pm8001_ha->lock);
>         }
> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

