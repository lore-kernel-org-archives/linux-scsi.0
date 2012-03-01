From: santosh prasad nayak <santoshprasadnayak@gmail.com>
Subject: Re: [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Thu, 1 Mar 2012 19:54:57 +0530
Message-ID: <CAOD=uF46HF3iLto3AhnTkjzSDebAkCYtTE-UJ26s00CwgwRPYA@mail.gmail.com>
References: <20120301142225.GA9789@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42785 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab2CAOY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 09:24:57 -0500
Received: by pbcup15 with SMTP id up15so944089pbc.19
        for <linux-scsi@vger.kernel.org>; Thu, 01 Mar 2012 06:24:57 -0800 (PST)
In-Reply-To: <20120301142225.GA9789@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org

The warnings are  there since from the beginning.
Even before my fix.

There are two locks:
1.  pm8001_ha->lock
2. t->task_state_lock

regards
santosh

On Thu, Mar 1, 2012 at 7:52 PM, Dan Carpenter <dan.carpenter@oracle.com=
> wrote:
> Hello Santosh Nayak,
>
> The patch bdaefbf580cd: "[SCSI] pm8001: Fix bogus interrupt state
> flag issue." from Feb 26, 2012, leads to the following warning:
> drivers/scsi/pm8001/pm8001_hwi.c:2400 mpi_sata_completion()
> =A0 =A0 =A0 =A0 error: double unlock 'irq:'
>
>
> =A0 =A0 =A0 =A0} else if (t->uldd_task) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&t->task_state_l=
ock, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&t->task_state_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pm8001_ccb_task_free(pm8001_ha, t, ccb=
, tag);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mb();/* ditto */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&pm8001_ha->lock=
, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&pm8001_ha->lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^
> It doesn't make sense to enable IRQs twice. =A0I'm not sure if it sho=
uld
> be the first or second unlock which enables them.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t->task_done(t);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&pm8001_ha->lock, fla=
gs);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irq(&pm8001_ha->lock);
> =A0 =A0 =A0 =A0} else if (!t->uldd_task) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&t->task_state_l=
ock, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&t->task_state_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pm8001_ccb_task_free(pm8001_ha, t, ccb=
, tag);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mb();/*ditto*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&pm8001_ha->lock=
, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irq(&pm8001_ha->lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^
> Same thing again.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t->task_done(t);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&pm8001_ha->lock, fla=
gs);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irq(&pm8001_ha->lock);
> =A0 =A0 =A0 =A0}
>
> regards,
> dan carpenter
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
