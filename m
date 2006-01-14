From: Nohez <nohez@cmie.com>
Subject: Re: Qlogic 2460 Query
Date: Sat, 14 Jan 2006 18:42:49 +0530 (IST)
Message-ID: <Pine.LNX.4.58.0601141836580.23973@moon.cmie.ernet.in>
References: <Pine.LNX.4.58.0601101930080.27390@moon.cmie.ernet.in>
 <20060114013640.GE7411@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [202.149.212.34] ([202.149.212.34]:52035 "EHLO cmie.com")
	by vger.kernel.org with ESMTP id S1751267AbWANNLa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 08:11:30 -0500
In-Reply-To: <20060114013640.GE7411@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org


Andrew,

I applied the patch. Following is the output from /var/log/messages
after recompiling and reloading the driver.

Thanks

Nohez

-------------------------------------------------------------------
Relevant output from /var/log/messages
-------------------------------------------------------------------
kernel: QLogic Fibre Channel HBA Driver
kernel: qla2400 0000:02:02.0: Found an ISP2422, irq 11, iobase 0xd1094000
kernel: qla2400 0000:02:02.0: Configuring PCI space...
kernel: qla2400 0000:02:02.0: Configure NVRAM parameters...
kernel: qla2400 0000:02:02.0: Verifying loaded RISC code...
kernel: scsi(3): **** Load RISC code ****
kernel: qla2x00_mailbox_command(3): **** FAILED. mbx0=4001, mbx1=0, mbx2=568, cmd=9 ****
kernel: qla2x00_load_ram(3): failed. rval=102 mb[0]=4001.
kernel: scsi(3): [ERROR] Failed to load segment 0 of firmware
kernel: qla2400 0000:02:02.0: [ERROR] Failed to load segment 0 of firmware
kernel: Mailbox registers:
kernel: scsi(3): mbox 0 0x0000
kernel: scsi(3): mbox 1 0x0000
kernel: scsi(3): mbox 2 0x0002
kernel: scsi(3): mbox 3 0x4001
kernel: scsi(3): mbox 4 0x0000
kernel: scsi(3): mbox 5 0x0000
kernel: qla2x00_mailbox_command(3): **** FAILED. mbx0=4001, mbx1=e000, mbx2=568, cmd=9 ****
kernel: qla2x00_load_ram(3): failed. rval=102 mb[0]=4001.
kernel: scsi(3): [ERROR] Failed to load segment 0 of firmware
kernel: qla2400 0000:02:02.0: [ERROR] Failed to load segment 0 of firmware
kernel: Mailbox registers:
kernel: scsi(3): mbox 0 0x0000
kernel: scsi(3): mbox 1 0x0000
kernel: scsi(3): mbox 2 0x0002
kernel: scsi(3): mbox 3 0x4001
kernel: scsi(3): mbox 4 0x0000
kernel: scsi(3): mbox 5 0x0000
kernel: scsi(3): Setup chip **** FAILED ****.
kernel: qla2x00_initialize_adapter(): **** FAILED ****
kernel: qla2400 0000:02:02.0: Failed to initialize adapter
kernel: scsi(3): Failed to initialize adapter - Adapter flags 0.
kernel: qla2x00_mailbox_command(3): **** FAILED. mbx0=4001, mbx1=d13d, mbx2=d188, cmd=14 ****
kernel: qla2x00_stop_firmware(3): failed=102.
kernel: Trying to free free IRQ11
-------------------------------------------------------------------

On Fri, 13 Jan 2006, Andrew Vasquez wrote:

> Could you apply the attached patch so that we can get some additional
> information which may help in narrowing down where exactly we are
> failing?  After applying the patch, recompiling, and reloading the
> driver, forward over the kernel-output.
> 
> Thanks,
> Andrew Vasquez
> 
> ---
> 
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
> index 935a59a..632f653 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -9,6 +9,7 @@
>   */
>  /* #define QL_DEBUG_LEVEL_1  */ /* Output register accesses to COM1 */
>  /* #define QL_DEBUG_LEVEL_2  */ /* Output error msgs to COM1 */
> +#define QL_DEBUG_LEVEL_2   /* Output error msgs to COM1 */
>  /* #define QL_DEBUG_LEVEL_3  */ /* Output function trace msgs to COM1 */
>  /* #define QL_DEBUG_LEVEL_4  */ /* Output NVRAM trace msgs to COM1 */
>  /* #define QL_DEBUG_LEVEL_5  */ /* Output ring trace msgs to COM1 */
> diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
> index 363205c..b2e22b0 100644
> --- a/drivers/scsi/qla2xxx/qla_settings.h
> +++ b/drivers/scsi/qla2xxx/qla_settings.h
> @@ -8,7 +8,7 @@
>   * Compile time Options:
>   *     0 - Disable and 1 - Enable
>   */
> -#define DEBUG_QLA2100		0	/* For Debug of qla2x00 */
> +#define DEBUG_QLA2100		1	/* For Debug of qla2x00 */
>  
>  #define USE_ABORT_TGT		1	/* Use Abort Target mbx cmd */
