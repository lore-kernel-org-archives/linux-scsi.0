From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Fri, 21 Jun 2019 12:41:14 +0200
Message-ID: <5d9d0851-f864-6d78-7e7d-9d018bea5704@free.fr>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
 <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org>
 <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com>
 <alpine.LNX.2.21.1906181107240.287@nippy.intranet>
 <017cf3cf-ecd8-19c2-3bbd-7e7c28042c3c@free.fr>
 <f8339103-5b45-b72d-9f87-fd4dd7b3081e@interlog.com>
 <f1f98ab0-399a-6c12-073d-ee8ad47d5588@free.fr>
 <48912bc0-8c79-408d-7ed2-c127b99b8bcc@interlog.com>
 <e04e14b7-e1ee-c0c1-9e6d-2628d2c873a9@free.fr>
 <alpine.LNX.2.21.1906210942560.131@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.21.1906210942560.131@nippy.intranet>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 21/06/2019 01:43, Finn Thain wrote:

> On Thu, 20 Jun 2019, Marc Gonzalez wrote:
> 
>> How likely is it that distro kernels would *not* enable CHR_DEV_SG?
>> (Distros tend to enable everything, and then some.)
> 
> How likely is it that embedded developers would *not* disable CHR_DEV_SG?
> They tend to disable everything, and then enable only what they need.

I don't see where you're going with this line of reasoning?

Below is my current (as of next-20190612) defconfig.

Notice the options marked as "not set". These are options that are
enabled by default (and which I've disabled).

Everyone thinks "their" option is critical (and it is, *to them*) but, in fact,
few really are -- universally. When an option is enabled by default, it does not
show up in defconfigs that want the option, and shows up as disabled in defconfigs
that don't want it.

Ideally, options would show as enabled in defconfigs that want the option,
and not show in defconfigs that don't.

I'm currently trying to change "enabled by default" for the following options:
# CONFIG_SCSI_PROC_FS is not set
# CONFIG_LCD_CLASS_DEVICE is not set
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
# CONFIG_COMMON_CLK_XGENE is not set
# CONFIG_QCOM_A53PLL is not set
# CONFIG_QCOM_CLK_APCS_MSM8916 is not set

I guess SCSI_PROC_FS might be the more useful to me, as it might help
debugging USB drive issues? In any event, I would rather have it show
up explicitly in my defconfig, to remind me I've selected it.

As for a few other "default on" options in my defconfig...

- SWAP I guess goes all the way back to Linux 2.0 on x86

- EFI is enabled by default because "big" arm64 systems rely on it.
But that's not true of smaller arm64 systems, based on DT.

- Not sure about the IOSCHED algorithms.

- IPV6 makes sense, to push for broader adoption

TODO: look into HW_RANDOM and CRYPTO_HW


# CONFIG_SWAP is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_PREEMPT=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_BLK_DEV_INITRD=y
CONFIG_ARCH_QCOM=y
CONFIG_CMDLINE="ignore_loglevel nosmp"
# CONFIG_EFI is not set
# CONFIG_SUSPEND is not set
CONFIG_PM=y
CONFIG_CPU_IDLE=y
CONFIG_ARM_CPUIDLE=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MQ_IOSCHED_DEADLINE is not set
# CONFIG_MQ_IOSCHED_KYBER is not set
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_INET=y
# CONFIG_IPV6 is not set
# CONFIG_WIRELESS is not set
CONFIG_PCI=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIE_QCOM=y
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_SCSI=y
# CONFIG_SCSI_PROC_FS is not set
CONFIG_BLK_DEV_SD=y
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PLATFORM=y
CONFIG_SCSI_UFS_QCOM=y
CONFIG_NETDEVICES=y
CONFIG_ATL1C=y
# CONFIG_WLAN is not set
# CONFIG_INPUT_KEYBOARD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_SERIO_SERPORT is not set
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_LEGACY_PTY_COUNT=16
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_MSM=y
CONFIG_SERIAL_MSM_CONSOLE=y
CONFIG_SERIAL_DEV_BUS=y
# CONFIG_HW_RANDOM is not set
CONFIG_I2C=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_QUP=y
CONFIG_SPMI=y
CONFIG_PINCTRL_MSM8998=y
CONFIG_THERMAL=y
CONFIG_QCOM_TSENS=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_QCOM_SMD_RPM=y
# CONFIG_LCD_CLASS_DEVICE is not set
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_SOC=y
CONFIG_SND_SOC_WCD9335=y
# CONFIG_HID is not set
# CONFIG_USB_HID is not set
CONFIG_USB=y
# CONFIG_USB_PCI is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_STORAGE=y
CONFIG_USB_DWC3=y
# CONFIG_COMMON_CLK_XGENE is not set
CONFIG_COMMON_CLK_QCOM=y
# CONFIG_QCOM_A53PLL is not set
# CONFIG_QCOM_CLK_APCS_MSM8916 is not set
CONFIG_QCOM_CLK_SMD_RPM=y
CONFIG_MSM_GCC_8998=y
CONFIG_HWSPINLOCK=y
CONFIG_HWSPINLOCK_QCOM=y
CONFIG_MAILBOX=y
CONFIG_QCOM_APCS_IPC=y
CONFIG_ARM_SMMU=y
CONFIG_RPMSG_QCOM_GLINK_RPM=y
CONFIG_RPMSG_QCOM_GLINK_SMEM=y
CONFIG_RPMSG_QCOM_SMD=y
CONFIG_RPMSG_VIRTIO=y
CONFIG_QCOM_COMMAND_DB=y
CONFIG_QCOM_SMEM=y
CONFIG_QCOM_SMD_RPM=y
CONFIG_IIO=y
CONFIG_PHY_QCOM_QMP=y
CONFIG_PHY_QCOM_QUSB2=y
CONFIG_NVMEM=y
CONFIG_QCOM_QFPROM=y
CONFIG_SLIMBUS=y
CONFIG_SLIM_QCOM_CTRL=y
CONFIG_INTERCONNECT=y
CONFIG_INTERCONNECT_QCOM=y
CONFIG_TMPFS=y
# CONFIG_CRYPTO_HW is not set
CONFIG_DEBUG_FS=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y
CONFIG_STACKTRACE=y
