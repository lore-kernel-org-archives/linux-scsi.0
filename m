From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v9] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 20 Jul 2016 13:15:31 -0700
Message-ID: <1469045731.13881.4.camel@haakon3.risingtidesystems.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
	 <1467151535-1443-1-git-send-email-mikecyr@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42490 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbcGTUVr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2016 16:21:47 -0400
In-Reply-To: <1467151535-1443-1-git-send-email-mikecyr@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: joe@perches.com, hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com

Hi Michael, Bryant & Co,

Apologies for the extended follow-up over the summer holiday.

Comments below.

On Tue, 2016-06-28 at 17:05 -0500, Michael Cyr wrote:
> From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
> 
> This driver is a pick up of the old IBM VIO scsi Target Driver
> that was started by Nick and Fujita 2-4 years ago.
> http://comments.gmane.org/gmane.linux.scsi/90119
> 
> The driver provides a virtual SCSI device on IBM Power Servers.
> 
> This patch contains the fifth version for an initial merge of the
> tcm ibmvscsis driver. More information on this driver and config
> can be found:
> 
> https://github.com/powervm/ibmvscsis/wiki/Configuration
> http://www.linux-iscsi.org/wiki/IBM_vSCSI
> 
> Signed-off-by: Steven Royer <seroyer@linux.vnet.ibm.com>
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> Signed-off-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
> Version 9:
> - Fixed issues raised by Christoph Hellwig.
> 
> Version 8:
> - Badly formed patch, ignore.
> 
> Version 7:
> - Removed old module from drivers/scsi/ibmvscsi/Makefile
> - Fixed styling from Joe Perches comments.
> 
> Version 6:
> - Removed modification of report luns
> - fixed Maintainers file
> - removed #include <target/target_core_backend.h>
> 
> Version 5:
> - changed to use scsilun_to_int
> - removed inquiry modification
> - changed to use target_alloc_session
> - removed shutdown_session, etc
> 
> Version 4:
> - Changed some print statements to dev_err.
> -Also changed to use target_alloc_session instead of manually coding it.
> - Removed scsi_cmnd and scsi_host bits removed from libsrp to completely
> - Stripped out un-needed includes.
> - Added pre-allocation of commands before IO starts.
> - Added Support for Transport event, fast-fail support, MESSAGE_IN_CRQ format
> - Changed the way queues are handled for better performance, and state mgmt.
> 
> Version 3:
> - Revert old libsrp and make it clear resurrection old vscsi target driver
> - Made libsrp a linked file to the ibmvscsis module
> 
> Version 2:
> -Fixed comments from Bart/Joe in regards to styling and code structure
> 
> 
>  MAINTAINERS                                      |   10 +-
>  drivers/scsi/Kconfig                             |   27 +-
>  drivers/scsi/Makefile                            |    2 +-
>  drivers/scsi/ibmvscsi/ibmvfc.h                   |    2 +-
>  drivers/scsi/ibmvscsi/ibmvscsi.h                 |    2 +-
>  drivers/scsi/ibmvscsi_tgt/Makefile               |    4 +
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c         | 4087 ++++++++++++++++++++++
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h         |  346 ++
>  drivers/scsi/ibmvscsi_tgt/libsrp.c               |  427 +++
>  drivers/scsi/ibmvscsi_tgt/libsrp.h               |  123 +
>  drivers/scsi/libsrp.c                            |  447 ---
>  include/scsi/libsrp.h                            |   78 -
>  {drivers/scsi/ibmvscsi => include/scsi}/viosrp.h |   13 +-
>  13 files changed, 5020 insertions(+), 548 deletions(-)
>  create mode 100644 drivers/scsi/ibmvscsi_tgt/Makefile
>  create mode 100644 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
>  create mode 100644 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
>  create mode 100644 drivers/scsi/ibmvscsi_tgt/libsrp.c
>  create mode 100644 drivers/scsi/ibmvscsi_tgt/libsrp.h
>  delete mode 100644 drivers/scsi/libsrp.c
>  delete mode 100644 include/scsi/libsrp.h
>  rename {drivers/scsi/ibmvscsi => include/scsi}/viosrp.h (92%)

This -v9 patch has been applied to target-pending/for-next here:

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=for-next&id=88a678bbc34cecce36bf2c7a8af4cba38f9f77ce

Note the deletion of drivers/scsi/libsrp.c + include/scsi/libsrp.h has
been dropped from the above commit, as it looks like they where changes
specific to your local tree.

Please have a quick look, and let me know if anything doesn't look
right.

