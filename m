From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: pm8001_hwi.c uldd_task - missing spin_lockirqsave?
Date: Mon, 17 Sep 2012 17:23:38 +0800
Message-ID: <790003F5C19642FD990B89D73587D7A4@usish.com.cn>
References: <5056E8C7.2080704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:58801 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab2IQJYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2012 05:24:04 -0400
In-Reply-To: <5056E8C7.2080704@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'roel kluin' <roel.kluin@gmail.com>, lindar_liu@usish.com
Cc: "'James E.J. Bottomley'" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

> 
> The file drivers/scsi/pm8001/pm8001_hwi.c contains the piece of code
below,
> at
> the end of mpi_sata_completion() and  mpi_sata_event(), which appears
wrong.
> While the test is opposite, the executed branch does exactly the same. I
believe
> one of the branches should spin_lockirqsave instead? not 100% sure how to
fix
> this.
> 
> Roel
> 
> 	} else if (t->uldd_task) {
> 		spin_unlock_irqrestore(&t->task_state_lock, flags);
> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> 		mb();/* ditto */
> 		spin_unlock_irq(&pm8001_ha->lock);
> 		t->task_done(t);
> 		spin_lock_irq(&pm8001_ha->lock);
> 	} else if (!t->uldd_task) {
> 		spin_unlock_irqrestore(&t->task_state_lock, flags);
> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
> 		mb();/*ditto*/
> 		spin_unlock_irq(&pm8001_ha->lock);
> 		t->task_done(t);
> 		spin_lock_irq(&pm8001_ha->lock);
> 	}
> --
[Jack Wang] Current mainline code all task->uldd_task is not null, so we can
remove the below branch. Not sure why you said should use spin_lock_irqsave.


