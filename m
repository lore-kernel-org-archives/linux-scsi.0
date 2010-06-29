From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 03/23] bfa: PBC vport create
Date: Tue, 29 Jun 2010 17:50:55 -0500
Message-ID: <1277851855.4379.174.camel@mulgrave.site>
References: <1276626113-3102-1-git-send-email-huangj@brocade.com>
	 <1277045513.5242.15.camel@mulgrave.site>
	 <04391A4E90BB2149B010D22452FA168702283154A5@HQ-EXCH-6.corp.brocade.com>
	 <04391A4E90BB2149B010D22452FA16870228315BCE@HQ-EXCH-6.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab0F2WvC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2010 18:51:02 -0400
In-Reply-To: <04391A4E90BB2149B010D22452FA16870228315BCE@HQ-EXCH-6.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vinodh Ravindran <vravindr@Brocade.COM>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Krishna Gudipati <kgudipat@Brocade.com>, Akshay Mathur <amathur@brocade.com>

On Tue, 2010-06-29 at 12:34 -0700, Jing Huang wrote:
> >>This one's giving a single rejection:
> >>
> >>patching file drivers/scsi/bfa/bfad_drv.h
> >>Hunk #2 FAILED at 197.
> >>1 out of 2 hunks FAILED -- saving rejects to file
> >>drivers/scsi/bfa/bfad_drv.h.rej
> >>
> >>But it looks to be serious:  then hunk is:
> >>
> >>+++ drivers/scsi/bfa/bfad_drv.h
> >>@@ -197,12 +199,18 @@
> >> 	bfa_boolean_t	ipfc_enabled;
> >> 	union bfad_tmp_buf tmp_buf;
> >> 	struct fc_host_statistics link_stats;
> >>+	struct list_head pbc_pcfg_list;
> >> 	u32 fwtrc_len;
> >> 	char *fwtrc;
> >> 	u32 reglen;
> >> 	char *regdata;
> >> };
> >>
> >>But the defined structure in the file is:
> >>
> >>	bfa_boolean_t	ipfc_enabled;
> >>	union bfad_tmp_buf tmp_buf;
> >>	struct fc_host_statistics link_stats;
> >>};
> >>
> >>So there's quite a bit missing somewhere.
> >>
> >>James
> >>
> >
> >Hi James,
> >
> >This patch set depends on the patch sent out earlier by Krishna Guidapt to collect
> >debug info
> >using sysfs binary attributes, here is the link to the patch:
> >
> >http://marc.info/?l=linux-scsi&m=127604326602491&w=2
> >
> >It enables the basics debuggability the current upstream driver lacks as a result of
> >IOCTL
> >removal, so that when there is some issue happen in the firmware/hardware, when
> >can
> >use them to dump out firmware trace and read/write to the chip registers.
> >
> >If you need more time to review or have any concern on that particular patch,
> >please let me know,
> >I can recreate the 2.2.2.1 patch set without that change so that they can be applied
> >cleanly to the
> >current scsi-misc tree.
> >
> >Thanks
> >
> >Jing
> >
> >
> 
> Hi James,
> 
> Any comments on my response above? Do you want me to remove the dependency on
> Krishna's patch and resubmit?

Yes, I dug it out and looked at it ... it really seems that what you're
trying to do in this patch:

bfa: Add sysfs support to obtain debug info

is add something to sysfs that would be better exported with debugfs.

So I'll leave it up to you ... if the debug info patch can be redone
with debugfs and this still applies, I'll take it ... otherwise, just a
redo not to be based on that patch might be better.

James


