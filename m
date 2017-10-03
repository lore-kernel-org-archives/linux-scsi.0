From: Christoph Hellwig <hch@lst.de>
Subject: [RFC] bsg-lib interface cleanup
Date: Tue,  3 Oct 2017 12:48:36 +0200
Message-ID: <20171003104845.10417-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

this series cleans up various abuses of the bsg interfaces, and then
splits bsg for SCSI passthrough from bsg for arbitrary transport
passthrough.  This removes the scsi_request abuse in bsg-lib that is
very confusing, and also makes sure we can sanity check the requests
we get.  The current code will happily execute scsi commands against
bsg-lib queues, and transport pass through against scsi nodes, without
any indication to the driver that we are doing the wrong thing.

The series includes the fix from Bejamin as the first patch as I
rebased on top of it, but that one really needs to got into 4.14 ASAP.
