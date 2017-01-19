From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 03/17] lpfc: NVME Initiator: Base modifications Part B
Date: Thu, 19 Jan 2017 09:08:19 +0100
Message-ID: <20170119080819.GC5054@linux-x5ow.site>
References: <587ec2ee.01djIfQsSlhQj6k1%jsmart2021@gmail.com>
 <20170118101112.GC3514@linux-x5ow.site>
 <4c44ac81-e409-371e-7fa5-bc1946b6c650@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750900AbdASIIf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Jan 2017 03:08:35 -0500
Content-Disposition: inline
In-Reply-To: <4c44ac81-e409-371e-7fa5-bc1946b6c650@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On Wed, Jan 18, 2017 at 06:45:46PM -0800, James Smart wrote:
> 
> 
> On 1/18/2017 2:11 AM, Johannes Thumshirn wrote:
> >On Tue, Jan 17, 2017 at 05:20:46PM -0800, James Smart wrote:
> >>NVME Initiator: Base modifications
> >>
> >>This is part B of parts A..F.
> >>
> >>Part B is limited to lpfc_attr.c: lpfc attribute modifications
> >>
> >>*********
> >>
> >>Refer to Part A for a description of base modifications
> >>
> >>Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> >>Signed-off-by: James Smart <james.smart@broadcom.com>
> >>---
> >[...]
> >
> >>+	len += snprintf(buf + len, PAGE_SIZE - len,
> >>+			"%s%d WWPN x%llx WWNN x%llx DID x%06x %s\n",
> >>+			"NVME LPORT lpfc",
> >Is it the lack of coffee or should it be
> >			"NVME LPORT lpfc%d WWPN x%llx WWNN x%llx DID x%06x %s\n"
> >
> >I think you're doing it to not hit the 80 chars limit, but then there are
> >way more offenders than that one, so...
> 
> The line split is certainly due to the 80 limit and have that issue a lot.
> 
> As for what the string name should be - I agree with you. something is
> confused.
> 
> >>+int
> >>+lpfc_emptyq_wait(struct lpfc_hba *phba, struct list_head *q, spinlock_t *lock)
> >>+{
> >>+	int cnt = 0;
> >>+
> >>+	spin_lock_irq(lock);
> >>+	while (!list_empty(q)) {
> >>+		spin_unlock_irq(lock);
> >>+		msleep(20);
> >>+		if (cnt++ > 250) {  /* 5 secs */
> >>+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
> >>+					"0466 %s %s\n",
> >>+					"Outstanding IO when ",
> >>+					"bringing Adapter offline\n");
> >>+				return 0;
> >>+		}
> >>+		spin_lock_irq(lock);
> >>+	}
> >>+	spin_unlock_irq(lock);
> >>+	return 1;
> >>+}
> >>+
> >Aren't you using lpc_emptyq_wait() in patches prior to that already? This
> >breaks git bisect. Pleas test-build (ideally + checkpatch and sparse/smatch)
> >each patch in the series individually.
> 
> I called out - in patch2 - that Patches 2 through 7, known as parts A..F,
> area really one big patch. They will not follow the git bisect rules.  I
> could have sent them in one huge patch, but chose to break them up.
> Unfortunately, the mods accumulated over time with lots of reworks -
> creating a base that was too intertwined to put into small functional
> patches without spending oodles of time to carve them up.   I hope you can
> bear with me on this set and review the 7 pieces as one big patch.

For review one big patch clearly is a huge problem, I agree. But the final
merged version must not break bisects. So we can probably defer the discussion
to the end of the merging.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
