From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] [SCSI] mvumi: GFP_KERNEL under spin lock
Date: Tue, 14 Aug 2012 17:59:27 +0300
Message-ID: <20120814145926.GA29090@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jyli@marvell.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello Jianyun Li,

The patch f0c568a478f0: "[SCSI] mvumi: Add Marvell UMI driver" from 
May 11, 2011, leads to the following warning:
drivers/scsi/mvumi.c:121 mvumi_alloc_mem_resource()
	 error: scheduling with locks held: 'spin_lock:host_lock'

The problem is that we do a couple GPF_KERNEL allocations in
mvumi_alloc_mem_resource() and this static analysis program sees a path
where that function is called with spin_locks held.

mvumi_isr_handler() <- takes a spin lock
-> mvumi_handshake()
   -> mvumi_init_data()
      -> mvumi_alloc_mem_resource() <- GFP_KERNEL

The IRQ handler does print a warning before calling mvumi_handshake()
so it seems like this path doesn't get exercised very much.

regards,
dan carpenter
