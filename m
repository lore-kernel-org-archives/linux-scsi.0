From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/5] bfa: Brocade BFA FC SCSI driver (makefile)
Date: Sat, 04 Apr 2009 08:19:58 -0500
Message-ID: <1238851198.4083.5.camel@mulgrave.int.hansenpartnership.com>
References: <200904020335.n323ZJVh004287@blc-10-2.brocade.com>
	 <1238679361.3383.4.camel@mulgrave.int.hansenpartnership.com>
	 <b674f4c50904040541l523c489eh3556819a022c1ed7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34636 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906AbZDDNUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Apr 2009 09:20:02 -0400
In-Reply-To: <b674f4c50904040541l523c489eh3556819a022c1ed7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <jhuang007@gmail.com>
Cc: Krishna Gudipati <kgudipat@brocade.com>, huangj@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, nkattang@brocade.com, rvadivel@brocade.com, vravindr@brocade.com

On Sat, 2009-04-04 at 20:41 +0800, Jing Huang wrote:
> On Thu, Apr 2, 2009 at 9:36 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Wed, 2009-04-01 at 20:35 -0700, Krishna Gudipati wrote:
> >> From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
> >>
> >> This patch contains Makefile and Kconfig file for scsi and bfa.Fixed
> >> the code review comments from previous submission.
> >>
> >> Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
> >> ---
> >>  Kconfig      |    9 +++++++++
> >>  Makefile     |    1 +
> >>  bfa/Makefile |   27 +++++++++++++++++++++++++++
> >>  3 files changed, 37 insertions(+)
> >>
> >> diff -urpN orig/drivers/scsi/Kconfig patch/drivers/scsi/Kconfig
> >> --- orig/drivers/scsi/Kconfig 2009-04-01 20:08:49.271161000 -0700
> >> +++ patch/drivers/scsi/Kconfig        2009-04-01 20:08:44.003822000 -0700
> >> @@ -1797,6 +1797,15 @@ config SCSI_SRP
> >>         To compile this driver as a module, choose M here: the
> >>         module will be called libsrp.
> >>
> >> +config SCSI_BFA_FC
> >> +     tristate "Brocade BFA Fibre Channel Support"
> >> +     depends on PCI && SCSI
> >> +     help
> >> +       This bfa driver supports all Brocade PCIe Fibre Channel host adapters.
> >> +
> >> +       To compile this driver as a module, choose M here. The module will
> >> +       be called bfa.
> >> +
> >
> > You're still not using the FC transport class to export common sysfs FC
> > information or to help make your driver smaller.  I thought you were
> > going to fix this after this was noted in your first submission to
> > linux-scsi on 24 September?
> >
> > James
> >
> >
> 
> Hi James,
> 
> We removed Brocade specific sysfs code after first linux-scsi
> submission. Can you please
> clarify where we are still not using the FC transport class to export
> common sysfs FC
> information? We do use the fc transport template to create the common
> sysfs FC attributes
> (in bfad_attr.c) under /sys/class/fc_host/<host#>

Ah ... I was going by the fact that you don't  select SCSI_FC_ATTRS in
the Kconfig ... so this is just something as simple as a missing select?
(Without the select you'll fail some of the random compile tests because
the needed scsi_transport_fc code won't be present).

James


