From: Borislav Petkov <bp@alien8.de>
Subject: Re: [-next PATCH 4/4] treewide: Use DEVICE_ATTR_WO
Date: Tue, 19 Dec 2017 19:44:41 +0100
Message-ID: <20171219184441.ixxh757tl44qvk5l@pd.tnic>
References: <cover.1513706701.git.joe@perches.com>
 <fa30f1ad73f76dafff816df40cacffe613aa2f48.1513706702.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fa30f1ad73f76dafff816df40cacffe613aa2f48.1513706702.git.joe@perches.com>
Sender: linux-pm-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Thomas Falcon <tlfalcon@linux.vnet.ibm.com>, John Allen <jallen@linux.vnet.ibm.com>, Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>, linux-wimax@intel.com, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 19, 2017 at 10:15:09AM -0800, Joe Perches wrote:
> Convert DEVICE_ATTR uses to DEVICE_ATTR_WO where possible.
> 
> Done with perl script:
> 
> $ git grep -w --name-only DEVICE_ATTR | \
>   xargs perl -i -e 'local $/; while (<>) { s/\bDEVICE_ATTR\s*\(\s*(\w+)\s*,\s*\(?(?:\s*S_IWUSR\s*|\s*0200\s*)\)?\s*,\s*NULL\s*,\s*\s_store\s*\)/DEVICE_ATTR_WO(\1)/g; print;}'
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/s390/kernel/smp.c                 | 2 +-
>  arch/x86/kernel/cpu/microcode/core.c   | 2 +-
>  drivers/input/touchscreen/elants_i2c.c | 2 +-
>  drivers/net/ethernet/ibm/ibmvnic.c     | 2 +-
>  drivers/net/wimax/i2400m/sysfs.c       | 3 +--
>  drivers/scsi/lpfc/lpfc_attr.c          | 3 +--
>  drivers/thermal/thermal_sysfs.c        | 2 +-
>  7 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index b8c1a85bcf2d..a919b2f0141d 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -1151,7 +1151,7 @@ static ssize_t __ref rescan_store(struct device *dev,
>  	rc = smp_rescan_cpus();
>  	return rc ? rc : count;
>  }
> -static DEVICE_ATTR(rescan, 0200, NULL, rescan_store);
> +static DEVICE_ATTR_WO(rescan);
>  #endif /* CONFIG_HOTPLUG_CPU */
>  
>  static int __init s390_smp_init(void)
> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
> index c4fa4a85d4cb..09c74b0560dd 100644
> --- a/arch/x86/kernel/cpu/microcode/core.c
> +++ b/arch/x86/kernel/cpu/microcode/core.c
> @@ -560,7 +560,7 @@ static ssize_t pf_show(struct device *dev,
>  	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
>  }
>  
> -static DEVICE_ATTR(reload, 0200, NULL, reload_store);
> +static DEVICE_ATTR_WO(reload);
>  static DEVICE_ATTR(version, 0400, version_show, NULL);
>  static DEVICE_ATTR(processor_flags, 0400, pf_show, NULL);
>  

# cat /sys/devices/system/cpu/microcode/reload
cat: /sys/devices/system/cpu/microcode/reload: Permission denied

The reason for the code churn being?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
