From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: [PATCH 0/5] mpt fusion: Add logging support
Date: Thu, 2 Aug 2007 06:57:25 +0900
Message-ID: <20070801080055Y.tomof@acm.org>
References: <20070731005521U.tomof@acm.org>
	<664A4EBB07F29743873A87CF62C26D708B41D0@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:47823 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXHAV5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Aug 2007 17:57:43 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D708B41D0@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: tomof@acm.org, James.Bottomley@SteelEye.com, Sathya.Prakash@lsi.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp

On Tue, 31 Jul 2007 12:40:41 -0600
"Moore, Eric" <Eric.Moore@lsi.com> wrote:

> On Monday, July 30, 2007 4:32 PM,  FUJITA Tomonori wrote:
> > > On another note, while unloading the driver, and I get an 
> > following opps
> > > from bsg in the context of scsi_remove_host.   This is w/o the "SMP
> > > passthrough" patch, so why would fusion drivers be linked to bsg?
> > > Woudn't this break mptspi and mptfc, since they will not be 
> > working with
> > > bsg.
> > > 
> > > 
> > > Call Trace:
> > >  [<ffffffff881f519c>] :scsi_transport_sas:sas_bsg_remove+0x27/0x32
> > >  [<ffffffff881f6349>] :scsi_transport_sas:sas_host_remove+0x30/0x34
> > >  [<ffffffff80375326>] transport_remove_classdev+0x1d/0x4c
> > >  [<ffffffff80375001>] attribute_container_device_trigger+0x69/0xa7
> > >  [<ffffffff8803778b>] :scsi_mod:scsi_remove_host+0xcd/0xfa
> > >  [<ffffffff883461ac>] :mptscsih:mptscsih_remove+0x32/0xae
> > >  [<ffffffff8031416d>] pci_device_remove+0x24/0x48
> > >  [<ffffffff803720ed>] __device_release_driver+0x91/0xb3
> > >  [<ffffffff80372631>] driver_detach+0xd6/0x115
> > >  [<ffffffff80371ba3>] bus_remove_driver+0x6d/0x90
> > >  [<ffffffff803143f4>] pci_unregister_driver+0x17/0x6b
> > >  [<ffffffff88355044>] :mptsas:mptsas_exit+0x10/0x5f
> > >  [<ffffffff80252afb>] sys_delete_module+0x1b1/0x1e0
> > >  [<ffffffff80307d9c>] __up_write+0x21/0x10d
> > >  [<ffffffff8020bc4e>] system_call+0x7e/0x83
> > 
> > This patch fix the problem?
> > 
> > ---
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] scsi_transport_sas: initialize sas_host_attrs->q
> > 
> > fix the bug to call bsg_unregister_queue for an uninitialized queue.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> yes it does fix it.
> 
> I'm not sure if this has already been posted to lsml@, but please apply
> to scsi-rc-fixes-2.6.

The following patch should fix this problem:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=c000c43cf12090972fad0fbb621d78c2100d0373
