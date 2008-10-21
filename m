From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bugme-new] [Bug 11792] New: Oops when reading
 /proc/megaraid/hba0/diskdrives-ch*
Date: Wed, 22 Oct 2008 08:08:11 +0900
Message-ID: <20081022080835R.fujita.tomonori@lab.ntt.co.jp>
References: <20081021124701.3d639c4e.akpm@linux-foundation.org>
	<20081021195419.GR26184@parisc-linux.org>
	<e8ca35370810211322s42f87392o5259353af8a25323@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:35075 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYJUXJ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 19:09:57 -0400
In-Reply-To: <e8ca35370810211322s42f87392o5259353af8a25323@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pterjan@gmail.com
Cc: matthew@wil.cx, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, sumantp@lsil.com, bo.yang@lsi.com, bugme-daemon@bugzilla.kernel.org

On Tue, 21 Oct 2008 22:22:37 +0200
"Pascal Terjan" <pterjan@gmail.com> wrote:

> On Tue, Oct 21, 2008 at 9:54 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > On Tue, Oct 21, 2008 at 12:47:01PM -0700, Andrew Morton wrote:
> >> > Latest working kernel version: 2.6.24
> >> > Earliest failing kernel version: 2.6.27-rc8
> >>
> >> It's a regression.
> >>
> >> > Pid: 2319, comm: diff Not tainted (2.6.27-server-0.rc8.2mnb #1)
> >
> > It's also a distro kernel by the looks of things.  Can it be reproduced
> > with an upstream kernel?
> 
> I will try booting the server on vanilla kernel but I'm not sure when
> (we already rebooted it 2 times recently and users won't enjoy it).
> 
> This is a distro kernel but I don't see patches that could impact this :
> http://svn.mandriva.com/cgi-bin/viewvc.cgi/packages/cooker/kernel/current/PATCHES/patches/
> 
> Machine is a old HP NetServer LT 6000
> 
> 04:03.1 I2O: Intel Corporation 80960RP (i960RP) Microprocessor (rev
> 09) (prog-if 01)
> 	Subsystem: Hewlett-Packard Company MegaRAID, Integrated NetRAID
> 	Flags: bus master, fast Back2Back, medium devsel, latency 64, IRQ 11
> 	Memory at f4000000 (32-bit, prefetchable) [size=64M]
> 	[virtual] Expansion ROM at a8130000 [disabled] [size=32K]
> 	Capabilities: [80] Power Management version 2
> 	Kernel driver in use: megaraid_legacy
> 	Kernel modules: i2o_core, megaraid

This patch helps?


diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 28c9da7..9294ed8 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4414,12 +4414,14 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 
 	scmd = &adapter->int_scmd;
 	memset(scmd, 0, sizeof(Scsi_Cmnd));
+	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
 
 	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
 	scmd->device = sdev;
 
 	scmd->device->host = adapter->host;
 	scmd->host_scribble = (void *)scb;
+	scmd->cmnd = adapter->int_cdb;
 	scmd->cmnd[0] = MEGA_INTERNAL_CMD;
 
 	scb->state |= SCB_ACTIVE;
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index ee70bd4..5ffec15 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -889,6 +889,7 @@ typedef struct {
 	u8	sglen;	/* f/w supported scatter-gather list length */
 
 	scb_t			int_scb;
+	unsigned char		int_cdb[MAX_COMMAND_SIZE];
 	Scsi_Cmnd		int_scmd;
 	struct mutex		int_mtx;	/* To synchronize the internal
 						commands */

