From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 00/17] hpsa driver updates
Date: Mon, 16 Nov 2009 15:06:49 -0600
Message-ID: <1258405609.2517.353.camel@mulgrave.site>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbZKPVGv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Nov 2009 16:06:51 -0500
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com

On Wed, 2009-11-11 at 10:50 -0600, Stephen M. Cameron wrote:
> The following series implements hpsa scsi driver for HP Smart Arrays,
> and some updates since the last time.
> The first 5 patches in the series are already in Andrew Morton's tree.
> 
> ---
> 
> Andrew Morton (1):
>       avoid helpful cleanup patches.
> 
> Stephen M. Cameron (16):
>       hpsa: fix typo that causes scsi status to be lost
>       hpsa:  Make fill_cmd() return void
>       hpsa: Remove sendcmd, in no case are we required to poll for completions.
>       hpsa: Flush cache with interrupts still enabled.
>       hpsa: Retry driver initiated commands on unit attention
>       hpsa: decode unit attention condition and retry commands.
>       hpsa: Make hpsa_sdev_attrs static
>       hpsa:  Allow device rescan to be triggered via sysfs.
>       Add thread to allow controllers to register for rescan for new devices
>       hpsa: Factor out some pci_unmap code
>       hpsa: Factor out command submission sequence
>       hpsa: Use shost_priv instead of accessing host->hostdata[0] directly.
>       hpsa: Allocate the correct amount of extra space for the scsi host
>       Fix use of unallocated memory for MSA2xxx enclosure device data.
>       hpsa: Fix vendor id check
>       Add hpsa driver for HP Smart Array controllers.

Actually, it's pretty difficult to review a 17 patch series like this
because the human mind (or at least mine) doesn't retain sufficient
context from patch to patch.  I ended up just pulling all 17 into a tree
and reviewing the finished driver.

That said:

in hpsa.c:

> static struct device_attribute *hpsa_shost_attrs[] = {
>	&dev_attr_rescan,
>	NULL,
> };

We already have a host scan attribute which (admittedly using the
transport class logic) you can plug into ... can't you just use it?  It
supplies user context, so you could dispense with all that scan thread
stuff as well, I think.

> static DEFINE_MUTEX(scan_mutex);
> static LIST_HEAD(scan_q);
> static int scan_thread(void *data);

These names are too generic.  We already have a scan_mutex at least
defined at the top level.  I know they're protected by static, but that
doesn't necessarily help if they show up in a debug stack trace.

All of this report luns stuff looks fairly identical to the report luns
we do in scsi_scan.c ... barring the initial command, which could be
translated.  Wouldn't it be easier to have the generic code parse and do
all of this?

> static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
>	void (*done)(struct scsi_cmnd *))
> {
[...]
>	c = cmd_alloc(h);
>	spin_unlock_irqrestore(&h->lock, flags);
>	if (c == NULL) {			/* trouble... */
>		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
>		cmd->result = DID_NO_CONNECT << 16;
>		done(cmd);
>		return 0;
>	}

I think you want to return SCSI_MLQUEUE_HOST_BUSY here, which will
trigger a throttle and retry after either something frees or I/O
pressure builds more.

> static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
> {
[...]
>	rc = hpsa_send_reset(h, dev->scsi3addr);
>	if (rc == 0 && wait_for_device_to_become_ready(h, dev->scsi3addr) == 0)
>		return SUCCESS;

So the first thing we do after a device reset successful return is send
a test unit ready to the failing device ... there's no real need for you
to duplicate that, is there?

The ioctl stuff looks like you could do it all with SG_IO now rather
than rolling your own versions ... or is there some backward
compatibility problem here?


> static __devinit int hpsa_hard_reset_controller(struct pci_dev *pdev)
> {
[...]
>	set_current_state(TASK_UNINTERRUPTIBLE);
>	schedule_timeout(HZ >> 1);

msleep(500) please ..  This isn't the only place this occurs, could you
replace all of them?

in hpsa_cmd.h:

> /* Unit Attentions ASC's as defined for the MSA2012sa */
> #define POWER_OR_RESET			0x29
> #define STATE_CHANGED			0x2a
> #define UNIT_ATTENTION_CLEARED		0x2f
> #define LUN_FAILED			0x3e
> #define REPORT_LUNS_CHANGED		0x3f
> 
> /* Unit Attentions ASCQ's as defined for the MSA2012sa */
> 
> 	/* These ASCQ's defined for ASC = POWER_OR_RESET */
> #define POWER_ON_RESET			0x00
> #define POWER_ON_REBOOT			0x01
> #define SCSI_BUS_RESET			0x02
> #define MSA_TARGET_RESET		0x03
> #define CONTROLLER_FAILOVER		0x04
> #define TRANSCEIVER_SE			0x05
> #define TRANSCEIVER_LVD			0x06
> 
> 	/* These ASCQ's defined for ASC = STATE_CHANGED */
> #define RESERVATION_PREEMPTED		0x03
> #define ASYM_ACCESS_CHANGED		0x06
> #define LUN_CAPACITY_CHANGED		0x09

Traditionally we've shied away from putting ASC/ASCQ values into
defines ... but these all look to be global not hpsa local, so they
should be in a common central file.

Otherwise looks OK to a cursory glance.

James


