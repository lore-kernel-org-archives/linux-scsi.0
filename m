From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips 2.5 driver update [4/4]: use dev_printk
Date: Tue, 6 May 2003 13:34:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B0377A6@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C313F5.BC2C4900"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:28315 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S263998AbTEFRWC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2003 13:22:02 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id h46HV8Z29110
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2003 10:31:08 -0700
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8p2+Sun/8.8.8) with ESMTP id KAA07704
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2003 10:34:27 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C313F5.BC2C4900
Content-Type: text/plain;
	charset="iso-8859-1"

Use the new dev_printk.

Thanks go to Mike Christie who originally
created this patch.

David Jeffery

 ips.c |  135
+++++++++++++++++++++++++++---------------------------------------
 ips.h |    5 ++
 2 files changed, 62 insertions(+), 78 deletions(-)


------_=_NextPart_000_01C313F5.BC2C4900
Content-Type: text/plain;
	name="patch4.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch4.txt"

diff -urN linux-2.5.69_p3/drivers/scsi/ips.c =
linux-2.5.69_p4/drivers/scsi/ips.c=0A=
--- linux-2.5.69_p3/drivers/scsi/ips.c	2003-05-06 13:20:31.000000000 =
-0400=0A=
+++ linux-2.5.69_p4/drivers/scsi/ips.c	2003-05-06 13:19:58.000000000 =
-0400=0A=
@@ -680,13 +680,13 @@=0A=
    scb->cmd.flush_cache.reserved3 =3D 0;=0A=
    scb->cmd.flush_cache.reserved4 =3D 0;=0A=
 =0A=
-   printk(KERN_NOTICE "(%s%d) Flushing Cache.\n", ips_name, =
ha->host_num);=0A=
+   IPS_PRINTK(KERN_WARNING, ha->pcidev, "Flushing Cache.\n");=0A=
 =0A=
    /* send command */=0A=
    if (ips_send_wait(ha, scb, ips_cmd_timeout, IPS_INTR_ON) =3D=3D =
IPS_FAILURE)=0A=
-      printk(KERN_NOTICE "(%s%d) Incomplete Flush.\n", ips_name, =
ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "Incomplete Flush.\n");=0A=
 =0A=
-   printk(KERN_NOTICE "(%s%d) Flushing Complete.\n", ips_name, =
ha->host_num);=0A=
+   IPS_PRINTK(KERN_WARNING, ha->pcidev, "Flushing Complete.\n");=0A=
 =0A=
    ips_sh[i] =3D NULL;=0A=
    ips_ha[i] =3D NULL;=0A=
@@ -753,13 +753,13 @@=0A=
       scb->cmd.flush_cache.reserved3 =3D 0;=0A=
       scb->cmd.flush_cache.reserved4 =3D 0;=0A=
 =0A=
-      printk(KERN_NOTICE "(%s%d) Flushing Cache.\n", ips_name, =
ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "Flushing Cache.\n");=0A=
 =0A=
       /* send command */=0A=
       if (ips_send_wait(ha, scb, ips_cmd_timeout, IPS_INTR_ON) =3D=3D =
IPS_FAILURE)=0A=
-         printk(KERN_NOTICE "(%s%d) Incomplete Flush.\n", ips_name, =
ha->host_num);=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "Incomplete =
Flush.\n");=0A=
       else=0A=
-         printk(KERN_NOTICE "(%s%d) Flushing Complete.\n", ips_name, =
ha->host_num);=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "Flushing =
Complete.\n");=0A=
    }=0A=
 =0A=
    return (NOTIFY_OK);=0A=
@@ -909,7 +909,7 @@=0A=
       /* Attempt the flush command */=0A=
       ret =3D ips_send_wait(ha, scb, ips_cmd_timeout, =
IPS_INTR_IORL);=0A=
       if (ret =3D=3D IPS_SUCCESS) {=0A=
-         printk(KERN_NOTICE "(%s%d) Reset Request - Flushed Cache\n", =
ips_name, ha->host_num);=0A=
+         IPS_PRINTK(KERN_NOTICE, ha->pcidev, "Reset Request - Flushed =
Cache\n");=0A=
          return (SUCCESS);=0A=
          }=0A=
    }=0A=
@@ -923,16 +923,14 @@=0A=
     * command must have already been sent=0A=
     * reset the controller=0A=
     */=0A=
