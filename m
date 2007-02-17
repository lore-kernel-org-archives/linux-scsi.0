From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libata: fix probe_ent free in ata_sas_port_alloc()
Date: Sat, 17 Feb 2007 09:16:14 -0600
Message-ID: <1171725374.3379.15.camel@mulgrave.il.steeleye.com>
References: <45D710E8.3090104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45D710E8.3090104@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2007-02-17 at 23:27 +0900, Tejun Heo wrote:
> probe_ent is allocated using devm_kzalloc() and thus should be freed
> using devm_kfree().  ata_sas_port_alloc() freed its probe_ent using
> kfree() thus causing double free later.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> James, does this fix the bug you mentioned on IRC?

Yes and no.  I actually have two devices in this sas setup: a SATA disk
and a SATAPI DVD burner.  Originally, I got the bug I reported here

                           Subject: 
BUG in libata from
ata_sas_port_alloc

On my SATA disk.  However, the DVD was fine.  Now the disk shows up
fine, but I get this from the DVD:

BUG: at drivers/base/devres.c:642 devm_kfree()
 [<c0103c0a>] show_trace_log_lvl+0x1a/0x30
 [<c0104282>] show_trace+0x12/0x20
 [<c0104336>] dump_stack+0x16/0x20
 [<c023f09a>] devm_kfree+0x4a/0x50
 [<f892eea2>] ata_sas_port_alloc+0x62/0x80 [libata]
 [<f897869e>] sas_ata_init_host_and_port+0x5e/0xa0 [libsas]
 [<f897832d>] sas_target_alloc+0x4d/0x60 [libsas]
[...]

This time, it's the opposite problem: the SATAPI DVD was kmalloc
allocated.  The fault all seems to be in this code:

struct ata_probe_ent *
ata_probe_ent_alloc(struct device *dev, const struct ata_port_info *port)
{
	struct ata_probe_ent *probe_ent;

	/* XXX - the following if can go away once all LLDs are managed */
	if (!list_empty(&dev->devres_head))
		probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
	else
		probe_ent = kzalloc(sizeof(*probe_ent), GFP_KERNEL);

So we can't tell how the memory was obtained.

To fix it, it looks like we might have to mark it in some way and then
call a freeing function (ata_probe_ent_free?) to release it via the
correct method.

James



