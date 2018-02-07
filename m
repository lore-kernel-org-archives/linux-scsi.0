From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH 4/6] scsi: qedf: fix LTO-enabled build
Date: Wed, 7 Feb 2018 10:38:20 -0500 (EST)
Message-ID: <alpine.OSX.2.00.1802071036410.1266@administrators-MacBook-Pro.local>
References: <20180202131225.1658853-1-arnd@arndb.de> <20180202131225.1658853-5-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180202131225.1658853-5-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@cavium.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Nilesh Javali <nilesh.javali@cavium.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Fri, 2 Feb 2018, 8:12am, Arnd Bergmann wrote:

> The prototype for qedf_dbg_fops/qedf_debugfs_ops doesn't match the definition,
> which causes the final link to fail with link-time optimizations:
> 
> drivers/scsi/qedf/qedf_main.c:34: error: type of 'qedf_dbg_fops' does not match original declaration [-Werror=lto-type-mismatch]
>  extern struct file_operations qedf_dbg_fops;
> 
> drivers/scsi/qedf/qedf_debugfs.c:443: note: 'qedf_dbg_fops' was previously declared here
>  const struct file_operations qedf_dbg_fops[] = {
> 
> drivers/scsi/qedf/qedf_main.c:33: error: type of 'qedf_debugfs_ops' does not match original declaration [-Werror=lto-type-mismatch]
>  extern struct qedf_debugfs_ops qedf_debugfs_ops;
> 
> drivers/scsi/qedf/qedf_debugfs.c:102: note: 'qedf_debugfs_ops' was previously declared here
>  struct qedf_debugfs_ops qedf_debugfs_ops[] = {
> 
> This corrects the prototype and moves it into a shared header file where it
> belongs. The file operations can also be marked 'const' like the
> qedf_debugfs_ops.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/qedf/qedf_dbg.h     | 17 ++++++++++-------
>  drivers/scsi/qedf/qedf_debugfs.c |  6 +++---
>  drivers/scsi/qedf/qedf_main.c    |  8 +++-----
>  3 files changed, 16 insertions(+), 15 deletions(-)
> 

Thanks.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
