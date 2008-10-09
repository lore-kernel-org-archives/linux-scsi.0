From: Matthew Wilcox <matthew@wil.cx>
Subject: lpfc sleeps while holding a spinlock
Date: Thu, 9 Oct 2008 10:41:01 -0600
Message-ID: <20081009164101.GX25780@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36962 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbYJIQlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2008 12:41:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org


This is with 2.6.27-rc9; most recent non-janitorial commit to the lpfc
directory is ff0f4cb5ea322dcc32d08bab2d758c050ba1ab07 (Update lpfc driver
version to 8.2.7).  The janitorial commits do not affect the code in
question.


This bug gets reported by lockdep as a mismatch between holding the
hbalock with interrupts on vs acquiring it in interrupt context, but
actually the problem is a GFP_KERNEL allocation while holding a spinlock:

lpfc_sli_hbqbuf_fill_hbqs(struct lpfc_hba *phba, uint32_t hbqno,
uint32_t count)
{
...
        spin_lock_irqsave(&phba->hbalock, flags);
...
        for (i = start; i < end; i++) {
                hbq_buffer = (phba->hbqs[hbqno].hbq_alloc_buffer)(phba);

where previously:
drivers/scsi/lpfc/lpfc_init.c: phba->hbqs[LPFC_ELS_HBQ].hbq_alloc_buffer = lpfc_els_hbq_alloc;

and:
lpfc_els_hbq_alloc(struct lpfc_hba *phba)
{
        struct hbq_dmabuf *hbqbp;
        hbqbp = kmalloc(sizeof(struct hbq_dmabuf), GFP_KERNEL);

Presumably these GFP_KERNEL should become GFP_ATOMIC, or the spinlock
shouldn't be taken at this point, but I haven't looked deeply enough
into the driver to determine which course of action is correct.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
