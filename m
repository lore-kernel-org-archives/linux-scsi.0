From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC] libsas: modifying libsas port creation
Date: Tue, 28 Sep 2010 12:34:35 -0700
Message-ID: <AANLkTikdEXgrffj8sT=TW_fhqs+1EW3+5ktfY+jZhEH-@mail.gmail.com>
References: <86810401A1B22346A09CBA649BE561E90133F6445B@azsmsx505.amr.corp.intel.com>
	<AANLkTinnh4=7sT+Jhx7px-mK37CZ17J-_bYEsSyKOoKC@mail.gmail.com>
	<SNT126-W423EB4A9F109822A4B728CCE660@phx.gbl>
	<86810401A1B22346A09CBA649BE561E9013408BE8B@azsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63950 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab0I1Teg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2010 15:34:36 -0400
Received: by wyb28 with SMTP id 28so5877wyb.19
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2010 12:34:35 -0700 (PDT)
In-Reply-To: <86810401A1B22346A09CBA649BE561E9013408BE8B@azsmsx505.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Thomson, Patrick S" <patrick.s.thomson@intel.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Marushak, Nathan" <nathan.marushak@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Jeppsen, Roger C" <roger.c.jeppsen@intel.com>

On Tue, Sep 28, 2010 at 11:36 AM, Thomson, Patrick S
<patrick.s.thomson@intel.com> wrote:
> Alrighty...
>
> Based on Dan's feedback and some from Nate, here's another go
> at the changes. I removed the spinlock and renamed the elements in
> enum cfg. The default behavior remains the same however. I'm
> still leery on changing existing behavior, unless of course people
> think it's a good idea

I guess I'm not understanding the usage model for this change.  When
would you want two phys attached to the same address to not form a
wide port, and would this be a per-phy policy rather than
per-controller?

General question about the code change below:

> +void notify_libsas_config(struct sas_ha_struct *sas_ha, enum cfg_sta=
te cfg)
> +{
> + =A0 =A0 =A0 unsigned long flags;
> +
> + =A0 =A0 =A0 switch (cfg) {
> + =A0 =A0 =A0 case CFGE_USE_LOCAL_AND_ATTACHED_SAS:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sas_ha->use_host_phy_addr =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case CFGE_USE_ONLY_ATTACHED_SAS:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sas_ha->use_host_phy_addr =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +}

Is it not sufficient to just set this flag before calling
sas_register_ha()?  If this was truly a dynamic notification I would
expect you would want to re-validate existing ports against this newly
set policy.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
