From: KY Srinivasan <kys@microsoft.com>
Subject: RE: scanning for LUNs
Date: Thu, 4 Apr 2013 17:12:37 +0000
Message-ID: <5c58dfba0d564ed4b6959a0d478268b9@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1365088357-22624-1-git-send-email-kys@microsoft.com>
 <1365088500.2764.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1365088500.2764.8.camel@dabdike>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Thursday, April 04, 2013 11:15 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: scanning for LUNs
> 
> On Thu, 2013-04-04 at 08:12 -0700, K. Y. Srinivasan wrote:
> > Here is the code snippet for scanning LUNS (drivers/scsi/scsi_scan.c in function
> > __scsi_scan_target()):
> >
> >         /*
> >          * Scan LUN 0, if there is some response, scan further. Ideally, we
> >          * would not configure LUN 0 until all LUNs are scanned.
> >          */
> >         res = scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL);
> >         if (res == SCSI_SCAN_LUN_PRESENT || res ==
> SCSI_SCAN_TARGET_PRESENT) {
> >                 if (scsi_report_lun_scan(starget, bflags, rescan) != 0)
> >
> >
> > So, if we don't get a response while scanning LUN0, we will not use
> > scsi_report_lun_scan().
> > On Hyper-V, the scsi emulation on the host does not treat LUN0 as
> > anything special and we
> > could have situations where the only device under a scsi controller is
> > at a location other than 0
> > or 1. In this case the standard LUN scanning code in Linux fails to
> > detect this device. Is this
> > behaviour expected? Why is LUN0 treated differently here. Looking at
> > the scsi spec, I am not sure
> > if this is what is specified. Any help/guidance will be greatly
> > appreciated.
> 
> Why don't you describe the problem.  We can't scan randomly a bunch of
> LUNs hoping for a response (the space is 10^19).  SAM thinks you use
> LUNW for this, but that's not well supported.  We can't annoy USB
> devices by probing with REPORT LUNS, so conventionally most arrays
> return something for LUN0 even if they don't actually have one (That's
> what the peripheral qualifier codes are supposed to be about).  We
> translate PQ1 and PQ2 to SCSI_SCAN_TARGET_PRESENT, which means no LUN,
> but there is a target to scan here.
> 
> If you're sending back an error to an INQUIRY to LUN0, then you're out
> of spec.  The SCSI standards say:
> 
>         SPC3 6.4.1: In response to an INQUIRY command received by an
>         incorrect logical unit, the SCSI target device shall return the
>         INQUIRY data with the peripheral qualifier set to the value
>         defined in 6.4.2. The INQUIRY command shall return CHECK
>         CONDITION status only when the device server is unable to return
>         the requested INQUIRY data

Thanks James. I will further investigate the issue on our platform.

Regards,

K. Y
> 
> James
> 
> 
> James
> 
> 
