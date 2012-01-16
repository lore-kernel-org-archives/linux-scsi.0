From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH v4 0/2] libsas: eh reworks (ata-eh vs discovery,
 races, ...)
Date: Tue, 17 Jan 2012 00:24:07 +0400
Message-ID: <1326745447.2872.28.camel@dabdike>
References: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
	 <1326223752.3264.43.camel@dabdike.int.hansenpartnership.com>
	 <CABE8wwuBN45f2s-bcW3R=5VE1V3svtcrp93-9LW5zZ6VtZFqmQ@mail.gmail.com>
	 <1326703228.2872.5.camel@dabdike>
	 <1326733212.2548.3.camel@ultramagnus.opencreations.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44031 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754959Ab2APUYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2012 15:24:12 -0500
In-Reply-To: <1326733212.2548.3.camel@ultramagnus.opencreations.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jack_wang@usish.com

On Mon, 2012-01-16 at 09:00 -0800, Dan Williams wrote:
> On Mon, 2012-01-16 at 12:40 +0400, James Bottomley wrote:
> > On Tue, 2012-01-10 at 12:18 -0800, Dan Williams wrote:
> > > On Tue, Jan 10, 2012 at 11:29 AM, James Bottomley
> > > <James.Bottomley@hansenpartnership.com> wrote:
> > > > On Mon, 2012-01-09 at 23:38 -0800, Dan Williams wrote:
> > > >> The latest version of the patch kit is available here:
> > > >>
> > > >>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas-eh-reworks-v4
> > > >>
> > > >> Changes since v3: http://marc.info/?l=linux-scsi&m=132581455214789&w=2
> > > >
> > > > Just to check I'm not lost here. I think this is currently the only
> > > > mergeable set of patches you have because you're reworking patches in
> > > > all your other series and will repost ... is this correct?
> > > 
> > > There are two mergeable topics in isci.git:
> > > libsas-eh-reworks-v4: mergeable
> > > devel: mergeable, posted as "[GIT PATCH v2 00/15] isci update for 3.3
> > > (part1)" [1].  This contains all the general updates to the driver
> > > that were independent of the libsas churn.  It was rebased to
> > > incorporate Ben's firmware removal patch, but is otherwise idle and
> > > ready to merge.
> > 
> > 1/2 doesn't apply:
> > 
> > patching file drivers/scsi/libsas/sas_scsi_host.c
> > Hunk #1 succeeded at 235 with fuzz 2 (offset -14 lines).
> > Hunk #2 FAILED at 267.
> > Hunk #3 succeeded at 505 with fuzz 2 (offset -25 lines).
> > Hunk #4 succeeded at 512 with fuzz 1 (offset -34 lines).
> > Hunk #5 FAILED at 655.
> > 2 out of 5 hunks FAILED -- saving rejects to file
> > drivers/scsi/libsas/sas_scsi_host.c.rej
> > 
> 
> ...and you have the pre-requisites to
> drivers/scsi/libsas/sas_scsi_host.c?
> 
> d7ca96e libsas: kill sas_slave_destroy
> eb4a9d3 libsas: fix domain_device leak
> 07ec747 libsas: remove ata_port.lock management duties from lldds
> 8f2c41b libsas: convert dev->gone to flags
> 2145ed7 libsas: close error handling vs sas_ata_task_done() race
> 9540580b libsas: prevent double completion of scmds from eh
> 630efd3 libsas: fix timeout vs completion race
> 41707de libsas: let libata handle command timeouts
> 6b7b289 libsas: defer SAS_TASK_NEED_DEV_RESET commands to libata
> b13a7df libsas: sas_phy_enable via transport_sas_phy_reset
> 3b58c03 libsas: fix sas_find_local_phy(), take phy references
> 
> I managed to confuse things by posting only incremental series... the
> full set is in git, and I can repost as needed.

Well, no, when I asked you said the libsas series was pending rewrite.
Specifically

[PATCH v3 03/14] libsas: prevent domain rediscovery competing with ata
error handling

I think ... have you reposted that?

James


