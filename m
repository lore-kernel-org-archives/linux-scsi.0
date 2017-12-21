From: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [-next PATCH 4/4] treewide: Use DEVICE_ATTR_WO
Date: Thu, 21 Dec 2017 08:50:28 +0800
Message-ID: <1513817428.2592.4.camel@intel.com>
References: <cover.1513706701.git.joe@perches.com>
         <fa30f1ad73f76dafff816df40cacffe613aa2f48.1513706702.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <fa30f1ad73f76dafff816df40cacffe613aa2f48.1513706702.git.joe@perches.com>
Sender: netdev-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Borislav Petkov <bp@alien8.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Thomas Falcon <tlfalcon@linux.vnet.ibm.com>, John Allen <jallen@linux.vnet.ibm.com>, Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>, linux-wimax@intel.com, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Eduardo Valentin <edubezval@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org, netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-12-19 at 10:15 -0800, Joe Perches wrote:
> Convert DEVICE_ATTR uses to DEVICE_ATTR_WO where possible.
> 
> Done with perl script:
> 
> $ git grep -w --name-only DEVICE_ATTR | \
>   xargs perl -i -e 'local $/; while (<>) {
> s/\bDEVICE_ATTR\s*\(\s*(\w+)\s*,\s*\(?(?:\s*S_IWUSR\s*|\s*0200\s*)\)?
> \s*,\s*NULL\s*,\s*\s_store\s*\)/DEVICE_ATTR_WO(\1)/g; print;}'
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/s390/kernel/smp.c                 | 2 +-
>  arch/x86/kernel/cpu/microcode/core.c   | 2 +-
>  drivers/input/touchscreen/elants_i2c.c | 2 +-
>  drivers/net/ethernet/ibm/ibmvnic.c     | 2 +-
>  drivers/net/wimax/i2400m/sysfs.c       | 3 +--
>  drivers/scsi/lpfc/lpfc_attr.c          | 3 +--
>  drivers/thermal/thermal_sysfs.c        | 2 +-

For the thermal part,
Acked-by: Zhang Rui <rui.zhang@intel.com>

thanks,
rui

>  7 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index b8c1a85bcf2d..a919b2f0141d 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -1151,7 +1151,7 @@ static ssize_t __ref rescan_store(struct device
> *dev,
>  	rc = smp_rescan_cpus();
>  	return rc ? rc : count;
>  }
> -static DEVICE_ATTR(rescan, 0200, NULL, rescan_store);
> +static DEVICE_ATTR_WO(rescan);
>  #endif /* CONFIG_HOTPLUG_CPU */
>  
>  static int __init s390_smp_init(void)
> diff --git a/arch/x86/kernel/cpu/microcode/core.c
> b/arch/x86/kernel/cpu/microcode/core.c
> index c4fa4a85d4cb..09c74b0560dd 100644
> --- a/arch/x86/kernel/cpu/microcode/core.c
> +++ b/arch/x86/kernel/cpu/microcode/core.c
> @@ -560,7 +560,7 @@ static ssize_t pf_show(struct device *dev,
>  	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
>  }
>  
> -static DEVICE_ATTR(reload, 0200, NULL, reload_store);
> +static DEVICE_ATTR_WO(reload);
>  static DEVICE_ATTR(version, 0400, version_show, NULL);
>  static DEVICE_ATTR(processor_flags, 0400, pf_show, NULL);
>  
> diff --git a/drivers/input/touchscreen/elants_i2c.c
> b/drivers/input/touchscreen/elants_i2c.c
> index a458e5ec9e41..819213e88f32 100644
> --- a/drivers/input/touchscreen/elants_i2c.c
> +++ b/drivers/input/touchscreen/elants_i2c.c
> @@ -1000,7 +1000,7 @@ static ssize_t show_iap_mode(struct device
> *dev,
>  				"Normal" : "Recovery");
>  }
>  
> -static DEVICE_ATTR(calibrate, S_IWUSR, NULL, calibrate_store);
> +static DEVICE_ATTR_WO(calibrate);
>  static DEVICE_ATTR(iap_mode, S_IRUGO, show_iap_mode, NULL);
>  static DEVICE_ATTR(update_fw, S_IWUSR, NULL, write_update_fw);
>  
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 1dc4aef37d3a..42b96e1a1b13 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -4411,7 +4411,7 @@ static ssize_t failover_store(struct device
> *dev, struct device_attribute *attr,
>  	return count;
>  }
>  
> -static DEVICE_ATTR(failover, 0200, NULL, failover_store);
> +static DEVICE_ATTR_WO(failover);
>  
>  static unsigned long ibmvnic_get_desired_dma(struct vio_dev *vdev)
>  {
> diff --git a/drivers/net/wimax/i2400m/sysfs.c
> b/drivers/net/wimax/i2400m/sysfs.c
> index 1237109f251a..8c67df11105c 100644
> --- a/drivers/net/wimax/i2400m/sysfs.c
> +++ b/drivers/net/wimax/i2400m/sysfs.c
> @@ -65,8 +65,7 @@ ssize_t i2400m_idle_timeout_store(struct device
> *dev,
>  }
>  
>  static
> -DEVICE_ATTR(i2400m_idle_timeout, S_IWUSR,
> -	    NULL, i2400m_idle_timeout_store);
> +DEVICE_ATTR_WO(i2400m_idle_timeout);
>  
>  static
>  struct attribute *i2400m_dev_attrs[] = {
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c
> b/drivers/scsi/lpfc/lpfc_attr.c
> index 517ff203cfde..6ddaf51a23f6 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -2418,8 +2418,7 @@ lpfc_soft_wwn_enable_store(struct device *dev,
> struct device_attribute *attr,
>  
>  	return count;
>  }
> -static DEVICE_ATTR(lpfc_soft_wwn_enable, S_IWUSR, NULL,
> -		   lpfc_soft_wwn_enable_store);
> +static DEVICE_ATTR_WO(lpfc_soft_wwn_enable);
>  
>  /**
>   * lpfc_soft_wwpn_show - Return the cfg soft ww port name of the
> adapter
> diff --git a/drivers/thermal/thermal_sysfs.c
> b/drivers/thermal/thermal_sysfs.c
> index 2bc964392924..ba81c9080f6e 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -317,7 +317,7 @@ emul_temp_store(struct device *dev, struct
> device_attribute *attr,
>  
>  	return ret ? ret : count;
>  }
> -static DEVICE_ATTR(emul_temp, S_IWUSR, NULL, emul_temp_store);
> +static DEVICE_ATTR_WO(emul_temp);
>  #endif
>  
>  static ssize_t
