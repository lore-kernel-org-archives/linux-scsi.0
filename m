From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3] SCSI: Make cmd_serial_number an atomic
Date: Sun, 3 Apr 2011 07:15:43 -0600
Message-ID: <20110403131543.GF7286@parisc-linux.org>
References: <20110401202051.GL4183@linux.intel.com> <20110402133643.GB18990@infradead.org> <20110402210240.GD7286@parisc-linux.org> <20110403110057.GC3872@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60862 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1DCNPp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2011 09:15:45 -0400
Content-Disposition: inline
In-Reply-To: <20110403110057.GC3872@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

On Sun, Apr 03, 2011 at 07:00:57AM -0400, Christoph Hellwig wrote:
> On Sat, Apr 02, 2011 at 03:02:40PM -0600, Matthew Wilcox wrote:
> > Fair enough, but you're making the perfect the enemy of the good.
> > How about putting this patch in for now (since it harms nothing), and
> > then it'll all go away when you delete cmd_serial_number?
> 
> If you change it anyway for mpt2sas just keep the atomic counter in
> it's local structures.  Or even better verify with LSI if the
> serial_number check can't simply be removed entirely, which I think it
> could.

Hm, yeah, it looks like it's only used for checking whether the command
we're aborting is the same command we're using to do the aborts.  In
which case, can't we simply do this?  Eric?

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6ceb775..bce9043 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2133,8 +2133,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 	switch (type) {
 	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
 		scmd_lookup = _scsih_scsi_lookup_get(ioc, smid_task);
-		if (scmd_lookup && (scmd_lookup->serial_number ==
-		    scmd->serial_number))
+		if (scmd_lookup == scmd))
 			rc = FAILED;
 		else
 			rc = SUCCESS;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
