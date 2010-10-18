From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFCv3 20/21] tcm: Add Kbuild and Kconfig for drivers/target
 and Documentation/target/
Date: Mon, 18 Oct 2010 15:48:59 -0700
Message-ID: <20101018154859.66b71121.randy.dunlap@oracle.com>
References: <1287441559-20129-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:37588 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147Ab0JRWty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2010 18:49:54 -0400
In-Reply-To: <1287441559-20129-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 18 Oct 2010 15:39:19 -0700 Nicholas A. Bellinger wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Add TCM Kbuild and Kconfig files and update drivers/ to pick up drivers/target.
> Add Docmentation/target/ for tcm_mod_builder.py script for generating new
> TCM v4 fabric modules functional ConfigFS skeletons.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  Documentation/target/tcm_mod_builder.py  | 1094 ++++++++++++++++++++++++++++++
>  Documentation/target/tcm_mod_builder.txt |  145 ++++
>  drivers/Kconfig                          |    2 +
>  drivers/Makefile                         |    1 +
>  drivers/target/Kbuild                    |   27 +
>  drivers/target/Kconfig                   |   34 +
>  6 files changed, 1303 insertions(+), 0 deletions(-)
>  create mode 100755 Documentation/target/tcm_mod_builder.py
>  create mode 100644 Documentation/target/tcm_mod_builder.txt
>  create mode 100644 drivers/target/Kbuild
>  create mode 100644 drivers/target/Kconfig


> diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
> new file mode 100644
> index 0000000..5c37653
> --- /dev/null
> +++ b/drivers/target/Kconfig
> @@ -0,0 +1,34 @@
> +config TARGET_CORE
> +        tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
> +	select CONFIGFS_FS

Indentation: use tabs, not spaces.

> +        default m

Don't enable random drivers/modules.
Let the user or defconfig do that.


> +        ---help---
> +        Say Y or M here to enable the TCM Storage Engine and ConfigFS enabled control path for target_core_mod.  This includes built-in TCM RAMDISK subsystem logic for virtual LUN 0 access
> +
> +config TCM_DEBUG_DEV
> +	tristate "TCM Debug device code"
> +	depends on TARGET_CORE
> +	default n
> +	---help---
> +	Say Y here to enable the TCM Debug device code
> +
> +config TCM_IBLOCK
> +	tristate "TCM/IBLOCK Subsystem Plugin for Linux/BLOCK"
> +	depends on TARGET_CORE
> +	default y
> +	---help---
> +	Say Y here to enable the TCM/IBLOCK subsystem plugin for non-buffered access to Linux/Block devices using BIO
> +
> +config TCM_FILEIO
> +	tristate "TCM/FILEIO Subsystem Plugin for Linux/VFS"
> +	depends on TARGET_CORE
> +	default y
> +	---help---
> +	Say Y here to enable the TCM/FILEIO subsystem plugin for buffered access to Linux/VFS struct file or struct block_device
> +
> +config TCM_PSCSI
> +	tristate "TCM/pSCSI Subsystem Plugin for Linux/SCSI"
> +	depends on TARGET_CORE
> +	default y
> +	---help---
> +	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered passthrough access to Linux/SCSI device
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
