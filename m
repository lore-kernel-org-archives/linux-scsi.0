From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH 6/6] scsi: qedf: use correct strncpy() size
Date: Wed, 7 Feb 2018 11:26:43 -0500 (EST)
Message-ID: <alpine.OSX.2.00.1802071126080.1466@administrators-MacBook-Pro.local>
References: <20180202131225.1658853-1-arnd@arndb.de> <20180202131225.1658853-7-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180202131225.1658853-7-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@cavium.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Saurav Kashyap <saurav.kashyap@cavium.com>, Arun Easi <arun.easi@cavium.com>, Nilesh Javali <nilesh.javali@cavium.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Fri, 2 Feb 2018, 8:12am, Arnd Bergmann wrote:

> gcc-8 warns during link-time optimization that the strncpy() call
> passes the size of the source buffer rather than the destination:
> 
> drivers/scsi/qedf/qedf_dbg.c: In function 'qedf_uevent_emit':
> include/linux/string.h:253: error: 'strncpy' specified bound depends on the length of the source argument [-Werror=stringop-overflow=]
> 
> This changes it to strscpy() with the correct length, guaranteeing
> a properly nul-terminated string of the right size.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/qedf/qedf_dbg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reasonable security precaution.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
