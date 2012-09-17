From: roel kluin <roel.kluin@gmail.com>
Subject: pm8001_hwi.c uldd_task - missing spin_lockirqsave?
Date: Mon, 17 Sep 2012 11:09:27 +0200
Message-ID: <5056E8C7.2080704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44099 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab2IQJJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2012 05:09:53 -0400
Received: by bkwj10 with SMTP id j10so2342945bkw.19
        for <linux-scsi@vger.kernel.org>; Mon, 17 Sep 2012 02:09:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang@usish.com, lindar_liu@usish.com
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

The file drivers/scsi/pm8001/pm8001_hwi.c contains the piece of code below, at
the end of mpi_sata_completion() and  mpi_sata_event(), which appears wrong.
While the test is opposite, the executed branch does exactly the same. I believe
one of the branches should spin_lockirqsave instead? not 100% sure how to fix this.

Roel

	} else if (t->uldd_task) {
		spin_unlock_irqrestore(&t->task_state_lock, flags);
		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
		mb();/* ditto */
		spin_unlock_irq(&pm8001_ha->lock);
		t->task_done(t);
		spin_lock_irq(&pm8001_ha->lock);
	} else if (!t->uldd_task) {
		spin_unlock_irqrestore(&t->task_state_lock, flags);
		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
		mb();/*ditto*/
		spin_unlock_irq(&pm8001_ha->lock);
		t->task_done(t);
		spin_lock_irq(&pm8001_ha->lock);
	}
