From: Meelis Roos <mroos@linux.ee>
Subject: Re: Another UBSAN warning from aic7xxx
Date: Mon, 18 Sep 2017 22:17:14 +0300 (EEST)
Message-ID: <alpine.LRH.2.21.1709181553400.628@math.ut.ee>
References: <alpine.LRH.2.20.1605171856430.9286@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.20.1605171856430.9286@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> Despite the first one being a false positive, her I am reporting another 
> one, from a older dual P2 server with Adaptec aic7896/97 Ultra2 SCSI 
> adapter and QUANTUM  VIKING II 4.5WSE HDD-s.

The same happens in other machines, like IBM xSeries 305, and is still 
present in 2017, in 4.14-rc1.

I debugged it a little. The warning comes from ahc_init():

        /*
         * Only allow target mode features if this unit has them enabled.
         */
        if ((AHC_TMODE_ENABLE & (0x1 << ahc->unit)) == 0)
                ahc->features &= ~AHC_TARGETMODE;

Here, ahc->unit seems to be -1.

ahc->unit is initialized to -1 in ahc_alloc() and can be later set by 
ahc_set_unit().

Stacktrace shows we come from ahc_linux_pci_dev_probe(). This function 
does ahc_alloc() and sets up PCI-specific configuration of the ahc 
structure. Then it calls ahc_pci_config() that in turn calls ahc_init() 
with ahc->unit still set to -1. 

ahc->unit initialized later:

ahc_linux_pci_dev_probe() finishes with call to 
ahc_linux_register_host().

ahc_linux_register_host() does among other things

ahc_set_unit(ahc, ahc_linux_unit++);

where ahc_linux_unit is defined as

static int ahc_linux_unit;

so it seems uninitialized in addition to being assigned too late.

With that in mind,  if ((AHC_TMODE_ENABLE & (0x1 << ahc->unit)) == 0) is 
clearly doing its check too early, or the number allocation is done too 
late. AHC_TMODE_ENABLE is defined 0 in a header, but is seems to be a 
compile-time bitmask of what AHC cards are to be used in target mode (as 
in BSD).

Perhaps we should do the ahc->unit number allocation in 
ahc_linux_pci_dev_probe().

I also can not understand the logic in ahc_lock() and ahc_unlock() 
around ahc_set_unit() - they use &s for lock, and s is defined locally 
in the ahc_linux_register_host() function as u_long s (uninitialized). 
Happens to work by luck?

Below is a patch that seems to cure it for me - moving the unit 
initialization earlier, and into another file, and removing the lock 
around it. Will this work or should we fix it differently?

Fixing this reveals another UBSAN warning from the same driver, will fix 
that too.

