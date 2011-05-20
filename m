From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] x86: Remove 32-bit versions of readq()/writeq()
Date: Fri, 20 May 2011 13:35:42 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70157F7BE99@inbmail01.lsi.com>
References: <20110519181500.GF6139@elte.hu>
	<1305849293-25437-1-git-send-email-roland@kernel.org>
 <BANLkTin2j0xhaSJvaNcqh1OPizdgxvEorQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTin2j0xhaSJvaNcqh1OPizdgxvEorQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hitoshi Mitake <h.mitake@gmail.com>, Roland Dreier <roland@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Milton Miller <miltonm@bga.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Len Brown <lenb@kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org



-----Original Message-----
=46rom: Hitoshi Mitake [mailto:h.mitake@gmail.com]=20
Sent: Friday, May 20, 2011 6:46 AM
To: Roland Dreier
Cc: Ingo Molnar; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.o=
rg; Benjamin Herrenschmidt; Milton Miller; James Bottomley; Desai, Kash=
yap; Len Brown; Ravi Anand; Vikas Chaudhary; Matthew Garrett
Subject: Re: [PATCH] x86: Remove 32-bit versions of readq()/writeq()

On Fri, May 20, 2011 at 08:54, Roland Dreier <roland@kernel.org> wrote:
> From: Roland Dreier <roland@purestorage.com>
>
> The presense of a writeq() implementation on 32-bit x86 that splits
> the 64-bit write into two 32-bit writes turns out to break the mpt2sa=
s
> driver (and in general is risky for drivers as was discussed in
> <http://lkml.kernel.org/r/adaab6c1h7c.fsf@cisco.com>). =A0To fix this=
,
> revert 2c5643b1c5c7 ("x86: provide readq()/writeq() on 32-bit too")
> and follow-on cleanups.
>
> This unfortunately leads to pushing non-atomic definitions of readq()
> and write() to various x86-only drivers that in the mean time started
> using the definitions in the x86 version of <asm/io.h>. =A0However as
> discussed exhaustively, this is actually the right thing to do,
> because the right way to split a 64-bit transaction is hardware
> dependent and therefore belongs in the hardware driver (eg mpt2sas
> needs a spinlock to make sure no other accesses occur in between the
> two halves of the access).
>
> Build tested on 32- and 64-bit x86 allmodconfig.
>
> Link: http://lkml.kernel.org/r/x86-32-writeq-is-broken@mdm.bga.com
> Cc: Hitoshi Mitake <h.mitake@gmail.com>
> Cc: Kashyap Desai <Kashyap.Desai@lsi.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Ravi Anand <ravi.anand@qlogic.com>
> Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Roland Dreier <roland@purestorage.com>

I should ack this patch based on the detailed explanation from guys in
the previous thread.
Acked-by: Hitoshi Mitake <h.mitake@gmail.com>

Thanks for your cleaning drivers, Roland!
[Desai, Kashyap]  I found this is the good approach to remove 32 bit ve=
rsion of readq/writeq.
Acked-by: Kashyap Desai <kashyap.desai@lsi.com>


> ---
> =A0arch/x86/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A02 --
> =A0arch/x86/include/asm/io.h =A0 =A0 =A0 =A0| =A0 24 ++--------------=
--------
> =A0drivers/acpi/apei/einj.c =A0 =A0 =A0 =A0 | =A0 =A08 ++++++++
> =A0drivers/acpi/atomicio.c =A0 =A0 =A0 =A0 =A0| =A0 =A04 ++++
> =A0drivers/edac/i3200_edac.c =A0 =A0 =A0 =A0| =A0 13 +++++++++++++
> =A0drivers/platform/x86/ibm_rtl.c =A0 | =A0 13 +++++++++++++
> =A0drivers/platform/x86/intel_ips.c | =A0 13 +++++++++++++
> =A0drivers/scsi/qla4xxx/ql4_nx.c =A0 =A0| =A0 21 ++++++++++++++++++++=
+
> =A08 files changed, 74 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index cc6c53a..ceb41f3 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -16,8 +16,6 @@ config X86_64
> =A0config X86
> =A0 =A0 =A0 =A0def_bool y
> =A0 =A0 =A0 =A0select HAVE_AOUT if X86_32
> - =A0 =A0 =A0 select HAVE_READQ
> - =A0 =A0 =A0 select HAVE_WRITEQ
> =A0 =A0 =A0 =A0select HAVE_UNSTABLE_SCHED_CLOCK
> =A0 =A0 =A0 =A0select HAVE_IDE
> =A0 =A0 =A0 =A0select HAVE_OPROFILE
> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> index 0722730..d02804d 100644
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -38,7 +38,6 @@
>
> =A0#include <linux/string.h>
> =A0#include <linux/compiler.h>
> -#include <asm-generic/int-ll64.h>
> =A0#include <asm/page.h>
>
> =A0#include <xen/xen.h>
> @@ -87,27 +86,6 @@ build_mmio_write(__writel, "l", unsigned int, "r",=
 )
> =A0build_mmio_read(readq, "q", unsigned long, "=3Dr", :"memory")
> =A0build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
>
> -#else
> -
> -static inline __u64 readq(const volatile void __iomem *addr)
> -{
> - =A0 =A0 =A0 const volatile u32 __iomem *p =3D addr;
> - =A0 =A0 =A0 u32 low, high;
> -
> - =A0 =A0 =A0 low =3D readl(p);
> - =A0 =A0 =A0 high =3D readl(p + 1);
> -
> - =A0 =A0 =A0 return low + ((u64)high << 32);
> -}
> -
> -static inline void writeq(__u64 val, volatile void __iomem *addr)
> -{
> - =A0 =A0 =A0 writel(val, addr);
> - =A0 =A0 =A0 writel(val >> 32, addr+4);
> -}
> -
> -#endif
> -
> =A0#define readq_relaxed(a) =A0 =A0 =A0 readq(a)
>
> =A0#define __raw_readq(a) =A0 =A0 =A0 =A0 readq(a)
> @@ -117,6 +95,8 @@ static inline void writeq(__u64 val, volatile void=
 __iomem *addr)
> =A0#define readq =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0readq
> =A0#define writeq =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 writeq
>
> +#endif
> +
> =A0/**
> =A0* =A0 =A0 virt_to_phys =A0 =A0- =A0 =A0 =A0 map virtual addresses =
to physical
> =A0* =A0 =A0 @address: address to remap
> diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
> index 096aebf..f74b2ea 100644
> --- a/drivers/acpi/apei/einj.c
> +++ b/drivers/acpi/apei/einj.c
> @@ -101,6 +101,14 @@ static DEFINE_MUTEX(einj_mutex);
>
> =A0static struct einj_parameter *einj_param;
>
> +#ifndef writeq
> +static inline void writeq(__u64 val, volatile void __iomem *addr)
> +{
> + =A0 =A0 =A0 writel(val, addr);
> + =A0 =A0 =A0 writel(val >> 32, addr+4);
> +}
> +#endif
> +
> =A0static void einj_exec_ctx_init(struct apei_exec_context *ctx)
> =A0{
> =A0 =A0 =A0 =A0apei_exec_ctx_init(ctx, einj_ins_type, ARRAY_SIZE(einj=
_ins_type),
> diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
> index 542e539..7489b89 100644
> --- a/drivers/acpi/atomicio.c
> +++ b/drivers/acpi/atomicio.c
> @@ -280,9 +280,11 @@ static int acpi_atomic_read_mem(u64 paddr, u64 *=
val, u32 width)
> =A0 =A0 =A0 =A0case 32:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*val =3D readl(addr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> +#ifdef readq
> =A0 =A0 =A0 =A0case 64:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*val =3D readq(addr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> +#endif
> =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> =A0 =A0 =A0 =A0}
> @@ -307,9 +309,11 @@ static int acpi_atomic_write_mem(u64 paddr, u64 =
val, u32 width)
> =A0 =A0 =A0 =A0case 32:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0writel(val, addr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> +#ifdef writeq
> =A0 =A0 =A0 =A0case 64:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0writeq(val, addr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> +#endif
> =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> =A0 =A0 =A0 =A0}
> diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
> index d41f900..aa08497 100644
> --- a/drivers/edac/i3200_edac.c
> +++ b/drivers/edac/i3200_edac.c
> @@ -101,6 +101,19 @@ struct i3200_priv {
>
> =A0static int nr_channels;
>
> +#ifndef readq
> +static inline __u64 readq(const volatile void __iomem *addr)
> +{
> + =A0 =A0 =A0 const volatile u32 __iomem *p =3D addr;
> + =A0 =A0 =A0 u32 low, high;
> +
> + =A0 =A0 =A0 low =3D readl(p);
> + =A0 =A0 =A0 high =3D readl(p + 1);
> +
> + =A0 =A0 =A0 return low + ((u64)high << 32);
> +}
> +#endif
> +
> =A0static int how_many_channels(struct pci_dev *pdev)
> =A0{
> =A0 =A0 =A0 =A0unsigned char capid0_8b; /* 8th byte of CAPID0 */
> diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ib=
m_rtl.c
> index 94a114a..b1396e5 100644
> --- a/drivers/platform/x86/ibm_rtl.c
> +++ b/drivers/platform/x86/ibm_rtl.c
> @@ -81,6 +81,19 @@ static void __iomem *rtl_cmd_addr;
> =A0static u8 rtl_cmd_type;
> =A0static u8 rtl_cmd_width;
>
> +#ifndef readq
> +static inline __u64 readq(const volatile void __iomem *addr)
> +{
> + =A0 =A0 =A0 const volatile u32 __iomem *p =3D addr;
> + =A0 =A0 =A0 u32 low, high;
> +
> + =A0 =A0 =A0 low =3D readl(p);
> + =A0 =A0 =A0 high =3D readl(p + 1);
> +
> + =A0 =A0 =A0 return low + ((u64)high << 32);
> +}
> +#endif
> +
> =A0static void __iomem *rtl_port_map(phys_addr_t addr, unsigned long =
len)
> =A0{
> =A0 =A0 =A0 =A0if (rtl_cmd_type =3D=3D RTL_ADDR_TYPE_MMIO)
> diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/=
intel_ips.c
> index 85c8ad4..5ffe7c3 100644
> --- a/drivers/platform/x86/intel_ips.c
> +++ b/drivers/platform/x86/intel_ips.c
> @@ -344,6 +344,19 @@ struct ips_driver {
> =A0static bool
> =A0ips_gpu_turbo_enabled(struct ips_driver *ips);
>
> +#ifndef readq
> +static inline __u64 readq(const volatile void __iomem *addr)
> +{
> + =A0 =A0 =A0 const volatile u32 __iomem *p =3D addr;
> + =A0 =A0 =A0 u32 low, high;
> +
> + =A0 =A0 =A0 low =3D readl(p);
> + =A0 =A0 =A0 high =3D readl(p + 1);
> +
> + =A0 =A0 =A0 return low + ((u64)high << 32);
> +}
> +#endif
> +
> =A0/**
> =A0* ips_cpu_busy - is CPU busy?
> =A0* @ips: IPS driver struct
> diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4=
_nx.c
> index 35381cb..03e522b 100644
> --- a/drivers/scsi/qla4xxx/ql4_nx.c
> +++ b/drivers/scsi/qla4xxx/ql4_nx.c
> @@ -655,6 +655,27 @@ static int qla4_8xxx_pci_is_same_window(struct s=
csi_qla_host *ha,
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +#ifndef readq
> +static inline __u64 readq(const volatile void __iomem *addr)
> +{
> + =A0 =A0 =A0 const volatile u32 __iomem *p =3D addr;
> + =A0 =A0 =A0 u32 low, high;
> +
> + =A0 =A0 =A0 low =3D readl(p);
> + =A0 =A0 =A0 high =3D readl(p + 1);
> +
> + =A0 =A0 =A0 return low + ((u64)high << 32);
> +}
> +#endif
> +
> +#ifndef writeq
> +static inline void writeq(__u64 val, volatile void __iomem *addr)
> +{
> + =A0 =A0 =A0 writel(val, addr);
> + =A0 =A0 =A0 writel(val >> 32, addr+4);
> +}
> +#endif
> +
> =A0static int qla4_8xxx_pci_mem_read_direct(struct scsi_qla_host *ha,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u64 off, void *data, int size)
> =A0{
>



--=20
Hitoshi Mitake
h.mitake@gmail.com
