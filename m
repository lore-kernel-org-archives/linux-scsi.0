From: Florian Lohoff <flo@rfc822.org>
Subject: spinlock sgiwd33 vs spinlock in wd33c93
Date: Sat, 25 Sep 2004 14:37:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040925123733.GC2630@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hydra.gt.owl.de ([195.71.99.218]:23435 "EHLO hydra.gt.owl.de")
	by vger.kernel.org with ESMTP id S269316AbUIYMhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Sep 2004 08:37:39 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,
by staring at the code i had the suspicion that the spinlock in the
users of the generic wd33c93.c might be obsolete or is my brain too
twisted.

     93
     94   spin_lock_irqsave(host->host_lock, flags);
     95   wd33c93_intr(host);
     96   spin_unlock_irqrestore(host->host_lock, flags);
     97

Whereas the wd33c93_intr itself does:

    775         asr = read_aux_stat(regs);
    776         if (!(asr & ASR_INT) || (asr & ASR_BSY))
    777                 return;
    778
    779         spin_lock_irqsave(&hostdata->lock, flags);
    780

It seems all users (gvp, a2091, a3000, sgiwd) do have it except mvme147

Flo
-- 
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
                        Heisenberg may have been here.
