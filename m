From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12727] AIC79xx problem on Adaptec 29320A-P controller
Date: Sat, 13 Jun 2009 17:19:15 GMT
Message-ID: <200906131719.n5DHJFew024948@demeter.kernel.org>
References: <bug-12727-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59880 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbZFMRTN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Jun 2009 13:19:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5DHJFwl024949
	for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2009 17:19:15 GMT
In-Reply-To: <bug-12727-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12727





--- Comment #2 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-06-13 17:19:13 ---
Reply-To: James.Bottomley@HansenPartnership.com

On Fri, 2009-06-12 at 09:41 -0500, James Bottomley wrote:
> On Tue, 2009-02-17 at 10:09 -0800, bugme-daemon@bugzilla.kernel.org
> wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=12727
> > 
> >            Summary: AIC79xx problem on Adaptec 29320A-P controller
> >            Product: SCSI Drivers
> >            Version: 2.5
> >      KernelVersion: 2.6.25.20-0.1-default
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Other
> >         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
> >         ReportedBy: j@jensen-net.org
> > 
> > 
> > Latest working kernel version: N/A
> > Earliest failing kernel version: 2.6.25.20-0.1-default
> > Distribution: OpenSUSE 11.0
> > Hardware Environment: Supermicro server
> > Software Environment: 
> > Problem Description:
> > When there is a pause in writing to the tape after that the error occurs.
> > 
> > Steps to reproduce: tar some data to tape.
> > 
> > Hardware information and error is below:
> > Linux version 2.6.25.20-0.1-default (geeko@buildhost) (gcc version 4.3.1
> > 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #1 SMP
> > 2008-12-12 20:30:38 +0100
> > scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
> >         <Adaptec 29320A Ultra320 SCSI adapter>
> >         aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs
> >  target0:0:3: asynchronous
> > scsi 0:0:3:0: Sequential-Access IBM      ULTRIUM-TD3      7AP5 PQ: 0 ANSI: 3
> >  target0:0:3: Beginning Domain Validation
> >  target0:0:3: wide asynchronous
> >  target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
> >  target0:0:3: Ending Domain Validation
> > scsi 0:0:3:1: Medium Changer    EXABYTE  MAGNUM 224       C270 PQ: 0 ANSI: 4
> > 
> > osst :I: Tape driver with OnStream support version 0.99.4
> > osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> > st: Version 20080221, fixed bufsize 32768, s/g segs 256
> > st 0:0:3:0: Attached scsi tape st0
> > st 0:0:3:0: st0: try direct i/o: yes (alignment 4 B)
> > st0: Block limits 1 - 16777215 bytes.
> > 
> > scsi0: PCI error Interrupt
> > >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> > scsi0: Dumping Card State at program address 0x7f Mode 0x22
> 
> Following up on this, we have a Novell bugzilla (partner restricted, I'm
> afraid):
> 
> https://bugzilla.novell.com/show_bug.cgi?id=509845
> 
> The good thing about the novell one is that the partner managed to get a
> SCSI analyser on the tape.  The analysis shows that the tape actually
> has a firmware bug in that if it sees Information Units of type 0x02
> (MULTIPLE COMMANDS) it just stops responding.  It can cope with any
> other type of Information Unit, apparently.
> 
> We'll be trying to get HP to fix the firmware, but an alternative
> solution might simply be to blacklist this device in the SPI transport
> class to disable information unit transfers, which should fix your
> problem
> 
> [Of course, a second problem is how to get the aic79xx driver to behave
> nicely handling errors in situations like this, but I'll leave that for
> another day.]

OK, so this patch should be an interim one until I can blacklist the
devices permanently.

What it does is allow the Adaptec firmware to pass on its values for
Packetize and QAS ... you just need to set Packetize to 'no' for the
tape device in the bios and the kernel (after this patch) will respect
the setting and not try to enable information units.

James

---
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c
b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 0f829b3..75b2331 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -627,19 +627,15 @@ ahd_linux_target_alloc(struct scsi_target *starget)
                         starget->id, &tstate);

         if ((flags  & CFPACKETIZED) == 0) {
-            /* Do not negotiate packetized transfers */
-            spi_rd_strm(starget) = 0;
-            spi_pcomp_en(starget) = 0;
-            spi_rti(starget) = 0;
-            spi_wr_flow(starget) = 0;
-            spi_hold_mcs(starget) = 0;
+            /* don't negotiate packetized (IU) transfers */
+            spi_max_iu(starget) = 0;
         } else {
             if ((ahd->features & AHD_RTI) == 0)
                 spi_rti(starget) = 0;
         }

         if ((flags & CFQAS) == 0)
-            spi_qas(starget) = 0;
+            spi_max_qas(starget) = 0;

         /* Transinfo values have been set to BIOS settings */
         spi_max_width(starget) = (flags & CFWIDEB) ? 1 : 0;