-   printk(KERN_NOTICE "(%s%d) Resetting controller.\n",=0A=
-          ips_name, ha->host_num);=0A=
+   IPS_PRINTK(KERN_NOTICE, ha->pcidev, "Resetting controller.\n");=0A=
    ret =3D (*ha->func.reset)(ha);=0A=
 =0A=
    if (!ret) {=0A=
       Scsi_Cmnd *scsi_cmd;=0A=
 =0A=
-      printk(KERN_NOTICE=0A=
-             "(%s%d) Controller reset failed - controller now =
offline.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_NOTICE, ha->pcidev,=0A=
+                 "Controller reset failed - controller now =
offline.\n");=0A=
 =0A=
       /* Now fail all of the active commands */=0A=
       DEBUG_VAR(1, "(%s%d) Failing active commands",=0A=
@@ -960,9 +958,8 @@=0A=
    if (!ips_clear_adapter(ha, IPS_INTR_IORL)) {=0A=
       Scsi_Cmnd *scsi_cmd;=0A=
 =0A=
-      printk(KERN_NOTICE=0A=
-             "(%s%d) Controller reset failed - controller now =
offline.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_NOTICE, ha->pcidev,=0A=
+                 "Controller reset failed - controller now =
offline.\n");=0A=
 =0A=
       /* Now fail all of the active commands */=0A=
       DEBUG_VAR(1, "(%s%d) Failing active commands",=0A=
@@ -1411,8 +1408,7 @@=0A=
          break;=0A=
 =0A=
       if (cstatus.fields.command_id > (IPS_MAX_CMDS - 1)) {=0A=
-         printk(KERN_WARNING "(%s%d) Spurious interrupt; no =
ccb.\n",=0A=
-                ips_name, ha->host_num);=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "Spurious interrupt; no =
ccb.\n");=0A=
 =0A=
          continue;=0A=
       }=0A=
@@ -1729,7 +1725,7 @@=0A=
       if(pt->CoppCP.cmd.flashfw.count + ha->flash_datasize >=0A=
         (PAGE_SIZE << ha->flash_order)){=0A=
          ips_free_flash_copperhead(ha);=0A=
-         printk(KERN_WARNING "failed size sanity check\n");=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "failed size sanity =
check\n");=0A=
          return IPS_FAILURE;=0A=
       }=0A=
    }=0A=
@@ -2452,15 +2448,13 @@=0A=
    ips_ffdc_reset(ha, IPS_INTR_IORL);=0A=
 =0A=
    if (!ips_read_config(ha, IPS_INTR_IORL)) {=0A=
-      printk(KERN_WARNING "(%s%d) unable to read config from =
controller.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "unable to read config from =
controller.\n");=0A=
 =0A=
       return (0);=0A=
    } /* end if */=0A=
 =0A=
    if (!ips_read_adapter_status(ha, IPS_INTR_IORL)) {=0A=
-      printk(KERN_WARNING "(%s%d) unable to read controller =
status.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "unable to read controller =
status.\n");=0A=
 =0A=
       return (0);=0A=
    }=0A=
@@ -2469,16 +2463,14 @@=0A=
    ips_identify_controller(ha);=0A=
 =0A=
    if (!ips_read_subsystem_parameters(ha, IPS_INTR_IORL)) {=0A=
-      printk(KERN_WARNING "(%s%d) unable to read subsystem =
parameters.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "unable to read subsystem =
parameters.\n");=0A=
 =0A=
       return (0);=0A=
    }=0A=
 =0A=
    /* write nvram user page 5 */=0A=
    if (!ips_write_driver_status(ha, IPS_INTR_IORL)) {=0A=
-      printk(KERN_WARNING "(%s%d) unable to write driver info to =
controller.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "unable to write driver =
info to controller.\n");=0A=
 =0A=
       return (0);=0A=
    }=0A=
@@ -3235,16 +3227,14 @@=0A=
    METHOD_TRACE("ipsintr_done", 2);=0A=
 =0A=
    if (!scb) {=0A=
-      printk(KERN_WARNING "(%s%d) Spurious interrupt; scb NULL.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "Spurious interrupt; scb =
NULL.\n");=0A=
 =0A=
       return ;=0A=
    }=0A=
 =0A=
    if (scb->scsi_cmd =3D=3D NULL) {=0A=
       /* unexpected interrupt */=0A=
-      printk(KERN_WARNING "(%s%d) Spurious interrupt; scsi_cmd not =
set.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "Spurious interrupt; =
scsi_cmd not set.\n");=0A=
 =0A=
       return;=0A=
    }=0A=
@@ -4679,8 +4669,8 @@=0A=
    }=0A=
 =0A=
    if (PostByte[0] < IPS_GOOD_POST_STATUS) {=0A=
-      printk(KERN_WARNING "(%s%d) reset controller fails (post status =
%x %x).\n",=0A=
-             ips_name, ha->host_num, PostByte[0], PostByte[1]);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "reset controller fails =
(post status %x %x).\n",=0A=
+                 PostByte[0], PostByte[1]);=0A=
 =0A=
       return (0);=0A=
    }=0A=
@@ -4771,8 +4761,8 @@=0A=
    }=0A=
 =0A=
    if (PostByte[0] < IPS_GOOD_POST_STATUS) {=0A=
-      printk(KERN_WARNING "(%s%d) reset controller fails (post status =
%x %x).\n",=0A=
-             ips_name, ha->host_num, PostByte[0], PostByte[1]);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "reset controller fails =
(post status %x %x).\n",=0A=
+                 PostByte[0], PostByte[1]);=0A=
 =0A=
       return (0);=0A=
    }=0A=
@@ -4858,8 +4848,7 @@=0A=
 =0A=
    if (i >=3D 45) {=0A=
       /* error occurred */=0A=
-      printk(KERN_WARNING "(%s%d) timeout waiting for post.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "timeout waiting for =
post.\n");=0A=
 =0A=
       return (0);=0A=
    }=0A=
@@ -4867,7 +4856,7 @@=0A=
    Post =3D readl(ha->mem_ptr + IPS_REG_I960_MSG0);=0A=
 =0A=
    if (Post =3D=3D 0x4F00) {                          /* If Flashing =
the Battery PIC         */=0A=
-       printk(KERN_WARNING "Flashing Battery PIC, Please wait ...\n" =
);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "Flashing Battery PIC, =
Please wait ...\n" );=0A=
 =0A=
        /* Clear the interrupt bit */=0A=
        Isr =3D (uint32_t) IPS_BIT_I960_MSG0I;=0A=
@@ -4882,8 +4871,7 @@=0A=
        }=0A=
 =0A=
        if (i >=3D 120) {=0A=
-          printk(KERN_WARNING "(%s%d) timeout waiting for Battery PIC =
Flash\n",=0A=
-                 ips_name, ha->host_num);=0A=
+          IPS_PRINTK(KERN_WARNING, ha->pcidev, "timeout waiting for =
Battery PIC Flash\n");=0A=
           return (0);=0A=
        }=0A=
 =0A=
@@ -4894,8 +4882,7 @@=0A=
    writel(Isr, ha->mem_ptr + IPS_REG_I2O_HIR);=0A=
 =0A=
    if (Post < (IPS_GOOD_POST_STATUS << 8)) {=0A=
-      printk(KERN_WARNING "(%s%d) reset controller fails (post status =
%x).\n",=0A=
-             ips_name, ha->host_num, Post);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "reset controller fails =
(post status %x).\n", Post);=0A=
 =0A=
       return (0);=0A=
    }=0A=
@@ -4913,8 +4900,7 @@=0A=
 =0A=
    if (i >=3D 240) {=0A=
       /* error occurred */=0A=
-      printk(KERN_WARNING "(%s%d) timeout waiting for config.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "timeout waiting for =
config.\n");=0A=
 =0A=
       return (0);=0A=
    }=0A=
@@ -5241,10 +5227,8 @@=0A=
          if (!(val & IPS_BIT_START_STOP))=0A=
             break;=0A=
 =0A=
-         printk(KERN_WARNING "(%s%d) ips_issue val [0x%x].\n",=0A=
-                ips_name, ha->host_num, val);=0A=
-         printk(KERN_WARNING "(%s%d) ips_issue semaphore chk =
timeout.\n",=0A=
-                ips_name, ha->host_num);=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "ips_issue val =
[0x%x].\n", val);=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "ips_issue semaphore chk =
timeout.\n");=0A=
 =0A=
          return (IPS_FAILURE);=0A=
       } /* end if */=0A=
@@ -5297,10 +5281,8 @@=0A=
          if (!(val & IPS_BIT_START_STOP))=0A=
             break;=0A=
 =0A=
-         printk(KERN_WARNING "(%s%d) ips_issue val [0x%x].\n",=0A=
-                ips_name, ha->host_num, val);=0A=
-         printk(KERN_WARNING "(%s%d) ips_issue semaphore chk =
timeout.\n",=0A=
-                ips_name, ha->host_num);=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "ips_issue val =
[0x%x].\n", val);=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "ips_issue semaphore chk =
timeout.\n");=0A=
 =0A=
          return (IPS_FAILURE);=0A=
       } /* end if */=0A=
@@ -5540,8 +5522,7 @@=0A=
    METHOD_TRACE("ips_write_driver_status", 1);=0A=
 =0A=
    if (!ips_readwrite_page5(ha, FALSE, intr)) {=0A=
-      printk(KERN_WARNING "(%s%d) unable to read NVRAM page 5.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "unable to read NVRAM page =
5.\n");=0A=
 =0A=
       return (0);=0A=
    }=0A=
@@ -5576,8 +5557,7 @@=0A=
 =0A=
    /* now update the page */=0A=
    if (!ips_readwrite_page5(ha, TRUE, intr)) {=0A=
-      printk(KERN_WARNING "(%s%d) unable to write NVRAM page 5.\n",=0A=
-             ips_name, ha->host_num);=0A=
+      IPS_PRINTK(KERN_WARNING, ha->pcidev, "unable to write NVRAM page =
5.\n");=0A=
 =0A=
       return (0);=0A=
    }=0A=
@@ -6540,10 +6520,10 @@=0A=
          strncpy(&FirmwareString[0], ha->enq->CodeBlkVersion, 8);=0A=
          FirmwareString[8] =3D 0;=0A=
 =0A=
-         printk(KERN_WARNING "Warning ! ! ! ServeRAID Version =
Mismatch\n");=0A=
-         printk(KERN_WARNING "Bios =3D %s, Firmware =3D %s, Device =
Driver =3D %s%s\n",=0A=
-                              BiosString, FirmwareString, =
IPS_VERSION_HIGH, IPS_VERSION_LOW );=0A=
-         printk(KERN_WARNING "These levels should match to avoid =
possible compatibility problems.\n" );=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "Warning ! ! ! ServeRAID =
Version Mismatch\n");=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "Bios =3D %s, Firmware =
=3D %s, Device Driver =3D %s%s\n",=0A=
+                    BiosString, FirmwareString, IPS_VERSION_HIGH, =
IPS_VERSION_LOW );=0A=
+         IPS_PRINTK(KERN_WARNING, ha->pcidev, "These levels should =
match to avoid possible compatibility problems.\n");=0A=
      }=0A=
  }=0A=
  else=0A=
@@ -6728,19 +6708,18 @@=0A=
 static int=0A=
 ips_register_scsi( int index){=0A=
 	struct Scsi_Host *sh;=0A=
-	ips_ha_t *ha, *oldha;=0A=
+	ips_ha_t *ha, *oldha =3D ips_ha[index];=0A=
 	sh =3D scsi_register(&ips_driver_template, sizeof(ips_ha_t));=0A=
 	if(!sh) {=0A=
-		printk(KERN_WARNING "Unable to register controller with SCSI =
subsystem\n" );=0A=
+		IPS_PRINTK(KERN_WARNING, oldha->pcidev, "Unable to register =
controller with SCSI subsystem\n");=0A=
 		return -1;=0A=
 	}=0A=
-	oldha =3D ips_ha[index];=0A=
 	ha =3D IPS_HA(sh);=0A=
 	memcpy(ha, oldha, sizeof(ips_ha_t));=0A=
 	free_irq(oldha->irq, oldha);=0A=
 	/* Install the interrupt handler with the new ha */=0A=
 	if (request_irq(ha->irq, do_ipsintr, SA_SHIRQ, ips_name, ha)) {=0A=
-		printk(KERN_WARNING "Unable to install interrupt handler\n" );=0A=
+		IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to install interrupt =
handler\n" );=0A=
 		scsi_unregister(sh);=0A=
 		return -1;=0A=
 	}=0A=
@@ -6943,7 +6922,7 @@=0A=
        uint32_t offs;=0A=
 =0A=
        if (!request_mem_region(mem_addr, mem_len, "ips")) {=0A=
-          printk(KERN_WARNING "Couldn't allocate IO Memory space %x =
len %d.\n", mem_addr, mem_len);=0A=
+          IPS_PRINTK(KERN_WARNING, pci_dev, "Couldn't allocate IO =
Memory space %x len %d.\n", mem_addr, mem_len);=0A=
           return -1;=0A=
           }=0A=
 =0A=
@@ -6959,14 +6938,14 @@=0A=
     /* setup I/O mapped area (if applicable) */=0A=
     if (io_addr) {=0A=
        if (!request_region(io_addr, io_len, "ips")) {=0A=
-          printk(KERN_WARNING "Couldn't allocate IO space %x len =
%d.\n", io_addr, io_len);=0A=
+          IPS_PRINTK(KERN_WARNING, pci_dev, "Couldn't allocate IO =
space %x len %d.\n", io_addr, io_len);=0A=
           return -1;=0A=
        }=0A=
     }=0A=
 =0A=
     /* get the revision ID */=0A=
     if (pci_read_config_byte(pci_dev, PCI_REVISION_ID, &revision_id)) =
{=0A=
-       printk(KERN_WARNING "Can't get revision id.\n" );=0A=
+       IPS_PRINTK(KERN_WARNING, pci_dev, "Can't get revision =
id.\n");=0A=
        return -1;=0A=
     }=0A=
 =0A=
@@ -6975,7 +6954,7 @@=0A=
     /* found a controller */=0A=
     ha =3D kmalloc(sizeof(ips_ha_t), GFP_KERNEL);=0A=
     if (ha =3D=3D NULL) {=0A=
-       printk(KERN_WARNING "Unable to allocate temporary ha struct\n" =
);=0A=
+       IPS_PRINTK(KERN_WARNING, pci_dev, "Unable to allocate temporary =
ha struct\n");=0A=
        return -1;=0A=
     }=0A=
 =0A=
@@ -7019,14 +6998,14 @@=0A=
     ha->enq =3D kmalloc(sizeof(IPS_ENQ), IPS_INIT_GFP);=0A=
 =0A=
     if (!ha->enq) {=0A=
-       printk(KERN_WARNING "Unable to allocate host inquiry =
structure\n" );=0A=
+       IPS_PRINTK(KERN_WARNING, pci_dev, "Unable to allocate host =
inquiry structure\n" );=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
     ha->adapt =3D pci_alloc_consistent(pci_dev, sizeof(IPS_ADAPTER) =
+=0A=
                                      sizeof(IPS_IO_CMD), =
&dma_address);=0A=
     if (!ha->adapt) {=0A=
-       printk(KERN_WARNING "Unable to allocate host adapt & dummy =
structures\n");=0A=
+       IPS_PRINTK(KERN_WARNING, pci_dev, "Unable to allocate host =
adapt & dummy structures\n");=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
     ha->adapt->hw_status_start =3D dma_address;=0A=
@@ -7035,21 +7014,21 @@=0A=
     ha->conf =3D kmalloc(sizeof(IPS_CONF), IPS_INIT_GFP);=0A=
 =0A=
     if (!ha->conf) {=0A=
-       printk(KERN_WARNING "Unable to allocate host conf structure\n" =
);=0A=
+       IPS_PRINTK(KERN_WARNING, pci_dev, "Unable to allocate host conf =
structure\n");=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
     ha->nvram =3D kmalloc(sizeof(IPS_NVRAM_P5), IPS_INIT_GFP);=0A=
 =0A=
     if (!ha->nvram) {=0A=
-       printk(KERN_WARNING "Unable to allocate host NVRAM structure\n" =
);=0A=
+       IPS_PRINTK(KERN_WARNING, pci_dev, "Unable to allocate host =
NVRAM structure\n");=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
     ha->subsys =3D kmalloc(sizeof(IPS_SUBSYS), IPS_INIT_GFP);=0A=
 =0A=
     if (!ha->subsys) {=0A=
-       printk(KERN_WARNING "Unable to allocate host subsystem =
structure\n" );=0A=
+       IPS_PRINTK(KERN_WARNING, pci_dev, "Unable to allocate host =
subsystem structure\n");=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
@@ -7061,7 +7040,7 @@=0A=
     ha->ioctl_datasize =3D count;=0A=
 =0A=
     if (!ha->ioctl_data) {=0A=
-       printk(KERN_WARNING "Unable to allocate IOCTL data\n" );=0A=
+       IPS_PRINTK(KERN_WARNING, pci_dev, "Unable to allocate IOCTL =
data\n");=0A=
        ha->ioctl_data =3D NULL;=0A=
        ha->ioctl_order =3D 0;=0A=
        ha->ioctl_datasize =3D 0;=0A=
@@ -7089,7 +7068,7 @@=0A=
           /*=0A=
            * Initialization failed=0A=
            */=0A=
-          printk(KERN_WARNING "Unable to initialize controller\n" =
);=0A=
+          IPS_PRINTK(KERN_WARNING, pci_dev, "Unable to initialize =
controller\n");=0A=
           return ips_abort_init(ha, index);=0A=
        }=0A=
     }=0A=
@@ -7121,7 +7100,7 @@=0A=
 =0A=
     /* Install the interrupt handler */=0A=
      if (request_irq(ha->irq, do_ipsintr, SA_SHIRQ, ips_name, ha)) =
{=0A=
-       printk(KERN_WARNING "Unable to install interrupt handler\n" =
);=0A=
+       IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to install =
interrupt handler\n");=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
@@ -7130,13 +7109,13 @@=0A=
      */=0A=
     ha->max_cmds =3D 1;=0A=
     if (!ips_allocatescbs(ha)) {=0A=
-       printk(KERN_WARNING "Unable to allocate a CCB\n" );=0A=
+       IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to allocate a =
CCB\n");=0A=
        free_irq(ha->irq, ha);=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
     if (!ips_hainit(ha)) {=0A=
-       printk(KERN_WARNING "Unable to initialize controller\n" );=0A=
+       IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to initialize =
controller\n");=0A=
        free_irq(ha->irq, ha);=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
@@ -7145,7 +7124,7 @@=0A=
 =0A=
     /* allocate CCBs */=0A=
     if (!ips_allocatescbs(ha)) {=0A=
-       printk(KERN_WARNING "Unable to allocate CCBs\n" );=0A=
+       IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to allocate =
CCBs\n");=0A=
        free_irq(ha->irq, ha);=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
diff -urN linux-2.5.69_p3/drivers/scsi/ips.h =
linux-2.5.69_p4/drivers/scsi/ips.h=0A=
--- linux-2.5.69_p3/drivers/scsi/ips.h	2003-05-06 13:20:31.000000000 =
-0400=0A=
+++ linux-2.5.69_p4/drivers/scsi/ips.h	2003-05-06 13:19:58.000000000 =
-0400=0A=
@@ -108,12 +108,17 @@=0A=
       #define IPS_ADD_HOST(shost,device)=0A=
       #define IPS_REMOVE_HOST(shost)=0A=
       #define IPS_SCSI_SET_DEVICE(sh,ha)   scsi_set_pci_device(sh, =
(ha)->pcidev)=0A=
+      #define IPS_PRINTK(level, pcidev, format, arg...)                =
 \=0A=
+            printk(level "%s %s:" format , (pcidev)->driver->name ,    =
 \=0A=
+            (pcidev)->slot_name , ## arg)=0A=
    #else=0A=
       #define IPS_REGISTER_HOSTS(SHT)      (!ips_detect(SHT))=0A=
       #define IPS_UNREGISTER_HOSTS(SHT)=0A=
       #define IPS_ADD_HOST(shost,device)   =
scsi_add_host(shost,device)=0A=
       #define IPS_REMOVE_HOST(shost)       scsi_remove_host(shost)=0A=
       #define IPS_SCSI_SET_DEVICE(sh,ha)   scsi_set_device(sh, =
&(ha)->pcidev->dev)=0A=
+      #define IPS_PRINTK(level, pcidev, format, arg...)                =
 \=0A=
+            dev_printk(level , &((pcidev)->dev) , format , ## arg)=0A=
    #endif=0A=
 =0A=
    #ifndef MDELAY=0A=

------_=_NextPart_000_01C313F5.BC2C4900--
