From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.5 scsi mid level - lower level interface description
Date: Wed, 24 Apr 2002 17:12:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020424171247.A27619@eng2.beaverton.ibm.com>
References: <3CC61421.ACA708DE@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CC61421.ACA708DE@torque.net>; from dougg@torque.net on Tue, Apr 23, 2002 at 10:10:41PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Tue, Apr 23, 2002 at 10:10:41PM -0400, Douglas Gilbert wrote:
> The attachment attempts to describe the interface between
> the scsi mid level and lower level drivers in the lk 2.5
> series.
> 
> It is a text file which I plan to place in the drivers/scsi
> directory. At the same time the rather dated callback
> function documentation in hosts.h could be removed and replaced 
> with a reference to this text file.
> 
> Criticisms, corrections and contributions are welcome.
> 
> Doug Gilbert

Doug,

Nice document.

I have a few suggested changes:

--- scsi_ll_inf.txt-orig	Wed Apr 24 09:41:05 2002
+++ scsi_ll_inf.txt	Wed Apr 24 17:08:47 2002
@@ -267,11 +267,9 @@
  *      @scp: pointer to scsi command object
  *      @done: function pointer to be invoked on completion
  *
- *      Returns an int with four component bytes: scsi_byte, msg_byte, 
- *      host_byte, driver_byte (status_byte is in the lsb). A value of
- *      0 is an unqualified success.
+ *      Returns 1 if the adapter is busy, else returns 0.
  *
- *      Required: if Scsi_Host::can_queue can ever by set (one)
+ *      Required: if Scsi_Host::can_queue is ever non-zero
  *                then this function is required.
  *
  *      Locks: Scsi_Host::host_lock held on entry (with "irqsave") and
@@ -281,7 +279,7 @@
  *      not wait for IO to complete. Hence the 'done' callback is invoked 
  *      (often directly from an interrupt service routine) sometime after
  *      this command has returned. In some cases (e.g. pseudo adapter 
- *      drivers the manufacture the response to a scsi INQUIRY)
+ *      drivers that manufacture the response to a scsi INQUIRY)
  *      the 'done' callback may be invoked before this function returns.
  *      If the 'done' callback is not invoked within a certain period
  *      the scsi mid level will commence error processing.
@@ -399,7 +397,8 @@
                    this host. Issued in ascending order from 0 (and the
                    positioning can be influenced by the scsihosts
                    kernel boot (or module) parameter
-    can_queue    - 1->use queuecommand(), 0->use command()
+    can_queue    - 0->use command(), greater than 0->use queuecommand() and do
+                   not send more than can_queue commands to the adapter.
     this_id      - scsi id of host (scsi initiator) or -1 if not known
     sg_tablesize - maximum scatter gather elements allowed by host.
                    0 implies scatter gather not supported by host
@@ -423,9 +422,9 @@
 
 Scsi_Device
 -----------
-There is one instance of this structure for each attached scsi (target) 
-device on a host. Scsi devices are uniquely identified within a host by 
-bus number, target id and logical unit number (lun).
+Generally, there is one instance of this structure for each scsi logical unit
+on a host. Scsi devices are uniquely identified within a host by bus number,
+target id and logical unit number (lun).
 The structure is defined in scsi.h
 
 Scsi_Cmnd
@@ -466,7 +465,7 @@
 -----
 [1] invoked during kernel initialization when built in or during module
     initialization. The scsi mid level will already be initialized.
-[2] detect() calls scsi_register() for each HBA is wants to control
+[2] detect() calls scsi_register() for each HBA it wants to control
     (if not scsi_register_host() will do it instead)
 [3] called as part of scsi bus scan during discovery of devices. This scan
     will be done for each host. Scsi commands such as INQUIRY, MODE SENSE


-- Patrick
