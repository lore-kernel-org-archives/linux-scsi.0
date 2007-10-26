From: Rob Landley <rob@landley.net>
Subject: [PATCH] Documentation/DocBook/scsi_midlayer.tmpl
Date: Fri, 26 Oct 2007 17:14:41 -0500
Message-ID: <200710261714.42300.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:57236
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752534AbXJZWOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 18:14:47 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id D10A673938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 18:17:28 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add Documentation/DocBook/scsi_midlayer.tmpl and patch
lots of drivers/scsi files fixing/adding kerneldoc comments.

Signed-off-by: Rob Landley <rob@landley.net>
---
 More of an RFC than a patch, really.  Kind of big and probably needs to be
 broken up.  One minor code change where I added parentheses in
 scsi_ioctl.c because (blah && blah & FLAG) is something I had to
 double-check the precedence of and wanted to clarify.  Everything else
 should be comments, docbook, or adding the tmpl to the Makefile.

 The upper and lower layers are mostly stubs at present.

 Documentation/DocBook/Makefile           |    2 
 Documentation/DocBook/scsi_midlayer.tmpl |  409 +++++++++++++++++++++
 drivers/scsi/constants.c                 |    1 
 drivers/scsi/scsi.c                      |  181 ++++-----
 drivers/scsi/scsi_devinfo.c              |   34 -
 drivers/scsi/scsi_error.c                |   34 -
 drivers/scsi/scsi_ioctl.c                |   24 -
 drivers/scsi/scsi_lib.c                  |   14 
 drivers/scsi/scsi_netlink.c              |   19 
 drivers/scsi/scsi_proc.c                 |  110 +++++
 drivers/scsi/scsi_scan.c                 |   30 +
 drivers/scsi/scsi_transport_fc.c         |   25 -
 drivers/scsi/scsi_transport_iscsi.c      |    3 
 drivers/scsi/scsi_transport_sas.c        |    5 
 drivers/scsi/scsi_transport_srp.c        |    2 
 drivers/scsi/scsicam.c                   |   39 +-
 16 files changed, 745 insertions(+), 187 deletions(-)

