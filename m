From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 4/5] qla2xxx: add target mode support
Date: Wed, 3 Oct 2007 21:48:34 +0900
Message-ID: <20071003214933Y.tomof@acm.org>
References: <46FBBF8C.80409@qlogic.com>
	<20070929151608P.fujita.tomonori@lab.ntt.co.jp>
	<470135CC.4080101@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43462 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbXJCMtH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 08:49:07 -0400
In-Reply-To: <470135CC.4080101@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, hare@suse.defujita.tomonori@lab.ntt.co.jp

On Mon, 01 Oct 2007 11:00:44 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> FUJITA Tomonori wrote:
> > On Thu, 27 Sep 2007 07:34:52 -0700
> > Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>> On Fri, 21 Sep 2007 07:34:18 -0700
> >>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> >>>
> >>>> Andrew Vasquez wrote:
> >>>>> On Sat, 01 Sep 2007, FUJITA Tomonori wrote:
> >>>>>
> >>>>>> This adds target mode support to qla2xxx.
> >>>>>>
> >>>>>> With set ql2enable_target_mode module parameter to 1, the driver runs
> >>>>>> in target mode. By default, ql2enable_target_mode is set to 0, and the
> >>>>>> driver should work in initiator mode as before.
> >>>>>>
> >>>>>> The driver could support dual-mode in the future but it doesn't at the
> >>>>>> moment (we need to add dual-mode support tgt first).
> >>>>>>
> >>>>>> It is based on scst qla2xxx target mode driver. Mike converted the
> >>>>>> driver to use tgt long ago. I changed it to use the latest (mainline)
> >>>>>> version of qla2xxx driver and tgt, and also converted it to use fc
> >>>>>> transport class.
> >>>>> Thanks for doing this.  Some initial comments before a full review is
> >>>>> complete, As was seen from the initiator updates needed for 24xx
> >>>>> support, there are comparable changes needed in the area of
> >>>>> target-mode support for 4gb and 8gb parts.  Also, which ISPs and
> >>>>> firmwares were exercised with this code?
> >>>> The patch is still under reviewing and will get done, soon.
> >>> Great, thinks!
> >> One more question on typical testing setup.
> >> I wonder how should I setup the testing environment esp., for the
> >> target-mode.
> > 
> > Sorry, I should have explained it with the patch.
> > 
> > Probabaly, you need to compile scsi-misc with the qla2xxx target patch
> > and the user-space target code.
> > 
> > 1. scsi-misc + the qla2xxx target patch
> > 
> > CONFIG_SCSI_TGT=m
> > CONFIG_SCSI_FC_ATTRS=m
> > CONFIG_SCSI_FC_TGT_ATTRS=y
> > CONFIG_SCSI_QLA_FC=m
> > CONFIG_SCSI_QLA_FC_TGT=y
> > 
> > 2. the user-space target code
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/tgt.git
> > 
> > rouen:~/git/tgt/usr$ make FCP=1 KERNELSRC=/home/fujita/git/scsi-misc-2.6
> > 
> > 
> > Starting the fc target mode is not so simple now (Mike and I know that
> > we need to fix it...).
> > 
> > 1. load scsi_tgt.ko
> > 
> > 2. start the user-space daemon
> > 
> > Here's a simple example.
> > 
> > ./tgt/usr/tgtd
> > ./tgt/usr/tgtadm --lld fc --mode target --op new --tid 1 --targetname volume1
> > ./tgt/usr/tgtadm --lld fc --mode logicalunit --op new --tid 1 --lun 1 -b /var/tmp/lun1
> Above command execution on the system with the HBA with target mode returns "invalid request" for some reason.
> Not sure if there are any steps that has to be in place?
> 
> The configuration is as follow,
> - two systems + a switch + a target device (JBOD) are involved.
> - each of systems has a QLogic HBA in it. The HBA on one system is in initiator mode and the other one is in target mode.
> - each of the port of the HBAs is connected to the switch and a target device (JBOD) is connected to the switch, too.
> 
> Thank you,
> Seokmann
> ---
> atl-01:/lib/modules/2.6.23-rc3-smp-tgt/kernel/drivers/scsi/qla2xxx # tgtadm --lld fc --mode target --op show
> Target 1: volume1
>     System information:
>         Driver: fc
>         Status: running
>     I_T nexus information:
>     LUN information:
>         LUN: 0
>             Type: controller
>             SCSI ID: deadbeaf1:0
>             SCSI SN: beaf10
>             Size: 0
>             Online: No
>             Poweron/Reset: Yes
>             Removable media: No
>             Backing store: No backing store
>     ACL information:

You successfully created a new target but failed to add a new logical
unit (#1) to it (note that lun 0 was created automatically).

> > ./tgt/usr/tgtadm --lld fc --mode logicalunit --op new --tid 1 --lun 1 -b /var/tmp/lun1

We are try to add a regular file (/var/tmp/lun1) to the target and
export it as a logical unit to initiators. Do you have /var/tmp/lun1?

fujita@arbre:/var/tmp$ ls -l lun1
-rw-r--r-- 1 fujita fujita 67108864 2007-06-14 22:01 lun1
