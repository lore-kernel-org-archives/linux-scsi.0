From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: [-next PATCH 3/4] treewide: Use DEVICE_ATTR_RO
Date: Thu, 21 Dec 2017 08:55:51 +0100
Message-ID: <ca11161c-d1cb-9cce-ae00-3ae7fa59fdd1@linux.vnet.ibm.com>
References: <cover.1513706701.git.joe@perches.com>
 <2e64e7d278fa9e4e255221fb84717884a7bfb69c.1513706701.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1831014135=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <2e64e7d278fa9e4e255221fb84717884a7bfb69c.1513706701.git.joe@perches.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Joe Perches <joe@perches.com>, Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, Robert Jarzmik <robert.jarzmik@free.fr>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Corey Minyard <minyard@acm.org>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, Harald Freudenberger <freude@de.ibm.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: alsa-devel@alsa-project.org, Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org, David Airlie <airlied@linux.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>, dri-devel@lists.freedesktop.org, Takashi Iwai <tiwai@suse.com>, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, esc.storagedev@microsemi.com, Russell King <linux@armlinux.org.uk>, linux-acpi@vger.kernel.org, linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-nvme@lists.infradead.org, openipmi-developer@lists.sourceforge.net, Jaroslav Kysela <perex@perex.cz>, linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Sakari
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--===============1831014135==
Content-Type: multipart/alternative;
 boundary="------------38DDBDF97ED8F21E27F7B2FB"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------38DDBDF97ED8F21E27F7B2FB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 12/19/2017 07:15 PM, Joe Perches wrote:

> Convert DEVICE_ATTR uses to DEVICE_ATTR_RO where possible.
>
> Done with perl script:
>
> $ git grep -w --name-only DEVICE_ATTR | \
>   xargs perl -i -e 'local $/; while (<>) { s/\bDEVICE_ATTR\s*\(\s*(\w+)\s*,\s*\(?(?:\s*S_IRUGO\s*|\s*0444\s*)\)?\s*,\s*\1_show\s*,\s*NULL\s*\)/DEVICE_ATTR_RO(\1)/g; print;}'
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/arm/mach-pxa/sharpsl_pm.c                       |  4 ++--
>  arch/sh/drivers/push-switch.c                        |  2 +-
>  arch/tile/kernel/sysfs.c                             | 10 +++++-----
>  drivers/acpi/device_sysfs.c                          |  6 +++---
>  drivers/char/ipmi/ipmi_msghandler.c                  | 17 ++++++++---------
>  drivers/gpu/drm/i915/i915_sysfs.c                    |  6 +++---
>  drivers/nvme/host/core.c                             | 10 +++++-----
>  drivers/s390/cio/css.c                               |  8 ++++----
>  drivers/s390/cio/device.c                            |  8 ++++----
>  drivers/s390/crypto/ap_card.c                        |  2 +-

For the s390 AP part,

ACK-by: Harald Freudenberger <freude@linux.vnet.ibm.com> Thanks

