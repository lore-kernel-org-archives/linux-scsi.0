From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Wed, 20 Aug 2003 01:22:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030820012204.449c2b34.christophe.varoqui@free.fr>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk>
	<20030819094838.F8428@sistina.com>
	<1061283871.3f41e81f8226b@impt3-2.free.fr>
	<20030819115110.I8420@sistina.com>
	<1061290087.3f4200678f811@impt2-2.free.fr>
	<20030819143552.K8420@sistina.com>
	<1061299572.3f4225742287c@impt1-2.free.fr>
	<20030819182347.O8420@sistina.com>
Reply-To: christophe.varoqui@free.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.wanadoo.fr ([193.252.22.28]:19233 "EHLO
	mwinf0303.wanadoo.fr") by vger.kernel.org with ESMTP
	id S261679AbTHSXWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 19:22:10 -0400
In-Reply-To: <20030819182347.O8420@sistina.com>
List-Id: linux-scsi@vger.kernel.org
To: mauelshagen@sistina.com
Cc: linux-scsi@vger.kernel.org

On Tue, 19 Aug 2003 18:23:47 +0200
Heinz.Mauelshagen@t-online.de (Heinz J . Mauelshagen) wrote:

> > You realize that it make those tools unsuitable for general use : 
> > * one may not want to use the full lvm compound binary to set up multipaths
> > * one may not want to tag its devices to set up multipaths, where its not necessary
> 
> The "Yes" was about the LVM2 tools and we do recommend them to be installed
> to support the variaty of volume management features.
> 
> If you have a corner use case where you don't need any of them but multipath,
> dmsetup can be used to cover what you want out of the box (creating ASCII
> mapping tables which is simple for multipath).
> No need to install LVM2 at all for that.
> 
This is not a corner case use : most users who face multipath problem cope with FC raid controlers that embed the volume management. Those users are in need of a clean and stand alone multipath layer, not a swiss-knife volume manager.

I understand that the implementation you propose offers a clean and coherent interface for volume management and multipath, but it will work as expected only for "all paths to LUN are active" configurations : ie high-end EMC clients (who don't need host volume management) and "FC JBOD connected through 2 HBA"-users. All other users must cope with ghosts.

You suggest admins can filter those out with LVM2 config file : OK, easy to do at initialisation time, but how can admins cope with ghosts becoming active and valid paths becoming ghosts ?
In the first case admins must insert the newly activated path in the multipath map _when the event occurs_.
In the second case, admins must blacklist a former valid path in the LVM2 config file _when the event occurs_.

It can only be done by scripts/plugins triggered by path failures as
* a ghost becomes active if 
  1) the host explicitly ask for it, housekeeping is in charge of the initiator of the activation demand
  2) the raid controler has fail an active path over the ghost which implies the hosts get a path failure in a mp target anyway
* an active path becomes ghost implies a path failure

As a whole MP device is vendor coherent, but different MP devices can be hold by different vendors, I wonder if it would be right to set the vendor-specific script/plugin path as a parameter of the target map.

Comments ?

> > 
> > Shouldn't LVM2 just rely on an separate multipath management (dm-based). There
> > surely will be one such implementation. We users don't need fragmentation in
> > such a low-level area.
> 
> dm is the multipath runtime (through a dm multipath target).
> 
No discussion here.

> As said: you can set up multipath configs without LVM2 in case you
> don't need full volume management functionality using the dmsetup tool.
> This is not the recommended way but you still can do it ;)
> 
You just cannot recommend what you described to a HPQ StorageWorks customer, like me :)
If the reasons why are still unclear, please point the blurry details as I'll be glad to elaborate.

regards,
 cvaroqui
