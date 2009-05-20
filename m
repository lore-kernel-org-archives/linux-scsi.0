From: Jeff Garzik <jeff@garzik.org>
Subject: old-EH and SAS (was Re: [PATCH 2/2] block: add function for waiting
 for a specific free tag)
Date: Wed, 20 May 2009 15:34:53 -0400
Message-ID: <4A145B5D.8020607@garzik.org>
References: <20090520065942.GD11363@kernel.dk> <20090520070104.GF11363@kernel.dk> <4A13EFBC.4010005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A13EFBC.4010005@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


(changing subject...)

> there won't be any race around it (the old-EH path is broken if
> invoked with commands in flight anyway, so doesn't matter).  Also, as

Speaking of the old-EH...  as of 
67651ee5710c45ea62fae68b768d65395ccf47c2 there are no drivers/ata/* 
drivers remaining that use old-EH.

old-EH now exists _entirely_ for a couple SAS drivers, and it is an ugly 
hack, so I wanted to take a moment to think about SAS, SATA, and 
SATA+SAS error handling.

The currently we have a few distinct phy+link configurations that EH 
must deal with, and each requires its own implementation (this ignores 
legacy SFF and other non-phy topologies):

1) SATA PHY.  This is what libata EH handles now: direct control over 
SATA PHY and link.

2) SAS+SATA PHY.  Essentially a super-set of #1, this includes nested 
expander configurations, direct attachment of SAS or SATA, etc.  Uses 
libsas.

3) SAS+SATA firmware.  Not quite as "low level" as #2, does not use libsas.

Each one of these clearly should use the same code for configuring and 
managing ATA devices, including per-device EH.

Move up to the link level, and things start to get ugly.

_Ideally_, libsas should take over all of link exception handling from 
libata, except for the final-link PMP handling.  In reality, I think we 
will have to deal with libsas doing 100% of link EH including PMP 
handling, and libata will continue to perform link EH w/ PMP for !libsas 
hardware.

The integration of discovery is pretty poor -- you wind up with one glob 
of SATA devices and another glob of SCSI devices, with two separate 
EH+scan processes.  Ideally libsas should tell libata to scan a single 
SATA phy, and handle parallelism/exclusion in libsas for SATA+SAS 
configurations.

Brian King did a new-EH conversion for ipr, some time ago.  Maybe that 
work could be picked up, extended to libsas, and permit removal of all 
the old-EH code remaining in libata.

Maybe I should s/eng_timeout/sas_timeout/ to emphasize the current state 
of code ;-)

	Jeff