--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ hg/Documentation/DocBook/scsi_midlayer.tmpl	2007-10-26 16:53:44.000000000 -0500
@@ -0,0 +1,409 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
+	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
+
+<book id="scsimid">
+  <bookinfo>
+    <title>SCSI Mid Layer Guide</title>
+  
+    <authorgroup>
+      <author>
+        <firstname>James</firstname>
+        <surname>Bottomley</surname>
+        <affiliation>
+          <address>
+            <email>James.Bottomley@steeleye.com</email>
+          </address>
+        </affiliation>
+      </author>
+
+      <author>
+        <firstname>Rob</firstname>
+        <surname>Landley</surname>
+        <affiliation>
+          <address>
+            <email>rob@landley.net</email>
+          </address>
+        </affiliation>
+      </author>
+
+    </authorgroup>
+
+    <copyright>
+      <year>2007</year>
+      <holder>Linux Foundation</holder>
+    </copyright>
+
+    <legalnotice>
+      <para>
+        This documentation is free software; you can redistribute
+        it and/or modify it under the terms of the GNU General Public
+        License version 2.
+      </para>
+      
+      <para>
+        This program is distributed in the hope that it will be
+        useful, but WITHOUT ANY WARRANTY; without even the implied
+        warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+        For more details see the file COPYING in the source
+        distribution of Linux.
+      </para>
+    </legalnotice>
+  </bookinfo>
+
+  <toc></toc>
+
+  <chapter id="intro">
+    <title>Introduction</title>
+    <sect1 id="protocol_vs_bus">
+      <title>Protocol vs bus</title>
+      <para>
+        Once upon a time, the Small Computer Systems Interface defined both
+        a parallel I/O bus and a data protocol to connect a wide variety of
+        peripherals (disk drives, tape drives, modems, printers, scanners,
+        optical drives, test equipment, and medical devices) to a host
+        computer.
+      </para>
+      <para>
+        Although the old parallel (fast/wide/ultra) SCSI bus has largely
+        fallen out of use, the SCSI command set is more widely used than ever
+        to communicate with devices over a number of different busses.
+      </para>
+      <para>
+        The <ulink url='http://www.t10.org/scsi-3.htm'>SCSI protocol</ulink>
+        is a big-endian peer-to-peer packet based protocol.  SCSI commands
+        are 6, 10, 12, or 16 bytes long, often followed by an associated data
+        payload.
+      </para>
+      <para>
+        SCSI commands can be transported over just about any kind of bus, and
+        are the default protocol for storage devices attached to USB, SATA,
+        SAS, Fibre Channel, FireWire, and ATAPI devices.  SCSI packets are
+        also commonly exchanged over Infiniband,
+        <ulink url='http://i2o.shadowconnect.com/faq.php'>I20</ulink>, TCP/IP
+        (<ulink url='http://en.wikipedia.org/wiki/ISCSI'>iSCSI</ulink>), even
+        <ulink url='http://cyberelk.net/tim/parport/parscsi.html'>Parallel
+        ports</ulink>.
+      </para>
+    </sect1>
+    <sect1 id="subsystem_design">
+      <title>Design of the Linux SCSI subsystem</title>
+      <para>
+        The SCSI subsystem uses a three layer design, with upper, mid, and low
+        layers.  Every operation involving the SCSI subsystem (such as reading
+        a sector from a disk) uses one driver at each of the 3 levels: one
+        upper layer driver, one lower layer driver, and the scsi midlayer.
+      </para>
+      <para>
+        The SCSI upper layer provides the interface between userspace and the
+        kernel, in the form of block and char device nodes for I/O and
+        ioctl().  The SCSI lower layer contains drivers for specific hardware
+        devices.
+      </para>
+      <para>
+        In between is the SCSI mid-layer, analogous to a network routing
+        layer such as the IPv4 stack.  The SCSI mid-layer routes a packet
+        based data protocol between the upper layer's /dev nodes and the
+        corresponding devices in the lower layer.  It manages command queues,
+        provides error handling and power management functions, and responds
+        to ioctl() requests.
+      </para>
+    </sect1>
+  </chapter>
+
+  <chapter id="upper_layer">
+    <title>SCSI upper layer</title>
+    <para>
+      The upper layer supports the user-kernel interface by providing
+      device nodes.
+    </para>
+    <sect1 id="sd">
+      <title>sd (SCSI Disk)</title>
+      <para>sd (sd_mod.o)</para>
+<!-- !Idrivers/scsi/sd.c -->
+    </sect1>
+    <sect1 id="sr">
+      <title>sr (SCSI CD-ROM)</title>
+      <para>sr (sr_mod.o)</para>
+    </sect1>
+    <sect1 id="st">
+      <title>st (SCSI Tape)</title>
+      <para>st (st.o)</para>
+    </sect1>
+    <sect1 id="sg">
+      <title>sg (SCSI Generic)</title>
+      <para>sg (sg.o)</para>
+    </sect1>
+    <sect1 id="ch">
+      <title>ch (SCSI Media Changer)</title>
+      <para>ch (ch.c)</para>
+    </sect1>
+  </chapter>
+
+  <chapter id="mid_layer">
+    <title>SCSI mid layer</title>
+
+    <sect1 id="midlayer_implementation">
+      <title>SCSI midlayer implementation</title>
+      <sect2 id="scsi_device.h">
+        <title>include/scsi/scsi_device.h</title>
+        <para>
+        </para>
+!Iinclude/scsi/scsi_device.h
+      </sect2>
+
+      <sect2 id="scsi.c">
+        <title>drivers/scsi/scsi.c</title>
+        <para>Main file for the scsi midlayer.</para>
+!Edrivers/scsi/scsi.c
+      </sect2>
+      <sect2 id="scsicam.c">
+        <title>drivers/scsi/scsicam.c</title>
+        <para>
+          <ulink url='http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf'>SCSI
+          Common Access Method</ulink> support functions, for use with
+          HDIO_GETGEO, etc.
+        </para>
+!Edrivers/scsi/scsicam.c
+      </sect2>
+      <sect2 id="scsi_error.c">
+        <title>drivers/scsi/scsi_error.c</title>
+        <para>Common SCSI error/timeout handling routines.</para>
+!Edrivers/scsi/scsi_error.c
+      </sect2>
+      <sect2 id="scsi_devinfo.c">
+        <title>drivers/scsi/scsi_devinfo.c</title>
+        <para>
+          Manage scsi_dev_info_list, which tracks blacklisted and whitelisted
+          devices.
+        </para>
+!Idrivers/scsi/scsi_devinfo.c
+      </sect2>
+      <sect2 id="scsi_ioctl.c">
+        <title>drivers/scsi/scsi_ioctl.c</title>
+        <para>
+          Handle ioctl() calls for scsi devices.
+        </para>
+!Edrivers/scsi/scsi_ioctl.c
+      </sect2>
+      <sect2 id="scsi_lib.c">
+        <title>drivers/scsi/scsi_lib.c</title>
+        <para>
+          SCSI queuing library.
+        </para>
+!Edrivers/scsi/scsi_lib.c
+      </sect2>
+      <sect2 id="scsi_lib_dma.c">
+        <title>drivers/scsi/scsi_lib_dma.c</title>
+        <para>
+          SCSI library functions depending on DMA
+          (map and unmap scatter-gather lists).
+        </para>
+!Edrivers/scsi/scsi_lib_dma.c
+      </sect2>
+      <sect2 id="scsi_module.c">
+        <title>drivers/scsi/scsi_module.c</title>
+        <para>
+          The file drivers/scsi/scsi_module.c contains legacy support for
+          old-style host templates.  It should never be used by any new driver.
+        </para>
+      </sect2>
+      <sect2 id="scsi_proc.c">
+        <title>drivers/scsi/scsi_proc.c</title>
+        <para>
+          The functions in this file provide an interface between
+          the PROC file system and the SCSI device drivers
+          It is mainly used for debugging, statistics and to pass
+          information directly to the lowlevel driver.
+
+          I.E. plumbing to manage /proc/scsi/*
+        </para>
+!Idrivers/scsi/scsi_proc.c
+      </sect2>
+      <sect2 id="scsi_netlink.c">
+        <title>drivers/scsi/scsi_netlink.c</title>
+        <para>
+          Infrastructure to provide async events from transports to userspace
+          via netlink, using a single NETLINK_SCSITRANSPORT protocol for all
+          transports.
+
+          See <ulink url='http://marc.info/?l=linux-scsi&amp;m=115507374832500&amp;w=2'>the
+          original patch submission</ulink> for more details.
+        </para>
+!Idrivers/scsi/scsi_netlink.c
+      </sect2>
+      <sect2 id="scsi_scan.c">
+        <title>drivers/scsi/scsi_scan.c</title>
+        <para>
+          Scan a host to determine which (if any) devices are attached.
+
+          The general scanning/probing algorithm is as follows, exceptions are
+          made to it depending on device specific flags, compilation options,
+          and global variable (boot or module load time) settings.
+
+          A specific LUN is scanned via an INQUIRY command; if the LUN has a
+          device attached, a scsi_device is allocated and setup for it.
+
+          For every id of every channel on the given host, start by scanning
+          LUN 0.  Skip hosts that don't respond at all to a scan of LUN 0.
+          Otherwise, if LUN 0 has a device attached, allocate and setup a
+          scsi_device for it.  If target is SCSI-3 or up, issue a REPORT LUN,
+          and scan all of the LUNs returned by the REPORT LUN; else,
+          sequentially scan LUNs up until some maximum is reached, or a LUN is
+          seen that cannot have a device attached to it.
+        </para>
+!Idrivers/scsi/scsi_scan.c
+      </sect2>
+      <sect2 id="scsi_sysctl.c">
+        <title>drivers/scsi/scsi_sysctl.c</title>
+        <para>
+          Set up the sysctl entry: "/dev/scsi/logging_level"
+          (DEV_SCSI_LOGGING_LEVEL) which sets/returns scsi_logging_level.
+        </para>
+      </sect2>
+      <sect2 id="scsi_sysfs.c">
+        <title>drivers/scsi/scsi_sysfs.c</title>
+        <para>
+          SCSI sysfs interface routines.
+        </para>
+!Edrivers/scsi/scsi_sysfs.c
+      </sect2>
+      <sect2 id="hosts.c">
+        <title>drivers/scsi/hosts.c</title>
+        <para>
+          mid to lowlevel SCSI driver interface
+        </para>
+!Edrivers/scsi/hosts.c
+      </sect2>
+      <sect2 id="constants.c">
+        <title>drivers/scsi/constants.c</title>
+        <para>
+          mid to lowlevel SCSI driver interface
+        </para>
+!Edrivers/scsi/constants.c
+      </sect2>
+    </sect1>
+
+    <sect1 id="Transport_classes">
+      <title>Transport classes</title>
+      <para>
+        Transport classes are service libraries for drivers in the scsi
+        lower layer, which expose transport attributes in sysfs.
+      </para>
+      <sect2 id="Fibre_Channel_transport">
+        <title>Fibre Channel transport</title>
+        <para>
+          The file drivers/scsi/scsi_transport_fc.c defines transport attributes
+          for Fibre Channel.
+        </para>
+!Edrivers/scsi/scsi_transport_fc.c
+      </sect2>
+      <sect2 id="iSCSI_transport">
+        <title>iSCSI transport class</title>
+        <para>
+          The file drivers/scsi/scsi_transport_iscsi.c defines transport
+          attributes for the iSCSI class, which sends SCSI packets over TCP/IP
+          connections.
+        </para>
+!Edrivers/scsi/scsi_transport_iscsi.c
+      </sect2>
+      <sect2 id="SAS_transport">
+        <title>Serial Attached SCSI (SAS) transport class</title>
+        <para>
+          The file drivers/scsi/scsi_transport_sas.c defines transport
+          attributes for Serial Attached SCSI, a variant of SATA aimed at
+          large high-end systems.
+        </para>
+        <para>
+          The SAS transport class contains common code to deal with SAS HBAs,
+          an aproximated representation of SAS topologies in the driver model,
+          and various sysfs attributes to expose these topologies and managment
+          interfaces to userspace.
+        </para>
+        <para>
+          In addition to the basic SCSI core objects this transport class
+          introduces two additional intermediate objects:  The SAS PHY
+          as represented by struct sas_phy defines an "outgoing" PHY on
+          a SAS HBA or Expander, and the SAS remote PHY represented by
+          struct sas_rphy defines an "incoming" PHY on a SAS Expander or
+          end device.  Note that this is purely a software concept, the
+          underlying hardware for a PHY and a remote PHY is the exactly
+          the same.
+        </para>
+        <para>
+          There is no concept of a SAS port in this code, users can see
+          what PHYs form a wide port based on the port_identifier attribute,
+          which is the same for all PHYs in a port.
+        </para>
+!Edrivers/scsi/scsi_transport_sas.c
+      </sect2>
+      <sect2 id="SATA_transport">
+        <title>SATA transport class</title>
+        <para>
+          The SATA transport is handled by libata, which has its own book of
+          documentation in this directory.
+        </para>
+      </sect2>
+      <sect2 id="SPI_transport">
+        <title>Parallel SCSI (SPI) transport class</title>
+        <para>
+          The file drivers/scsi/scsi_transport_spi.c defines transport
+          attributes for traditional (fast/wide/ultra) SCSI busses.
+        </para>
+!Edrivers/scsi/scsi_transport_spi.c
+      </sect2>
+      <sect2 id="SRP_transport">
+        <title>SCSI RDMA (SRP) transport class</title>
+        <para>
+          The file drivers/scsi/scsi_transport_srp.c defines transport
+          attributes for SCSI over Remote Direct Memory Access.
+        </para>
+!Edrivers/scsi/scsi_transport_srp.c
+      </sect2>
+    </sect1>
+
+  </chapter>
+
+  <chapter id="lower_layer">
+    <title>SCSI lower layer</title>
+    <sect1 id="hba_drivers">
+      <title>Host Bus Adapter transport types</title>
+      <para>
+        Many modern device controllers use the SCSI command set as a protocol to
+        communicate with their devices through many different types of physical
+        connections.
+      </para>
+      <para>
+        In SCSI language a bus capable of carrying SCSI commands is
+        called a "transport", and a controller connecting to such a bus is
+        called a "host bus adapter" (HBA).
+      </para>
+      <sect2 id="scsi_debug.c">
+        <title>Debug transport</title>
+        <para>
+          The file drivers/scsi/scsi_debug.c simulates a host adapter with a
+          variable number of disks (or disk like devices) attached, sharing a
+          common amount of RAM.  Does a lot of checking to make sure that we are
+          not getting blocks mixed up, and panics the kernel if anything out of
+          the ordinary is seen.
+        </para>
+        <para>
+          To be more realistic, the simulated devices have the transport
+          attributes of SAS disks.
+        </para>
+        <para>
+          For documentation see
+          <ulink url='http://www.torque.net/sg/sdebug26.html'>http://www.torque.net/sg/sdebug26.html</ulink>
+        </para>
+<!-- !Edrivers/scsi/scsi_debug.c -->
+      </sect2>
+      <sect2 id="todo">
+        <title>todo</title>
+        <para>Parallel (fast/wide/ultra) SCSI, USB, SATA,
+        SAS, Fibre Channel, FireWire, ATAPI devices, Infiniband,
+        I20, iSCSI, Parallel ports, netlink...
+        </para>
+      </sect2>
+    </sect1>
+  </chapter>
+</book>
diff -r a868e8217782 Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile	Mon Oct 22 19:40:02 2007 -0700
+++ b/Documentation/DocBook/Makefile	Fri Oct 26 17:08:49 2007 -0500
@@ -11,7 +11,7 @@ DOCBOOKS := wanbook.xml z8530book.xml mc
 	    procfs-guide.xml writing_usb_driver.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml s390-drivers.xml
+	    genericirq.xml s390-drivers.xml scsi_midlayer.xml
 
 ###
 # The build process is as follows (targets):
diff -r a868e8217782 drivers/scsi/constants.c
--- a/drivers/scsi/constants.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/constants.c	Fri Oct 26 17:09:14 2007 -0500
@@ -362,7 +362,6 @@ EXPORT_SYMBOL(scsi_print_command);
 EXPORT_SYMBOL(scsi_print_command);
 
 /**
- *
  *	scsi_print_status - print scsi status description
  *	@scsi_status: scsi status value
  *
diff -r a868e8217782 drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi.c	Fri Oct 26 17:09:14 2007 -0500
@@ -122,6 +122,11 @@ static const char *const scsi_device_typ
 	"Automation/Drive ",
 };
 
+/**
+ * scsi_device_type - Return 17 char string indicating device type.
+ * @type: type number to look up
+ */
+
 const char * scsi_device_type(unsigned type)
 {
 	if (type == 0x1e)
@@ -156,6 +161,14 @@ static struct scsi_host_cmd_pool scsi_cm
 
 static DEFINE_MUTEX(host_cmd_pool_mutex);
 
+/**
+ * __scsi_get_command - Allocate a struct scsi_cmnd
+ * @shost: host to transmit command
+ * @gfp_mask: allocation mask
+ *
+ * Description: allocate a struct scsi_cmd from host's slab, recycling from the
+ *              host's free_list if necessary.
+ */
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
@@ -179,13 +192,10 @@ struct scsi_cmnd *__scsi_get_command(str
 }
 EXPORT_SYMBOL_GPL(__scsi_get_command);
 
-/*
- * Function:	scsi_get_command()
- *
- * Purpose:	Allocate and setup a scsi command block
- *
- * Arguments:	dev	- parent scsi device
- *		gfp_mask- allocator flags
+/**
+ * scsi_get_command - Allocate and setup a scsi command block
+ * @dev: parent scsi device
+ * @gfp_mask: allocator flags
  *
  * Returns:	The allocated scsi command structure.
  */
@@ -217,6 +227,12 @@ struct scsi_cmnd *scsi_get_command(struc
 }
 EXPORT_SYMBOL(scsi_get_command);
 
+/**
+ * __scsi_put_command - Free a struct scsi_cmnd
+ * @shost: dev->host
+ * @cmd: Command to free
+ * @dev: parent scsi device
+ */
 void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 			struct device *dev)
 {
@@ -237,12 +253,9 @@ void __scsi_put_command(struct Scsi_Host
 }
 EXPORT_SYMBOL(__scsi_put_command);
 
-/*
- * Function:	scsi_put_command()
- *
- * Purpose:	Free a scsi command block
- *
- * Arguments:	cmd	- command block to free
+/**
+ * scsi_put_command - Free a scsi command block
+ * @cmd: command block to free
  *
  * Returns:	Nothing.
  *
@@ -263,12 +276,13 @@ void scsi_put_command(struct scsi_cmnd *
 }
 EXPORT_SYMBOL(scsi_put_command);
 
-/*
- * Function:	scsi_setup_command_freelist()
- *
- * Purpose:	Setup the command freelist for a scsi host.
- *
- * Arguments:	shost	- host to allocate the freelist for.
+/**
+ * scsi_setup_command_freelist - Setup the command freelist for a scsi host.
+ * @shost: host to allocate the freelist for.
+ *
+ * Description: The command freelist protects against system-wide out of memory
+ * deadlock by preallocating one SCSI command structure for each host, so the
+ * system can always write to a swap file on a device associated with that host.
  *
  * Returns:	Nothing.
  */
@@ -318,12 +332,9 @@ int scsi_setup_command_freelist(struct S
 
 }
 
-/*
- * Function:	scsi_destroy_command_freelist()
- *
- * Purpose:	Release the command freelist for a scsi host.
- *
- * Arguments:	shost	- host that's freelist is going to be destroyed
+/**
+ * scsi_destroy_command_freelist - Release the command freelist for a scsi host.
+ * @shost: host that's freelist is going to be destroyed
  */
 void scsi_destroy_command_freelist(struct Scsi_Host *shost)
 {
@@ -441,8 +452,12 @@ void scsi_log_completion(struct scsi_cmn
 }
 #endif
 
-/* 
- * Assign a serial number to the request for error recovery
+/**
+ * scsi_cmd_get_serial - Assign a serial number to a command
+ * @host: the scsi host
+ * @cmd: command to assign serial number to
+ *
+ * Description: a serial number identifies a request for error recovery
  * and debugging purposes.  Protected by the Host_Lock of host.
  */
 static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
@@ -452,14 +467,12 @@ static inline void scsi_cmd_get_serial(s
 		cmd->serial_number = host->cmd_serial_number++;
 }
 
-/*
- * Function:    scsi_dispatch_command
- *
- * Purpose:     Dispatch a command to the low-level driver.
- *
- * Arguments:   cmd - command block we are dispatching.
- *
- * Notes:
+/**
+ * scsi_dispatch_command - Dispatch a command to the low-level driver.
+ * @cmd: command block we are dispatching.
+ *
+ * Return: nonzero return request was rejected and device's queue needs to be
+ * plugged.
  */
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
@@ -585,7 +598,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 
 /**
  * scsi_req_abort_cmd -- Request command recovery for the specified command
- * cmd: pointer to the SCSI command of interest
+ * @cmd: pointer to the SCSI command of interest
  *
  * This function requests that SCSI Core start recovery for the
  * command by deleting the timer and adding the command to the eh
@@ -606,9 +619,9 @@ EXPORT_SYMBOL(scsi_req_abort_cmd);
  * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
  * ownership back to SCSI Core -- i.e. the LLDD has finished with it.
  *
- * This function is the mid-level's (SCSI Core) interrupt routine, which
- * regains ownership of the SCSI command (de facto) from a LLDD, and enqueues
- * the command to the done queue for further processing.
+ * Description: This function is the mid-level's (SCSI Core) interrupt routine,
+ * which regains ownership of the SCSI command (de facto) from a LLDD, and
+ * enqueues the command to the done queue for further processing.
  *
  * This is the producer of the done queue who enqueues at the tail.
  *
@@ -660,10 +673,11 @@ static struct scsi_driver *scsi_cmd_to_d
 	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
-/*
- * Function:    scsi_finish_command
- *
- * Purpose:     Pass command off to upper layer for finishing of I/O
+/**
+ * scsi_finish_command
+ * @cmd: the command
+ *
+ * Description: Pass command off to upper layer for finishing of I/O
  *              request, waking processes that are waiting on results,
  *              etc.
  */
@@ -708,18 +722,14 @@ void scsi_finish_command(struct scsi_cmn
 }
 EXPORT_SYMBOL(scsi_finish_command);
 
-/*
- * Function:	scsi_adjust_queue_depth()
- *
- * Purpose:	Allow low level drivers to tell us to change the queue depth
- * 		on a specific SCSI device
- *
- * Arguments:	sdev	- SCSI Device in question
- * 		tagged	- Do we use tagged queueing (non-0) or do we treat
- * 			  this device as an untagged device (0)
- * 		tags	- Number of tags allowed if tagged queueing enabled,
- * 			  or number of commands the low level driver can
- * 			  queue up in non-tagged mode (as per cmd_per_lun).
+/**
+ * scsi_adjust_queue_depth - Let low level drivers change a device's queue depth
+ * @sdev: SCSI Device in question
+ * @tagged: Do we use tagged queueing (non-0) or do we treat
+ *          this device as an untagged device (0)
+ * @tags: Number of tags allowed if tagged queueing enabled,
+ *        or number of commands the low level driver can
+ *        queue up in non-tagged mode (as per cmd_per_lun).
  *
  * Returns:	Nothing
  *
@@ -772,20 +782,17 @@ void scsi_adjust_queue_depth(struct scsi
 }
 EXPORT_SYMBOL(scsi_adjust_queue_depth);
 
-/*
- * Function:	scsi_track_queue_full()
- *
- * Purpose:	This function will track successive QUEUE_FULL events on a
+/**
+ * scsi_track_queue_full
+ * @sdev: SCSI Device in question
+ * @depth: Current number of outstanding SCSI commands on this device,
+ *         not counting the one returned as QUEUE_FULL.
+ *
+ * Description:	This function will track successive QUEUE_FULL events on a
  * 		specific SCSI device to determine if and when there is a
  * 		need to adjust the queue depth on the device.
  *
- * Arguments:	sdev	- SCSI Device in question
- * 		depth	- Current number of outstanding SCSI commands on
- * 			  this device, not counting the one returned as
- * 			  QUEUE_FULL.
- *
- * Returns:	0 - No change needed
- * 		>0 - Adjust queue depth to this new depth
+ * Returns:	0 - No change needed, >0 - Adjust queue depth to this new depth,
  * 		-1 - Drop back to untagged operation using host->cmd_per_lun
  * 			as the untagged command depth
  *
@@ -824,10 +831,10 @@ EXPORT_SYMBOL(scsi_track_queue_full);
 EXPORT_SYMBOL(scsi_track_queue_full);
 
 /**
- * scsi_device_get  -  get an addition reference to a scsi_device
+ * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
  *
- * Gets a reference to the scsi_device and increments the use count
+ * Description: Gets a reference to the scsi_device and increments the use count
  * of the underlying LLDD module.  You must hold host_lock of the
  * parent Scsi_Host or already have a reference when calling this.
  */
@@ -849,8 +856,8 @@ EXPORT_SYMBOL(scsi_device_get);
  * scsi_device_put  -  release a reference to a scsi_device
  * @sdev:	device to release a reference on.
  *
- * Release a reference to the scsi_device and decrements the use count
- * of the underlying LLDD module.  The device is freed once the last
+ * Description: Release a reference to the scsi_device and decrements the use
+ * count of the underlying LLDD module.  The device is freed once the last
  * user vanishes.
  */
 void scsi_device_put(struct scsi_device *sdev)
@@ -867,7 +874,7 @@ void scsi_device_put(struct scsi_device 
 }
 EXPORT_SYMBOL(scsi_device_put);
 
-/* helper for shost_for_each_device, thus not documented */
+/* helper for shost_for_each_device, see that for documentation */
 struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
 					   struct scsi_device *prev)
 {
@@ -895,8 +902,10 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
 /**
  * starget_for_each_device  -  helper to walk all devices of a target
  * @starget:	target whose devices we want to iterate over.
- *
- * This traverses over each devices of @shost.  The devices have
+ * @data:	Opaque passed to each function call.
+ * @fn:		Function to call on each device
+ *
+ * Description: This traverses over each device of @shost.  The devices have
  * a reference that must be released by scsi_host_put when breaking
  * out of the loop.
  */
@@ -919,8 +928,8 @@ EXPORT_SYMBOL(starget_for_each_device);
  * @starget:	SCSI target pointer
  * @lun:	SCSI Logical Unit Number
  *
- * Looks up the scsi_device with the specified @lun for a give
- * @starget. The returned scsi_device does not have an additional
+ * Description: Looks up the scsi_device with the specified @lun for a given
+ * @starget.  The returned scsi_device does not have an additional
  * reference.  You must hold the host's host_lock over this call and
  * any access to the returned scsi_device.
  *
@@ -947,9 +956,9 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_ta
  * @starget:	SCSI target pointer
  * @lun:	SCSI Logical Unit Number
  *
- * Looks up the scsi_device with the specified @channel, @id, @lun for a
- * give host.  The returned scsi_device has an additional reference that
- * needs to be release with scsi_host_put once you're done with it.
+ * Description: Looks up the scsi_device with the specified @channel, @id, @lun
+ * for a given host.  The returned scsi_device has an additional reference that
+ * needs to be released with scsi_host_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
 						 uint lun)
@@ -972,13 +981,13 @@ EXPORT_SYMBOL(scsi_device_lookup_by_targ
  * scsi_device_lookup - find a device given the host (UNLOCKED)
  * @shost:	SCSI host pointer
  * @channel:	SCSI channel (zero if only one channel)
- * @pun:	SCSI target number (physical unit number)
+ * @id:		SCSI target number (physical unit number)
  * @lun:	SCSI Logical Unit Number
  *
- * Looks up the scsi_device with the specified @channel, @id, @lun for a
- * give host. The returned scsi_device does not have an additional reference.
- * You must hold the host's host_lock over this call and any access to the
- * returned scsi_device.
+ * Description: Looks up the scsi_device with the specified @channel, @id, @lun
+ * for a give host. The returned scsi_device does not have an additional
+ * reference.  You must hold the host's host_lock over this call and any access
+ * to the returned scsi_device.
  *
  * Note:  The only reason why drivers would want to use this is because
  * they're need to access the device list in irq context.  Otherwise you
@@ -1006,9 +1015,9 @@ EXPORT_SYMBOL(__scsi_device_lookup);
  * @id:		SCSI target number (physical unit number)
  * @lun:	SCSI Logical Unit Number
  *
- * Looks up the scsi_device with the specified @channel, @id, @lun for a
- * give host.  The returned scsi_device has an additional reference that
- * needs to be release with scsi_host_put once you're done with it.
+ * Description: Looks up the scsi_device with the specified @channel, @id, @lun
+ * for a give host.  The returned scsi_device has an additional reference that
+ * needs to be released with scsi_host_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
 		uint channel, uint id, uint lun)
diff -r a868e8217782 drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_devinfo.c	Fri Oct 26 17:09:14 2007 -0500
@@ -276,11 +276,12 @@ static void scsi_strcpy_devinfo(char *na
 }
 
 /**
- * scsi_dev_info_list_add: add one dev_info list entry.
+ * scsi_dev_info_list_add - add one dev_info list entry.
+ * @compatible: if true, null terminate short strings.  Otherwise space pad.
  * @vendor:	vendor string
  * @model:	model (product) string
  * @strflags:	integer string
- * @flag:	if strflags NULL, use this flag value
+ * @flags:	if strflags NULL, use this flag value
  *
  * Description:
  * 	Create and add one dev_info entry for @vendor, @model, @strflags or
@@ -322,8 +323,7 @@ static int scsi_dev_info_list_add(int co
 }
 
 /**
- * scsi_dev_info_list_add_str: parse dev_list and add to the
- * scsi_dev_info_list.
+ * scsi_dev_info_list_add_str - parse dev_list and add to the scsi_dev_info_list.
  * @dev_list:	string of device flags to add
  *
  * Description:
@@ -374,15 +374,15 @@ static int scsi_dev_info_list_add_str(ch
 }
 
 /**
- * get_device_flags - get device specific flags from the dynamic device
- * list. Called during scan time.
+ * get_device_flags - get device specific flags from the dynamic device list.
+ * @sdev:       &scsi_device to get flags for
  * @vendor:	vendor name
  * @model:	model name
  *
  * Description:
  *     Search the scsi_dev_info_list for an entry matching @vendor and
  *     @model, if found, return the matching flags value, else return
- *     the host or global default settings.
+ *     the host or global default settings.  Called during scan time.
  **/
 int scsi_get_device_flags(struct scsi_device *sdev,
 			  const unsigned char *vendor,
@@ -483,13 +483,11 @@ stop_output:
 }
 
 /* 
- * proc_scsi_dev_info_write: allow additions to the scsi_dev_info_list via
- * /proc.
- *
- * Use: echo "vendor:model:flag" > /proc/scsi/device_info
- *
- * To add a black/white list entry for vendor and model with an integer
- * value of flag to the scsi device info list.
+ * proc_scsi_dev_info_write - allow additions to scsi_dev_info_list via /proc.
+ *
+ * Description: Adds a black/white list entry for vendor and model with an
+ * integer value of flag to the scsi device info list.
+ * To use, echo "vendor:model:flag" > /proc/scsi/device_info
  */
 static int proc_scsi_devinfo_write(struct file *file, const char __user *buf,
 				   unsigned long length, void *data)
@@ -532,8 +530,7 @@ MODULE_PARM_DESC(default_dev_flags,
 		 "scsi default device flag integer value");
 
 /**
- * scsi_dev_info_list_delete: called from scsi.c:exit_scsi to remove
- * 	the scsi_dev_info_list.
+ * scsi_dev_info_list_delete - called from scsi.c:exit_scsi to remove the scsi_dev_info_list.
  **/
 void scsi_exit_devinfo(void)
 {
@@ -552,11 +549,10 @@ void scsi_exit_devinfo(void)
 }
 
 /**
- * scsi_dev_list_init: set up the dynamic device list.
- * @dev_list:	string of device flags to add
+ * scsi_dev_list_init - set up the dynamic device list.
  *
  * Description:
- * 	Add command line @dev_list entries, then add
+ * 	Add command line entries from scsi_dev_flags, then add
  * 	scsi_static_device_list entries to the scsi device info list.
  **/
 int __init scsi_init_devinfo(void)
diff -r a868e8217782 drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_error.c	Fri Oct 26 17:09:14 2007 -0500
@@ -795,7 +795,7 @@ EXPORT_SYMBOL(scsi_eh_finish_cmd);
 /**
  * scsi_eh_get_sense - Get device sense data.
  * @work_q:	Queue of commands to process.
- * @done_q:	Queue of proccessed commands..
+ * @done_q:	Queue of proccessed commands.
  *
  * Description:
  *    See if we need to request sense information.  if so, then get it
@@ -859,7 +859,7 @@ EXPORT_SYMBOL_GPL(scsi_eh_get_sense);
 
 /**
  * scsi_eh_tur - Send TUR to device.
- * @scmd:	Scsi cmd to send TUR
+ * @scmd:	&scsi_cmnd to send TUR
  *
  * Return value:
  *    0 - Device is ready. 1 - Device NOT ready.
@@ -888,14 +888,14 @@ retry_tur:
 }
 
 /**
- * scsi_eh_abort_cmds - abort canceled commands.
- * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * scsi_eh_abort_cmds - abort pending commands.
+ * @work_q:	&list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  * Decription:
  *    Try and see whether or not it makes sense to try and abort the
- *    running command.  this only works out to be the case if we have one
- *    command that has timed out.  if the command simply failed, it makes
+ *    running command.  This only works out to be the case if we have one
+ *    command that has timed out.  If the command simply failed, it makes
  *    no sense to try and abort the command, since as far as the shost
  *    adapter is concerned, it isn't running.
  **/
@@ -932,7 +932,7 @@ static int scsi_eh_abort_cmds(struct lis
 
 /**
  * scsi_eh_try_stu - Send START_UNIT to device.
- * @scmd:	Scsi cmd to send START_UNIT
+ * @scmd:	&scsi_cmnd to send START_UNIT
  *
  * Return value:
  *    0 - Device is ready. 1 - Device NOT ready.
@@ -957,8 +957,9 @@ static int scsi_eh_try_stu(struct scsi_c
 
  /**
  * scsi_eh_stu - send START_UNIT if needed
- * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @shost:	&scsi host being recovered.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  * Notes:
  *    If commands are failing due to not ready, initializing command required,
@@ -1009,10 +1010,11 @@ static int scsi_eh_stu(struct Scsi_Host 
 /**
  * scsi_eh_bus_device_reset - send bdr if needed
  * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  * Notes:
- *    Try a bus device reset.  still, look to see whether we have multiple
+ *    Try a bus device reset.  Still, look to see whether we have multiple
  *    devices that are jammed or not - if we have multiple devices, it
  *    makes no sense to try bus_device_reset - we really would need to try
  *    a bus_reset instead. 
@@ -1064,8 +1066,9 @@ static int scsi_eh_bus_device_reset(stru
 
 /**
  * scsi_eh_bus_reset - send a bus reset 
- * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @shost:	&scsi host being recovered.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  **/
 static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			     struct list_head *work_q,
@@ -1441,7 +1444,8 @@ static void scsi_restart_operations(stru
 /**
  * scsi_eh_ready_devs - check device ready state and recover if not.
  * @shost: 	host to be recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  **/
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
diff -r a868e8217782 drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_ioctl.c	Fri Oct 26 17:09:14 2007 -0500
@@ -174,10 +174,15 @@ static int scsi_ioctl_get_pci(struct scs
 }
 
 
-/*
- * the scsi_ioctl() function differs from most ioctls in that it does
- * not take a major/minor number as the dev field.  Rather, it takes
- * a pointer to a scsi_devices[] element, a structure. 
+/**
+ * scsi_ioctl - Dispatch ioctl to scsi device
+ * @sdev: scsi device receiving ioctl
+ * @cmd: which ioctl is it
+ * @arg: data associated with ioctl
+ *
+ * Description: The scsi_ioctl() function differs from most ioctls in that it
+ * does not take a major/minor number as the dev field.  Rather, it takes
+ * a pointer to a &struct scsi_device. 
  */
 int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
@@ -264,9 +269,12 @@ int scsi_ioctl(struct scsi_device *sdev,
 }
 EXPORT_SYMBOL(scsi_ioctl);
 
-/*
- * the scsi_nonblock_ioctl() function is designed for ioctls which may
- * be executed even if the device is in recovery.
+/**
+ * scsi_nonblock_ioctl() - Handle SG_SCSI_RESET
+ * @sdev: scsi device receiving ioctl
+ * @cmd: Must be SC_SCSI_RESET
+ * @arg: pointer to int containing SG_SCSI_RESET_{DEVICE,BUS,HOST}
+ * @filp: either NULL or a &struct file which must have the O_NONBLOCK flag.
  */
 int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 			    void __user *arg, struct file *filp)
@@ -276,7 +284,7 @@ int scsi_nonblockable_ioctl(struct scsi_
 	/* The first set of iocts may be executed even if we're doing
 	 * error processing, as long as the device was opened
 	 * non-blocking */
-	if (filp && filp->f_flags & O_NONBLOCK) {
+	if (filp && (filp->f_flags & O_NONBLOCK)) {
 		if (scsi_host_in_recovery(sdev->host))
 			return -ENODEV;
 	} else if (!scsi_block_when_processing_errors(sdev))
diff -r a868e8217782 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_lib.c	Fri Oct 26 17:09:14 2007 -0500
@@ -274,7 +274,7 @@ static void scsi_bi_endio(struct bio *bi
 /**
  * scsi_req_map_sg - map a scatterlist into a request
  * @rq:		request to fill
- * @sg:		scatterlist
+ * @sgl:	scatterlist
  * @nsegs:	number of elements
  * @bufflen:	len of buffer
  * @gfp:	memory allocation flags
@@ -365,13 +365,15 @@ free_bios:
  * @sdev:	scsi device
  * @cmd:	scsi command
  * @cmd_len:	length of scsi cdb
- * @data_direction: data direction
+ * @data_direction: DMA_TO_DEVICE, DMA_FROM_DEVICE, or DMA_NONE
  * @buffer:	data buffer (this can be a kernel buffer or scatterlist)
  * @bufflen:	len of buffer
  * @use_sg:	if buffer is a scatterlist this is the number of elements
  * @timeout:	request timeout in seconds
  * @retries:	number of times to retry request
- * @flags:	or into request flags
+ * @privdata:	data passed to done()
+ * @done:	callback function when done
+ * @gfp:	memory allocation flags
  **/
 int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
 		       int cmd_len, int data_direction, void *buffer, unsigned bufflen,
@@ -1804,7 +1806,7 @@ void scsi_exit_queue(void)
  *	@timeout: command timeout
  *	@retries: number of retries before failing
  *	@data: returns a structure abstracting the mode header data
- *	@sense: place to put sense data (or NULL if no sense to be collected).
+ *	@sshdr: place to put sense data (or NULL if no sense to be collected).
  *		must be SCSI_SENSE_BUFFERSIZE big.
  *
  *	Returns zero if successful; negative error number or scsi
@@ -1881,7 +1883,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	@timeout: command timeout
  *	@retries: number of retries before failing
  *	@data: returns a structure abstracting the mode header data
- *	@sense: place to put sense data (or NULL if no sense to be collected).
+ *	@sshdr: place to put sense data (or NULL if no sense to be collected).
  *		must be SCSI_SENSE_BUFFERSIZE big.
  *
  *	Returns zero if unsuccessful, or the header offset (either 4
@@ -2324,7 +2326,7 @@ EXPORT_SYMBOL_GPL(scsi_target_unblock);
 
 /**
  * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt
- * @sg:		scatter-gather list
+ * @sgl:	scatter-gather list
  * @sg_count:	number of segments in sg
  * @offset:	offset in bytes into sg, on return offset into the mapped area
  * @len:	bytes to map, on return number of bytes mapped
diff -r a868e8217782 drivers/scsi/scsi_netlink.c
--- a/drivers/scsi/scsi_netlink.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_netlink.c	Fri Oct 26 17:09:14 2007 -0500
@@ -32,11 +32,12 @@ EXPORT_SYMBOL_GPL(scsi_nl_sock);
 
 
 /**
- * scsi_nl_rcv_msg -
- *    Receive message handler. Extracts message from a receive buffer.
+ * scsi_nl_rcv_msg - Receive message handler.
+ * @skb:		socket receive buffer
+ *
+ * Description: Extracts message from a receive buffer.
  *    Validates message header and calls appropriate transport message handler
  *
- * @skb:		socket receive buffer
  *
  **/
 static void
@@ -99,9 +100,7 @@ next_msg:
 
 
 /**
- * scsi_nl_rcv_event -
- *    Event handler for a netlink socket.
- *
+ * scsi_nl_rcv_event - Event handler for a netlink socket.
  * @this:		event notifier block
  * @event:		event type
  * @ptr:		event payload
@@ -129,9 +128,7 @@ static struct notifier_block scsi_netlin
 
 
 /**
- * scsi_netlink_init -
- *    Called by SCSI subsystem to intialize the SCSI transport netlink
- *    interface
+ * scsi_netlink_init - Called by SCSI subsystem to intialize the SCSI transport netlink interface
  *
  **/
 void
@@ -160,9 +157,7 @@ scsi_netlink_init(void)
 
 
 /**
- * scsi_netlink_exit -
- *    Called by SCSI subsystem to disable the SCSI transport netlink
- *    interface
+ * scsi_netlink_exit - Called by SCSI subsystem to disable the SCSI transport netlink interface
  *
  **/
 void
diff -r a868e8217782 drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_proc.c	Fri Oct 26 17:09:14 2007 -0500
@@ -45,6 +45,16 @@ static struct proc_dir_entry *proc_scsi;
 /* Protect sht->present and sht->proc_dir */
 static DEFINE_MUTEX(global_host_template_mutex);
 
+/**
+ * proc_scsi_read - handle read from /proc by calling host's proc_info() command
+ * @buffer: passed to proc_info
+ * @start: passed to proc_info
+ * @offset: passed to proc_info
+ * @length: passed to proc_info
+ * @eof: returns whether length read was less than requested
+ * @data: pointer to a &struct Scsi_Host
+ */
+
 static int proc_scsi_read(char *buffer, char **start, off_t offset,
 			  int length, int *eof, void *data)
 {
@@ -57,6 +67,13 @@ static int proc_scsi_read(char *buffer, 
 	return n;
 }
 
+/**
+ * proc_scsi_write_proc - Handle write to /proc by calling host's proc_info()
+ * @file: not used
+ * @buf: source of data to write.
+ * @count: number of bytes (at most PROC_BLOCK_SIZE) to write.
+ * @data: pointer to &struct Scsi_Host
+ */
 static int proc_scsi_write_proc(struct file *file, const char __user *buf,
                            unsigned long count, void *data)
 {
@@ -79,6 +96,13 @@ out:
 	free_page((unsigned long)page);
 	return ret;
 }
+
+/**
+ * scsi_proc_hostdir_add - Create directory in /proc for a scsi host
+ * @sht: owner of this directory
+ *
+ * Sets sht->proc_dir to the new directory.
+ */
 
 void scsi_proc_hostdir_add(struct scsi_host_template *sht)
 {
@@ -97,6 +121,10 @@ void scsi_proc_hostdir_add(struct scsi_h
 	mutex_unlock(&global_host_template_mutex);
 }
 
+/**
+ * scsi_proc_hostdir_rm - remove directory in /proc for a scsi host
+ * @sht: owner of directory
+ */
 void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
 {
 	if (!sht->proc_info)
@@ -110,6 +138,11 @@ void scsi_proc_hostdir_rm(struct scsi_ho
 	mutex_unlock(&global_host_template_mutex);
 }
 
+
+/**
+ * scsi_proc_host_add - Add entry for this host to appropriate /proc dir
+ * @shost: host to add
+ */
 void scsi_proc_host_add(struct Scsi_Host *shost)
 {
 	struct scsi_host_template *sht = shost->hostt;
@@ -133,6 +166,10 @@ void scsi_proc_host_add(struct Scsi_Host
 	p->owner = sht->module;
 }
 
+/**
+ * scsi_proc_host_rm - remove this host's entry from /proc
+ * @shost: which host
+ */
 void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
 	char name[10];
@@ -143,7 +180,14 @@ void scsi_proc_host_rm(struct Scsi_Host 
 	sprintf(name,"%d", shost->host_no);
 	remove_proc_entry(name, shost->hostt->proc_dir);
 }
-
+/**
+ * proc_print_scsidevice - return data about this host
+ * @dev: A scsi device
+ * @data: &struct seq_file to output to.
+ *
+ * Description: prints Host, Channel, Id, Lun, Vendor, Model, Rev, Type,
+ * and revision.
+ */
 static int proc_print_scsidevice(struct device *dev, void *data)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -189,6 +233,21 @@ static int proc_print_scsidevice(struct 
 	return 0;
 }
 
+/**
+ * scsi_add_single_device - Respond to user request to probe for/add device
+ * @host: user-supplied decimal integer
+ * @channel: user-supplied decimal integer
+ * @id: user-supplied decimal integer
+ * @lun: user-supplied decimal integer
+ *
+ * Description: called by writing "scsi add-single-device" to /proc/scsi/scsi.
+ *
+ * does scsi_host_lookup() and either user_scan() if that transport
+ * type supports it, or else scsi_scan_host_selected()
+ *
+ * Note: this seems to be aimed exclusively at SCSI parallel busses.
+ */
+
 static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
 {
 	struct Scsi_Host *shost;
@@ -206,6 +265,16 @@ static int scsi_add_single_device(uint h
 	return error;
 }
 
+/**
+ * scsi_remove_single_device - Respond to user request to remove a device
+ * @host: user-supplied decimal integer
+ * @channel: user-supplied decimal integer
+ * @id: user-supplied decimal integer
+ * @lun: user-supplied decimal integer
+ *
+ * Description: called by writing "scsi remove-single-device" to
+ * /proc/scsi/scsi.  Does a scsi_device_lookup() and scsi_remove_device()
+ */
 static int scsi_remove_single_device(uint host, uint channel, uint id, uint lun)
 {
 	struct scsi_device *sdev;
@@ -226,6 +295,25 @@ static int scsi_remove_single_device(uin
 	return error;
 }
 
+/**
+ * proc_scsi_write - handle writes to /proc/scsi/scsi
+ * @file: not used
+ * @buf: buffer to write
+ * @length: length of buf, at most PAGE_SIZE
+ * @ppos: not used
+ *
+ * Description: this provides a legacy mechanism to add or remove devices by
+ * Host, Channel, ID, and Lun.  To use,
+ * "echo 'scsi add-single-device 0 1 2 3' > /proc/scsi/scsi" or
+ * "echo 'scsi remove-single-device 0 1 2 3' > /proc/scsi/scsi" with
+ * "0 1 2 3" replaced by the Host, Channel, Id, and Lun.
+ *
+ * Note: this seems to be aimed at parallel SCSI. Most modern busses (USB,
+ * SATA, Firewire, Fibre Channel, etc) dynamically assign these values to
+ * provide a unique identifier and nothing more.
+ */
+
+
 static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 			       size_t length, loff_t *ppos)
 {
@@ -291,6 +379,11 @@ static ssize_t proc_scsi_write(struct fi
 	return err;
 }
 
+/**
+ * proc_scsi_show - show contents of /proc/scsi/scsi (attached devices)
+ * @s: output goes here
+ * @p: not used
+ */
 static int proc_scsi_show(struct seq_file *s, void *p)
 {
 	seq_printf(s, "Attached devices:\n");
@@ -298,10 +391,17 @@ static int proc_scsi_show(struct seq_fil
 	return 0;
 }
 
+/**
+ * proc_scsi_open - glue function
+ * @inode: not used
+ * @file: passed to single_open()
+ *
+ * Associates proc_scsi_show with this file
+ */
 static int proc_scsi_open(struct inode *inode, struct file *file)
 {
 	/*
-	 * We don't really needs this for the write case but it doesn't
+	 * We don't really need this for the write case but it doesn't
 	 * harm either.
 	 */
 	return single_open(file, proc_scsi_show, NULL);
@@ -315,6 +415,9 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
+/**
+ * scsi_init_procfs - create scsi and scsi/scsi in procfs
+ */
 int __init scsi_init_procfs(void)
 {
 	struct proc_dir_entry *pde;
@@ -336,6 +439,9 @@ err1:
 	return -ENOMEM;
 }
 
+/**
+ * scsi_exit_procfs - Remove scsi/scsi and scsi from procfs
+ */
 void scsi_exit_procfs(void)
 {
 	remove_proc_entry("scsi/scsi", NULL);
diff -r a868e8217782 drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_scan.c	Fri Oct 26 17:09:14 2007 -0500
@@ -221,6 +221,9 @@ static void scsi_unlock_floptical(struct
 
 /**
  * scsi_alloc_sdev - allocate and setup a scsi_Device
+ * @starget: which target to allocate a &scsi_device for
+ * @lun: which lun
+ * @hostdata: usually NULL and set by ->slave_alloc instead
  *
  * Description:
  *     Allocate, initialize for io, and return a pointer to a scsi_Device.
@@ -954,9 +957,10 @@ static unsigned char *scsi_inq_str(unsig
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @starget:	pointer to target device structure
  * @lun:	LUN of target device
- * @sdevscan:	probe the LUN corresponding to this scsi_device
- * @sdevnew:	store the value of any new scsi_device allocated
  * @bflagsp:	store bflags here if not NULL
+ * @sdevp:	probe the LUN corresponding to this scsi_device
+ * @rescan:     if nonzero skip some code only needed on first scan
+ * @hostdata:	passed to scsi_alloc_sdev()
  *
  * Description:
  *     Call scsi_probe_lun, if a LUN with an attached device is found,
@@ -1107,6 +1111,8 @@ static int scsi_probe_and_add_lun(struct
  * scsi_sequential_lun_scan - sequentially scan a SCSI target
  * @starget:	pointer to target structure to scan
  * @bflags:	black/white list flag for LUN 0
+ * @scsi_level: Which version of the standard does this device adhere to
+ * @rescan:     passed to scsi_probe_add_lun()
  *
  * Description:
  *     Generally, scan from LUN 1 (LUN 0 is assumed to already have been
@@ -1217,7 +1223,7 @@ EXPORT_SYMBOL(scsilun_to_int);
 
 /**
  * int_to_scsilun: reverts an int into a scsi_lun
- * @int:        integer to be reverted
+ * @lun:        integer to be reverted
  * @scsilun:	struct scsi_lun to be set.
  *
  * Description:
@@ -1249,18 +1255,22 @@ EXPORT_SYMBOL(int_to_scsilun);
 
 /**
  * scsi_report_lun_scan - Scan using SCSI REPORT LUN results
- * @sdevscan:	scan the host, channel, and id of this scsi_device
+ * @starget: which target
+ * @bflags: Zero or a mix of BLIST_NOLUN, BLIST_REPORTLUN2, or BLIST_NOREPORTLUN
+ * @rescan: nonzero if we can skip code only needed on first scan
  *
  * Description:
- *     If @sdevscan is for a SCSI-3 or up device, send a REPORT LUN
- *     command, and scan the resulting list of LUNs by calling
- *     scsi_probe_and_add_lun.
- *
- *     Modifies sdevscan->lun.
+ *   Fast scanning for modern (SCSI-3) devices by sending a REPORT LUN command.
+ *   Scan the resulting list of LUNs by calling scsi_probe_and_add_lun.
+ *
+ *   If BLINK_REPORTLUN2 is set, scan a target that supports more than 8
+ *   LUNs even if it's older than SCSI-3.
+ *   If BLIST_NOREPORTLUN is set, return 1 always.
+ *   If BLIST_NOLUN is set, return 0 always.
  *
  * Return:
  *     0: scan completed (or no memory, so further scanning is futile)
- *     1: no report lun scan, or not configured
+ *     1: could not scan with REPORT LUN
  **/
 static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				int rescan)
diff -r a868e8217782 drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_fc.c	Fri Oct 26 17:09:14 2007 -0500
@@ -481,9 +481,9 @@ MODULE_PARM_DESC(dev_loss_tmo,
 		 " exceeded, the scsi target is removed. Value should be"
 		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
 
-/**
+/*
  * Netlink Infrastructure
- **/
+ */
 
 static atomic_t fc_event_seq;
 
@@ -491,7 +491,7 @@ static atomic_t fc_event_seq;
  * fc_get_event_number - Obtain the next sequential FC event number
  *
  * Notes:
- *   We could have inline'd this, but it would have required fc_event_seq to
+ *   We could have inlined this, but it would have required fc_event_seq to
  *   be exposed. For now, live with the subroutine call.
  *   Atomic used to avoid lock/unlock...
  **/
@@ -586,6 +586,7 @@ EXPORT_SYMBOL(fc_host_post_event);
  * @event_number:	fc event number obtained from get_fc_event_number()
  * @data_len:		amount, in bytes, of vendor unique data
  * @data_buf:		pointer to vendor unique data
+ * @vendor_id:          Vendor id
  *
  * Notes:
  *	This routine assumes no locks are held on entry.
@@ -2214,13 +2215,13 @@ fc_flush_devloss(struct Scsi_Host *shost
 /**
  * fc_remove_host - called to terminate any fc_transport-related elements
  *                  for a scsi host.
- * @rport:	remote port to be unblocked.
+ * @shost:	Which &Scsi_Host
  *
  * This routine is expected to be called immediately preceeding the
  * a driver's call to scsi_remove_host().
  *
  * WARNING: A driver utilizing the fc_transport, which fails to call
- *   this routine prior to scsi_remote_host(), will leave dangling
+ *   this routine prior to scsi_remove_host(), will leave dangling
  *   objects in /sys/class/fc_remote_ports. Access to any of these
  *   objects can result in a system crash !!!
  *
@@ -2691,11 +2692,11 @@ EXPORT_SYMBOL(fc_remote_port_add);
  * port is no longer part of the topology. Note: Although a port
  * may no longer be part of the topology, it may persist in the remote
  * ports displayed by the fc_host. We do this under 2 conditions:
- * - If the port was a scsi target, we delay its deletion by "blocking" it.
+ * 1) If the port was a scsi target, we delay its deletion by "blocking" it.
  *   This allows the port to temporarily disappear, then reappear without
  *   disrupting the SCSI device tree attached to it. During the "blocked"
  *   period the port will still exist.
- * - If the port was a scsi target and disappears for longer than we
+ * 2) If the port was a scsi target and disappears for longer than we
  *   expect, we'll delete the port and the tear down the SCSI device tree
  *   attached to it. However, we want to semi-persist the target id assigned
  *   to that port if it eventually does exist. The port structure will
@@ -2709,7 +2710,8 @@ EXPORT_SYMBOL(fc_remote_port_add);
  * temporary blocked state. From the LLDD's perspective, the rport no
  * longer exists. From the SCSI midlayer's perspective, the SCSI target
  * exists, but all sdevs on it are blocked from further I/O. The following
- * is then expected:
+ * is then expected.
+ *
  *   If the remote port does not return (signaled by a LLDD call to
  *   fc_remote_port_add()) within the dev_loss_tmo timeout, then the
  *   scsi target is removed - killing all outstanding i/o and removing the
@@ -2795,9 +2797,10 @@ EXPORT_SYMBOL(fc_remote_port_delete);
  * fc_remote_port_rolechg - notifies the fc transport that the roles
  *		on a remote may have changed.
  * @rport:	The remote port that changed.
- *
- * The LLDD calls this routine to notify the transport that the roles
- * on a remote port may have changed. The largest effect of this is
+ * @roles:      New roles for this port.
+ *
+ * Description: The LLDD calls this routine to notify the transport that the
+ * roles on a remote port may have changed. The largest effect of this is
  * if a port now becomes a FCP Target, it must be allocated a
  * scsi target id.  If the port is no longer a FCP target, any
  * scsi target id value assigned to it will persist in case the
diff -r a868e8217782 drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_iscsi.c	Fri Oct 26 17:09:14 2007 -0500
@@ -328,6 +328,7 @@ EXPORT_SYMBOL_GPL(iscsi_add_session);
  * iscsi_create_session - create iscsi class session
  * @shost: scsi host
  * @transport: iscsi transport
+ * @target_id: which target
  *
  * This can be called from a LLD or iscsi_transport.
  **/
@@ -465,7 +466,7 @@ EXPORT_SYMBOL_GPL(iscsi_create_conn);
 
 /**
  * iscsi_destroy_conn - destroy iscsi class connection
- * @session: iscsi cls session
+ * @conn: iscsi cls session
  *
  * This can be called from a LLD or iscsi_transport.
  **/
diff -r a868e8217782 drivers/scsi/scsi_transport_sas.c
--- a/drivers/scsi/scsi_transport_sas.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_sas.c	Fri Oct 26 17:09:14 2007 -0500
@@ -1309,6 +1309,7 @@ static void sas_rphy_initialize(struct s
 
 /**
  * sas_end_device_alloc - allocate an rphy for an end device
+ * @parent: which port
  *
  * Allocates an SAS remote PHY structure, connected to @parent.
  *
@@ -1345,6 +1346,8 @@ EXPORT_SYMBOL(sas_end_device_alloc);
 
 /**
  * sas_expander_alloc - allocate an rphy for an end device
+ * @parent: which port
+ * @type: SAS_EDGE_EXPANDER_DEVICE or SAS_FANOUT_EXPANDER_DEVICE
  *
  * Allocates an SAS remote PHY structure, connected to @parent.
  *
@@ -1431,7 +1434,7 @@ EXPORT_SYMBOL(sas_rphy_add);
 
 /**
  * sas_rphy_free  --  free a SAS remote PHY
- * @rphy	SAS remote PHY to free
+ * @rphy: SAS remote PHY to free
  *
  * Frees the specified SAS remote PHY.
  *
diff -r a868e8217782 drivers/scsi/scsi_transport_srp.c
--- a/drivers/scsi/scsi_transport_srp.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_srp.c	Fri Oct 26 17:09:14 2007 -0500
@@ -243,7 +243,7 @@ EXPORT_SYMBOL_GPL(srp_rport_add);
 
 /**
  * srp_rport_del  --  remove a SRP remote port
- * @port:	SRP remote port to remove
+ * @rport:	SRP remote port to remove
  *
  * Removes the specified SRP remote port.
  */
diff -r a868e8217782 drivers/scsi/scsicam.c
--- a/drivers/scsi/scsicam.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsicam.c	Fri Oct 26 17:09:14 2007 -0500
@@ -24,6 +24,14 @@ static int setsize(unsigned long capacit
 static int setsize(unsigned long capacity, unsigned int *cyls, unsigned int *hds,
 		   unsigned int *secs);
 
+/**
+ * scsi_bios_ptable - Read PC partition table out of first sector of device.
+ * @dev: from this device
+ *
+ * Description: Reads the first sector from the device and returns %0x42 bytes
+ *              starting at offset %0x1be.
+ * Returns: partition table in kmalloc(GFP_KERNEL) memory, or NULL on error.
+ */
 unsigned char *scsi_bios_ptable(struct block_device *dev)
 {
 	unsigned char *res = kmalloc(66, GFP_KERNEL);
@@ -43,15 +51,17 @@ unsigned char *scsi_bios_ptable(struct b
 }
 EXPORT_SYMBOL(scsi_bios_ptable);
 
-/*
- * Function : int scsicam_bios_param (struct block_device *bdev, ector_t capacity, int *ip)
- *
- * Purpose : to determine the BIOS mapping used for a drive in a 
+/**
+ * scsicam_bios_param - Determine geometry of a disk in cylinders/heads/sectors.
+ * @bdev: which device
+ * @capacity: size of the disk in sectors
+ * @ip: return value: ip[0]=heads, ip[1]=sectors, ip[2]=cylinders
+ *
+ * Description : determine the BIOS mapping/geometry used for a drive in a 
  *      SCSI-CAM system, storing the results in ip as required
  *      by the HDIO_GETGEO ioctl().
  *
  * Returns : -1 on failure, 0 on success.
- *
  */
 
 int scsicam_bios_param(struct block_device *bdev, sector_t capacity, int *ip)
@@ -98,15 +108,18 @@ int scsicam_bios_param(struct block_devi
 }
 EXPORT_SYMBOL(scsicam_bios_param);
 
-/*
- * Function : static int scsi_partsize(unsigned char *buf, unsigned long 
- *     capacity,unsigned int *cyls, unsigned int *hds, unsigned int *secs);
- *
- * Purpose : to determine the BIOS mapping used to create the partition
+/**
+ * scsi_partsize - Parse cylinders/heads/sectors from PC partition table
+ * @buf: partition table, see scsi_bios_ptable()
+ * @capacity: size of the disk in sectors
+ * @cyls: put cylinders here
+ * @hds: put heads here
+ * @secs: put sectors here
+ *
+ * Description: determine the BIOS mapping/geometry used to create the partition
  *      table, storing the results in *cyls, *hds, and *secs 
  *
- * Returns : -1 on failure, 0 on success.
- *
+ * Returns: -1 on failure, 0 on success.
  */
 
 int scsi_partsize(unsigned char *buf, unsigned long capacity,
@@ -194,7 +207,7 @@ EXPORT_SYMBOL(scsi_partsize);
  *
  * WORKING                                                    X3T9.2
  * DRAFT                                                        792D
- *
+ * see http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf
  *
  *                                                        Revision 6
  *                                                         10-MAR-94

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
