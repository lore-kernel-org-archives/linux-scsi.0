From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 4/5] qla2xxx: add target mode support
Date: Thu, 4 Oct 2007 09:44:21 +0900
Message-ID: <20071004013053T.tomof@acm.org>
References: <470135CC.4080101@qlogic.com>
	<20071003214933Y.tomof@acm.org>
	<4703F1CE.3020803@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:59095 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbXJDApR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 20:45:17 -0400
In-Reply-To: <4703F1CE.3020803@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, hare@suse.de

On Wed, 03 Oct 2007 12:47:26 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> FUJITA Tomonori wrote:
> > On Mon, 01 Oct 2007 11:00:44 -0700
> > Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> >> atl-01:/lib/modules/2.6.23-rc3-smp-tgt/kernel/drivers/scsi/qla2xxx # tgtadm --lld fc --mode target --op show
> >> Target 1: volume1
> >>     System information:
> >>         Driver: fc
> >>         Status: running
> >>     I_T nexus information:
> >>     LUN information:
> >>         LUN: 0
> >>             Type: controller
> >>             SCSI ID: deadbeaf1:0
> >>             SCSI SN: beaf10
> >>             Size: 0
> >>             Online: No
> >>             Poweron/Reset: Yes
> >>             Removable media: No
> >>             Backing store: No backing store
> >>     ACL information:
> > 
> > You successfully created a new target but failed to add a new logical
> > unit (#1) to it (note that lun 0 was created automatically).
> Yes, I have noticed it.
> 
> >>> ./tgt/usr/tgtadm --lld fc --mode logicalunit --op new --tid 1 --lun 1 -b /var/tmp/lun1
> > 
> > We are try to add a regular file (/var/tmp/lun1) to the target and
> > export it as a logical unit to initiators. Do you have /var/tmp/lun1?
> With the creation of an empty file, it started to display the lun1.
> ---
> atl-01:~ # tgtadm --lld fc --mode target --op show
> Target 1: tgt-vol1
>     System information:
>         Driver: fc
>         Status: running
>     I_T nexus information:
>         I_T nexus: f6fb6000

The target got an initiator. Can you setup a target first (all the
initiators are shut down (or fc kernel modules in initiators hosts are
unloaded). There is no I_T nexus in the show operation's output. Then
you start initiator hosts (or load the kernel modules) and hopefully
the initiator hots can see luns.


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
>         LUN: 1
>             Type: disk
>             SCSI ID: deadbeaf1:1
>             SCSI SN: beaf11
>             Size: 0

Note 'Size: 0' line. Needs to use a non-empty file.


>             Online: Yes
>             Poweron/Reset: Yes
>             Removable media: No
>             Backing store: /var/tmp/lun1
>     ACL information:
> atl-01:~ #
> ---
> 
> However, from the initiator, still not be able to see the target - from the lsscsi, no other devices (controller/virtual-disk) than those physical devices available on the fabric.
> Instead, the host with target-mode displays following messages,
> ---
> Oct 3 11:21:13 atl-01 kernel: q2t_it_nexus_response 1191:  dff46400 0
> Oct 3 11:21:13 atl-01 kernel: q2t_it_nexus_response 1191:  dff46400 0

It means that user-space daemon (tgtd) sent a message that a new I_T
nexus was created.


> 
> If I understood correctly, the F/W on the host with target-mode should have gotten some SCSI commands from the host with initiator-mode by now.
> And those commands should have been forwarded to the target driver via the interrupt handler (qla24xx_intr_handler()).

Yeah, I think so.


> Just for my learning, could you share with me which of the F/W version (on the target-mode QLogic FC HBA) you are using?

qla2xxx 0000:0a:02.0:
 QLogic Fibre Channel HBA Driver: 8.02.00-k2
  QLogic QLA2340 - 133MHz PCI-X to 2Gb FC, Single Channel
  ISP2312: PCI-X (133 MHz) @ 0000:0a:02.0 hdma-, host#=3, fw=3.03.20 IPX
