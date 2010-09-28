From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC] libsas: modifying libsas port creation
Date: Mon, 27 Sep 2010 17:03:51 -0700
Message-ID: <AANLkTinnh4=7sT+Jhx7px-mK37CZ17J-_bYEsSyKOoKC@mail.gmail.com>
References: <86810401A1B22346A09CBA649BE561E90133F6445B@azsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35465 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab0I1ADz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2010 20:03:55 -0400
Received: by wyb28 with SMTP id 28so4450422wyb.19
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2010 17:03:53 -0700 (PDT)
In-Reply-To: <86810401A1B22346A09CBA649BE561E90133F6445B@azsmsx505.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Thomson, Patrick S" <patrick.s.thomson@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Marushak, Nathan" <nathan.marushak@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Jeppsen, Roger C" <roger.c.jeppsen@intel.com>

Hi Pat,

General comments / questions below:

On Mon, Sep 27, 2010 at 4:14 PM, Thomson, Patrick S
<patrick.s.thomson@intel.com> wrote:
> Hello,
>
> I'm working on a SAS driver for Intel's Patsburg chipset and ran acro=
ss a problem (for me) when libsas creates a port. Specifically, it appe=
ars that libsas will use only use the attached sas address when creatin=
g a port, instead of the sas address on each side of the link. What I'd=
 like to propose is to modify port creation such that, based on a flag =
stored in struct sas_ha_struct, that the SAS address on the initiator s=
ide can be taken into account. If the flag is not set, then the origina=
l behavior is in force.
>
> The main point is that the original behavior is the default, and if a=
nyone wants to use the modified port creation, they call sas_ha_struct.=
notify_libsas_config() right after sas_ha_register during module init.
>

Shouldn't this just be the default without a configuration option?
=46or cases where port->sas_addr !=3D phy->sas_addr I assume you would
always want this new behavior regardless of the flag??

> Thanks!
> Pat Thomson
>
> diff -Nau old/include/scsi/libsas.h new/include/scsi/libsas.h
> --- old/include/scsi/libsas.h =A0 2010-09-27 14:23:14.142380393 -0700
> +++ new/include/scsi/libsas.h =A0 2010-09-27 15:26:38.040818779 -0700
> @@ -89,6 +89,11 @@
> =A0 =A0 =A0 =A0DISC_NUM_EVENTS =A0 =A0 =A0 =A0 =3D 3,
> =A0};
>
> +enum cfg_state {
> + =A0 =A0 =A0 CFGE_USE_HOST_TARGET_SAS =3D 0U, /* struct sas_ha_struc=
t.use_host_phy_addr */
> + =A0 =A0 =A0 CFGE_USE_ONLY_TARGET_SAS =3D 1, =A0/* struct sas_ha_str=
uct.use_host_phy_addr */
> +};
> +
> =A0/* ---------- Expander Devices ---------- */
>
> =A0#define to_dom_device(_obj) container_of(_obj, struct domain_devic=
e, dev_obj)
> @@ -344,6 +349,9 @@
>
> =A0 =A0 =A0 =A0struct scsi_core core;
>
> + =A0 =A0 =A0 spinlock_t =A0 =A0 =A0 =A0libsas_config_lock;
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0use_host_phy_addr; /* defaults =
to 0 */
> +

Reading an int is assumed atomic so we wouldn't need a lock to set or
clear this flag.  Something like this would be better done at init
time.  Maybe if you needed it for ordering you could do something like

use_host_phy_addr=3D1
spin_lock();
spin_unlock();

=2E..but that does not appear to be the case here.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
