From: Joe Perches <joe@perches.com>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O
 testing
Date: Wed, 16 May 2012 10:18:27 -0700
Message-ID: <1337188707.6903.4.camel@joe2Laptop>
References: <1337188023.3796.130.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1337188023.3796.130.camel@schen9-DESK>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-05-16 at 10:07 -0700, Tim Chen wrote:
> I've ported Matthew's scsi RAM driver (originally posted in
> http://marc.info/?l=linux-scsi&m=120331663227540&w=2) to the 3.3 kernel.

just trivia:

> diff --git a/drivers/scsi/scsi_ram.c b/drivers/scsi/scsi_ram.c
[]
> +static void scsi_ram_too_big(struct scsi_cmnd *cmnd, unsigned int start,
> +				unsigned int len)
> +{
> +	printk(KERN_WARNING, "Request exceeded device capacity! %u %u\n", start, len);

Probably ignored a warning here. No comma after KERN_WARNING.

I'd add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt before
any include and use pr_<level> instead.

[]

> +static int scsi_ram_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
> +{
> +	struct scsi_ram_cmnd *ram_cmnd = (void *)&cmnd->SCp;
> +	struct scsi_ram_device *ram_device = scsi_ram_devices[cmnd->device->id];
> +	unsigned long flags;
> +
> +	pr_debug("%s: Queueing command\n", DRV_NAME);

No need for DRV_NAME when using pr_fmt

[]

> +static int scsi_ram_slave_alloc(struct scsi_device *sdev)
> +{
> +	struct scsi_ram_device *ram_device;
> +
> +	pr_debug("%s: slave_alloc %d:%d\n", DRV_NAME, sdev->id, sdev->lun);

here too, etc...