>  drivers/scsi/hpsa.c                                  | 10 +++++-----
>  drivers/scsi/lpfc/lpfc_attr.c                        | 18 ++++++++----------
>  drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c |  8 ++++----
>  drivers/thermal/thermal_sysfs.c                      |  6 +++---
>  sound/soc/soc-core.c                                 |  2 +-
>  sound/soc/soc-dapm.c                                 |  2 +-
>  16 files changed, 58 insertions(+), 61 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
> index 398ba9ba2632..ef9fd9b759cb 100644
> --- a/arch/arm/mach-pxa/sharpsl_pm.c
> +++ b/arch/arm/mach-pxa/sharpsl_pm.c
> @@ -802,8 +802,8 @@ static ssize_t battery_voltage_show(struct device *dev, struct device_attribute
>  	return sprintf(buf, "%d\n", sharpsl_pm.battstat.mainbat_voltage);
>  }
>
> -static DEVICE_ATTR(battery_percentage, 0444, battery_percentage_show, NULL);
> -static DEVICE_ATTR(battery_voltage, 0444, battery_voltage_show, NULL);
> +static DEVICE_ATTR_RO(battery_percentage);
> +static DEVICE_ATTR_RO(battery_voltage);
>
>  extern void (*apm_get_power_status)(struct apm_power_info *);
>
> diff --git a/arch/sh/drivers/push-switch.c b/arch/sh/drivers/push-switch.c
> index a17181160233..762bc5619910 100644
> --- a/arch/sh/drivers/push-switch.c
> +++ b/arch/sh/drivers/push-switch.c
> @@ -24,7 +24,7 @@ static ssize_t switch_show(struct device *dev,
>  	struct push_switch_platform_info *psw_info = dev->platform_data;
>  	return sprintf(buf, "%s\n", psw_info->name);
>  }
> -static DEVICE_ATTR(switch, S_IRUGO, switch_show, NULL);
> +static DEVICE_ATTR_RO(switch);
>
>  static void switch_timer(struct timer_list *t)
>  {
> diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
> index af5024f0fb5a..b09456a3d77a 100644
> --- a/arch/tile/kernel/sysfs.c
> +++ b/arch/tile/kernel/sysfs.c
> @@ -38,7 +38,7 @@ static ssize_t chip_width_show(struct device *dev,
>  {
>  	return sprintf(page, "%u\n", smp_width);
>  }
> -static DEVICE_ATTR(chip_width, 0444, chip_width_show, NULL);
> +static DEVICE_ATTR_RO(chip_width);
>
>  static ssize_t chip_height_show(struct device *dev,
>  				struct device_attribute *attr,
> @@ -46,7 +46,7 @@ static ssize_t chip_height_show(struct device *dev,
>  {
>  	return sprintf(page, "%u\n", smp_height);
>  }
> -static DEVICE_ATTR(chip_height, 0444, chip_height_show, NULL);
> +static DEVICE_ATTR_RO(chip_height);
>
>  static ssize_t chip_serial_show(struct device *dev,
>  				struct device_attribute *attr,
> @@ -54,7 +54,7 @@ static ssize_t chip_serial_show(struct device *dev,
>  {
>  	return get_hv_confstr(page, HV_CONFSTR_CHIP_SERIAL_NUM);
>  }
> -static DEVICE_ATTR(chip_serial, 0444, chip_serial_show, NULL);
> +static DEVICE_ATTR_RO(chip_serial);
>
>  static ssize_t chip_revision_show(struct device *dev,
>  				  struct device_attribute *attr,
> @@ -62,7 +62,7 @@ static ssize_t chip_revision_show(struct device *dev,
>  {
>  	return get_hv_confstr(page, HV_CONFSTR_CHIP_REV);
>  }
> -static DEVICE_ATTR(chip_revision, 0444, chip_revision_show, NULL);
> +static DEVICE_ATTR_RO(chip_revision);
>
>
>  static ssize_t type_show(struct device *dev,
> @@ -71,7 +71,7 @@ static ssize_t type_show(struct device *dev,
>  {
>  	return sprintf(page, "tilera\n");
>  }
> -static DEVICE_ATTR(type, 0444, type_show, NULL);
> +static DEVICE_ATTR_RO(type);
>
>  #define HV_CONF_ATTR(name, conf)					\
>  	static ssize_t name ## _show(struct device *dev,		\
> diff --git a/drivers/acpi/device_sysfs.c b/drivers/acpi/device_sysfs.c
> index a041689e5701..545e91420cde 100644
> --- a/drivers/acpi/device_sysfs.c
> +++ b/drivers/acpi/device_sysfs.c
> @@ -357,7 +357,7 @@ static ssize_t real_power_state_show(struct device *dev,
>  	return sprintf(buf, "%s\n", acpi_power_state_string(state));
>  }
>
> -static DEVICE_ATTR(real_power_state, 0444, real_power_state_show, NULL);
> +static DEVICE_ATTR_RO(real_power_state);
>
>  static ssize_t power_state_show(struct device *dev,
>  				struct device_attribute *attr, char *buf)
> @@ -367,7 +367,7 @@ static ssize_t power_state_show(struct device *dev,
>  	return sprintf(buf, "%s\n", acpi_power_state_string(adev->power.state));
>  }
>
> -static DEVICE_ATTR(power_state, 0444, power_state_show, NULL);
> +static DEVICE_ATTR_RO(power_state);
>
>  static ssize_t
>  acpi_eject_store(struct device *d, struct device_attribute *attr,
> @@ -462,7 +462,7 @@ static ssize_t description_show(struct device *dev,
>
>  	return result;
>  }
> -static DEVICE_ATTR(description, 0444, description_show, NULL);
> +static DEVICE_ATTR_RO(description);
>
>  static ssize_t
>  acpi_device_sun_show(struct device *dev, struct device_attribute *attr,
> diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
> index f45732a2cb3e..7f51acd74e10 100644
> --- a/drivers/char/ipmi/ipmi_msghandler.c
> +++ b/drivers/char/ipmi/ipmi_msghandler.c
> @@ -2588,7 +2588,7 @@ static ssize_t device_id_show(struct device *dev,
>
>  	return snprintf(buf, 10, "%u\n", id.device_id);
>  }
> -static DEVICE_ATTR(device_id, S_IRUGO, device_id_show, NULL);
> +static DEVICE_ATTR_RO(device_id);
>
>  static ssize_t provides_device_sdrs_show(struct device *dev,
>  					 struct device_attribute *attr,
> @@ -2604,8 +2604,7 @@ static ssize_t provides_device_sdrs_show(struct device *dev,
>
>  	return snprintf(buf, 10, "%u\n", (id.device_revision & 0x80) >> 7);
>  }
> -static DEVICE_ATTR(provides_device_sdrs, S_IRUGO, provides_device_sdrs_show,
> -		   NULL);
> +static DEVICE_ATTR_RO(provides_device_sdrs);
>
>  static ssize_t revision_show(struct device *dev, struct device_attribute *attr,
>  			     char *buf)
> @@ -2620,7 +2619,7 @@ static ssize_t revision_show(struct device *dev, struct device_attribute *attr,
>
>  	return snprintf(buf, 20, "%u\n", id.device_revision & 0x0F);
>  }
> -static DEVICE_ATTR(revision, S_IRUGO, revision_show, NULL);
> +static DEVICE_ATTR_RO(revision);
>
>  static ssize_t firmware_revision_show(struct device *dev,
>  				      struct device_attribute *attr,
> @@ -2637,7 +2636,7 @@ static ssize_t firmware_revision_show(struct device *dev,
>  	return snprintf(buf, 20, "%u.%x\n", id.firmware_revision_1,
>  			id.firmware_revision_2);
>  }
> -static DEVICE_ATTR(firmware_revision, S_IRUGO, firmware_revision_show, NULL);
> +static DEVICE_ATTR_RO(firmware_revision);
>
>  static ssize_t ipmi_version_show(struct device *dev,
>  				 struct device_attribute *attr,
> @@ -2655,7 +2654,7 @@ static ssize_t ipmi_version_show(struct device *dev,
>  			ipmi_version_major(&id),
>  			ipmi_version_minor(&id));
>  }
> -static DEVICE_ATTR(ipmi_version, S_IRUGO, ipmi_version_show, NULL);
> +static DEVICE_ATTR_RO(ipmi_version);
>
>  static ssize_t add_dev_support_show(struct device *dev,
>  				    struct device_attribute *attr,
> @@ -2688,7 +2687,7 @@ static ssize_t manufacturer_id_show(struct device *dev,
>
>  	return snprintf(buf, 20, "0x%6.6x\n", id.manufacturer_id);
>  }
> -static DEVICE_ATTR(manufacturer_id, S_IRUGO, manufacturer_id_show, NULL);
> +static DEVICE_ATTR_RO(manufacturer_id);
>
>  static ssize_t product_id_show(struct device *dev,
>  			       struct device_attribute *attr,
> @@ -2704,7 +2703,7 @@ static ssize_t product_id_show(struct device *dev,
>
>  	return snprintf(buf, 10, "0x%4.4x\n", id.product_id);
>  }
> -static DEVICE_ATTR(product_id, S_IRUGO, product_id_show, NULL);
> +static DEVICE_ATTR_RO(product_id);
>
>  static ssize_t aux_firmware_rev_show(struct device *dev,
>  				     struct device_attribute *attr,
> @@ -2742,7 +2741,7 @@ static ssize_t guid_show(struct device *dev, struct device_attribute *attr,
>
>  	return snprintf(buf, 38, "%pUl\n", guid.b);
>  }
> -static DEVICE_ATTR(guid, S_IRUGO, guid_show, NULL);
> +static DEVICE_ATTR_RO(guid);
>
>  static struct attribute *bmc_dev_attrs[] = {
>  	&dev_attr_device_id.attr,
> diff --git a/drivers/gpu/drm/i915/i915_sysfs.c b/drivers/gpu/drm/i915/i915_sysfs.c
> index 1d0ab8ff5915..b33d2158c234 100644
> --- a/drivers/gpu/drm/i915/i915_sysfs.c
> +++ b/drivers/gpu/drm/i915/i915_sysfs.c
> @@ -445,13 +445,13 @@ static ssize_t gt_min_freq_mhz_store(struct device *kdev,
>  	return ret ?: count;
>  }
>
> -static DEVICE_ATTR(gt_act_freq_mhz, S_IRUGO, gt_act_freq_mhz_show, NULL);
> -static DEVICE_ATTR(gt_cur_freq_mhz, S_IRUGO, gt_cur_freq_mhz_show, NULL);
> +static DEVICE_ATTR_RO(gt_act_freq_mhz);
> +static DEVICE_ATTR_RO(gt_cur_freq_mhz);
>  static DEVICE_ATTR_RW(gt_boost_freq_mhz);
>  static DEVICE_ATTR_RW(gt_max_freq_mhz);
>  static DEVICE_ATTR_RW(gt_min_freq_mhz);
>
> -static DEVICE_ATTR(vlv_rpe_freq_mhz, S_IRUGO, vlv_rpe_freq_mhz_show, NULL);
> +static DEVICE_ATTR_RO(vlv_rpe_freq_mhz);
>
>  static ssize_t gt_rp_mhz_show(struct device *kdev, struct device_attribute *attr, char *buf);
>  static DEVICE_ATTR(gt_RP0_freq_mhz, S_IRUGO, gt_rp_mhz_show, NULL);
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 63691e251f8c..8f9fa6f1dfb4 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2516,14 +2516,14 @@ static ssize_t wwid_show(struct device *dev, struct device_attribute *attr,
>  		serial_len, subsys->serial, model_len, subsys->model,
>  		head->ns_id);
>  }
> -static DEVICE_ATTR(wwid, S_IRUGO, wwid_show, NULL);
> +static DEVICE_ATTR_RO(wwid);
>
>  static ssize_t nguid_show(struct device *dev, struct device_attribute *attr,
>  		char *buf)
>  {
>  	return sprintf(buf, "%pU\n", dev_to_ns_head(dev)->ids.nguid);
>  }
> -static DEVICE_ATTR(nguid, S_IRUGO, nguid_show, NULL);
> +static DEVICE_ATTR_RO(nguid);
>
>  static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
>  		char *buf)
> @@ -2540,21 +2540,21 @@ static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
>  	}
>  	return sprintf(buf, "%pU\n", &ids->uuid);
>  }
> -static DEVICE_ATTR(uuid, S_IRUGO, uuid_show, NULL);
> +static DEVICE_ATTR_RO(uuid);
>
>  static ssize_t eui_show(struct device *dev, struct device_attribute *attr,
>  		char *buf)
>  {
>  	return sprintf(buf, "%8ph\n", dev_to_ns_head(dev)->ids.eui64);
>  }
> -static DEVICE_ATTR(eui, S_IRUGO, eui_show, NULL);
> +static DEVICE_ATTR_RO(eui);
>
>  static ssize_t nsid_show(struct device *dev, struct device_attribute *attr,
>  		char *buf)
>  {
>  	return sprintf(buf, "%d\n", dev_to_ns_head(dev)->ns_id);
>  }
> -static DEVICE_ATTR(nsid, S_IRUGO, nsid_show, NULL);
> +static DEVICE_ATTR_RO(nsid);
>
>  static struct attribute *nvme_ns_id_attrs[] = {
>  	&dev_attr_wwid.attr,
> diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
> index 0f11dce6e224..9263a0fb3858 100644
> --- a/drivers/s390/cio/css.c
> +++ b/drivers/s390/cio/css.c
> @@ -268,7 +268,7 @@ static ssize_t type_show(struct device *dev, struct device_attribute *attr,
>  	return sprintf(buf, "%01x\n", sch->st);
>  }
>
> -static DEVICE_ATTR(type, 0444, type_show, NULL);
> +static DEVICE_ATTR_RO(type);
>
>  static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
>  			     char *buf)
> @@ -278,7 +278,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
>  	return sprintf(buf, "css:t%01X\n", sch->st);
>  }
>
> -static DEVICE_ATTR(modalias, 0444, modalias_show, NULL);
> +static DEVICE_ATTR_RO(modalias);
>
>  static struct attribute *subch_attrs[] = {
>  	&dev_attr_type.attr,
> @@ -315,7 +315,7 @@ static ssize_t chpids_show(struct device *dev,
>  	ret += sprintf(buf + ret, "\n");
>  	return ret;
>  }
> -static DEVICE_ATTR(chpids, 0444, chpids_show, NULL);
> +static DEVICE_ATTR_RO(chpids);
>
>  static ssize_t pimpampom_show(struct device *dev,
>  			      struct device_attribute *attr,
> @@ -327,7 +327,7 @@ static ssize_t pimpampom_show(struct device *dev,
>  	return sprintf(buf, "%02x %02x %02x\n",
>  		       pmcw->pim, pmcw->pam, pmcw->pom);
>  }
> -static DEVICE_ATTR(pimpampom, 0444, pimpampom_show, NULL);
> +static DEVICE_ATTR_RO(pimpampom);
>
>  static struct attribute *io_subchannel_type_attrs[] = {
>  	&dev_attr_chpids.attr,
> diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
> index 6eefb67b31f3..f50ea035aa9b 100644
> --- a/drivers/s390/cio/device.c
> +++ b/drivers/s390/cio/device.c
> @@ -597,13 +597,13 @@ static ssize_t vpm_show(struct device *dev, struct device_attribute *attr,
>  	return sprintf(buf, "%02x\n", sch->vpm);
>  }
>
> -static DEVICE_ATTR(devtype, 0444, devtype_show, NULL);
> -static DEVICE_ATTR(cutype, 0444, cutype_show, NULL);
> -static DEVICE_ATTR(modalias, 0444, modalias_show, NULL);
> +static DEVICE_ATTR_RO(devtype);
> +static DEVICE_ATTR_RO(cutype);
> +static DEVICE_ATTR_RO(modalias);
>  static DEVICE_ATTR_RW(online);
>  static DEVICE_ATTR(availability, 0444, available_show, NULL);
>  static DEVICE_ATTR(logging, 0200, NULL, initiate_logging);
> -static DEVICE_ATTR(vpm, 0444, vpm_show, NULL);
> +static DEVICE_ATTR_RO(vpm);
>
>  static struct attribute *io_subchannel_attrs[] = {
>  	&dev_attr_logging.attr,
> diff --git a/drivers/s390/crypto/ap_card.c b/drivers/s390/crypto/ap_card.c
> index 97a8cf578116..2c726df210f6 100644
> --- a/drivers/s390/crypto/ap_card.c
> +++ b/drivers/s390/crypto/ap_card.c
> @@ -57,7 +57,7 @@ static ssize_t ap_functions_show(struct device *dev,
>  	return snprintf(buf, PAGE_SIZE, "0x%08X\n", ac->functions);
>  }
>
> -static DEVICE_ATTR(ap_functions, 0444, ap_functions_show, NULL);
> +static DEVICE_ATTR_RO(ap_functions);
>
>  static ssize_t ap_req_count_show(struct device *dev,
>  				 struct device_attribute *attr,
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index b0aa5dc1d54c..d62377b68ef4 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -901,14 +901,14 @@ static ssize_t host_show_legacy_board(struct device *dev,
>  	return snprintf(buf, 20, "%d\n", h->legacy_board ? 1 : 0);
>  }
>
> -static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
> -static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
> -static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
> +static DEVICE_ATTR_RO(raid_level);
> +static DEVICE_ATTR_RO(lunid);
> +static DEVICE_ATTR_RO(unique_id);
>  static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
> -static DEVICE_ATTR(sas_address, S_IRUGO, sas_address_show, NULL);
> +static DEVICE_ATTR_RO(sas_address);
>  static DEVICE_ATTR(hp_ssd_smart_path_enabled, S_IRUGO,
>  			host_show_hp_ssd_smart_path_enabled, NULL);
> -static DEVICE_ATTR(path_info, S_IRUGO, path_info_show, NULL);
> +static DEVICE_ATTR_RO(path_info);
>  static DEVICE_ATTR(hp_ssd_smart_path_status, S_IWUSR|S_IRUGO|S_IROTH,
>  		host_show_hp_ssd_smart_path_status,
>  		host_store_hp_ssd_smart_path_status);
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 95f7ba3c3f1a..517ff203cfde 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -2294,8 +2294,8 @@ static DEVICE_ATTR(num_discovered_ports, S_IRUGO,
>  		   lpfc_num_discovered_ports_show, NULL);
>  static DEVICE_ATTR(menlo_mgmt_mode, S_IRUGO, lpfc_mlomgmt_show, NULL);
>  static DEVICE_ATTR(nport_evt_cnt, S_IRUGO, lpfc_nport_evt_cnt_show, NULL);
> -static DEVICE_ATTR(lpfc_drvr_version, S_IRUGO, lpfc_drvr_version_show, NULL);
> -static DEVICE_ATTR(lpfc_enable_fip, S_IRUGO, lpfc_enable_fip_show, NULL);
> +static DEVICE_ATTR_RO(lpfc_drvr_version);
> +static DEVICE_ATTR_RO(lpfc_enable_fip);
>  static DEVICE_ATTR(board_mode, S_IRUGO | S_IWUSR,
>  		   lpfc_board_mode_show, lpfc_board_mode_store);
>  static DEVICE_ATTR(issue_reset, S_IWUSR, NULL, lpfc_issue_reset);
> @@ -2306,12 +2306,11 @@ static DEVICE_ATTR(used_rpi, S_IRUGO, lpfc_used_rpi_show, NULL);
>  static DEVICE_ATTR(max_xri, S_IRUGO, lpfc_max_xri_show, NULL);
>  static DEVICE_ATTR(used_xri, S_IRUGO, lpfc_used_xri_show, NULL);
>  static DEVICE_ATTR(npiv_info, S_IRUGO, lpfc_npiv_info_show, NULL);
> -static DEVICE_ATTR(lpfc_temp_sensor, S_IRUGO, lpfc_temp_sensor_show, NULL);
> -static DEVICE_ATTR(lpfc_fips_level, S_IRUGO, lpfc_fips_level_show, NULL);
> -static DEVICE_ATTR(lpfc_fips_rev, S_IRUGO, lpfc_fips_rev_show, NULL);
> -static DEVICE_ATTR(lpfc_dss, S_IRUGO, lpfc_dss_show, NULL);
> -static DEVICE_ATTR(lpfc_sriov_hw_max_virtfn, S_IRUGO,
> -		   lpfc_sriov_hw_max_virtfn_show, NULL);
> +static DEVICE_ATTR_RO(lpfc_temp_sensor);
> +static DEVICE_ATTR_RO(lpfc_fips_level);
> +static DEVICE_ATTR_RO(lpfc_fips_rev);
> +static DEVICE_ATTR_RO(lpfc_dss);
> +static DEVICE_ATTR_RO(lpfc_sriov_hw_max_virtfn);
>  static DEVICE_ATTR(protocol, S_IRUGO, lpfc_sli4_protocol_show, NULL);
>  static DEVICE_ATTR(lpfc_xlane_supported, S_IRUGO, lpfc_oas_supported_show,
>  		   NULL);
> @@ -3719,8 +3718,7 @@ lpfc_static_vport_show(struct device *dev, struct device_attribute *attr,
>  /*
>   * Sysfs attribute to control the statistical data collection.
>   */
> -static DEVICE_ATTR(lpfc_static_vport, S_IRUGO,
> -		   lpfc_static_vport_show, NULL);
> +static DEVICE_ATTR_RO(lpfc_static_vport);
>
>  /**
>   * lpfc_stat_data_ctrl_store - write call back for lpfc_stat_data_ctrl sysfs file
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
> index a1c81c12718c..4338b8a1309f 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
> @@ -158,10 +158,10 @@ static ssize_t dynamic_pool_show(struct device *dev,
>  	return ret;
>  };
>
> -static DEVICE_ATTR(active_bo, 0444, active_bo_show, NULL);
> -static DEVICE_ATTR(free_bo, 0444, free_bo_show, NULL);
> -static DEVICE_ATTR(reserved_pool, 0444, reserved_pool_show, NULL);
> -static DEVICE_ATTR(dynamic_pool, 0444, dynamic_pool_show, NULL);
> +static DEVICE_ATTR_RO(active_bo);
> +static DEVICE_ATTR_RO(free_bo);
> +static DEVICE_ATTR_RO(reserved_pool);
> +static DEVICE_ATTR_RO(dynamic_pool);
>
>  static struct attribute *sysfs_attrs_ctrl[] = {
>  	&dev_attr_active_bo.attr,
> diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> index c008af7fb480..2bc964392924 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -396,10 +396,10 @@ create_s32_tzp_attr(offset);
>   * All the attributes created for tzp (create_s32_tzp_attr) also are always
>   * present on the sysfs interface.
>   */
> -static DEVICE_ATTR(type, 0444, type_show, NULL);
> -static DEVICE_ATTR(temp, 0444, temp_show, NULL);
> +static DEVICE_ATTR_RO(type);
> +static DEVICE_ATTR_RO(temp);
>  static DEVICE_ATTR_RW(policy);
> -static DEVICE_ATTR(available_policies, S_IRUGO, available_policies_show, NULL);
> +static DEVICE_ATTR_RO(available_policies);
>  static DEVICE_ATTR_RW(sustainable_power);
>
>  /* These thermal zone device attributes are created based on conditions */
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index 2d392f2d7ffe..9a380e55f4af 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -173,7 +173,7 @@ static ssize_t codec_reg_show(struct device *dev,
>  	return soc_codec_reg_show(rtd->codec, buf, PAGE_SIZE, 0);
>  }
>
> -static DEVICE_ATTR(codec_reg, 0444, codec_reg_show, NULL);
> +static DEVICE_ATTR_RO(codec_reg);
>
>  static ssize_t pmdown_time_show(struct device *dev,
>  				struct device_attribute *attr, char *buf)
> diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> index a10b21cfc31e..d1977ced895f 100644
> --- a/sound/soc/soc-dapm.c
> +++ b/sound/soc/soc-dapm.c
> @@ -2364,7 +2364,7 @@ static ssize_t dapm_widget_show(struct device *dev,
>  	return count;
>  }
>
> -static DEVICE_ATTR(dapm_widget, 0444, dapm_widget_show, NULL);
> +static DEVICE_ATTR_RO(dapm_widget);
>
>  struct attribute *soc_dapm_dev_attrs[] = {
>  	&dev_attr_dapm_widget.attr,


--------------38DDBDF97ED8F21E27F7B2FB
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <pre>On 12/19/2017 07:15 PM, Joe Perches wrote:</pre>
    <blockquote type="cite"
cite="mid:2e64e7d278fa9e4e255221fb84717884a7bfb69c.1513706701.git.joe@perches.com">
      <pre wrap="">Convert DEVICE_ATTR uses to DEVICE_ATTR_RO where possible.

Done with perl script:

$ git grep -w --name-only DEVICE_ATTR | \
  xargs perl -i -e 'local $/; while (&lt;&gt;) { s/\bDEVICE_ATTR\s*\(\s*(\w+)\s*,\s*\(?(?:\s*S_IRUGO\s*|\s*0444\s*)\)?\s*,\s*\1_show\s*,\s*NULL\s*\)/DEVICE_ATTR_RO(\1)/g; print;}'

Signed-off-by: Joe Perches <a class="moz-txt-link-rfc2396E" href="mailto:joe@perches.com">&lt;joe@perches.com&gt;</a>
---
 arch/arm/mach-pxa/sharpsl_pm.c                       |  4 ++--
 arch/sh/drivers/push-switch.c                        |  2 +-
 arch/tile/kernel/sysfs.c                             | 10 +++++-----
 drivers/acpi/device_sysfs.c                          |  6 +++---
 drivers/char/ipmi/ipmi_msghandler.c                  | 17 ++++++++---------
 drivers/gpu/drm/i915/i915_sysfs.c                    |  6 +++---
 drivers/nvme/host/core.c                             | 10 +++++-----
 drivers/s390/cio/css.c                               |  8 ++++----
 drivers/s390/cio/device.c                            |  8 ++++----
 drivers/s390/crypto/ap_card.c                        |  2 +-</pre>
    </blockquote>
    <pre><font face="Courier New, Courier, monospace">For the s390 AP part,
</font></pre>
    <pre><font face="Courier New, Courier, monospace">ACK-by: Harald Freudenberger <a class="moz-txt-link-rfc2396E" href="mailto:freude@linux.vnet.ibm.com">&lt;freude@linux.vnet.ibm.com&gt;</a>

Thanks
</font></pre>
    <blockquote type="cite"
cite="mid:2e64e7d278fa9e4e255221fb84717884a7bfb69c.1513706701.git.joe@perches.com">
      <pre wrap="">
 drivers/scsi/hpsa.c                                  | 10 +++++-----
 drivers/scsi/lpfc/lpfc_attr.c                        | 18 ++++++++----------
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c |  8 ++++----
 drivers/thermal/thermal_sysfs.c                      |  6 +++---
 sound/soc/soc-core.c                                 |  2 +-
 sound/soc/soc-dapm.c                                 |  2 +-
 16 files changed, 58 insertions(+), 61 deletions(-)

diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 398ba9ba2632..ef9fd9b759cb 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -802,8 +802,8 @@ static ssize_t battery_voltage_show(struct device *dev, struct device_attribute
 	return sprintf(buf, "%d\n", sharpsl_pm.battstat.mainbat_voltage);
 }

-static DEVICE_ATTR(battery_percentage, 0444, battery_percentage_show, NULL);
-static DEVICE_ATTR(battery_voltage, 0444, battery_voltage_show, NULL);
+static DEVICE_ATTR_RO(battery_percentage);
+static DEVICE_ATTR_RO(battery_voltage);

 extern void (*apm_get_power_status)(struct apm_power_info *);

diff --git a/arch/sh/drivers/push-switch.c b/arch/sh/drivers/push-switch.c
index a17181160233..762bc5619910 100644
--- a/arch/sh/drivers/push-switch.c
+++ b/arch/sh/drivers/push-switch.c
@@ -24,7 +24,7 @@ static ssize_t switch_show(struct device *dev,
 	struct push_switch_platform_info *psw_info = dev-&gt;platform_data;
 	return sprintf(buf, "%s\n", psw_info-&gt;name);
 }
-static DEVICE_ATTR(switch, S_IRUGO, switch_show, NULL);
+static DEVICE_ATTR_RO(switch);

 static void switch_timer(struct timer_list *t)
 {
diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
index af5024f0fb5a..b09456a3d77a 100644
--- a/arch/tile/kernel/sysfs.c
+++ b/arch/tile/kernel/sysfs.c
@@ -38,7 +38,7 @@ static ssize_t chip_width_show(struct device *dev,
 {
 	return sprintf(page, "%u\n", smp_width);
 }
-static DEVICE_ATTR(chip_width, 0444, chip_width_show, NULL);
+static DEVICE_ATTR_RO(chip_width);

 static ssize_t chip_height_show(struct device *dev,
 				struct device_attribute *attr,
@@ -46,7 +46,7 @@ static ssize_t chip_height_show(struct device *dev,
 {
 	return sprintf(page, "%u\n", smp_height);
 }
-static DEVICE_ATTR(chip_height, 0444, chip_height_show, NULL);
+static DEVICE_ATTR_RO(chip_height);

 static ssize_t chip_serial_show(struct device *dev,
 				struct device_attribute *attr,
@@ -54,7 +54,7 @@ static ssize_t chip_serial_show(struct device *dev,
 {
 	return get_hv_confstr(page, HV_CONFSTR_CHIP_SERIAL_NUM);
 }
-static DEVICE_ATTR(chip_serial, 0444, chip_serial_show, NULL);
+static DEVICE_ATTR_RO(chip_serial);

 static ssize_t chip_revision_show(struct device *dev,
 				  struct device_attribute *attr,
@@ -62,7 +62,7 @@ static ssize_t chip_revision_show(struct device *dev,
 {
 	return get_hv_confstr(page, HV_CONFSTR_CHIP_REV);
 }
-static DEVICE_ATTR(chip_revision, 0444, chip_revision_show, NULL);
+static DEVICE_ATTR_RO(chip_revision);


 static ssize_t type_show(struct device *dev,
@@ -71,7 +71,7 @@ static ssize_t type_show(struct device *dev,
 {
 	return sprintf(page, "tilera\n");
 }
-static DEVICE_ATTR(type, 0444, type_show, NULL);
+static DEVICE_ATTR_RO(type);

 #define HV_CONF_ATTR(name, conf)					\
 	static ssize_t name ## _show(struct device *dev,		\
diff --git a/drivers/acpi/device_sysfs.c b/drivers/acpi/device_sysfs.c
index a041689e5701..545e91420cde 100644
--- a/drivers/acpi/device_sysfs.c
+++ b/drivers/acpi/device_sysfs.c
@@ -357,7 +357,7 @@ static ssize_t real_power_state_show(struct device *dev,
 	return sprintf(buf, "%s\n", acpi_power_state_string(state));
 }

-static DEVICE_ATTR(real_power_state, 0444, real_power_state_show, NULL);
+static DEVICE_ATTR_RO(real_power_state);

 static ssize_t power_state_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -367,7 +367,7 @@ static ssize_t power_state_show(struct device *dev,
 	return sprintf(buf, "%s\n", acpi_power_state_string(adev-&gt;power.state));
 }

-static DEVICE_ATTR(power_state, 0444, power_state_show, NULL);
+static DEVICE_ATTR_RO(power_state);

 static ssize_t
 acpi_eject_store(struct device *d, struct device_attribute *attr,
@@ -462,7 +462,7 @@ static ssize_t description_show(struct device *dev,

 	return result;
 }
-static DEVICE_ATTR(description, 0444, description_show, NULL);
+static DEVICE_ATTR_RO(description);

 static ssize_t
 acpi_device_sun_show(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index f45732a2cb3e..7f51acd74e10 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2588,7 +2588,7 @@ static ssize_t device_id_show(struct device *dev,

 	return snprintf(buf, 10, "%u\n", id.device_id);
 }
-static DEVICE_ATTR(device_id, S_IRUGO, device_id_show, NULL);
+static DEVICE_ATTR_RO(device_id);

 static ssize_t provides_device_sdrs_show(struct device *dev,
 					 struct device_attribute *attr,
@@ -2604,8 +2604,7 @@ static ssize_t provides_device_sdrs_show(struct device *dev,

 	return snprintf(buf, 10, "%u\n", (id.device_revision &amp; 0x80) &gt;&gt; 7);
 }
-static DEVICE_ATTR(provides_device_sdrs, S_IRUGO, provides_device_sdrs_show,
-		   NULL);
+static DEVICE_ATTR_RO(provides_device_sdrs);

 static ssize_t revision_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
@@ -2620,7 +2619,7 @@ static ssize_t revision_show(struct device *dev, struct device_attribute *attr,

 	return snprintf(buf, 20, "%u\n", id.device_revision &amp; 0x0F);
 }
-static DEVICE_ATTR(revision, S_IRUGO, revision_show, NULL);
+static DEVICE_ATTR_RO(revision);

 static ssize_t firmware_revision_show(struct device *dev,
 				      struct device_attribute *attr,
@@ -2637,7 +2636,7 @@ static ssize_t firmware_revision_show(struct device *dev,
 	return snprintf(buf, 20, "%u.%x\n", id.firmware_revision_1,
 			id.firmware_revision_2);
 }
-static DEVICE_ATTR(firmware_revision, S_IRUGO, firmware_revision_show, NULL);
+static DEVICE_ATTR_RO(firmware_revision);

 static ssize_t ipmi_version_show(struct device *dev,
 				 struct device_attribute *attr,
@@ -2655,7 +2654,7 @@ static ssize_t ipmi_version_show(struct device *dev,
 			ipmi_version_major(&amp;id),
 			ipmi_version_minor(&amp;id));
 }
-static DEVICE_ATTR(ipmi_version, S_IRUGO, ipmi_version_show, NULL);
+static DEVICE_ATTR_RO(ipmi_version);

 static ssize_t add_dev_support_show(struct device *dev,
 				    struct device_attribute *attr,
@@ -2688,7 +2687,7 @@ static ssize_t manufacturer_id_show(struct device *dev,

 	return snprintf(buf, 20, "0x%6.6x\n", id.manufacturer_id);
 }
-static DEVICE_ATTR(manufacturer_id, S_IRUGO, manufacturer_id_show, NULL);
+static DEVICE_ATTR_RO(manufacturer_id);

 static ssize_t product_id_show(struct device *dev,
 			       struct device_attribute *attr,
@@ -2704,7 +2703,7 @@ static ssize_t product_id_show(struct device *dev,

 	return snprintf(buf, 10, "0x%4.4x\n", id.product_id);
 }
-static DEVICE_ATTR(product_id, S_IRUGO, product_id_show, NULL);
+static DEVICE_ATTR_RO(product_id);

 static ssize_t aux_firmware_rev_show(struct device *dev,
 				     struct device_attribute *attr,
@@ -2742,7 +2741,7 @@ static ssize_t guid_show(struct device *dev, struct device_attribute *attr,

 	return snprintf(buf, 38, "%pUl\n", guid.b);
 }
-static DEVICE_ATTR(guid, S_IRUGO, guid_show, NULL);
+static DEVICE_ATTR_RO(guid);

 static struct attribute *bmc_dev_attrs[] = {
 	&amp;dev_attr_device_id.attr,
diff --git a/drivers/gpu/drm/i915/i915_sysfs.c b/drivers/gpu/drm/i915/i915_sysfs.c
index 1d0ab8ff5915..b33d2158c234 100644
--- a/drivers/gpu/drm/i915/i915_sysfs.c
+++ b/drivers/gpu/drm/i915/i915_sysfs.c
@@ -445,13 +445,13 @@ static ssize_t gt_min_freq_mhz_store(struct device *kdev,
 	return ret ?: count;
 }

-static DEVICE_ATTR(gt_act_freq_mhz, S_IRUGO, gt_act_freq_mhz_show, NULL);
-static DEVICE_ATTR(gt_cur_freq_mhz, S_IRUGO, gt_cur_freq_mhz_show, NULL);
+static DEVICE_ATTR_RO(gt_act_freq_mhz);
+static DEVICE_ATTR_RO(gt_cur_freq_mhz);
 static DEVICE_ATTR_RW(gt_boost_freq_mhz);
 static DEVICE_ATTR_RW(gt_max_freq_mhz);
 static DEVICE_ATTR_RW(gt_min_freq_mhz);

-static DEVICE_ATTR(vlv_rpe_freq_mhz, S_IRUGO, vlv_rpe_freq_mhz_show, NULL);
+static DEVICE_ATTR_RO(vlv_rpe_freq_mhz);

 static ssize_t gt_rp_mhz_show(struct device *kdev, struct device_attribute *attr, char *buf);
 static DEVICE_ATTR(gt_RP0_freq_mhz, S_IRUGO, gt_rp_mhz_show, NULL);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 63691e251f8c..8f9fa6f1dfb4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2516,14 +2516,14 @@ static ssize_t wwid_show(struct device *dev, struct device_attribute *attr,
 		serial_len, subsys-&gt;serial, model_len, subsys-&gt;model,
 		head-&gt;ns_id);
 }
-static DEVICE_ATTR(wwid, S_IRUGO, wwid_show, NULL);
+static DEVICE_ATTR_RO(wwid);

 static ssize_t nguid_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 	return sprintf(buf, "%pU\n", dev_to_ns_head(dev)-&gt;ids.nguid);
 }
-static DEVICE_ATTR(nguid, S_IRUGO, nguid_show, NULL);
+static DEVICE_ATTR_RO(nguid);

 static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -2540,21 +2540,21 @@ static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
 	}
 	return sprintf(buf, "%pU\n", &amp;ids-&gt;uuid);
 }
-static DEVICE_ATTR(uuid, S_IRUGO, uuid_show, NULL);
+static DEVICE_ATTR_RO(uuid);

 static ssize_t eui_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 	return sprintf(buf, "%8ph\n", dev_to_ns_head(dev)-&gt;ids.eui64);
 }
-static DEVICE_ATTR(eui, S_IRUGO, eui_show, NULL);
+static DEVICE_ATTR_RO(eui);

 static ssize_t nsid_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 	return sprintf(buf, "%d\n", dev_to_ns_head(dev)-&gt;ns_id);
 }
-static DEVICE_ATTR(nsid, S_IRUGO, nsid_show, NULL);
+static DEVICE_ATTR_RO(nsid);

 static struct attribute *nvme_ns_id_attrs[] = {
 	&amp;dev_attr_wwid.attr,
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 0f11dce6e224..9263a0fb3858 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -268,7 +268,7 @@ static ssize_t type_show(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%01x\n", sch-&gt;st);
 }

-static DEVICE_ATTR(type, 0444, type_show, NULL);
+static DEVICE_ATTR_RO(type);

 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
@@ -278,7 +278,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "css:t%01X\n", sch-&gt;st);
 }

-static DEVICE_ATTR(modalias, 0444, modalias_show, NULL);
+static DEVICE_ATTR_RO(modalias);

 static struct attribute *subch_attrs[] = {
 	&amp;dev_attr_type.attr,
@@ -315,7 +315,7 @@ static ssize_t chpids_show(struct device *dev,
 	ret += sprintf(buf + ret, "\n");
 	return ret;
 }
-static DEVICE_ATTR(chpids, 0444, chpids_show, NULL);
+static DEVICE_ATTR_RO(chpids);

 static ssize_t pimpampom_show(struct device *dev,
 			      struct device_attribute *attr,
@@ -327,7 +327,7 @@ static ssize_t pimpampom_show(struct device *dev,
 	return sprintf(buf, "%02x %02x %02x\n",
 		       pmcw-&gt;pim, pmcw-&gt;pam, pmcw-&gt;pom);
 }
-static DEVICE_ATTR(pimpampom, 0444, pimpampom_show, NULL);
+static DEVICE_ATTR_RO(pimpampom);

 static struct attribute *io_subchannel_type_attrs[] = {
 	&amp;dev_attr_chpids.attr,
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 6eefb67b31f3..f50ea035aa9b 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -597,13 +597,13 @@ static ssize_t vpm_show(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%02x\n", sch-&gt;vpm);
 }

-static DEVICE_ATTR(devtype, 0444, devtype_show, NULL);
-static DEVICE_ATTR(cutype, 0444, cutype_show, NULL);
-static DEVICE_ATTR(modalias, 0444, modalias_show, NULL);
+static DEVICE_ATTR_RO(devtype);
+static DEVICE_ATTR_RO(cutype);
+static DEVICE_ATTR_RO(modalias);
 static DEVICE_ATTR_RW(online);
 static DEVICE_ATTR(availability, 0444, available_show, NULL);
 static DEVICE_ATTR(logging, 0200, NULL, initiate_logging);
-static DEVICE_ATTR(vpm, 0444, vpm_show, NULL);
+static DEVICE_ATTR_RO(vpm);

 static struct attribute *io_subchannel_attrs[] = {
 	&amp;dev_attr_logging.attr,
diff --git a/drivers/s390/crypto/ap_card.c b/drivers/s390/crypto/ap_card.c
index 97a8cf578116..2c726df210f6 100644
--- a/drivers/s390/crypto/ap_card.c
+++ b/drivers/s390/crypto/ap_card.c
@@ -57,7 +57,7 @@ static ssize_t ap_functions_show(struct device *dev,
 	return snprintf(buf, PAGE_SIZE, "0x%08X\n", ac-&gt;functions);
 }

-static DEVICE_ATTR(ap_functions, 0444, ap_functions_show, NULL);
+static DEVICE_ATTR_RO(ap_functions);

 static ssize_t ap_req_count_show(struct device *dev,
 				 struct device_attribute *attr,
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b0aa5dc1d54c..d62377b68ef4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -901,14 +901,14 @@ static ssize_t host_show_legacy_board(struct device *dev,
 	return snprintf(buf, 20, "%d\n", h-&gt;legacy_board ? 1 : 0);
 }

-static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
-static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
-static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
+static DEVICE_ATTR_RO(raid_level);
+static DEVICE_ATTR_RO(lunid);
+static DEVICE_ATTR_RO(unique_id);
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
-static DEVICE_ATTR(sas_address, S_IRUGO, sas_address_show, NULL);
+static DEVICE_ATTR_RO(sas_address);
 static DEVICE_ATTR(hp_ssd_smart_path_enabled, S_IRUGO,
 			host_show_hp_ssd_smart_path_enabled, NULL);
-static DEVICE_ATTR(path_info, S_IRUGO, path_info_show, NULL);
+static DEVICE_ATTR_RO(path_info);
 static DEVICE_ATTR(hp_ssd_smart_path_status, S_IWUSR|S_IRUGO|S_IROTH,
 		host_show_hp_ssd_smart_path_status,
 		host_store_hp_ssd_smart_path_status);
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 95f7ba3c3f1a..517ff203cfde 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2294,8 +2294,8 @@ static DEVICE_ATTR(num_discovered_ports, S_IRUGO,
 		   lpfc_num_discovered_ports_show, NULL);
 static DEVICE_ATTR(menlo_mgmt_mode, S_IRUGO, lpfc_mlomgmt_show, NULL);
 static DEVICE_ATTR(nport_evt_cnt, S_IRUGO, lpfc_nport_evt_cnt_show, NULL);
-static DEVICE_ATTR(lpfc_drvr_version, S_IRUGO, lpfc_drvr_version_show, NULL);
-static DEVICE_ATTR(lpfc_enable_fip, S_IRUGO, lpfc_enable_fip_show, NULL);
+static DEVICE_ATTR_RO(lpfc_drvr_version);
+static DEVICE_ATTR_RO(lpfc_enable_fip);
 static DEVICE_ATTR(board_mode, S_IRUGO | S_IWUSR,
 		   lpfc_board_mode_show, lpfc_board_mode_store);
 static DEVICE_ATTR(issue_reset, S_IWUSR, NULL, lpfc_issue_reset);
@@ -2306,12 +2306,11 @@ static DEVICE_ATTR(used_rpi, S_IRUGO, lpfc_used_rpi_show, NULL);
 static DEVICE_ATTR(max_xri, S_IRUGO, lpfc_max_xri_show, NULL);
 static DEVICE_ATTR(used_xri, S_IRUGO, lpfc_used_xri_show, NULL);
 static DEVICE_ATTR(npiv_info, S_IRUGO, lpfc_npiv_info_show, NULL);
-static DEVICE_ATTR(lpfc_temp_sensor, S_IRUGO, lpfc_temp_sensor_show, NULL);
-static DEVICE_ATTR(lpfc_fips_level, S_IRUGO, lpfc_fips_level_show, NULL);
-static DEVICE_ATTR(lpfc_fips_rev, S_IRUGO, lpfc_fips_rev_show, NULL);
-static DEVICE_ATTR(lpfc_dss, S_IRUGO, lpfc_dss_show, NULL);
-static DEVICE_ATTR(lpfc_sriov_hw_max_virtfn, S_IRUGO,
-		   lpfc_sriov_hw_max_virtfn_show, NULL);
+static DEVICE_ATTR_RO(lpfc_temp_sensor);
+static DEVICE_ATTR_RO(lpfc_fips_level);
+static DEVICE_ATTR_RO(lpfc_fips_rev);
+static DEVICE_ATTR_RO(lpfc_dss);
+static DEVICE_ATTR_RO(lpfc_sriov_hw_max_virtfn);
 static DEVICE_ATTR(protocol, S_IRUGO, lpfc_sli4_protocol_show, NULL);
 static DEVICE_ATTR(lpfc_xlane_supported, S_IRUGO, lpfc_oas_supported_show,
 		   NULL);
@@ -3719,8 +3718,7 @@ lpfc_static_vport_show(struct device *dev, struct device_attribute *attr,
 /*
  * Sysfs attribute to control the statistical data collection.
  */
-static DEVICE_ATTR(lpfc_static_vport, S_IRUGO,
-		   lpfc_static_vport_show, NULL);
+static DEVICE_ATTR_RO(lpfc_static_vport);

 /**
  * lpfc_stat_data_ctrl_store - write call back for lpfc_stat_data_ctrl sysfs file
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index a1c81c12718c..4338b8a1309f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -158,10 +158,10 @@ static ssize_t dynamic_pool_show(struct device *dev,
 	return ret;
 };

-static DEVICE_ATTR(active_bo, 0444, active_bo_show, NULL);
-static DEVICE_ATTR(free_bo, 0444, free_bo_show, NULL);
-static DEVICE_ATTR(reserved_pool, 0444, reserved_pool_show, NULL);
-static DEVICE_ATTR(dynamic_pool, 0444, dynamic_pool_show, NULL);
+static DEVICE_ATTR_RO(active_bo);
+static DEVICE_ATTR_RO(free_bo);
+static DEVICE_ATTR_RO(reserved_pool);
+static DEVICE_ATTR_RO(dynamic_pool);

 static struct attribute *sysfs_attrs_ctrl[] = {
 	&amp;dev_attr_active_bo.attr,
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index c008af7fb480..2bc964392924 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -396,10 +396,10 @@ create_s32_tzp_attr(offset);
  * All the attributes created for tzp (create_s32_tzp_attr) also are always
  * present on the sysfs interface.
  */
-static DEVICE_ATTR(type, 0444, type_show, NULL);
-static DEVICE_ATTR(temp, 0444, temp_show, NULL);
+static DEVICE_ATTR_RO(type);
+static DEVICE_ATTR_RO(temp);
 static DEVICE_ATTR_RW(policy);
-static DEVICE_ATTR(available_policies, S_IRUGO, available_policies_show, NULL);
+static DEVICE_ATTR_RO(available_policies);
 static DEVICE_ATTR_RW(sustainable_power);

 /* These thermal zone device attributes are created based on conditions */
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 2d392f2d7ffe..9a380e55f4af 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -173,7 +173,7 @@ static ssize_t codec_reg_show(struct device *dev,
 	return soc_codec_reg_show(rtd-&gt;codec, buf, PAGE_SIZE, 0);
 }

-static DEVICE_ATTR(codec_reg, 0444, codec_reg_show, NULL);
+static DEVICE_ATTR_RO(codec_reg);

 static ssize_t pmdown_time_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index a10b21cfc31e..d1977ced895f 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2364,7 +2364,7 @@ static ssize_t dapm_widget_show(struct device *dev,
 	return count;
 }

-static DEVICE_ATTR(dapm_widget, 0444, dapm_widget_show, NULL);
+static DEVICE_ATTR_RO(dapm_widget);

 struct attribute *soc_dapm_dev_attrs[] = {
 	&amp;dev_attr_dapm_widget.attr,
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------38DDBDF97ED8F21E27F7B2FB--


--===============1831014135==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==

--===============1831014135==--
