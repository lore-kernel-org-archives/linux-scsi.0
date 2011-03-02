From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [RFC 12/12] iscsi-target: Add Makefile/Kconfig and update TCM
 top level
Date: Tue, 1 Mar 2011 22:32:51 -0800
Message-ID: <20110301223251.11c95eed.rdunlap@xenotime.net>
References: <1299036841-23677-1-git-send-email-nab@linux-iscsi.org>
	<1299036841-23677-13-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1299036841-23677-13-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Tue,  1 Mar 2011 19:34:01 -0800 Nicholas A. Bellinger wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Add Makefile/Kconfig and update drivers/target/[Makefile,Kconfig]
> to include the fabric module.
> 
> igned-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/Kconfig        |    1 +
>  drivers/target/Makefile       |    1 +
>  drivers/target/iscsi/Kconfig  |   17 +++++++++++++++++
>  drivers/target/iscsi/Makefile |   20 ++++++++++++++++++++
>  4 files changed, 39 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/target/iscsi/Kconfig
>  create mode 100644 drivers/target/iscsi/Makefile
> 
> diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
> index 387d293..798749a 100644
> --- a/drivers/target/Kconfig
> +++ b/drivers/target/Kconfig
> @@ -30,5 +30,6 @@ config TCM_PSCSI
>  	passthrough access to Linux/SCSI device
>  
>  source "drivers/target/tcm_loop/Kconfig"
> +source "drivers/target/iscsi/Kconfig"
>  
>  endif
> diff --git a/drivers/target/Makefile b/drivers/target/Makefile
> index 60028fe..b038b7d 100644
> --- a/drivers/target/Makefile
> +++ b/drivers/target/Makefile
> @@ -24,3 +24,4 @@ obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
>  
>  # Fabric modules
>  obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop/
> +obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
> diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
> new file mode 100644
> index 0000000..d1eaec4
> --- /dev/null
> +++ b/drivers/target/iscsi/Kconfig
> @@ -0,0 +1,17 @@
> +config ISCSI_TARGET
> +	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
> +	select CRYPTO
> +	select CRYPTO_CRC32C
> +	select CRYPTO_CRC32C_INTEL

  CRYPTO_CRC32C_INTEL depends on X86.  so is ISCSI_TARGET only for X86,
or is this kconfig just mucked up?


> +	help
> +	Say Y here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
> +	Target Mode Stack.
> +
> +if ISCSI_TARGET
> +
> +config ISCSI_TARGET_DEBUG
> +	bool "LIO-Target iscsi_debug.h ring buffer messages"
> +	help
> +	Say Y here to enable the legacy DEBUG_ISCSI macros in iscsi_debug.h
> +
> +endif
> diff --git a/drivers/target/iscsi/Makefile b/drivers/target/iscsi/Makefile
> new file mode 100644
> index 0000000..5ca883d
> --- /dev/null
> +++ b/drivers/target/iscsi/Makefile
> @@ -0,0 +1,20 @@
> +iscsi_target_mod-y +=		iscsi_auth_chap.o \
> +				iscsi_parameters.o \
> +				iscsi_seq_and_pdu_list.o \
> +				iscsi_thread_queue.o \
> +				iscsi_target_datain_values.o \
> +				iscsi_target_device.o \
> +				iscsi_target_erl0.o \
> +				iscsi_target_erl1.o \
> +				iscsi_target_erl2.o \
> +				iscsi_target_login.o \
> +				iscsi_target_nego.o \
> +				iscsi_target_nodeattrib.o \
> +				iscsi_target_tmr.o \
> +				iscsi_target_tpg.o \
> +				iscsi_target_util.o \
> +				iscsi_target.o \
> +				iscsi_target_configfs.o \
> +				iscsi_target_stat.o
> +
> +obj-$(CONFIG_ISCSI_TARGET)	+= iscsi_target_mod.o
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
