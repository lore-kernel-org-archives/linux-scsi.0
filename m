From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] cxgb3i: convert cdev->l2opt to use rcu to prevent NULL
 dereference (v2)
Date: Thu, 22 Sep 2011 15:51:39 -0400
Message-ID: <20110922195138.GB16912@hmsreliant.think-freely.org>
References: <1315331953-11456-1-git-send-email-nhorman@tuxdriver.com>
 <4E7B83EB.2000105@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47015 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab1IVTv7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2011 15:51:59 -0400
Content-Disposition: inline
In-Reply-To: <4E7B83EB.2000105@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, Divy Le Ray <divy@chelsio.com>, Steve Wise <swise@chelsio.com>, Karen Xie <kxie@chelsio.com>, stable-commits@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Thu, Sep 22, 2011 at 01:52:27PM -0500, Mike Christie wrote:
> On 09/06/2011 12:59 PM, Neil Horman wrote:
> > This oops was reported recently:
> > d:mon> e
> > cpu 0xd: Vector: 300 (Data Access) at [c0000000fd4c7120]
> >     pc: d00000000076f194: .t3_l2t_get+0x44/0x524 [cxgb3]
> >     lr: d000000000b02108: .init_act_open+0x150/0x3d4 [cxgb3i]
> >     sp: c0000000fd4c73a0
> >    msr: 8000000000009032
> >    dar: 0
> >  dsisr: 40000000
> >   current = 0xc0000000fd640d40
> >   paca    = 0xc00000000054ff80
> >     pid   = 5085, comm = iscsid
> > d:mon> t
> > [c0000000fd4c7450] d000000000b02108 .init_act_open+0x150/0x3d4 [cxgb3i]
> > [c0000000fd4c7500] d000000000e45378 .cxgbi_ep_connect+0x784/0x8e8 [libcxgbi]
> > [c0000000fd4c7650] d000000000db33f0 .iscsi_if_rx+0x71c/0xb18
> > [scsi_transport_iscsi2]
> > [c0000000fd4c7740] c000000000370c9c .netlink_data_ready+0x40/0xa4
> > [c0000000fd4c77c0] c00000000036f010 .netlink_sendskb+0x4c/0x9c
> > [c0000000fd4c7850] c000000000370c18 .netlink_sendmsg+0x358/0x39c
> > [c0000000fd4c7950] c00000000033be24 .sock_sendmsg+0x114/0x1b8
> > [c0000000fd4c7b50] c00000000033d208 .sys_sendmsg+0x218/0x2ac
> > [c0000000fd4c7d70] c00000000033f55c .sys_socketcall+0x228/0x27c
> > [c0000000fd4c7e30] c0000000000086a4 syscall_exit+0x0/0x40
> > --- Exception: c01 (System Call) at 00000080da560cfc
> > 
> > The root cause was an EEH error, which sent us down the offload_close path in
> > the cxgb3 driver, which in turn sets cdev->l2opt to NULL, without regard for
> > upper layer driver (like the cxgbi drivers) which might have execution contexts
> > in the middle of its use. The result is the oops above, when t3_l2t_get attempts
> > to dereference L2DATA(cdev)->nentries in arp_hash right after the EEH error handler sets it to NULL.
> > 
> 
> Did you end up having a similar problem on cxgb4i too?
> 
I'm working on a audit of the code for that now (IBM reported this problem, and
was onlyusing cxgb3, so I'm having to do this all visually for cxgb4

Neil

