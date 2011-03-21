From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 16:13:07 -0700
Message-ID: <1300749187.21880.109.camel@haakon2.linux-iscsi.org>
References: <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
	 <4D87CF99.7040008@linux.vnet.ibm.com>
	 <1300746873.21880.81.camel@haakon2.linux-iscsi.org>
	 <20110322080628V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55975 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab1CUXUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 19:20:19 -0400
In-Reply-To: <20110322080628V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Tue, 2011-03-22 at 08:06 +0900, FUJITA Tomonori wrote:
> On Mon, 21 Mar 2011 15:34:33 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Mon, 2011-03-21 at 17:22 -0500, Brian King wrote:
> > > Tomo,
> > > 
> > > Thanks for all the work you've done with this driver. It is much appreciated.
> > > 
> > > What sort of performance are you seeing with this? With filebacked devices, I
> > > was seeing around 1 MB/sec doing a basic disktest run. I haven't compared this
> > > to ibmvstgt, but I'm pretty sure we did a fair bit better there. Perhaps I've got
> > > some setup issue?
> > > 
> > > I tried a ramdisk device and saw this on the server:
> > > 
> > > 
> > > DMA_TO_DEVICE not supported for RAMDISK_DR with task_sg_chaining=1
> > > 
> > > 
> > 
> > So for the RAMDISK_DR (direct) SGL memory mapping case we do not support
> > WRITEs for HW fabric modules using task_sg_changing=1.
> > 
> > Please go ahead and use RAMDISK_MCP instead, and I will look at adding a
> > special case in target_core_fabric_configfs.c code to disallow
> > RAMDISK_DR symlink creation of configfs ports for target fabric modules
> > using task_sg_chaining=1.
> 
> I really want to remove 'task_sg_chaining=0', all the drivers support
> sg chaining. It's a hacky. What drivers doesn't support it?

It's only drivers for which we are not using HW provided scatterlists
into TCM backend memory, which today is just iscsi_target_mod
iscsi_target_rx_thread() -> sock_recvmsg() code.

So that said, dropping TFO->task_sg_chaning is fine with me.  It will
still be useful for TCM to determine this for a fabric module using a
new flag (for the current stable iscsi_target_mod code case) so that non
iscsi_target_mod of RAMDISK_DR Port/LUN export can be -ENOSYS within
target_core_fabric_configfs.c:target_fabric_port_link().

--nab

