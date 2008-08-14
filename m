From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: With kernel 2.6.19 no sg devices for devices that return PQ=1, PDT=0x1f
Date: Thu, 14 Aug 2008 21:59:54 +0200
Message-ID: <200808142159.54897.swen@vnet.ibm.com>
References: <48984A20.2050002@linux.vnet.ibm.com> <200808080852.53822.swen@vnet.ibm.com> <1218300656.3480.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:44690 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbYHNT6r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 15:58:47 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id m7EJweGG020328
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2008 19:58:40 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7EJwe7v3088562
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2008 21:58:40 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7EJwdLX030779
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2008 21:58:40 +0200
In-Reply-To: <1218300656.3480.47.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: dougg@torque.net, Martin Petermann <martin@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Saturday 09 August 2008 18:50, James Bottomley wrote:
> On Fri, 2008-08-08 at 08:52 +0200, Swen Schillig wrote:
> > On Wednesday 06 August 2008 18:58, James Bottomley wrote:
> > > On Wed, 2008-08-06 at 11:06 +0200, Douglas Gilbert wrote:
> > > > Swen Schillig wrote:
> > > > > On Tuesday 05 August 2008 18:51, James Bottomley wrote:
> > > > >> On Tue, 2008-08-05 at 14:40 +0200, Martin Petermann wrote:
> > > > >>> With kernel 2.6.19 a change was introduced that no sg device was 
> > > > >>> generated if PQ=1, PDT=0x1f was returned from the particular device:
> > > > >>>
> > > > >>> commit 84961f28e9d13a4b193d0c8545f3c060c1890ff3
> > > > >>> Author: dave wysochanski <davidw@netapp.com>
> > > > >>> Date:   Wed Aug 9 14:56:32 2006 -0400
> > > > >>>
> > > > >>>      [SCSI] Don't add scsi_device for devices that return PQ=1, PDT=0x1f
> > > > >>>
> > > > >>> Before it was possible on Linux 390 in user space to a e.g. LUN 0 to a 
> > > > >>> port and to receive a generic device:
> > > > >>>
> > > > >>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
> > > > >>> total 0
> > > > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
> > > > >>> -rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
> > > > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
> > > > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 status
> > > > >>> --w------- 1 root root 4096 Aug  4 12:07 uevent
> > > > >>> --w------- 1 root root    0 Aug  4 13:46 unit_add
> > > > >>> --w------- 1 root root    0 Aug  5 14:24 unit_remove
> > > > >>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # echo 0 > 
> > > > >>> unit_add
> > > > >>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
> > > > >>> total 0
> > > > >>> drwxr-xr-x 2 root root    0 Aug  5 14:25 0x0000000000000000
> > > > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
> > > > >>> -rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
> > > > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
> > > > >>> -r--r--r-- 1 root root 4096 Aug  4 12:07 status
> > > > >>> --w------- 1 root root 4096 Aug  4 12:07 uevent
> > > > >>> --w------- 1 root root    0 Aug  5 14:25 unit_add
> > > > >>> --w------- 1 root root    0 Aug  5 14:24 unit_remove
> > > > >>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # lsscsi -g
> > > > >>> [0:0:0:0]    no dev  IBM      2107900          2.27  -         /dev/sg0
> > > > >>>
> > > > >>> After this fix there is no /dev/sg0 device generated.
> > > > >>>
> > > > >>> We are utilizing the possibility to create such a device for the 
> > > > >>> sg_utils commands in the case no other LUN has been attached to a port.
> > > > >>>
> > > > >>> I do not want to put this fix into question. I would like to know if 
> > > > >>> someone has an idea how to workaround this problem and to generate a 
> > > > >>> generic device in user space using kernel 2.6.19 or a later version.
> > > > >> First of all, why is the device returning PQ=1 PTD=0x1f? this should
> > > > >> mean its not connected and probably doesn't exist... ie inaccessible
> > > > >> without some unspecified action being taken.  If you can use it, it's
> > > > >> clearly not behaving like a PQ=1 LUN.  Perhaps the simplest thing would
> > > > >> be for something in s390 to fix up the inquiry data ... or we could
> > > > >> allow you could have a script to force it to appear (as in if you send a
> > > > >> specific scan for this one LUN we could override the catch in the code
> > > > >> that throws it out again).
> > > > >>
> > > > >> James
> > > > >>
> > > > >>
> > > > >> --
> > > > >> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > > >> the body of a message to majordomo@vger.kernel.org
> > > > >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > >>
> > > > > 
> > > > > James
> > > > > 
> > > > > I think Martin is saying that this LUN is a non existent one which is just used for scanning
> > > > > all available (existing) LUNs on the remote storage port.
> > > > > That's why PQ=1 PTD=0x1f are returned and correct !
> > > > > 
> > > > > So what's required here is the possibility to add a "dummy" LUN which can be used just for this purpose.
> > > > > Not sure whether this is covered by anything in the standard
> > > > 
> > > > That sounds like a job for the REPORT LUNS well known logical
> > > > unit (WLUN or W-LUN). I implemented one in the scsi_debug driver.
> > > > See the description of the "no_lun_0" parameter in
> > > > http://sg.torque.net/sg/sdebug26.html
> > > > 
> > > > You might try:
> > > >    echo "- - 49409" > /sys/class/scsi_host/host<n>/scan
> > > > where "host<n>" is the controller in question. Then
> > > > see if a WLUN has appeared as a sg device node.
> > > 
> > > Actually, if this thing is WLUN or ZLUN ... that's something we should
> > > support unconditionally without looking at the PQ bit ... is that how it
> > > is supposed to show up on the Z?
> > > 
> > > James
> > > 
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > Yes, that's exactly how it should be !
> > That would mean in our case that LUN 0xc101 would get a generic device 
> > which could be used for scanning.
> > 
> > so something like 
> > 
> > Index: HEAD/drivers/scsi/scsi_scan.c
> > ===================================================================
> > --- HEAD.orig/drivers/scsi/scsi_scan.c
> > +++ HEAD/drivers/scsi/scsi_scan.c
> > @@ -1080,7 +1080,7 @@ static int scsi_probe_and_add_lun(struct
> >          * PDT=1Fh none (no FDD connected to the requested logical unit)
> >          */
> >         if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
> > -            (result[0] & 0x1f) == 0x1f) {
> > +            (result[0] & 0x1f) == 0x1f && (lun & 0xc100) != 0xc100)) {
> >                 SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
> >                                         "scsi scan: peripheral device type"
> >                                         " of 31, no device added\n"));
> 
> I think you mean lun & 0xff00 == 0xc100
> 
> perhaps there should be #defines for this too, something like
> 
> #define SCSI_W_LUN_BASE 0x1c00
> #define SCSI_W_LUN_REPORT_LUNS (SCSI_W_LUN_BASE + 1)
> #define SCSI_W_LUN_ACCESS_CONTROL (SCSI_W_LUN_BASE + 2)
> #define SCSI_W_LUN_TARGET_LOG_PAGE (SCSI_W_LUN_BASE + 3)
> 
> James
> 
Yes, sorry that's what I meant actually, ok despite the "==" which should be "!=" like in Martins patch.
But I'm not sure what you need the defines for, they're not used anywhere, are they ?

Cheers Swen 
