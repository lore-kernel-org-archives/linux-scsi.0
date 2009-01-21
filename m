From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: need help to merge (small) virtual scsi driver upstream.
Date: Wed, 21 Jan 2009 15:12:09 +0900
Message-ID: <20090121151113X.fujita.tomonori@lab.ntt.co.jp>
References: <4974CED2.9000900@hw0.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50814 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZAUGMV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2009 01:12:21 -0500
In-Reply-To: <4974CED2.9000900@hw0.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: henrik@hw0.org
Cc: linux-scsi@vger.kernel.org

On Mon, 19 Jan 2009 20:04:50 +0100
Henrik Stokseth <henrik@hw0.org> wrote:

> Hi! I'm one of the developers on the CDEmu project.
> 
> We want to get a driver merged into vanilla linux kernel. CDEmu is a
> software suite that allows people to take a CD/DVD-image and mount it on
> the system in the form of a virtual disc. Major parts of this software
> is based on user-space components, but we have a kernel module that's
> responsible for acting like a SCSI HBA. Mainly all
> this HBA does is to send requests to a userspace daemon for processing
> and then fetch the result and send it back to the SCSI subsystem.
> 
> The project's homepage is here: http://cdemu.sourceforge.net
> 
> I went over the code to make sure it follows the coding style that's
> used. Is there anything else I need to do? I'm a programmer but
> kernel code is something that I seldom touch.

>From a quick look at the patch, your driver links requests to a list
and then the user-space daemon reads the requests via the special
character device file and sends the response back to kernel space.

If I correctly understand what you want, there are some possible
alternatives, I guess.

Note that I'm not sure 2) and 3) is acceptable to the SCSI maintainer.


1) use iSCSI initiator and target on the same machine

First, set up iSCSI target software supporting CD/DVD. For example,
you can use tgt (http://stgt.berlios.de), user-space program.

Then you set up the iSCSI initiator to connect the target. Basically,
the iSCSI initiator works like a virtual hba as you like. The iSCSI
initiator and target communicate via tcp while your software
communicates via the special character device.

If you go with this setup, all you need are already in mainline.


2) extend SCSI_TGT

CONFIG_SCSI_TGT and CONFIG_SCSI_IBMVSCSIS do the similar thing as you
do, creating a virtual hba, sending requests to userspace, and getting
the responses. CONFIG_SCSI_IBMVSCSIS is designed for IBM POWER
architectures. But you can implement a new driver working with
CONFIG_SCSI_TGT. CONFIG_SCSI_TGT also uses tgt so CD/DVD support is
ready.


3) extend scsi_debug.c

drivers/scsi/scsi_debug.c provides a virtual hba and virtual disk. You
could extend it to support CD/DVD.
