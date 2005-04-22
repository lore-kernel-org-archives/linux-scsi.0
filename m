From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Removing a disk from the qla2xxx driver.
Date: Fri, 22 Apr 2005 00:10:54 -0700
Message-ID: <20050422071054.GC5069@plap.qlogic.org>
References: <267988DEACEC5A4D86D5FCD780313FBB0732C84F@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:63449 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261997AbVDVHK5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2005 03:10:57 -0400
Content-Disposition: inline
In-Reply-To: <267988DEACEC5A4D86D5FCD780313FBB0732C84F@exch-03.noida.hcltech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 20 Apr 2005, Rajat  Jain, Noida wrote:

> 
> The driver documentstion says it has the "qlascan" command which can help in
> adding new disks by the following procedure:
> 
> 1) First add the Disk to the HBA.
> 2) # echo "scsi-qlascan" > /proc/scsi/<driver-name>/<adapter-id> (The
> qla2xxx driver will rescan)

FYI:  these /proc interfaces are not present in the mainline
(upstream) qla2xxx driver.  Besides, typically these steps are only
needed if the topology isolates a LIP or SCN.  If the additional
device causes an RSCN (in the case of a fabric environment) to
propagate from the switch, the HBA will perform an SNS discovery and
login to the device.

Another alternative to forcing a LIP (and subsequently cause a
rescan), would be to initiate a bus-reset via sg_reset:

	# sg_reset -b /dev/sg0

The only downside is the /dev/sg0 device-node requirement.

> 3) # echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi (The mid-level
> will add the device)
> 

Yes, this will instruct the mid-layer to perform its own scan.

> However, what I wanted to know was that how can I REMOVE a SCSI device from
> the HBA at run time? By logic, I believe that the sequence should be:
> 
> 1) # echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi (The
> mid-level will remove the device)

This is the only step that is needed.

> 2) Then remove the Disk from the HBA.
> 3) # echo "scsi-qlascan" > /proc/scsi/<driver-name>/<adapter-id> (The
> qla2xxx driver will rescan, and will remove the disk)
> 

No, the HBA's recognition of the device persists throughout the
driver's lifetime -- this is not necessary.

Hope this helps.

Regards,
Andrew Vasquez
