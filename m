From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.32-rc8
Date: Tue, 01 Dec 2009 12:13:47 -0500
Message-ID: <1259687627.11762.307.camel@mulgrave.site>
References: <1259620194.11762.137.camel@mulgrave.site>
	 <1259686458.6482.14.camel@zeppelin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1259686458.6482.14.camel@zeppelin>
Sender: linux-pci-owner@vger.kernel.org
To: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-12-01 at 14:54 -0200, Kleber Sacilotto de Souza wrote:
> Can you please add the patch from "[PATCH] ipr: fix EEH recovery" sent
> to this list?

Adding linux-pci because this hack actually tampers with internal PCI
device state, which looks wrong.

The thread is here:

http://marc.info/?l=linux-scsi&m=125918723218627

and the proposed full patch and explanation below.

PCI people, is this correct, or is there a better way to do it?

James

---

Hi,

After commits c82f63e411f1b58427c103bd95af2863b1c96dd1 (PCI: check saved
state before restore) and 4b77b0a2ba27d64f58f16d8d4d48d8319dda36ff (PCI:
Clear saved_state after the state has been restored) PCI drivers are
prevented from restoring the device standard configuration registers
twice in a row. These changes introduced a regression on ipr EEH
recovery.

The ipr device driver saves the PCI state only during the device probe
and restores it on ipr_reset_restore_cfg_space() during IOA resets. This
behavior is causing the EEH recovery to fail after the second error
detected, since the registers are not being restored.

One possible solution would be saving the registers after restoring
them. The problem with this approach is that while recovering from an
EEH error if pci_save_state() results in an EEH error, the adapter/slot
will be reset, and end up back in ipr_reset_restore_cfg_space(), but it
won't have a valid saved state to restore, so pci_restore_state() will
fail.

The following patch introduces a workaround for this problem, hacking
around the PCI API by setting pdev->state_saved = true before we do the
restore. It fixes the EEH regression and prevents that we hit another
EEH error during EEH recovery.


Thanks,
Kleber



Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 76d294f..c3ff9a6 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6516,6 +6516,7 @@ static int ipr_reset_restore_cfg_space(struct
ipr_cmnd *ipr_cmd)
        int rc;
 
        ENTER;
+       ioa_cfg->pdev->state_saved = true;
        rc = pci_restore_state(ioa_cfg->pdev);
 
        if (rc != PCIBIOS_SUCCESSFUL) {
-- 


-- 
Kleber S. Souza
IBM Linux Technology Center