> [    1.730498] ================================================================================
> [    1.730693] UBSAN: Undefined behaviour in drivers/scsi/aic7xxx/aic7xxx_core.c:5325:31
> [    1.730872] shift exponent -1 is negative
> [    1.730993] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.6.0 #14
> [    1.731110] Hardware name: To be Filled To be Filled/Intel 440BX/GX, BIOS 063101 07/15/99
> [    1.731287]  00000000 c135ccec 00000046 f6461c50 00000001 c13974db f6461c44 ffffffff
> [    1.731757]  c1397a66 c1775bd0 f6461c54 c10f28c1 f7269638 00000202 0000312d f72695f8
> [    1.732026]  00000004 f7269618 00000058 f7269638 00000056 00ff473c 80000500 00000000
> [    1.732026] Call Trace:
> [    1.732026]  [<c135ccec>] ? dump_stack+0x45/0x69
> [    1.732026]  [<c13974db>] ? ubsan_epilogue+0xb/0x40
> [    1.732026]  [<c1397a66>] ? __ubsan_handle_shift_out_of_bounds+0xd6/0x120
> [    1.732026]  [<c10f28c1>] ? hrtimer_interrupt+0x101/0x390
> [    1.732026]  [<c1540031>] ? scrdown+0x30/0x1bb
> [    1.732026]  [<c15422b0>] ? pci_conf1_read+0x90/0x150
> [    1.732026]  [<c148ef5b>] ? ahc_init+0xb2b/0xd90
> [    1.732026]  [<c1545c27>] ? pci_read+0x37/0x70
> [    1.732026]  [<c1398948>] ? pci_bus_read_config_byte+0x68/0xb0
> [    1.732026]  [<c14a0c30>] ? ahc_pci_read_config+0x40/0xd0
> [    1.732026]  [<c14998e4>] ? ahc_pci_config+0x4a4/0x10f0
> [    1.732026]  [<c1540000>] ? rgb_foreground+0xdc/0xdd
> [    1.732026]  [<c14a09bd>] ? ahc_linux_pci_dev_probe+0xed/0x320
> [    1.732026]  [<c124c617>] ? kernfs_add_one+0x147/0x1b0
> [    1.732026]  [<c124c2b6>] ? kernfs_new_node+0x36/0x80
> [    1.732026]  [<c145448c>] ? __pm_runtime_resume+0x3c/0x60
> [    1.732026]  [<c13a93d1>] ? pci_device_probe+0x91/0x130
> [    1.732026]  [<c1446068>] ? driver_probe_device+0xc8/0x330
> [    1.732026]  [<c14462d0>] ? driver_probe_device+0x330/0x330
> [    1.732026]  [<c14462d0>] ? driver_probe_device+0x330/0x330
> [    1.732026]  [<c1446369>] ? __driver_attach+0x99/0xd0
> [    1.732026]  [<c1443c5c>] ? bus_for_each_dev+0x4c/0x90
> [    1.732026]  [<c144582a>] ? driver_attach+0x1a/0x40
> [    1.732026]  [<c14462d0>] ? driver_probe_device+0x330/0x330
> [    1.732026]  [<c1445227>] ? bus_add_driver+0x127/0x290
> [    1.732026]  [<c1b1d245>] ? spi_transport_init+0x1aa/0x1aa
> [    1.732026]  [<c1446d87>] ? driver_register+0x67/0x120
> [    1.732026]  [<c1b1d2c7>] ? ahc_linux_init+0x82/0x8f
> [    1.732026]  [<c100041a>] ? do_one_initcall+0x8a/0x260
> [    1.732026]  [<c1b1d245>] ? spi_transport_init+0x1aa/0x1aa
> [    1.732026]  [<c109543f>] ? parameq+0xf/0xb0
> [    1.732026]  [<c10956e5>] ? parse_args+0x205/0x510
> [    1.732026]  [<c1aebe6f>] ? kernel_init_freeable+0x153/0x25c
> [    1.732026]  [<c1aebeec>] ? kernel_init_freeable+0x1d0/0x25c
> [    1.732026]  [<c16af8b9>] ? kernel_init+0x9/0x120
> [    1.732026]  [<c10a225b>] ? schedule_tail+0xb/0xa0
> [    1.732026]  [<c16b8889>] ? ret_from_kernel_thread+0x21/0x38
> [    1.732026]  [<c16af8b0>] ? rest_init+0x60/0x60
> [    1.732026] ================================================================================

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index acd687f4554e..436b8e0462dd 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -376,8 +376,6 @@ static int ahc_linux_run_command(struct ahc_softc*,
 static void ahc_linux_setup_tag_info_global(char *p);
 static int  aic7xxx_setup(char *s);
 
-static int ahc_linux_unit;
-
 
 /************************** OS Utility Wrappers *******************************/
 void
@@ -1090,7 +1088,6 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
 	char	buf[80];
 	struct	Scsi_Host *host;
 	char	*new_name;
-	u_long	s;
 	int	retval;
 
 	template->name = ahc->description;
@@ -1109,9 +1106,6 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
 	host->max_lun = AHC_NUM_LUNS;
 	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
 	host->sg_tablesize = AHC_NSEG;
-	ahc_lock(ahc, &s);
-	ahc_set_unit(ahc, ahc_linux_unit++);
-	ahc_unlock(ahc, &s);
 	sprintf(buf, "scsi%d", host->host_no);
 	new_name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
 	if (new_name != NULL) {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index 0fc14dac7070..0c1231f7610f 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -42,6 +42,8 @@
 #include "aic7xxx_osm.h"
 #include "aic7xxx_pci.h"
 
+static int ahc_linux_unit = 0;
+
 /* Define the macro locally since it's different for different class of chips.
 */
 #define ID(x)	ID_C(x, PCI_CLASS_STORAGE_SCSI)
@@ -249,10 +251,12 @@ ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
                 	return (-ENODEV);
 		}
 	}
+	ahc_set_unit(ahc, ahc_linux_unit++);
 	ahc->dev_softc = pci;
 	error = ahc_pci_config(ahc, entry);
 	if (error != 0) {
 		ahc_free(ahc);
+		ahc_linux_unit--;
 		return (-error);
 	}
 


-- 
Meelis Roos (mroos@linux.ee)
