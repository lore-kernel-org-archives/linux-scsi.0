From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 3/4] scsi_data_buffer
Date: Tue, 13 Nov 2007 16:26:59 +0900
Message-ID: <20071113162847B.tomof@acm.org>
References: <20071112220652.dd9562c5.akpm@linux-foundation.org>
	<20071113154309K.tomof@acm.org>
	<20071112230703.f41309cc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:58450 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759131AbXKMH2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Nov 2007 02:28:12 -0500
In-Reply-To: <20071112230703.f41309cc.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: tomof@acm.org, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, pw@osc.edu, bhalevy@panasas.com, jes@sgi.com

On Mon, 12 Nov 2007 23:07:03 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 13 Nov 2007 15:40:42 +0900 FUJITA Tomonori <tomof@acm.org> wrote:
> 
> > On Mon, 12 Nov 2007 22:06:52 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Thu, 08 Nov 2007 18:59:30 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
> > > 
> > > >   In preparation for bidi we abstract all IO members of scsi_cmnd,
> > > >   that will need to duplicate, into a substructure.
> > > > 
> > > >   - Group all IO members of scsi_cmnd into a scsi_data_buffer
> > > >     structure.
> > > 
> > > drivers/scsi/qla1280.c: In function 'qla1280_done':
> > > drivers/scsi/qla1280.c:1313: error: 'struct scsi_cmnd' has no member named 'use_sg'
> > > drivers/scsi/qla1280.c:1314: error: 'struct scsi_cmnd' has no member named 'request_buffer'
> > > drivers/scsi/qla1280.c:1315: error: 'struct scsi_cmnd' has no member named 'use_sg'
> > > drivers/scsi/qla1280.c:1316: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
> > > drivers/scsi/qla1280.c:1318: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
> > > drivers/scsi/qla1280.c: In function 'qla1280_return_status':
> > > drivers/scsi/qla1280.c:1409: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
> > > drivers/scsi/qla1280.c:1416: error: 'struct scsi_cmnd' has no member named 'resid'
> > > drivers/scsi/qla1280.c: In function 'qla1280_64bit_start_scsi':
> > > drivers/scsi/qla1280.c:2791: error: 'struct scsi_cmnd' has no member named 'use_sg'
> > > drivers/scsi/qla1280.c:2792: error: 'struct scsi_cmnd' has no member named 'request_buffer'
> > > drivers/scsi/qla1280.c:2793: error: 'struct scsi_cmnd' has no member named 'use_sg'
> > > drivers/scsi/qla1280.c:2801: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
> > > drivers/scsi/qla1280.c:2896: error: 'struct scsi_cmnd' has no member named 'use_sg'
> > > drivers/scsi/qla1280.c:2991: error: 'struct scsi_cmnd' has no member named 'request_buffer'
> > > drivers/scsi/qla1280.c:2992: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
> > > drivers/scsi/qla1280.c:3004: error: 'struct scsi_cmnd' has no member named 'request_bufflen'
> > > make[2]: *** [drivers/scsi/qla1280.o] Error 1
> > > 
> > > It mystfies me how a patch like this can have been floating about in N
> > > submissions across M months and nobody has done an allmodconfig build or
> > > even a grep to find out what broke.
> > > 
> > > ho hum.  I shall mark qla1280 BROKEN and shall plod onwards.
> > 
> > A patch to fix this is in James' scsi-pending tree. Jes tested and
> > fixed it (thanks !) so it will go to -mm via scsi-misc soon.
> 
> oh gawd.  So we have git-scsi-misc, git-scsi-rc-fixes and now
> git-scsi-pending?

I don't think that you will have git-scsi-pending. James just uses the
tree for patches that are not ready for scsi-misc.


> I hope you fixed imm, ppa and any other broken drivers?

There are patches to fix both.

All the scsi drivers are ready for the scsi_data_buffer patchset
though some patches have not been merged yet, I think.

Probabaly, it's the easiest way to handle the scsi_data_buffer
patchset is adding it via scsi-misc.


> > Boaz, it's better to send major scsi patches to -mm via scsi-misc to
> > avoid problems like this.
> > 
> > 
> > By the way, Andrew, can you add the following patchset to -mm?
> > 
> > http://lkml.org/lkml/2007/10/24/138
> > 
> > It fixes the IOMMUs' problem to merge scatter/gather segments without
> > considering LLDs' restrictions.
> 
> hmm, OK, I saved them away to look at after next -mm.

Thanks.