diff --git a/drivers/scsi/scsi_transport_spi.c
b/drivers/scsi/scsi_transport_spi.c
index f49f55c..654a34f 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -234,8 +234,10 @@ static int spi_setup_transport_attrs(struct
transport_container *tc,
     spi_width(starget) = 0;    /* narrow */
     spi_max_width(starget) = 1;
     spi_iu(starget) = 0;    /* no IU */
+    spi_max_iu(starget) = 1;
     spi_dt(starget) = 0;    /* ST */
     spi_qas(starget) = 0;
+    spi_max_qas(starget) = 1;
     spi_wr_flow(starget) = 0;
     spi_rd_strm(starget) = 0;
     spi_rti(starget) = 0;
@@ -360,9 +362,9 @@ static DEVICE_ATTR(field, S_IRUGO,                \
 /* The Parallel SCSI Tranport Attributes: */
 spi_transport_max_attr(offset, "%d\n");
 spi_transport_max_attr(width, "%d\n");
-spi_transport_rd_attr(iu, "%d\n");
+spi_transport_max_attr(iu, "%d\n");
 spi_transport_rd_attr(dt, "%d\n");
-spi_transport_rd_attr(qas, "%d\n");
+spi_transport_max_attr(qas, "%d\n");
 spi_transport_rd_attr(wr_flow, "%d\n");
 spi_transport_rd_attr(rd_strm, "%d\n");
 spi_transport_rd_attr(rti, "%d\n");
@@ -874,13 +876,13 @@ spi_dv_device_internal(struct scsi_device *sdev, u8
*buffer)

     /* try QAS requests; this should be harmless to set if the
      * target supports it */
-    if (scsi_device_qas(sdev)) {
+    if (scsi_device_qas(sdev) && spi_max_qas(starget)) {
         DV_SET(qas, 1);
     } else {
         DV_SET(qas, 0);
     }

-    if (scsi_device_ius(sdev) && min_period < 9) {
+    if (scsi_device_ius(sdev) && spi_max_iu(starget) && min_period < 9) {
         /* This u320 (or u640). Set IU transfers */
         DV_SET(iu, 1);
         /* Then set the optional parameters */
@@ -1412,12 +1414,18 @@ static mode_t target_attribute_is_visible(struct
kobject *kobj,
     else if (attr == &dev_attr_iu.attr &&
          spi_support_ius(starget))
         return TARGET_ATTRIBUTE_HELPER(iu);
+    else if (attr == &dev_attr_max_iu.attr &&
+         spi_support_ius(starget))
+        return TARGET_ATTRIBUTE_HELPER(iu);
     else if (attr == &dev_attr_dt.attr &&
          spi_support_dt(starget))
         return TARGET_ATTRIBUTE_HELPER(dt);
     else if (attr == &dev_attr_qas.attr &&
          spi_support_qas(starget))
         return TARGET_ATTRIBUTE_HELPER(qas);
+    else if (attr == &dev_attr_max_qas.attr &&
+         spi_support_qas(starget))
+        return TARGET_ATTRIBUTE_HELPER(qas);
     else if (attr == &dev_attr_wr_flow.attr &&
          spi_support_ius(starget))
         return TARGET_ATTRIBUTE_HELPER(wr_flow);
@@ -1447,8 +1455,10 @@ static struct attribute *target_attributes[] = {
     &dev_attr_width.attr,
     &dev_attr_max_width.attr,
     &dev_attr_iu.attr,
+    &dev_attr_max_iu.attr,
     &dev_attr_dt.attr,
     &dev_attr_qas.attr,
+    &dev_attr_max_qas.attr,
     &dev_attr_wr_flow.attr,
     &dev_attr_rd_strm.attr,
     &dev_attr_rti.attr,
diff --git a/include/scsi/scsi_transport_spi.h
b/include/scsi/scsi_transport_spi.h
index 286e962..7497a38 100644
--- a/include/scsi/scsi_transport_spi.h
+++ b/include/scsi/scsi_transport_spi.h
@@ -36,8 +36,10 @@ struct spi_transport_attrs {
     unsigned int width:1;    /* 0 - narrow, 1 - wide */
     unsigned int max_width:1;
     unsigned int iu:1;    /* Information Units enabled */
+    unsigned int max_iu:1;
     unsigned int dt:1;    /* DT clocking enabled */
     unsigned int qas:1;    /* Quick Arbitration and Selection enabled */
+    unsigned int max_qas:1;
     unsigned int wr_flow:1;    /* Write Flow control enabled */
     unsigned int rd_strm:1;    /* Read streaming enabled */
     unsigned int rti:1;    /* Retain Training Information */
@@ -77,8 +79,10 @@ struct spi_host_attrs {
 #define spi_width(x)    (((struct spi_transport_attrs
*)&(x)->starget_data)->width)
 #define spi_max_width(x) (((struct spi_transport_attrs
*)&(x)->starget_data)->max_width)
 #define spi_iu(x)    (((struct spi_transport_attrs *)&(x)->starget_data)->iu)
+#define spi_max_iu(x)    (((struct spi_transport_attrs
*)&(x)->starget_data)->max_iu)
 #define spi_dt(x)    (((struct spi_transport_attrs *)&(x)->starget_data)->dt)
 #define spi_qas(x)    (((struct spi_transport_attrs
*)&(x)->starget_data)->qas)
+#define spi_max_qas(x)    (((struct spi_transport_attrs
*)&(x)->starget_data)->max_qas)
 #define spi_wr_flow(x)    (((struct spi_transport_attrs
*)&(x)->starget_data)->wr_flow)
 #define spi_rd_strm(x)    (((struct spi_transport_attrs
*)&(x)->starget_data)->rd_strm)
 #define spi_rti(x)    (((struct spi_transport_attrs
*)&(x)->starget_data)->rti)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
