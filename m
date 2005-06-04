From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Fri, 03 Jun 2005 18:19:32 -0700
Message-ID: <1117847972.23638.62.camel@mina>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

The following patches should enable the use of scatter lists for all
REQ_BLOCK_PC requests and cleanup some code duplication or dangerous
memory allocations in the dm-multipath hw handlers and
block/scsi_ioctl.c.

REQ_BLOCK_PC scatter list usage only required converting the old
sg_scsi_ioctl code to do bio backed requests since the current block
layer SG_IO code will always use requests with bios. But while
converting the old ioctl and removing some dangerous (GFP_KERNEL in
failover path) memory allocations from a dm-multipath hw_handler (and
while updating the LSI one) I was able to seperate some common code into
two new functions: blk_rq_map_kern() and bio_map_kern. These functions
are similar to their blk/bio*user cousins where they allocate requests
and bios and setup the data pointers except they work on kernel buffers.

The goal is next convert the scsi 'special' requests to use these
functions, so scsi will be able to use block layer functions for scatter
lists setup for all requests. And then hopefully one day we will not
need those stinking "if (sc->use_sg)" paths all over our scsi drivers.
