From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: scanning for LUNs
Date: Thu,  4 Apr 2013 08:12:37 -0700
Message-ID: <1365088357-22624-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, kys@microsoft.com
List-Id: linux-scsi@vger.kernel.org

Here is the code snippet for scanning LUNS (drivers/scsi/scsi_scan.c in function 
__scsi_scan_target()):

        /*
         * Scan LUN 0, if there is some response, scan further. Ideally, we
         * would not configure LUN 0 until all LUNs are scanned.
         */
        res = scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL);
        if (res == SCSI_SCAN_LUN_PRESENT || res == SCSI_SCAN_TARGET_PRESENT) {
                if (scsi_report_lun_scan(starget, bflags, rescan) != 0)
 

So, if we don't get a response while scanning LUN0, we will not use scsi_report_lun_scan().
On Hyper-V, the scsi emulation on the host does not treat LUN0 as anything special and we 
could have situations where the only device under a scsi controller is at a location other than 0
or 1. In this case the standard LUN scanning code in Linux fails to detect this device. Is this
behaviour expected? Why is LUN0 treated differently here. Looking at the scsi spec, I am not sure
if this is what is specified. Any help/guidance will be greatly appreciated.
 
Regards,

K. Y
