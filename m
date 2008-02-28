From: "Ke Wei" <kewei.mv@gmail.com>
Subject: Re: [PATCH] mvsas: Mainly add version info to run testing process.
Date: Thu, 28 Feb 2008 11:16:26 +0800
Message-ID: <6b2481670802271916y62aa0588w81de83c08c9f128c@mail.gmail.com>
References: <20080227125025.GA7897@ubuntu.domain>
	 <1204129357.3470.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from po-out-1718.google.com ([72.14.252.155]:57407 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYB1DQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2008 22:16:29 -0500
Received: by po-out-1718.google.com with SMTP id b23so4863752poe.1
        for <linux-scsi@vger.kernel.org>; Wed, 27 Feb 2008 19:16:26 -0800 (PST)
In-Reply-To: <1204129357.3470.14.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, lil@marvell.com, saeed.bishara@gmail.com, kewei@marvell.com

On Thu, Feb 28, 2008 at 12:22 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2008-02-27 at 20:50 +0800, Ke Wei wrote:
> > 1. Owing to device testing, we need the kernel can show mvsas current
> > version in the /proc system.
>
> I'm afraid proc is really deprecated now.  We have /sys for showing
> necessary information.  For an example of how to use /sys, aacraid does
> it the right way (drivers/scsi/aacraid/linit.c).  They use this for
> exposing a lot of detail about the actual device and its firmware.  The
> format of sysfs is one entry per file, rather than descriptive text.
>
> However, for both the parameters you're trying to export, you can get
> them an alternative way.  The driver version is available from modinfo,
> which is usually what your support is looking for:
>
> jejb@hobholes> modinfo -F version mvsas
> 0.5
>
> And the sas_address is available from the phys.  Because it's possible
> for a HBA to have a different address per phy, it has to be stored this
> way:
>
> jejb@hobholes> ls /sys/class/sas_host/host0/device/*/sas_phy\:*/sas_address
> /sys/class/sas_host/host0/device/phy-0:0/sas_phy:phy-0:0/sas_address
> /sys/class/sas_host/host0/device/phy-0:1/sas_phy:phy-0:1/sas_address
> /sys/class/sas_host/host0/device/phy-0:2/sas_phy:phy-0:2/sas_address
> /sys/class/sas_host/host0/device/phy-0:3/sas_phy:phy-0:3/sas_address
> /sys/class/sas_host/host0/device/phy-0:4/sas_phy:phy-0:4/sas_address
> /sys/class/sas_host/host0/device/phy-0:5/sas_phy:phy-0:5/sas_address
> /sys/class/sas_host/host0/device/phy-0:6/sas_phy:phy-0:6/sas_address
> /sys/class/sas_host/host0/device/phy-0:7/sas_phy:phy-0:7/sas_address
>
> (showing that the sas_address is stored under the sas_phy class in
> sysfs).  The values for this one (aic94xx) are all the same:
>
> jejb@hobholes> cat /sys/class/sas_host/host0/device/*/sas_phy\:*/sas_address
> 0x50000d100001cae0
> 0x50000d100001cae0
> 0x50000d100001cae0
> 0x50000d100001cae0
> 0x50000d100001cae0
> 0x50000d100001cae0
> 0x50000d100001cae0
> 0x50000d100001cae0
>
Ok, I will tell our testing team how to show version in this way.

>
> > 2. Set the correct SAS address to per port.
>
> This looks interesting:
>
> >         for (i = 0; i < mvi->chip->n_phy; i++) {
> > -               /* FIXME: is this the correct dword order? */
> > -               u32 lo = *((u32 *)&mvi->sas_addr[0]);
> > -               u32 hi = *((u32 *)&mvi->sas_addr[4]);
> > +               u32 lo = swab32p((u32 *)&mvi->sas_addr[4]);
> > +               u32 hi = swab32p((u32 *)&mvi->sas_addr[0]);
> >
> >                 mvs_detect_porttype(mvi, i);
>
> I'm assuming the swab32p is because the mvi->sas_addr array is in wire
> (big endian) format, and you need to write it out to the config
> registers as two u32 upper and lower words via mvs_write_port_cfg.  As
> long as that register set is always in pci order (little endian), I
> think this will work, but has it been tested on a big endian system,
> like PPC?

Yes,  the mvi->sas_addr array is in wire big endian format. And it
will be written to two
little-endian 32-bit registers after converting to little endian. So I
think this is independent
of system architecture.




-- 
Best Regards,
Ke Wei
