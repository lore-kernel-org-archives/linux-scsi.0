From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking IRQ-safe
Date: Wed, 15 Jun 2011 10:22:08 -0700
Message-ID: <BANLkTimM-=fGphT_okWuMYY1LgDk=XQzow@mail.gmail.com>
References: <1308023045-5257-1-git-send-email-roland@kernel.org> <1308157596.20109.28.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49589 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1FORW3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 13:22:29 -0400
In-Reply-To: <1308157596.20109.28.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:06 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Btw, I think the same type of conversion may need to happen for
> transport_lookup_tmr_lun() as well, as I believe qla_target.c can call
> this directly from interrupt context in certain situations.

Yes, I think I sent another mail about this... the reason I didn't just
send a patch is that transport_lookup_tmr_lun() ends with:

        spin_lock(&se_tmr->tmr_dev->se_tmr_lock);
        list_add_tail(&se_tmr->tmr_list, &se_tmr->tmr_dev->dev_tmr_list);
        spin_unlock(&se_tmr->tmr_dev->se_tmr_lock);

and indeed se_tmr_lock looks like it is taken with bare spin_lock()
in lots of places.

Presumably se_tmr_lock is taken from process context sometimes?
So we would need to convert all those spin_lock()s to spin_lock_irq()
(or irqsave I guess).

 - R.
