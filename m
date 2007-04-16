From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Major qla2xxx regression on sparc64
Date: Mon, 16 Apr 2007 09:37:12 -0700
Message-ID: <20070416163712.GA10822@andrew-vasquezs-computer.local>
References: <20070416.010218.130850966.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:35904 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030874AbXDPQhQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2007 12:37:16 -0400
Content-Disposition: inline
In-Reply-To: <20070416.010218.130850966.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, 16 Apr 2007, David Miller wrote:

> Sparc64 systems which have an on-board qla2xxx chip (such as
> SunBlade-1000 and SunBlade-2000, there are probably some other systems
> like this too) do not have any NVRAM information present, in fact the
> NVRAM is basically all 0's from what I can tell.
> 
> This always worked just fine since the code would previously just use
> a bunch of defaults when an inconsistent NVRAM was detected.
> 
> But the changeset below at the end of this email broke this and now
> I'm seeing bug reports from sparc64 users and I was just able to
> reproduce the problem myself just today as well.  I verified that
> reverting the patch below gets things working again.
> 
> Emanuele, you can feed the patch below to "patch -p1 -R" to get that
> working again so we can move on to the other sparc64 bug we're looking
> into :-)

I sent Emanuele the attached patch during the weekend...

> The failure mode isn't nice, it actually ends up crashing with an OOPS
> in qla2xxx_init_host_attr() because ha->node_name is NULL, it's
> supposed to be initialized by functions like qla2x00_nvram_config()

No, it's not very nice...

> Can we revert the patch below or do something similar to get things
> working again on sparc64?
> 
> The most important thing which qla2x00_nvram_config() seems to want to
> get is the WWN port_name and node_name.  These are provided in the OFW
> device tree so we could pluck them out of there with something like:
> 
> #ifdef CONFIG_SPARC
> #include <asm/prom.h>
> #include <asm/pbm.h>
> #endif
> 
> ...
> 
> #ifdef CONFIG_SPARC
> 	struct pcidev_cookie *pcp = pdev->sysdata;
> 	u8 *port_name, *node_name;
> 
> 	port_name = of_get_property(pcp->prom_node, "port-wwn", NULL);
> 	node_name = of_get_property(pcp->prom_node, "node-wwn", NULL);
> #endif
> Those will hold a pointer to the property values or NULL if the
> property does not exist.  This is private data, so you should make
> copies of them into your local data structure and not use references
> to them.
> 
> I don't see any OFW properties present that could be used to fill in
> the rest of the NVRAM parameters, so we'd need to use the defaults
> that the code before the change was using.

I'd be more inclined to do soemthing like the above, rather than:

> But even if that fails, I think the fallback code should be put back,
> since it obviously was used by at least one system and it's probable
> that there are some other applications of using this qla2xxx chip that
> will have an empty NVRAM too.

Then they should really get their NVRAM corrected, if in fact their
NVRAMs are cleared.

> I can understand the apprehension in using a fixed port_name[] value,
> since it could conflict with other FC controllers on the mesh, but if
> that is so important just choose some random value that is a valid FC
> ID or use some characteristic ID that can be used to compose part of
> the port WWN in order to give it at least some uniqueness.

Look, there's a fine balance here that we must strike -- the solution
that you're proposing implies that there's some 'random' bit-space
within the IEEE NAA with which one can safely encode without stomping
on any valid OUI.

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-qla2xxx-Error-out-during-probe-if-we-re-unable-to.patch"

>From 9ee6de3bbaa03390b83226e7bb84c49566a583b3 Mon Sep 17 00:00:00 2001
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Wed, 11 Apr 2007 16:02:06 -0700
Subject: [PATCH] qla2xxx: Error-out during probe() if we're unable to complete HBA initialization.

Remove a stale check against ha->device_flags
(DFLG_NO_CABLE) as topology scanning is performed within the
DPC-thread context.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b78919a..0a36912 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1577,9 +1577,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 	}
 
-	if (qla2x00_initialize_adapter(ha) &&
-	    !(ha->device_flags & DFLG_NO_CABLE)) {
-
+	if (qla2x00_initialize_adapter(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to initialize adapter\n");
 
-- 
1.5.1.1.107.g7a159


--J2SCkAp4GZ/dPZZf--
