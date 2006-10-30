From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Fwd: linux-2.6.19-rc3-g2da6dc28 build #105 failed
Date: Sun, 29 Oct 2006 19:03:57 -0800
Message-ID: <20061029190357.98fc9c98.randy.dunlap@oracle.com>
References: <200610291945.16948.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:54152 "EHLO
	agminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1030494AbWJ3DI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Oct 2006 22:08:26 -0500
In-Reply-To: <200610291945.16948.toralf.foerster@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-scsi@vger.kernel.org, zippel@linux-m68k.org

On Sun, 29 Oct 2006 19:45:15 +0100 Toralf F=F6rster wrote:

> Hello,

config SCSI_ISCSI_ATTRS
	tristate "iSCSI Transport Attributes"
	depends on SCSI && NET
	help
	  If you wish to export transport-specific information about
	  each attached iSCSI device to sysfs, say Y.
	  Otherwise, say N.

but NET is disabled, yet somehow SCSI_ISCSI_ATTRS is enabled.
I don't see how that happens.
Roman, any ideas?


> the build with the attached .config failed, make ends with:
> ...
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `iscsi_broadcast_skb':
> scsi_transport_iscsi.c:(.text+0xce80c): undefined reference to `netli=
nk_broadcast'
> drivers/built-in.o: In function `iscsi_unicast_skb':
> scsi_transport_iscsi.c:(.text+0xce866): undefined reference to `netli=
nk_unicast'
> drivers/built-in.o: In function `iscsi_recv_pdu':
> : undefined reference to `__alloc_skb'
> drivers/built-in.o: In function `iscsi_recv_pdu':
> : undefined reference to `skb_over_panic'
> drivers/built-in.o: In function `iscsi_conn_error':
> : undefined reference to `__alloc_skb'
> drivers/built-in.o: In function `iscsi_conn_error':
> : undefined reference to `skb_over_panic'
> drivers/built-in.o: In function `iscsi_if_send_reply':
> ...
> scsi_transport_iscsi.c:(.init.text+0xb5d8): undefined reference to `n=
etlink_kernel_create'
> drivers/built-in.o: In function `iscsi_transport_exit':
> scsi_transport_iscsi.c:(.exit.text+0xed2): undefined reference to `so=
ck_release'
> make: *** [.tmp_vmlinux1] Error 1
>=20
>=20
> Here's the config:
>=20
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.19-rc3
> # Sun Oct 29 18:16:59 2006
> #
> CONFIG_X86_32=3Dy
> CONFIG_GENERIC_TIME=3Dy
> CONFIG_LOCKDEP_SUPPORT=3Dy
> CONFIG_STACKTRACE_SUPPORT=3Dy
> CONFIG_SEMAPHORE_SLEEPERS=3Dy
> CONFIG_X86=3Dy
> CONFIG_MMU=3Dy
> CONFIG_GENERIC_ISA_DMA=3Dy
> CONFIG_GENERIC_IOMAP=3Dy
> CONFIG_GENERIC_HWEIGHT=3Dy
> CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
> CONFIG_DMI=3Dy
> CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
>=20
> #
> # Code maturity level options
> #
> # CONFIG_EXPERIMENTAL is not set
> CONFIG_BROKEN_ON_SMP=3Dy
> CONFIG_INIT_ENV_ARG_LIMIT=3D32
>=20
> #
> # General setup
> #
> CONFIG_LOCALVERSION=3D""
> CONFIG_LOCALVERSION_AUTO=3Dy
> # CONFIG_SWAP is not set
> # CONFIG_SYSVIPC is not set
> CONFIG_BSD_PROCESS_ACCT=3Dy
> CONFIG_BSD_PROCESS_ACCT_V3=3Dy
> # CONFIG_UTS_NS is not set
> CONFIG_IKCONFIG=3Dy
> # CONFIG_IKCONFIG_PROC is not set
> # CONFIG_RELAY is not set
> CONFIG_INITRAMFS_SOURCE=3D""
> CONFIG_SYSCTL=3Dy
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=3Dy
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=3Dy
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> CONFIG_HOTPLUG=3Dy
> CONFIG_PRINTK=3Dy
> CONFIG_BUG=3Dy
> CONFIG_ELF_CORE=3Dy
> CONFIG_BASE_FULL=3Dy
> CONFIG_FUTEX=3Dy
> CONFIG_EPOLL=3Dy
> CONFIG_SHMEM=3Dy
> CONFIG_SLAB=3Dy
> CONFIG_VM_EVENT_COUNTERS=3Dy
> CONFIG_RT_MUTEXES=3Dy
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=3D0
> # CONFIG_SLOB is not set
>=20
> #
> # Loadable module support
> #
> # CONFIG_MODULES is not set
>=20
> #
> # Block layer
> #
> CONFIG_BLOCK=3Dy
> CONFIG_LBD=3Dy
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_LSF=3Dy
>=20
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=3Dy
> # CONFIG_IOSCHED_AS is not set
> # CONFIG_IOSCHED_DEADLINE is not set
> # CONFIG_IOSCHED_CFQ is not set
> # CONFIG_DEFAULT_AS is not set
> # CONFIG_DEFAULT_DEADLINE is not set
> # CONFIG_DEFAULT_CFQ is not set
> CONFIG_DEFAULT_NOOP=3Dy
> CONFIG_DEFAULT_IOSCHED=3D"noop"
>=20
> #
> # Processor type and features
> #
> # CONFIG_SMP is not set
> CONFIG_X86_PC=3Dy
> # CONFIG_X86_ELAN is not set
> # CONFIG_X86_VOYAGER is not set
> # CONFIG_X86_NUMAQ is not set
> # CONFIG_X86_SUMMIT is not set
> # CONFIG_X86_BIGSMP is not set
> # CONFIG_X86_VISWS is not set
> # CONFIG_X86_GENERICARCH is not set
> # CONFIG_X86_ES7000 is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> CONFIG_MPENTIUMM=3Dy
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP2 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_CMPXCHG=3Dy
> CONFIG_X86_XADD=3Dy
> CONFIG_X86_L1_CACHE_SHIFT=3D6
> CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
> CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
> CONFIG_X86_WP_WORKS_OK=3Dy
> CONFIG_X86_INVLPG=3Dy
> CONFIG_X86_BSWAP=3Dy
> CONFIG_X86_POPAD_OK=3Dy
> CONFIG_X86_CMPXCHG64=3Dy
> CONFIG_X86_GOOD_APIC=3Dy
> CONFIG_X86_INTEL_USERCOPY=3Dy
> CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
> CONFIG_X86_TSC=3Dy
> # CONFIG_HPET_TIMER is not set
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=3Dy
> # CONFIG_PREEMPT is not set
> # CONFIG_X86_UP_APIC is not set
> CONFIG_X86_MCE=3Dy
> # CONFIG_X86_MCE_NONFATAL is not set
> CONFIG_VM86=3Dy
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> CONFIG_X86_REBOOTFIXUPS=3Dy
> CONFIG_MICROCODE=3Dy
> CONFIG_MICROCODE_OLD_INTERFACE=3Dy
> # CONFIG_X86_MSR is not set
> CONFIG_X86_CPUID=3Dy
>=20
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> # CONFIG_EFI_VARS is not set
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> # CONFIG_NOHIGHMEM is not set
> # CONFIG_HIGHMEM4G is not set
> CONFIG_HIGHMEM64G=3Dy
> CONFIG_PAGE_OFFSET=3D0xC0000000
> CONFIG_HIGHMEM=3Dy
> CONFIG_X86_PAE=3Dy
> CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
> CONFIG_FLATMEM=3Dy
> CONFIG_FLAT_NODE_MEM_MAP=3Dy
> # CONFIG_SPARSEMEM_STATIC is not set
> CONFIG_SPLIT_PTLOCK_CPUS=3D4
> CONFIG_RESOURCES_64BIT=3Dy
> CONFIG_HIGHPTE=3Dy
> # CONFIG_MATH_EMULATION is not set
> # CONFIG_MTRR is not set
> CONFIG_EFI=3Dy
> CONFIG_BOOT_IOREMAP=3Dy
> # CONFIG_REGPARM is not set
> CONFIG_SECCOMP=3Dy
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> CONFIG_HZ_1000=3Dy
> CONFIG_HZ=3D1000
> # CONFIG_KEXEC is not set
> CONFIG_PHYSICAL_START=3D0x100000
> CONFIG_COMPAT_VDSO=3Dy
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy
>=20
> #
> # Power management options (ACPI, APM)
> #
> CONFIG_PM=3Dy
> # CONFIG_PM_LEGACY is not set
> # CONFIG_PM_DEBUG is not set
> # CONFIG_PM_SYSFS_DEPRECATED is not set
>=20
> #
> # ACPI (Advanced Configuration and Power Interface) Support
> #
> CONFIG_ACPI=3Dy
> CONFIG_ACPI_SLEEP=3Dy
> CONFIG_ACPI_SLEEP_PROC_FS=3Dy
> # CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
> # CONFIG_ACPI_AC is not set
> # CONFIG_ACPI_BATTERY is not set
> CONFIG_ACPI_BUTTON=3Dy
> CONFIG_ACPI_VIDEO=3Dy
> CONFIG_ACPI_FAN=3Dy
> CONFIG_ACPI_PROCESSOR=3Dy
> # CONFIG_ACPI_THERMAL is not set
> # CONFIG_ACPI_ASUS is not set
> # CONFIG_ACPI_IBM is not set
> # CONFIG_ACPI_TOSHIBA is not set
> CONFIG_ACPI_BLACKLIST_YEAR=3D0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=3Dy
> CONFIG_ACPI_POWER=3Dy
> CONFIG_ACPI_SYSTEM=3Dy
> CONFIG_X86_PM_TIMER=3Dy
>=20
> #
> # APM (Advanced Power Management) BIOS Support
> #
> CONFIG_APM=3Dy
> CONFIG_APM_IGNORE_USER_SUSPEND=3Dy
> # CONFIG_APM_DO_ENABLE is not set
> CONFIG_APM_CPU_IDLE=3Dy
> CONFIG_APM_DISPLAY_BLANK=3Dy
> CONFIG_APM_RTC_IS_GMT=3Dy
> # CONFIG_APM_ALLOW_INTS is not set
> # CONFIG_APM_REAL_MODE_POWER_OFF is not set
>=20
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=3Dy
> CONFIG_CPU_FREQ_TABLE=3Dy
> CONFIG_CPU_FREQ_DEBUG=3Dy
> # CONFIG_CPU_FREQ_STAT is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=3Dy
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
> CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dy
> CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
> CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dy
>=20
> #
> # CPUFreq processor drivers
> #
> CONFIG_X86_ACPI_CPUFREQ=3Dy
> # CONFIG_X86_POWERNOW_K6 is not set
> # CONFIG_X86_POWERNOW_K7 is not set
> # CONFIG_X86_GX_SUSPMOD is not set
> CONFIG_X86_SPEEDSTEP_CENTRINO=3Dy
> CONFIG_X86_SPEEDSTEP_CENTRINO_ACPI=3Dy
> CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=3Dy
> CONFIG_X86_SPEEDSTEP_ICH=3Dy
> # CONFIG_X86_P4_CLOCKMOD is not set
> # CONFIG_X86_LONGRUN is not set
> # CONFIG_X86_LONGHAUL is not set
>=20
> #
> # shared options
> #
> # CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
> CONFIG_X86_SPEEDSTEP_LIB=3Dy
> CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=3Dy
>=20
> #
> # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
> #
> CONFIG_PCI=3Dy
> CONFIG_PCI_GOBIOS=3Dy
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> # CONFIG_PCI_GOANY is not set
> CONFIG_PCI_BIOS=3Dy
> # CONFIG_PCIEPORTBUS is not set
> CONFIG_ISA_DMA_API=3Dy
> CONFIG_ISA=3Dy
> # CONFIG_EISA is not set
> CONFIG_MCA=3Dy
> CONFIG_MCA_LEGACY=3Dy
> # CONFIG_MCA_PROC_FS is not set
> # CONFIG_SCx200 is not set
>=20
> #
> # PCCARD (PCMCIA/CardBus) support
> #
> # CONFIG_PCCARD is not set
>=20
> #
> # PCI Hotplug Support
> #
>=20
> #
> # Executable file formats
> #
> CONFIG_BINFMT_ELF=3Dy
> # CONFIG_BINFMT_AOUT is not set
> # CONFIG_BINFMT_MISC is not set
>=20
> #
> # Networking
> #
> # CONFIG_NET is not set
>=20
> #
> # Device Drivers
> #
>=20
> #
> # Generic Driver Options
> #
> CONFIG_STANDALONE=3Dy
> CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
> CONFIG_FW_LOADER=3Dy
> # CONFIG_SYS_HYPERVISOR is not set
>=20
> #
> # Connector - unified userspace <-> kernelspace linker
> #
>=20
> #
> # Memory Technology Devices (MTD)
> #
> # CONFIG_MTD is not set
>=20
> #
> # Parallel port support
> #
> CONFIG_PARPORT=3Dy
> CONFIG_PARPORT_PC=3Dy
> CONFIG_PARPORT_NOT_PC=3Dy
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=3Dy
> # CONFIG_PARPORT_1284 is not set
>=20
> #
> # Plug and Play support
> #
> CONFIG_PNP=3Dy
> # CONFIG_PNP_DEBUG is not set
>=20
> #
> # Protocols
> #
> # CONFIG_ISAPNP is not set
>=20
> #
> # Block devices
> #
> CONFIG_BLK_DEV_FD=3Dy
> CONFIG_BLK_DEV_XD=3Dy
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=3Dy
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_SX8 is not set
> CONFIG_BLK_DEV_RAM=3Dy
> CONFIG_BLK_DEV_RAM_COUNT=3D16
> CONFIG_BLK_DEV_RAM_SIZE=3D4096
> CONFIG_BLK_DEV_RAM_BLOCKSIZE=3D1024
> CONFIG_BLK_DEV_INITRD=3Dy
> # CONFIG_CDROM_PKTCDVD is not set
>=20
> #
> # Misc devices
> #
> # CONFIG_SGI_IOC4 is not set
>=20
> #
> # ATA/ATAPI/MFM/RLL support
> #
> # CONFIG_IDE is not set
>=20
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=3Dy
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_PROC_FS=3Dy
>=20
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=3Dy
> CONFIG_CHR_DEV_ST=3Dy
> CONFIG_CHR_DEV_OSST=3Dy
> CONFIG_BLK_DEV_SR=3Dy
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> # CONFIG_CHR_DEV_SG is not set
> # CONFIG_CHR_DEV_SCH is not set
>=20
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> CONFIG_SCSI_MULTI_LUN=3Dy
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
>=20
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=3Dy
> # CONFIG_SCSI_FC_ATTRS is not set
> CONFIG_SCSI_ISCSI_ATTRS=3Dy
> CONFIG_SCSI_SAS_ATTRS=3Dy
> CONFIG_SCSI_SAS_LIBSAS=3Dy
> CONFIG_SCSI_SAS_LIBSAS_DEBUG=3Dy
>=20
> #
> # SCSI low-level drivers
> #
> CONFIG_BLK_DEV_3W_XXXX_RAID=3Dy
> CONFIG_SCSI_3W_9XXX=3Dy
> # CONFIG_SCSI_7000FASST is not set
> CONFIG_SCSI_ACARD=3Dy
> # CONFIG_SCSI_AHA152X is not set
> # CONFIG_SCSI_AHA1542 is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> CONFIG_SCSI_AIC7XXX_OLD=3Dy
> CONFIG_SCSI_AIC79XX=3Dy
> CONFIG_AIC79XX_CMDS_PER_DEVICE=3D32
> CONFIG_AIC79XX_RESET_DELAY_MS=3D5000
> # CONFIG_AIC79XX_ENABLE_RD_STRM is not set
> CONFIG_AIC79XX_DEBUG_ENABLE=3Dy
> CONFIG_AIC79XX_DEBUG_MASK=3D0
> CONFIG_AIC79XX_REG_PRETTY_PRINT=3Dy
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_IN2000 is not set
> CONFIG_SCSI_ARCMSR=3Dy
> # CONFIG_MEGARAID_NEWGEN is not set
> CONFIG_MEGARAID_LEGACY=3Dy
> CONFIG_MEGARAID_SAS=3Dy
> CONFIG_SCSI_HPTIOP=3Dy
> CONFIG_SCSI_BUSLOGIC=3Dy
> CONFIG_SCSI_OMIT_FLASHPOINT=3Dy
> CONFIG_SCSI_DMX3191D=3Dy
> CONFIG_SCSI_DTC3280=3Dy
> CONFIG_SCSI_EATA=3Dy
> # CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
> # CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
> CONFIG_SCSI_EATA_MAX_TAGS=3D16
> CONFIG_SCSI_FUTURE_DOMAIN=3Dy
> # CONFIG_SCSI_FD_MCS is not set
> CONFIG_SCSI_GDTH=3Dy
> CONFIG_SCSI_GENERIC_NCR5380=3Dy
> # CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
> CONFIG_SCSI_GENERIC_NCR53C400=3Dy
> CONFIG_SCSI_IBMMCA=3Dy
> CONFIG_IBMMCA_SCSI_ORDER_STANDARD=3Dy
> # CONFIG_IBMMCA_SCSI_DEV_RESET is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_PPA is not set
> # CONFIG_SCSI_IMM is not set
> # CONFIG_SCSI_NCR53C406A is not set
> # CONFIG_SCSI_NCR_D700 is not set
> # CONFIG_SCSI_STEX is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_NCR_Q720 is not set
> # CONFIG_SCSI_MCA_53C9X is not set
> CONFIG_SCSI_PAS16=3Dy
> CONFIG_SCSI_PSI240I=3Dy
> CONFIG_SCSI_QLOGIC_FAS=3Dy
> CONFIG_SCSI_QLOGIC_1280=3Dy
> # CONFIG_SCSI_QLA_FC is not set
> CONFIG_SCSI_QLA_ISCSI=3Dy
> # CONFIG_SCSI_LPFC is not set
> CONFIG_SCSI_SIM710=3Dy
> CONFIG_53C700_IO_MAPPED=3Dy
> CONFIG_SCSI_SYM53C416=3Dy
> CONFIG_SCSI_DC390T=3Dy
> # CONFIG_SCSI_T128 is not set
> # CONFIG_SCSI_U14_34F is not set
> CONFIG_SCSI_ULTRASTOR=3Dy
> CONFIG_SCSI_NSP32=3Dy
> # CONFIG_SCSI_DEBUG is not set
>=20
> #
> # Serial ATA (prod) and Parallel ATA (experimental) drivers
> #
> # CONFIG_ATA is not set
>=20
> #
> # Old CD-ROM drivers (not SCSI, not IDE)
> #
> CONFIG_CD_NO_IDESCSI=3Dy
> CONFIG_AZTCD=3Dy
> CONFIG_GSCD=3Dy
> # CONFIG_SBPCD is not set
> CONFIG_MCDX=3Dy
> CONFIG_OPTCD=3Dy
> # CONFIG_CM206 is not set
> # CONFIG_SJCD is not set
> CONFIG_ISP16_CDI=3Dy
> # CONFIG_CDU31A is not set
> CONFIG_CDU535=3Dy
>=20
> #
> # Multi-device support (RAID and LVM)
> #
> # CONFIG_MD is not set
>=20
> #
> # Fusion MPT device support
> #
> # CONFIG_FUSION is not set
> # CONFIG_FUSION_SPI is not set
> # CONFIG_FUSION_FC is not set
> # CONFIG_FUSION_SAS is not set
>=20
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_IEEE1394 is not set
>=20
> #
> # I2O device support
> #
> CONFIG_I2O=3Dy
> # CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
> CONFIG_I2O_EXT_ADAPTEC=3Dy
> # CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
> # CONFIG_I2O_CONFIG is not set
> CONFIG_I2O_BUS=3Dy
> # CONFIG_I2O_BLOCK is not set
> CONFIG_I2O_SCSI=3Dy
> # CONFIG_I2O_PROC is not set
>=20
> #
> # ISDN subsystem
> #
>=20
> #
> # Telephony Support
> #
> CONFIG_PHONE=3Dy
> CONFIG_PHONE_IXJ=3Dy
>=20
> #
> # Input device support
> #
> CONFIG_INPUT=3Dy
> CONFIG_INPUT_FF_MEMLESS=3Dy
>=20
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=3Dy
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
> CONFIG_INPUT_JOYDEV=3Dy
> # CONFIG_INPUT_TSDEV is not set
> CONFIG_INPUT_EVDEV=3Dy
> # CONFIG_INPUT_EVBUG is not set
>=20
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=3Dy
> CONFIG_KEYBOARD_ATKBD=3Dy
> CONFIG_KEYBOARD_SUNKBD=3Dy
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_KEYBOARD_NEWTON=3Dy
> # CONFIG_KEYBOARD_STOWAWAY is not set
> CONFIG_INPUT_MOUSE=3Dy
> # CONFIG_MOUSE_PS2 is not set
> CONFIG_MOUSE_SERIAL=3Dy
> # CONFIG_MOUSE_INPORT is not set
> CONFIG_MOUSE_LOGIBM=3Dy
> # CONFIG_MOUSE_PC110PAD is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> CONFIG_INPUT_JOYSTICK=3Dy
> CONFIG_JOYSTICK_ANALOG=3Dy
> CONFIG_JOYSTICK_A3D=3Dy
> # CONFIG_JOYSTICK_ADI is not set
> # CONFIG_JOYSTICK_COBRA is not set
> CONFIG_JOYSTICK_GF2K=3Dy
> # CONFIG_JOYSTICK_GRIP is not set
> # CONFIG_JOYSTICK_GRIP_MP is not set
> CONFIG_JOYSTICK_GUILLEMOT=3Dy
> CONFIG_JOYSTICK_INTERACT=3Dy
> # CONFIG_JOYSTICK_SIDEWINDER is not set
> CONFIG_JOYSTICK_TMDC=3Dy
> CONFIG_JOYSTICK_IFORCE=3Dy
> # CONFIG_JOYSTICK_IFORCE_232 is not set
> # CONFIG_JOYSTICK_WARRIOR is not set
> CONFIG_JOYSTICK_MAGELLAN=3Dy
> # CONFIG_JOYSTICK_SPACEORB is not set
> CONFIG_JOYSTICK_SPACEBALL=3Dy
> # CONFIG_JOYSTICK_STINGER is not set
> CONFIG_JOYSTICK_TWIDJOY=3Dy
> CONFIG_JOYSTICK_DB9=3Dy
> CONFIG_JOYSTICK_GAMECON=3Dy
> # CONFIG_JOYSTICK_TURBOGRAFX is not set
> CONFIG_JOYSTICK_JOYDUMP=3Dy
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
>=20
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=3Dy
> CONFIG_SERIO_I8042=3Dy
> # CONFIG_SERIO_SERPORT is not set
> CONFIG_SERIO_CT82C710=3Dy
> CONFIG_SERIO_PARKBD=3Dy
> CONFIG_SERIO_PCIPS2=3Dy
> CONFIG_SERIO_LIBPS2=3Dy
> CONFIG_SERIO_RAW=3Dy
> CONFIG_GAMEPORT=3Dy
> CONFIG_GAMEPORT_NS558=3Dy
> CONFIG_GAMEPORT_L4=3Dy
> CONFIG_GAMEPORT_EMU10K1=3Dy
> # CONFIG_GAMEPORT_FM801 is not set
>=20
> #
> # Character devices
> #
> CONFIG_VT=3Dy
> CONFIG_VT_CONSOLE=3Dy
> CONFIG_HW_CONSOLE=3Dy
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_SERIAL_NONSTANDARD=3Dy
> CONFIG_COMPUTONE=3Dy
> CONFIG_ROCKETPORT=3Dy
> # CONFIG_CYCLADES is not set
> # CONFIG_DIGIEPCA is not set
> CONFIG_ESPSERIAL=3Dy
> CONFIG_MOXA_INTELLIO=3Dy
> CONFIG_MOXA_SMARTIO=3Dy
> # CONFIG_ISI is not set
> CONFIG_SYNCLINK=3Dy
> # CONFIG_SYNCLINKMP is not set
> # CONFIG_SYNCLINK_GT is not set
> CONFIG_N_HDLC=3Dy
> # CONFIG_RISCOM8 is not set
> # CONFIG_SPECIALIX is not set
> CONFIG_SX=3Dy
> CONFIG_RIO=3Dy
> CONFIG_RIO_OLDPCI=3Dy
> # CONFIG_STALDRV is not set
>=20
> #
> # Serial drivers
> #
> # CONFIG_SERIAL_8250 is not set
>=20
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=3Dy
> CONFIG_SERIAL_JSM=3Dy
> CONFIG_UNIX98_PTYS=3Dy
> CONFIG_LEGACY_PTYS=3Dy
> CONFIG_LEGACY_PTY_COUNT=3D256
> CONFIG_PRINTER=3Dy
> # CONFIG_LP_CONSOLE is not set
> CONFIG_PPDEV=3Dy
> # CONFIG_TIPAR is not set
>=20
> #
> # IPMI
> #
> CONFIG_IPMI_HANDLER=3Dy
> CONFIG_IPMI_PANIC_EVENT=3Dy
> CONFIG_IPMI_PANIC_STRING=3Dy
> # CONFIG_IPMI_DEVICE_INTERFACE is not set
> # CONFIG_IPMI_SI is not set
> # CONFIG_IPMI_WATCHDOG is not set
> CONFIG_IPMI_POWEROFF=3Dy
>=20
> #
> # Watchdog Cards
> #
> # CONFIG_WATCHDOG is not set
> CONFIG_HW_RANDOM=3Dy
> CONFIG_HW_RANDOM_INTEL=3Dy
> CONFIG_HW_RANDOM_AMD=3Dy
> CONFIG_HW_RANDOM_GEODE=3Dy
> CONFIG_HW_RANDOM_VIA=3Dy
> CONFIG_NVRAM=3Dy
> # CONFIG_RTC is not set
> CONFIG_GEN_RTC=3Dy
> CONFIG_GEN_RTC_X=3Dy
> # CONFIG_DTLK is not set
> CONFIG_R3964=3Dy
> # CONFIG_APPLICOM is not set
>=20
> #
> # Ftape, the floppy tape device driver
> #
> # CONFIG_FTAPE is not set
> CONFIG_AGP=3Dy
> # CONFIG_AGP_ALI is not set
> # CONFIG_AGP_ATI is not set
> # CONFIG_AGP_AMD is not set
> # CONFIG_AGP_AMD64 is not set
> # CONFIG_AGP_INTEL is not set
> # CONFIG_AGP_NVIDIA is not set
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_SWORKS is not set
> # CONFIG_AGP_VIA is not set
> # CONFIG_AGP_EFFICEON is not set
> CONFIG_DRM=3Dy
> # CONFIG_DRM_TDFX is not set
> CONFIG_DRM_R128=3Dy
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_MWAVE is not set
> CONFIG_PC8736x_GPIO=3Dy
> CONFIG_NSC_GPIO=3Dy
> CONFIG_CS5535_GPIO=3Dy
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
>=20
> #
> # TPM devices
> #
>=20
> #
> # I2C support
> #
> # CONFIG_I2C is not set
>=20
> #
> # SPI support
> #
> # CONFIG_SPI is not set
> # CONFIG_SPI_MASTER is not set
>=20
> #
> # Dallas's 1-wire bus
> #
> CONFIG_W1=3Dy
>=20
> #
> # 1-wire Bus Masters
> #
> CONFIG_W1_MASTER_MATROX=3Dy
>=20
> #
> # 1-wire Slaves
> #
> # CONFIG_W1_SLAVE_THERM is not set
> CONFIG_W1_SLAVE_SMEM=3Dy
> CONFIG_W1_SLAVE_DS2433=3Dy
> # CONFIG_W1_SLAVE_DS2433_CRC is not set
>=20
> #
> # Hardware Monitoring support
> #
> # CONFIG_HWMON is not set
> # CONFIG_HWMON_VID is not set
>=20
> #
> # Multimedia devices
> #
> # CONFIG_VIDEO_DEV is not set
>=20
> #
> # Digital Video Broadcasting Devices
> #
>=20
> #
> # Graphics support
> #
> # CONFIG_FIRMWARE_EDID is not set
> # CONFIG_FB is not set
>=20
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=3Dy
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> # CONFIG_VIDEO_SELECT is not set
> # CONFIG_MDA_CONSOLE is not set
> CONFIG_DUMMY_CONSOLE=3Dy
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
>=20
> #
> # Sound
> #
> # CONFIG_SOUND is not set
>=20
> #
> # USB support
> #
> CONFIG_USB_ARCH_HAS_HCD=3Dy
> CONFIG_USB_ARCH_HAS_OHCI=3Dy
> CONFIG_USB_ARCH_HAS_EHCI=3Dy
> # CONFIG_USB is not set
>=20
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
>=20
> #
> # USB Gadget Support
> #
> CONFIG_USB_GADGET=3Dy
> # CONFIG_USB_GADGET_DEBUG_FILES is not set
> CONFIG_USB_GADGET_SELECTED=3Dy
> # CONFIG_USB_GADGET_NET2280 is not set
> # CONFIG_USB_GADGET_PXA2XX is not set
> CONFIG_USB_GADGET_GOKU=3Dy
> CONFIG_USB_GOKU=3Dy
> # CONFIG_USB_GADGET_LH7A40X is not set
> # CONFIG_USB_GADGET_OMAP is not set
> # CONFIG_USB_GADGET_AT91 is not set
> # CONFIG_USB_GADGET_DUMMY_HCD is not set
> # CONFIG_USB_GADGET_DUALSPEED is not set
> # CONFIG_USB_ZERO is not set
> # CONFIG_USB_ETH is not set
> # CONFIG_USB_GADGETFS is not set
> # CONFIG_USB_FILE_STORAGE is not set
> CONFIG_USB_G_SERIAL=3Dy
> # CONFIG_USB_MIDI_GADGET is not set
>=20
> #
> # MMC/SD Card support
> #
> # CONFIG_MMC is not set
>=20
> #
> # LED devices
> #
> # CONFIG_NEW_LEDS is not set
>=20
> #
> # LED drivers
> #
>=20
> #
> # LED Triggers
> #
>=20
> #
> # InfiniBand support
> #
> # CONFIG_INFINIBAND is not set
>=20
> #
> # EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
> #
>=20
> #
> # Real Time Clock
> #
>=20
> #
> # DMA Engine support
> #
> # CONFIG_DMA_ENGINE is not set
>=20
> #
> # DMA Clients
> #
>=20
> #
> # DMA Devices
> #
>=20
> #
> # File systems
> #
> CONFIG_EXT2_FS=3Dy
> CONFIG_EXT2_FS_XATTR=3Dy
> CONFIG_EXT2_FS_POSIX_ACL=3Dy
> CONFIG_EXT2_FS_SECURITY=3Dy
> CONFIG_EXT2_FS_XIP=3Dy
> CONFIG_FS_XIP=3Dy
> CONFIG_EXT3_FS=3Dy
> CONFIG_EXT3_FS_XATTR=3Dy
> # CONFIG_EXT3_FS_POSIX_ACL is not set
> # CONFIG_EXT3_FS_SECURITY is not set
> CONFIG_JBD=3Dy
> CONFIG_JBD_DEBUG=3Dy
> CONFIG_FS_MBCACHE=3Dy
> CONFIG_REISERFS_FS=3Dy
> # CONFIG_REISERFS_CHECK is not set
> CONFIG_REISERFS_PROC_INFO=3Dy
> # CONFIG_REISERFS_FS_XATTR is not set
> CONFIG_JFS_FS=3Dy
> # CONFIG_JFS_POSIX_ACL is not set
> # CONFIG_JFS_SECURITY is not set
> # CONFIG_JFS_DEBUG is not set
> CONFIG_JFS_STATISTICS=3Dy
> CONFIG_FS_POSIX_ACL=3Dy
> # CONFIG_XFS_FS is not set
> CONFIG_MINIX_FS=3Dy
> CONFIG_ROMFS_FS=3Dy
> CONFIG_INOTIFY=3Dy
> # CONFIG_INOTIFY_USER is not set
> CONFIG_QUOTA=3Dy
> CONFIG_QFMT_V1=3Dy
> # CONFIG_QFMT_V2 is not set
> CONFIG_QUOTACTL=3Dy
> CONFIG_DNOTIFY=3Dy
> # CONFIG_AUTOFS_FS is not set
> # CONFIG_AUTOFS4_FS is not set
> CONFIG_FUSE_FS=3Dy
> CONFIG_GENERIC_ACL=3Dy
>=20
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> CONFIG_UDF_FS=3Dy
> CONFIG_UDF_NLS=3Dy
>=20
> #
> # DOS/FAT/NT Filesystems
> #
> # CONFIG_MSDOS_FS is not set
> # CONFIG_VFAT_FS is not set
> CONFIG_NTFS_FS=3Dy
> CONFIG_NTFS_DEBUG=3Dy
> # CONFIG_NTFS_RW is not set
>=20
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=3Dy
> # CONFIG_PROC_KCORE is not set
> CONFIG_PROC_SYSCTL=3Dy
> CONFIG_SYSFS=3Dy
> CONFIG_TMPFS=3Dy
> CONFIG_TMPFS_POSIX_ACL=3Dy
> CONFIG_HUGETLBFS=3Dy
> CONFIG_HUGETLB_PAGE=3Dy
> CONFIG_RAMFS=3Dy
>=20
> #
> # Miscellaneous filesystems
> #
> # CONFIG_HFSPLUS_FS is not set
> CONFIG_CRAMFS=3Dy
> # CONFIG_VXFS_FS is not set
> CONFIG_HPFS_FS=3Dy
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
>=20
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=3Dy
>=20
> #
> # Native Language Support
> #
> CONFIG_NLS=3Dy
> CONFIG_NLS_DEFAULT=3D"iso8859-1"
> CONFIG_NLS_CODEPAGE_437=3Dy
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> CONFIG_NLS_CODEPAGE_862=3Dy
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> CONFIG_NLS_CODEPAGE_865=3Dy
> CONFIG_NLS_CODEPAGE_866=3Dy
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> CONFIG_NLS_CODEPAGE_950=3Dy
> CONFIG_NLS_CODEPAGE_932=3Dy
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> CONFIG_NLS_ISO8859_8=3Dy
> CONFIG_NLS_CODEPAGE_1250=3Dy
> # CONFIG_NLS_CODEPAGE_1251 is not set
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=3Dy
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> CONFIG_NLS_ISO8859_5=3Dy
> CONFIG_NLS_ISO8859_6=3Dy
> CONFIG_NLS_ISO8859_7=3Dy
> CONFIG_NLS_ISO8859_9=3Dy
> CONFIG_NLS_ISO8859_13=3Dy
> CONFIG_NLS_ISO8859_14=3Dy
> CONFIG_NLS_ISO8859_15=3Dy
> CONFIG_NLS_KOI8_R=3Dy
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_UTF8=3Dy
>=20
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
> # CONFIG_PRINTK_TIME is not set
> CONFIG_ENABLE_MUST_CHECK=3Dy
> # CONFIG_MAGIC_SYSRQ is not set
> CONFIG_UNUSED_SYMBOLS=3Dy
> # CONFIG_DEBUG_KERNEL is not set
> CONFIG_LOG_BUF_SHIFT=3D14
> CONFIG_DEBUG_BUGVERBOSE=3Dy
> # CONFIG_DEBUG_FS is not set
> # CONFIG_UNWIND_INFO is not set
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_EARLY_PRINTK=3Dy
> CONFIG_DOUBLEFAULT=3Dy
>=20
> #
> # Security options
> #
> CONFIG_KEYS=3Dy
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY is not set
>=20
> #
> # Cryptographic options
> #
> # CONFIG_CRYPTO is not set
>=20
> #
> # Library routines
> #
> CONFIG_CRC_CCITT=3Dy
> # CONFIG_CRC16 is not set
> CONFIG_CRC32=3Dy
> CONFIG_LIBCRC32C=3Dy
> CONFIG_ZLIB_INFLATE=3Dy
> CONFIG_PLIST=3Dy
> CONFIG_GENERIC_HARDIRQS=3Dy
> CONFIG_GENERIC_IRQ_PROBE=3Dy
> CONFIG_X86_BIOS_REBOOT=3Dy
> CONFIG_KTIME_SCALAR=3Dy
>=20
>=20
>=20
> -------------------------------------------------------
>=20
> --=20
> MfG/Sincerely
>=20
> Toralf F=F6rster
> +++ I'm not subscribed to the email list, please Cc: me +++
>=20


---
~Randy
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
