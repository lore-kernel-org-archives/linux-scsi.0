From: Brian King <brking@us.ibm.com>
Subject: [PATCH 0/10] libata: Add support for SATA attachment to SAS adapters
Date: Wed, 29 Mar 2006 08:37:41 -0600
Message-ID: <442A9BB5.9040407@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:63374 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751116AbWC2Ohp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 09:37:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Jeff,

Here is a refresh of my patchset to add support to libata to
allow for SAS HBAs to use libata to attach SATA devices.
The patchset is against your #upstream branch. Once again,
no real feature changes here, just a refresh (some of the
patches no longer would apply). Additionally, I have removed
the CDB length checking code that was discussed yesterday
on the list. I've been running with these patches for a
while now without problems.

Please apply.

Thanks,

Brian


The following patchset enhances libata to allow SAS device drivers
to utilize libata to talk to SATA devices. It introduces some
new APIs which allow libata to be used without allocating a
virtual scsi host.

New APIs:

ata_sas_port_alloc - Allocate an ata_port 
ata_sas_port_init - Initialize an ata_port (probe device, etc)
ata_sas_port_destroy - Free an ata_port allocated by ata_sas_port_alloc
ata_sas_slave_configure - configure scsi device
ata_sas_queuecmd - queue a scsi command, similar to ata_scsi_queuecomand

These new APIs can be used either directly by a SAS LLDD or could be used
by the SAS transport class. 

Possible usage for a SAS LLDD would be:

scsi_scan_host
	target_alloc
		ata_sas_port_alloc
	slave_alloc
		ata_sas_port_init
	slave_configure
		ata_sas_slave_configure

Commands received by the LLDD for SATA devices would call ata_sas_queuecmd.

Device teardown would occur with:

slave_destroy
	port_disable
target_destroy
	ata_sas_port_destroy


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
