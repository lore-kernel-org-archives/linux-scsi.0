From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] scsi: cxlflash: Select SCSI_SCAN_ASYNC
Date: Tue, 20 Feb 2018 19:56:35 +1100
Message-ID: <87sh9wrqd8.fsf@concordia.ellerman.id.au>
References: <20180219071037.27938-1-vaibhav@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20180219071037.27938-1-vaibhav@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
To: "Manoj N . Kumar" <manoj@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Matthew R . Ochs" <mrochs@linux.vnet.ibm.com>, Vaibhav Jain <vaibhav@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

Vaibhav Jain <vaibhav@linux.vnet.ibm.com> writes:

> The cxlflash driver uses "Asynchronous SCSI scanning" enabled by
> CONFIG_SCSI_SCAN_ASYNC. Without this enabled the modprobe of cxlflash
> module gets hung with following backtrace:
>
> Call Trace:
>  __switch_to+0x2cc/0x470
>  __schedule+0x288/0xab0
>  schedule+0x40/0xc0
>  schedule_timeout+0x254/0x4f0
>  wait_for_common+0xdc/0x260
>  flush_work+0x140/0x2a0
>  work_on_cpu+0x88/0xb0
>  pci_device_probe+0x1d0/0x220
>  driver_probe_device+0x408/0x5b0
>  __driver_attach+0x16c/0x1a0
>  bus_for_each_dev+0xb8/0x110
>  driver_attach+0x3c/0x60
>  bus_add_driver+0x1d8/0x370
>  driver_register+0x9c/0x180
>  __pci_register_driver+0x74/0xa0
>  init_cxlflash+0x158/0x1cc
>  do_one_initcall+0x68/0x1e0
>  do_init_module+0x90/0x254
>  load_module+0x2f8c/0x3720
>  SyS_finit_module+0xcc/0x140
>  system_call+0x58/0x6c

Why does it "hang"? That's kind of bizarre, I would expect either a
build or runtime failure if a feature the driver requires is missing.

> diff --git a/drivers/scsi/cxlflash/Kconfig b/drivers/scsi/cxlflash/Kconfig
> index a011c5dbf214..f054c1b0fff3 100644
> --- a/drivers/scsi/cxlflash/Kconfig
> +++ b/drivers/scsi/cxlflash/Kconfig
> @@ -6,6 +6,7 @@ config CXLFLASH
>  	tristate "Support for IBM CAPI Flash"
>  	depends on PCI && SCSI && CXL && EEH
>  	select IRQ_POLL
> +	select SCSI_SCAN_ASYNC

It's user configurable, so it's rude to select it. It can also be
disabled on the kernel command line, so this seems like a fragile
solution.

cheers
