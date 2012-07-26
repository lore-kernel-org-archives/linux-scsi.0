From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH v3 0/7] ZPODD patches for scsi tree
Date: Thu, 26 Jul 2012 22:41:14 +0800
Message-ID: <20120726144108.GA2724@localhost.localdomain>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
 <50114989.3010900@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50114989.3010900@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2012 at 09:43:37AM -0400, Jeff Garzik wrote:
> On 07/26/2012 06:05 AM, Aaron Lu wrote:
> >v3:
> >Rebase on top of scsi-misc tree;
> >Add the sr related patches previously in Jeff's libata tree;
> >Re-organize the sr patches.
> >A problem for now: for patch
> >scsi: sr: support zero power ODD(ZPODD)
> >I can't set a flag in libata-acpi.c since a related function is
> >missing in scsi-misc tree. Will fix this when 3.6-rc1 released.
> 
> What does this mean?  Would you be more specific?

The patch "libata-acpi: add ata port runtime D3Cold support" by Lin Ming
introduced a function ata_acpi_wake_dev in libata-acpi.c, and only lives
in libata-next tree but not scsi-misc tree.

In patch "scsi: sr: support zero power ODD(ZPODD)" I need to set the
wakeup_by_user flag of the scsi device in ata_acpi_wake_dev like this:

--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -985,8 +985,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
 	struct ata_device *ata_dev = context;
 
 	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
-			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
+			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev)) {
+		ata_dev->sdev->wakeup_by_user = 1;
 		scsi_autopm_get_device(ata_dev->sdev);
+	}
 }
 
But since there is no such function in scsi-misc tree, I can't set the
flag. Any suggestions?

Another minor issue is, I need to use the can_power_off and
wakeup_by_user flag of the scsi_device structure in sr patches, but
they are all introduced in patches in libata-next tree, so I have to
re-define them in this patch set. Will cause conflict if James send
these sr patches to Linus. Any way to avoid this?

Thanks,
Aaron
