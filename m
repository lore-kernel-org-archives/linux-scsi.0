From: "Jeffery, David" <David_Jeffery@adaptec.com>
Subject: [PATCH] ips driver 3/4: 64bit dma addressing
Date: Thu, 6 Feb 2003 13:15:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B03773D@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C2CE0B.C6DF99E0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6+Sun/8.11.6) with ESMTP id h16IFuD24906
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2003 10:15:56 -0800 (PST)
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8+Sun/8.8.8) with ESMTP id KAA09012
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2003 10:15:52 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C2CE0B.C6DF99E0
Content-Type: text/plain;
	charset="iso-8859-1"

This large patch adds support for using 64bit addressing.

Special thanks goes to Mike Anderson who did the initial
versions of this patch.

The patch was made against 2.5.59.

David Jeffery

 ips.c |  596
++++++++++++++++++++++++++++++++----------------------------------
 ips.h |   59 +++++-
 2 files changed, 342 insertions(+), 313 deletions(-)


------_=_NextPart_000_01C2CE0B.C6DF99E0
Content-Type: application/octet-stream;
	name="ips.patch3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ips.patch3"

diff -ur linux-2.5.59_p2/drivers/scsi/ips.c =
linux-2.5.59_p3/drivers/scsi/ips.c=0A=
--- linux-2.5.59_p2/drivers/scsi/ips.c	Mon Jan 20 09:46:27 2003=0A=
+++ linux-2.5.59_p3/drivers/scsi/ips.c	Mon Jan 20 11:43:56 2003=0A=
@@ -461,6 +461,8 @@=0A=
 static int ips_make_passthru(ips_ha_t *, Scsi_Cmnd *, ips_scb_t *, =
int);=0A=
 static int ips_usrcmd(ips_ha_t *, ips_passthru_t *, ips_scb_t *);=0A=
 static void ips_cleanup_passthru(ips_ha_t *, ips_scb_t *);=0A=
+static void ips_scmd_buf_write(Scsi_Cmnd *scmd, void *data, unsigned =
int count);=0A=
+static void ips_scmd_buf_read(Scsi_Cmnd *scmd, void *data, unsigned =
int count);=0A=
 =0A=
 int  ips_proc_info(char *, char **, off_t, int, int, int);=0A=
 static int ips_host_info(ips_ha_t *, char *, off_t, int);=0A=
@@ -553,7 +555,7 @@=0A=
    /* If Booting from the Manager CD, Allocate a large Flash        =
*/=0A=
    /* Buffer ( so we won't need to allocate one for each adapter ). =
*/=0A=
     if ( ips_cd_boot ) {            =0A=
-      ips_FlashData =3D ( char * ) __get_free_pages( GFP_ATOMIC, 7 );  =
 =0A=
+      ips_FlashData =3D ( char * ) __get_free_pages( IPS_INIT_GFP, 7 =
);   =0A=
       if (ips_FlashData =3D=3D NULL) {=0A=
          /* The validity of this pointer is checked in =
ips_make_passthru() before it is used */=0A=
          printk( KERN_WARNING "ERROR: Can't Allocate Large Buffer for =
Flashing\n" );=0A=
@@ -1544,6 +1546,39 @@=0A=
 =0A=
 =
/***********************************************************************=
*****/=0A=
 /*                                                                     =
     */=0A=
+/* Routine Name: ips_alloc_passthru_buffer                             =
     */=0A=
+/*                                                                     =
     */=0A=
+/* Routine Description:                                                =
     */=0A=
+/*   allocate a buffer large enough for the ioctl data if the ioctl =
buffer  */=0A=
+/*   is too small or doesn't exist                                     =
     */=0A=
+/**********************************************************************=
******/=0A=
+static int=0A=
+ips_alloc_passthru_buffer(ips_ha_t *ha, int length){=0A=
+	void *bigger_buf;=0A=
+	int count;=0A=
+	int order;=0A=
+=0A=
+	if(ha->ioctl_data && length <=3D (PAGE_SIZE << ha->ioctl_order))=0A=
+		return 0;=0A=
+	/* there is no buffer or it's not big enough, allocate a new one =
*/=0A=
+	for (count =3D PAGE_SIZE, order =3D 0;=0A=
+	     count < length;=0A=
+	     order++, count <<=3D 1);=0A=
+	bigger_buf =3D (void *) __get_free_pages(IPS_ATOMIC_GFP, order);=0A=
+	if (bigger_buf) {=0A=
+		/* free the old memory */=0A=
+		free_pages((unsigned long) ha->ioctl_data, ha->ioctl_order);=0A=
+		/* use the new memory */=0A=
+		ha->ioctl_data =3D (char *) bigger_buf;=0A=
+		ha->ioctl_order =3D order;=0A=
+	} else {=0A=
+		return -1;=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+/**********************************************************************=
******/=0A=
+/*                                                                     =
     */=0A=
 /* Routine Name: ips_make_passthru                                     =
     */=0A=
 /*                                                                     =
     */=0A=
 /* Routine Description:                                                =
     */=0A=
@@ -1554,73 +1589,41 @@=0A=
 static int=0A=
 ips_make_passthru(ips_ha_t *ha, Scsi_Cmnd *SC, ips_scb_t *scb, int =
intr) {=0A=
    ips_passthru_t *pt;=0A=
-   char *buffer;=0A=
    int length =3D 0;=0A=
 =0A=
    METHOD_TRACE("ips_make_passthru", 1);=0A=
 =0A=
    if(!SC->use_sg){=0A=
-      buffer =3D SC->request_buffer;=0A=
       length =3D SC->request_bufflen;=0A=
    }else{=0A=
       struct scatterlist *sg =3D SC->request_buffer;=0A=
       int i;=0A=
       for(i =3D 0; i < SC->use_sg; i++)=0A=
          length +=3D sg[i].length;=0A=
-=0A=
-      if (length < sizeof(ips_passthru_t)) {=0A=
-         /* wrong size */=0A=
-         DEBUG_VAR(1, "(%s%d) Passthru structure wrong size",=0A=
-             ips_name, ha->host_num);=0A=
-         return (IPS_FAILURE);=0A=
-      }else if(!ha->ioctl_data || length > (PAGE_SIZE << =
ha->ioctl_order)){=0A=
-         void *bigger_buf;=0A=
-         int count;=0A=
-         int order;=0A=
-         /* try to allocate a bigger buffer */=0A=
-         for (count =3D PAGE_SIZE, order =3D 0;=0A=
-              count < length;=0A=
-              order++, count <<=3D 1);=0A=
-         bigger_buf =3D (void *) __get_free_pages(GFP_ATOMIC, =
order);=0A=
-         if (bigger_buf) {=0A=
-            /* free the old memory */=0A=
-            free_pages((unsigned long) ha->ioctl_data, =
ha->ioctl_order);=0A=
-            /* use the new memory */=0A=
-            ha->ioctl_data =3D (char *) bigger_buf;=0A=
-            ha->ioctl_order =3D order;=0A=
-            ha->ioctl_datasize =3D count;=0A=
-         } else {=0A=
-             pt =3D (ips_passthru_t*)IPS_SG_ADDRESS(sg);=0A=
-             pt->BasicStatus =3D 0x0B;=0A=
-             pt->ExtendedStatus =3D 0x00;=0A=
-             SC->result =3D DID_ERROR << 16;=0A=
-             return (IPS_FAILURE);=0A=
-         }=0A=
-      }=0A=
-      ha->ioctl_datasize =3D length;=0A=
-      length =3D 0;=0A=
-      for(i =3D 0; i < SC->use_sg; i++){=0A=
-         memcpy(&ha->ioctl_data[length], IPS_SG_ADDRESS(&sg[i]), =
sg[i].length);=0A=
-         length +=3D sg[i].length;=0A=
-      }=0A=
-      pt =3D (ips_passthru_t *)ha->ioctl_data;=0A=
-      buffer =3D ha->ioctl_data;=0A=
-   }=0A=
-   if (!length || !buffer) {=0A=
-      /* no data */=0A=
-      DEBUG_VAR(1, "(%s%d) No passthru structure",=0A=
-                ips_name, ha->host_num);=0A=
-=0A=
-      return (IPS_FAILURE);=0A=
    }=0A=
    if (length < sizeof(ips_passthru_t)) {=0A=
       /* wrong size */=0A=
       DEBUG_VAR(1, "(%s%d) Passthru structure wrong size",=0A=
-             ips_name, ha->host_num);=0A=
-=0A=
+          ips_name, ha->host_num);=0A=
       return (IPS_FAILURE);=0A=
    }=0A=
-   pt =3D (ips_passthru_t*) buffer;=0A=
+   if(ips_alloc_passthru_buffer(ha, length)){=0A=
+      /* allocation failure!  If ha->ioctl_data exists, use it to =
return=0A=
+         some error codes.  Return a failed command to the scsi layer. =
*/=0A=
+      if(ha->ioctl_data){=0A=
+         pt =3D (ips_passthru_t *)ha->ioctl_data;=0A=
+         ips_scmd_buf_read(SC, pt, sizeof(ips_passthru_t));=0A=
+         pt->BasicStatus =3D 0x0B;=0A=
+         pt->ExtendedStatus =3D 0x00;=0A=
+         ips_scmd_buf_write(SC, pt, sizeof(ips_passthru_t));=0A=
+      }=0A=
+      return IPS_FAILURE;=0A=
+   }=0A=
+   ha->ioctl_datasize =3D length;=0A=
+=0A=
+   ips_scmd_buf_read(SC, ha->ioctl_data, ha->ioctl_datasize);      =0A=
+   pt =3D (ips_passthru_t *)ha->ioctl_data;=0A=
+=0A=
    /*=0A=
     * Some notes about the passthru interface used=0A=
     *=0A=
@@ -1629,26 +1632,14 @@=0A=
     * packet we received from the sg driver. In this=0A=
     * case the CmdBSize field of the pt structure is=0A=
     * used for the size of the buffer.=0A=
-    *=0A=
-    * IF the scsi op_code =3D=3D 0x81 then we assume that=0A=
-    * we will need our own buffer and we will copy the=0A=
-    * data to/from the user buffer passed in the scsi=0A=
-    * command.  The data address resides at offset 4=0A=
-    * in the scsi command.  The length of the data resides=0A=
-    * at offset 8 in the scsi command.=0A=
     */=0A=
 =0A=
    switch (pt->CoppCmd) {=0A=
    case IPS_NUMCTRLS:=0A=
-      memcpy(buffer + sizeof(ips_passthru_t),=0A=
+      memcpy(ha->ioctl_data + sizeof(ips_passthru_t),=0A=
              &ips_num_controllers, sizeof(int));=0A=
-      SC->result =3D DID_OK << 16;=0A=
-=0A=
-      return (IPS_SUCCESS_IMM);=0A=
-=0A=
-   case IPS_CTRLINFO:=0A=
-      memcpy(buffer + sizeof(ips_passthru_t),=0A=
-             ha, sizeof(ips_ha_t));=0A=
+      ips_scmd_buf_write(SC, ha->ioctl_data,=0A=
+                         sizeof(ips_passthru_t) + sizeof(int));=0A=
       SC->result =3D DID_OK << 16;=0A=
 =0A=
       return (IPS_SUCCESS_IMM);=0A=
@@ -1678,8 +1669,8 @@=0A=
 =0A=
    } /* end switch */=0A=
 =0A=
-         return (IPS_FAILURE);=0A=
-      }=0A=
+   return (IPS_FAILURE);=0A=
+}=0A=
 =0A=
 =
/***********************************************************************=
*****/=0A=
 /* Routine Name: ips_flash_copperhead                                  =
     */=0A=
@@ -1717,7 +1708,7 @@=0A=
                     pt->CoppCP.cmd.flashfw.count;=0A=
          for (count =3D PAGE_SIZE, ha->flash_order =3D 0; count < =
datasize;=0A=
               ha->flash_order++, count <<=3D 1);=0A=
-         ha->flash_data =3D (char *)__get_free_pages(GFP_ATOMIC, =
ha->flash_order);=0A=
+         ha->flash_data =3D (char *)__get_free_pages(IPS_ATOMIC_GFP, =
ha->flash_order);=0A=
          ha->flash_datasize =3D 0;=0A=
       }else=0A=
          return IPS_FAILURE;=0A=
@@ -1794,13 +1785,55 @@=0A=
 }=0A=
 =0A=
 =
/***********************************************************************=
*****/=0A=
+/*                                                                     =
     */=0A=
+/* Routine Name: ips_fill_scb_sg_single                                =
     */=0A=
+/*                                                                     =
     */=0A=
+/* Routine Description:                                                =
     */=0A=
+/*   Fill in a single scb sg_list element from an address              =
     */=0A=
+/*   return a -1 if a breakup occured                                  =
     */=0A=
+/**********************************************************************=
******/=0A=
+static inline int ips_fill_scb_sg_single(ips_ha_t *ha, dma_addr_t =
busaddr,=0A=
+                            ips_scb_t *scb, int indx, unsigned int =
e_len)=0A=
+{=0A=
+=0A=
+   int      ret_val =3D 0;=0A=
+=0A=
+   if ( (scb->data_len + e_len) > ha->max_xfer) {=0A=
+      e_len =3D ha->max_xfer - scb->data_len;=0A=
+      scb->breakup =3D indx;=0A=
+      ++scb->sg_break;=0A=
+      ret_val =3D -1;=0A=
+   } else {=0A=
+      scb->breakup =3D 0;=0A=
+      scb->sg_break =3D 0;=0A=
+   }=0A=
+   if (IPS_USE_ENH_SGLIST(ha)) {=0A=
+      scb->sg_list.enh_list[indx].address_lo =3D=0A=
+         cpu_to_le32(pci_dma_lo32(busaddr));=0A=
+      scb->sg_list.enh_list[indx].address_hi =3D=0A=
+         cpu_to_le32(pci_dma_hi32(busaddr));=0A=
+      scb->sg_list.enh_list[indx].length =3D=0A=
+         cpu_to_le32(e_len);=0A=
+   } else {=0A=
+      scb->sg_list.std_list[indx].address =3D=0A=
+         cpu_to_le32(pci_dma_lo32(busaddr));=0A=
+      scb->sg_list.std_list[indx].length =3D=0A=
+         cpu_to_le32(e_len);=0A=
+   }=0A=
+=0A=
+   ++scb->sg_len;=0A=
+   scb->data_len +=3D e_len;=0A=
+   return ret_val;=0A=
+}=0A=
+=0A=
+/**********************************************************************=
******/=0A=
 /* Routine Name: ips_flash_firmware                                    =
     */=0A=
 /* Routine Description:                                                =
     */=0A=
 /*   flashes the firmware of a copperhead adapter                      =
     */=0A=
 =
/***********************************************************************=
*****/=0A=
 static int=0A=
 ips_flash_firmware(ips_ha_t * ha, ips_passthru_t *pt, ips_scb_t =
*scb){=0A=
-   IPS_SG_LIST *sg_list;=0A=
+   IPS_SG_LIST sg_list;=0A=
    uint32_t cmd_busaddr;=0A=
 =0A=
    if(pt->CoppCP.cmd.flashfw.type =3D=3D IPS_FW_IMAGE &&=0A=
@@ -1815,12 +1848,12 @@=0A=
       return IPS_FAILURE;=0A=
    }=0A=
    /* Save the S/G list pointer so it doesn't get clobbered */=0A=
-   sg_list =3D scb->sg_list;=0A=
+   sg_list.list =3D scb->sg_list.list;=0A=
    cmd_busaddr =3D scb->scb_busaddr;=0A=
    /* copy in the CP */=0A=
    memcpy(&scb->cmd, &pt->CoppCP.cmd, sizeof(IPS_IOCTL_CMD));=0A=
    /* FIX stuff that might be wrong */=0A=
-   scb->sg_list =3D sg_list;=0A=
+   scb->sg_list.list =3D sg_list.list;=0A=
    scb->scb_busaddr =3D cmd_busaddr;=0A=
    scb->bus =3D scb->scsi_cmd->channel;=0A=
    scb->target_id =3D scb->scsi_cmd->target;=0A=
@@ -1837,7 +1870,7 @@=0A=
                                       IPS_DMA_DIR(scb));=0A=
    scb->flags |=3D IPS_SCB_MAP_SINGLE;=0A=
    scb->cmd.flashfw.command_id =3D IPS_COMMAND_ID(ha, scb);=0A=
-   scb->cmd.flashfw.buffer_addr =3D scb->data_busaddr;=0A=
+   scb->cmd.flashfw.buffer_addr =3D cpu_to_le32(scb->data_busaddr);=0A=
    if (pt->TimeOut)=0A=
       scb->timeout =3D pt->TimeOut;=0A=
    scb->scsi_cmd->result =3D DID_OK <<16;=0A=
@@ -1869,7 +1902,7 @@=0A=
 =
/***********************************************************************=
*****/=0A=
 static int=0A=
 ips_usrcmd(ips_ha_t *ha, ips_passthru_t *pt, ips_scb_t *scb) {=0A=
-   IPS_SG_LIST *sg_list;=0A=
+   IPS_SG_LIST sg_list;=0A=
    uint32_t cmd_busaddr;=0A=
 =0A=
    METHOD_TRACE("ips_usrcmd", 1);=0A=
@@ -1878,14 +1911,14 @@=0A=
       return (0);=0A=
 =0A=
    /* Save the S/G list pointer so it doesn't get clobbered */=0A=
-   sg_list =3D scb->sg_list;=0A=
+   sg_list.list =3D scb->sg_list.list;=0A=
    cmd_busaddr =3D scb->scb_busaddr;=0A=
    /* copy in the CP */=0A=
    memcpy(&scb->cmd, &pt->CoppCP.cmd, sizeof(IPS_IOCTL_CMD));=0A=
    memcpy(&scb->dcdb, &pt->CoppCP.dcdb, sizeof(IPS_DCDB_TABLE));=0A=
 =0A=
    /* FIX stuff that might be wrong */=0A=
-   scb->sg_list =3D sg_list;=0A=
+   scb->sg_list.list =3D sg_list.list;=0A=
    scb->scb_busaddr =3D cmd_busaddr;=0A=
    scb->bus =3D scb->scsi_cmd->channel;=0A=
    scb->target_id =3D scb->scsi_cmd->target;=0A=
@@ -1905,23 +1938,13 @@=0A=
       return (0);=0A=
 =0A=
    if (pt->CmdBSize) {=0A=
-      if(!scb->scsi_cmd->use_sg){=0A=
-         scb->data_len =3D pt->CmdBSize;=0A=
-         scb->data_busaddr =3D pci_map_single(ha->pcidev,=0A=
-                                            =
scb->scsi_cmd->request_buffer +=0A=
-                                            sizeof(ips_passthru_t),=0A=
-                                            pt->CmdBSize,=0A=
-                                            IPS_DMA_DIR(scb));=0A=
-         scb->flags |=3D IPS_SCB_MAP_SINGLE;=0A=
-      } else {=0A=
-         scb->data_len =3D pt->CmdBSize;=0A=
-         scb->data_busaddr =3D pci_map_single(ha->pcidev,=0A=
-                                            ha->ioctl_data +=0A=
-                                            sizeof(ips_passthru_t),=0A=
-                                            pt->CmdBSize,=0A=
-                                            IPS_DMA_DIR(scb));=0A=
-         scb->flags |=3D IPS_SCB_MAP_SINGLE;=0A=
-      }=0A=
+      scb->data_len =3D pt->CmdBSize;=0A=
+      scb->data_busaddr =3D pci_map_single(ha->pcidev,=0A=
+                                         ha->ioctl_data +=0A=
+                                         sizeof(ips_passthru_t),=0A=
+                                         pt->CmdBSize,=0A=
+                                         IPS_DMA_DIR(scb));=0A=
+      scb->flags |=3D IPS_SCB_MAP_SINGLE;=0A=
    } else {=0A=
       scb->data_busaddr =3D 0L;=0A=
    }=0A=
@@ -1978,10 +2001,7 @@=0A=
 =0A=
       return ;=0A=
    }=0A=
-   if(!scb->scsi_cmd->use_sg)=0A=
-      pt =3D (ips_passthru_t *) scb->scsi_cmd->request_buffer;=0A=
-   else=0A=
-      pt =3D (ips_passthru_t *) ha->ioctl_data;=0A=
+   pt =3D (ips_passthru_t *) ha->ioctl_data;=0A=
 =0A=
    /* Copy data back to the user */=0A=
    if (scb->cmd.dcdb.op_code =3D=3D IPS_CMD_DCDB)        /* Copy DCDB =
Back to Caller's Area */=0A=
@@ -1996,14 +2016,7 @@=0A=
      scb->cmd.flashfw.op_code =3D=3D IPS_CMD_RW_BIOSFW))=0A=
       ips_free_flash_copperhead(ha);=0A=
 =0A=
-   if(scb->scsi_cmd->use_sg){=0A=
-      int i, length =3D 0;=0A=
-      struct scatterlist *sg =3D scb->scsi_cmd->request_buffer;=0A=
-      for(i =3D 0; i < scb->scsi_cmd->use_sg; i++){=0A=
-         memcpy(IPS_SG_ADDRESS(&sg[i]), &ha->ioctl_data[length], =
sg[i].length);=0A=
-         length +=3D sg[i].length;=0A=
-      }=0A=
-   }=0A=
+   ips_scmd_buf_write(scb->scsi_cmd, ha->ioctl_data, =
ha->ioctl_datasize);=0A=
 }=0A=
 =0A=
 =
/***********************************************************************=
*****/=0A=
@@ -2331,7 +2344,7 @@=0A=
    } else {=0A=
       /* Morpheus Family - Send Command to the card */=0A=
 =0A=
-      buffer =3D kmalloc(0x1000, GFP_ATOMIC);=0A=
+      buffer =3D kmalloc(0x1000, IPS_ATOMIC_GFP);=0A=
       if (!buffer)=0A=
          return;=0A=
 =0A=
@@ -2685,68 +2698,20 @@=0A=
          scb->sg_count =3D pci_map_sg(ha->pcidev, sg, SC->use_sg,=0A=
                                     =
scsi_to_pci_dma_dir(SC->sc_data_direction));=0A=
          scb->flags |=3D IPS_SCB_MAP_SG;=0A=
-         if (scb->sg_count =3D=3D 1) {=0A=
-            if (sg_dma_len(sg) > ha->max_xfer) {=0A=
-     	       scb->breakup =3D 1;=0A=
-               scb->data_len =3D ha->max_xfer;=0A=
-            } else=0A=
-               scb->data_len =3D sg_dma_len(sg);=0A=
-=0A=
-            scb->dcdb.transfer_length =3D scb->data_len;=0A=
-            scb->data_busaddr =3D sg_dma_address(sg);=0A=
-            scb->sg_len =3D 0;=0A=
-         } else {=0A=
-            /* Check for the first Element being bigger than MAX_XFER =
*/=0A=
-            if (sg_dma_len(&sg[0]) > ha->max_xfer) {=0A=
-               scb->sg_list[0].address =3D =
cpu_to_le32(sg_dma_address(&sg[0]));=0A=
-               scb->sg_list[0].length =3D ha->max_xfer;=0A=
-               scb->data_len =3D ha->max_xfer;=0A=
-               scb->breakup =3D 0; =0A=
-               scb->sg_break=3D1;  =0A=
-               scb->sg_len =3D 1;=0A=
-            } else {=0A=
-               for (i =3D 0; i < scb->sg_count; i++) {=0A=
-                  scb->sg_list[i].address =3D =
cpu_to_le32(sg_dma_address(&sg[i]));=0A=
-                  scb->sg_list[i].length =3D =
cpu_to_le32(sg_dma_len(&sg[i]));=0A=
-            =0A=
-                  if (scb->data_len + sg_dma_len(&sg[i]) > =
ha->max_xfer) {=0A=
-                     /*=0A=
-                      * Data Breakup required=0A=
-                      */=0A=
-                     scb->breakup =3D i;=0A=
-                     break;=0A=
-                  }=0A=
-               =0A=
-                  scb->data_len +=3D sg_dma_len(&sg[i]);=0A=
-               }=0A=
-=0A=
-               if (!scb->breakup)=0A=
-                  scb->sg_len =3D scb->sg_count;=0A=
-               else=0A=
-                  scb->sg_len =3D scb->breakup;=0A=
-            }=0A=
-=0A=
-            scb->dcdb.transfer_length =3D scb->data_len;=0A=
-            scb->data_busaddr =3D scb->sg_busaddr;=0A=
+         for (i =3D 0; i < scb->sg_count; i++) {=0A=
+            if ( ips_fill_scb_sg_single(ha, sg_dma_address(&sg[i]),=0A=
+                                        scb, i, sg_dma_len(&sg[i])) < =
0)=0A=
+               break;=0A=
          }=0A=
+         scb->dcdb.transfer_length =3D scb->data_len;=0A=
       } else {=0A=
          if (SC->request_bufflen) {=0A=
-            if (SC->request_bufflen > ha->max_xfer) {=0A=
-               /*=0A=
-                * Data breakup required=0A=
-                */=0A=
-               scb->breakup =3D 1;=0A=
-               scb->data_len =3D ha->max_xfer;=0A=
-            } else {=0A=
-               scb->data_len =3D SC->request_bufflen;=0A=
-            }=0A=
-=0A=
-            scb->dcdb.transfer_length =3D scb->data_len;=0A=
             scb->data_busaddr =3D pci_map_single(ha->pcidev, =
SC->request_buffer,=0A=
-                                               scb->data_len,=0A=
+                                               SC->request_bufflen,=0A=
                                                =
scsi_to_pci_dma_dir(SC->sc_data_direction));=0A=
             scb->flags |=3D IPS_SCB_MAP_SINGLE;=0A=
-            scb->sg_len =3D 0;=0A=
+            ips_fill_scb_sg_single(ha, scb->data_busaddr, scb, 0, =
SC->request_bufflen);=0A=
+            scb->dcdb.transfer_length =3D scb->data_len;=0A=
          } else {=0A=
             scb->data_busaddr =3D 0L;=0A=
             scb->sg_len =3D 0;=0A=
@@ -3299,118 +3264,41 @@=0A=
        */=0A=
       if ((scb->breakup) || (scb->sg_break)) {=0A=
          /* we had a data breakup */=0A=
-         uint8_t bk_save;=0A=
-=0A=
-         bk_save =3D scb->breakup;=0A=
-         scb->breakup =3D 0;=0A=
-         mod_timer(&scb->scsi_cmd->eh_timeout, jiffies + 120 * HZ);=0A=
+         scb->data_len =3D 0;=0A=
 =0A=
          if (scb->sg_count) {=0A=
             /* S/G request */=0A=
             struct scatterlist *sg;=0A=
-            int                 i;=0A=
+            int ips_sg_index =3D 0;=0A=
+            int sg_dma_index;=0A=
 =0A=
             sg =3D scb->scsi_cmd->request_buffer;=0A=
 =0A=
-            if (scb->sg_count =3D=3D 1) {=0A=
-               if (sg_dma_len(sg) - (bk_save * ha->max_xfer) > =
ha->max_xfer) {=0A=
-                  /* Further breakup required */=0A=
-                  scb->data_len =3D ha->max_xfer;=0A=
-                  scb->data_busaddr =3D sg_dma_address(sg) + (bk_save =
* ha->max_xfer);=0A=
-                  scb->breakup =3D bk_save + 1;=0A=
-               } else {=0A=
-                  scb->data_len =3D sg_dma_len(sg) - (bk_save * =
ha->max_xfer);=0A=
-                  scb->data_busaddr =3D sg_dma_address(sg) + (bk_save =
* ha->max_xfer);=0A=
-               }=0A=
+            /* Spin forward to last dma chunk */=0A=
+            sg_dma_index =3D scb->breakup;=0A=
 =0A=
-               scb->dcdb.transfer_length =3D scb->data_len;=0A=
-               scb->sg_len =3D 0;=0A=
-            } else {=0A=
-               /* We're here because there was MORE than one s/g unit. =
*/=0A=
-	            /* bk_save points to which sg unit to look at           =
*/=0A=
-	            /* sg_break points to how far through this unit we are  =
*/=0A=
-	            /* NOTE: We will not move from one sg to another here,  =
*/=0A=
-               /*    just finish the one we are in.  Not the most      =
*/=0A=
-               /*    efficient, but it keeps it from getting too hacky =
*/=0A=
-=0A=
-		         /* IF sg_break is non-zero, then just work on this current =
sg piece, */=0A=
-               /* pointed to by bk_save                                =
             */=0A=
-               if (scb->sg_break) {=0A=
-                  scb->sg_len =3D 1;=0A=
-                  scb->sg_list[0].address =3D =
sg_dma_address(&sg[bk_save])=0A=
-                                            + =
ha->max_xfer*scb->sg_break;=0A=
-                  if (ha->max_xfer > sg_dma_len(&sg[bk_save]) - =
ha->max_xfer * scb->sg_break) =0A=
-                     scb->sg_list[0].length =3D =
sg_dma_len(&sg[bk_save]) - ha->max_xfer * scb->sg_break;=0A=
-                  else =0A=
-                     scb->sg_list[0].length =3D ha->max_xfer;=0A=
-                  scb->sg_break++;              /* MUST GO HERE for =
math below to work */=0A=
-                  scb->data_len =3D scb->sg_list[0].length;;=0A=
-=0A=
-                  if (sg_dma_len(&sg[bk_save]) <=3D ha->max_xfer * =
scb->sg_break ) {=0A=
-                     scb->sg_break =3D 0;         /* No more work in =
this unit */=0A=
-                     if (( bk_save + 1 ) >=3D scb->sg_count) =0A=
-                        scb->breakup =3D 0;=0A=
-                     else=0A=
-                        scb->breakup =3D bk_save + 1;=0A=
-                  }=0A=
-               } else {=0A=
-			         /* ( sg_break =3D=3D 0 ), so this is our first look at a =
new sg piece */=0A=
-                  if (sg_dma_len(&sg[bk_save]) > ha->max_xfer) {=0A=
-                     scb->sg_list[0].address =3D =
sg_dma_address(&sg[bk_save]);=0A=
-                     scb->sg_list[0].length =3D ha->max_xfer;=0A=
-                     scb->breakup =3D bk_save;=0A=
-                     scb->sg_break =3D 1;=0A=
-                     scb->data_len =3D ha->max_xfer;=0A=
-                     scb->sg_len =3D 1;=0A=
- 	          } else {=0A=
-	         /* OK, the next sg is a short one, so loop until full */=0A=
-                     scb->data_len =3D 0;=0A=
-                     scb->sg_len =3D 0;=0A=
-                     scb->sg_break =3D 0;=0A=
-                     /*   We're only doing full units here */=0A=
-                     for (i =3D bk_save; i < scb->sg_count; i++) {=0A=
-                        scb->sg_list[i - bk_save].address =3D =
sg_dma_address(&sg[i]);=0A=
-                        scb->sg_list[i - bk_save].length =3D =
cpu_to_le32(sg_dma_len(&sg[i]));=0A=
-                        if (scb->data_len + sg_dma_len(&sg[i]) > =
ha->max_xfer) {=0A=
-                           scb->breakup =3D i;  /* sneaky, if not more =
work, than breakup is 0 */=0A=
-                           break;=0A=
-                        }=0A=
-                        scb->data_len +=3D sg_dma_len(&sg[i]);=0A=
-                        scb->sg_len++;           /* only if we didn't =
get too big */=0A=
-		  		         }=0A=
-			         }=0A=
-		         }=0A=
-=0A=
-               /* Also, we need to be sure we don't queue work ( =
breakup !=3D 0 )=0A=
-                  if no more sg units for next time */=0A=
-               scb->dcdb.transfer_length =3D scb->data_len;=0A=
-               scb->data_busaddr =3D scb->sg_busaddr;=0A=
-            }=0A=
-                                              =0A=
-         } else {=0A=
-            /* Non S/G Request */=0A=
-            pci_unmap_single(ha->pcidev, scb->data_busaddr, =
scb->data_len,=0A=
-                             IPS_DMA_DIR(scb));=0A=
-            if ((scb->scsi_cmd->request_bufflen - (bk_save * =
ha->max_xfer)) > ha->max_xfer) {=0A=
-               /* Further breakup required */=0A=
-               scb->data_len =3D ha->max_xfer;=0A=
-               scb->data_busaddr =3D pci_map_single(ha->pcidev,=0A=
-                                           =
scb->scsi_cmd->request_buffer +=0A=
-                                           (bk_save * =
ha->max_xfer),=0A=
-                                           scb->data_len, =
IPS_DMA_DIR(scb));=0A=
-               scb->breakup =3D bk_save + 1;=0A=
-            } else {=0A=
-               scb->data_len =3D scb->scsi_cmd->request_bufflen - =
(bk_save * ha->max_xfer);=0A=
-               scb->data_busaddr =3D pci_map_single(ha->pcidev,=0A=
-                                           =
scb->scsi_cmd->request_buffer +=0A=
-                                           (bk_save * =
ha->max_xfer),=0A=
-                                           scb->data_len, =
IPS_DMA_DIR(scb));=0A=
-	    }=0A=
+            /* Take care of possible partial on last chunk*/=0A=
+            ips_fill_scb_sg_single(ha, =
sg_dma_address(&sg[sg_dma_index]),=0A=
+                                   scb, ips_sg_index++,=0A=
+                                   sg_dma_len(&sg[sg_dma_index]));=0A=
+=0A=
+            for (; sg_dma_index < scb->sg_count; sg_dma_index++) {=0A=
+                 if ( ips_fill_scb_sg_single(ha, =
sg_dma_address(&sg[sg_dma_index]),=0A=
+                                             scb, ips_sg_index++, =0A=
+                                             =
sg_dma_len(&sg[sg_dma_index])) < 0)=0A=
+                    break;=0A=
 =0A=
-            scb->dcdb.transfer_length =3D scb->data_len;=0A=
-            scb->sg_len =3D 0;=0A=
-         }=0A=
+            }=0A=
 =0A=
+         } else {=0A=
+	 /* Non S/G Request */=0A=
+            (void) ips_fill_scb_sg_single(ha,=0A=
+                                          scb->data_busaddr + =
(scb->sg_break * ha->max_xfer),=0A=
+                                          scb, 0,=0A=
+                                          =
scb->scsi_cmd->request_bufflen - (scb->sg_break * ha->max_xfer));=0A=
+          }=0A=
+ =0A=
+         scb->dcdb.transfer_length =3D scb->data_len;=0A=
          scb->dcdb.cmd_attribute |=3D =
ips_command_direction[scb->scsi_cmd->cmnd[0]];=0A=
 =0A=
          if (!scb->dcdb.cmd_attribute & 0x3)=0A=
@@ -3616,6 +3504,68 @@=0A=
 =0A=
 =
/***********************************************************************=
*****/=0A=
 /*                                                                     =
     */=0A=
+/* Routine Name: ips_scmd_buf_write                                    =
     */=0A=
+/*                                                                     =
     */=0A=
+/* Routine Description:                                                =
     */=0A=
+/*  Write data to Scsi_Cmnd request_buffer at proper offsets           =
     */=0A=
+/**********************************************************************=
******/=0A=
+static void ips_scmd_buf_write(Scsi_Cmnd *scmd, void *data, =
unsigned=0A=
+				   int count)=0A=
+{=0A=
+	if (scmd->use_sg) {=0A=
+		int i;=0A=
+		unsigned int min_cnt, xfer_cnt;=0A=
+		char *cdata =3D (char *)data;=0A=
+		struct scatterlist *sg =3D scmd->request_buffer;=0A=
+		for (i =3D 0, xfer_cnt =3D 0;=0A=
+		     (i < scmd->use_sg) && (xfer_cnt < count); i++){=0A=
+			if(!IPS_SG_ADDRESS(&sg[i]))=0A=
+				return;=0A=
+			min_cnt =3D min( count - xfer_cnt, sg[i].length);=0A=
+			memcpy(IPS_SG_ADDRESS(&sg[i]), &cdata[xfer_cnt],=0A=
+			       min_cnt);=0A=
+			xfer_cnt +=3D min_cnt;=0A=
+		}=0A=
+=0A=
+	} else {=0A=
+		unsigned int min_cnt =3D min(count, scmd->request_bufflen);=0A=
+		memcpy(scmd->request_buffer, data, min_cnt);=0A=
+	}=0A=
+}=0A=
+=0A=
+/**********************************************************************=
******/=0A=
+/*                                                                     =
     */=0A=
+/* Routine Name: ips_scmd_buf_read                                     =
     */=0A=
+/*                                                                     =
     */=0A=
+/* Routine Description:                                                =
     */=0A=
+/*  Copy data from a Scsi_Cmnd to a new, linear buffer                 =
     */=0A=
+/**********************************************************************=
******/=0A=
+static void ips_scmd_buf_read(Scsi_Cmnd *scmd, void *data, unsigned=0A=
+				   int count)=0A=
+{=0A=
+	if (scmd->use_sg) {=0A=
+		int i;=0A=
+		unsigned int min_cnt, xfer_cnt;=0A=
+		char *cdata =3D (char *)data;=0A=
+		struct scatterlist *sg =3D scmd->request_buffer;=0A=
+		for (i =3D 0, xfer_cnt =3D 0;=0A=
+		     (i < scmd->use_sg) && (xfer_cnt < count); i++){=0A=
+			if(!IPS_SG_ADDRESS(&sg[i]))=0A=
+				return;=0A=
+			min_cnt =3D min( count - xfer_cnt, sg[i].length);=0A=
+			memcpy(&cdata[xfer_cnt],IPS_SG_ADDRESS(&sg[i]),=0A=
+			       min_cnt);=0A=
+			xfer_cnt +=3D min_cnt;=0A=
+		}=0A=
+=0A=
+	} else {=0A=
+		unsigned int min_cnt =3D min(count, scmd->request_bufflen);=0A=
+		memcpy(data, scmd->request_buffer, min_cnt);=0A=
+	}=0A=
+}=0A=
+=0A=
+/**********************************************************************=
******/=0A=
+/*                                                                     =
     */=0A=
 /* Routine Name: ips_send_cmd                                          =
     */=0A=
 /*                                                                     =
     */=0A=
 /* Routine Description:                                                =
     */=0A=
@@ -3690,7 +3640,7 @@=0A=
                strncpy(inquiry.ProductId, "SERVERAID       ", 16);=0A=
                strncpy(inquiry.ProductRevisionLevel, "1.00", 4);=0A=
 =0A=
-               memcpy(scb->scsi_cmd->request_buffer, &inquiry, =
scb->scsi_cmd->request_bufflen);=0A=
+	       ips_scmd_buf_write(scb->scsi_cmd, &inquiry, =
sizeof(inquiry));=0A=
 =0A=
                scb->scsi_cmd->result =3D DID_OK << 16;=0A=
             }=0A=
@@ -3720,15 +3670,19 @@=0A=
          if (!scb->sg_len) {=0A=
             scb->cmd.basic_io.op_code =3D=0A=
             (scb->scsi_cmd->cmnd[0] =3D=3D READ_6) ? IPS_CMD_READ : =
IPS_CMD_WRITE;=0A=
+            scb->cmd.basic_io.enhanced_sg =3D 0;=0A=
+            scb->cmd.basic_io.sg_addr =3D =
cpu_to_le32(scb->data_busaddr);=0A=
          } else {=0A=
             scb->cmd.basic_io.op_code =3D=0A=
             (scb->scsi_cmd->cmnd[0] =3D=3D READ_6) ? IPS_CMD_READ_SG : =
IPS_CMD_WRITE_SG;=0A=
+            scb->cmd.basic_io.enhanced_sg =3D IPS_USE_ENH_SGLIST(ha) ? =
0xFF : 0;=0A=
+            scb->cmd.basic_io.sg_addr =3D =
cpu_to_le32(scb->sg_busaddr);=0A=
          }=0A=
 =0A=
+         scb->cmd.basic_io.segment_4G =3D 0;=0A=
          scb->cmd.basic_io.command_id =3D IPS_COMMAND_ID(ha, scb);=0A=
          scb->cmd.basic_io.log_drv =3D scb->target_id;=0A=
          scb->cmd.basic_io.sg_count =3D scb->sg_len;=0A=
-         scb->cmd.basic_io.sg_addr =3D =
cpu_to_le32(scb->data_busaddr);=0A=
 =0A=
          if (scb->cmd.basic_io.lba)=0A=
             scb->cmd.basic_io.lba =3D =
cpu_to_le32(le32_to_cpu(scb->cmd.basic_io.lba) +=0A=
@@ -3743,7 +3697,6 @@=0A=
          if (le16_to_cpu(scb->cmd.basic_io.sector_count) =3D=3D 0)=0A=
             scb->cmd.basic_io.sector_count =3D cpu_to_le16(256);=0A=
 =0A=
-         scb->cmd.basic_io.reserved =3D 0;=0A=
          ret =3D IPS_SUCCESS;=0A=
          break;=0A=
 =0A=
@@ -3752,15 +3705,19 @@=0A=
          if (!scb->sg_len) {=0A=
             scb->cmd.basic_io.op_code =3D=0A=
             (scb->scsi_cmd->cmnd[0] =3D=3D READ_10) ? IPS_CMD_READ : =
IPS_CMD_WRITE;=0A=
+            scb->cmd.basic_io.enhanced_sg =3D 0;=0A=
+            scb->cmd.basic_io.sg_addr =3D =
cpu_to_le32(scb->data_busaddr);=0A=
          } else {=0A=
             scb->cmd.basic_io.op_code =3D=0A=
             (scb->scsi_cmd->cmnd[0] =3D=3D READ_10) ? IPS_CMD_READ_SG =
: IPS_CMD_WRITE_SG;=0A=
+            scb->cmd.basic_io.enhanced_sg =3D IPS_USE_ENH_SGLIST(ha) ? =
0xFF : 0;=0A=
+            scb->cmd.basic_io.sg_addr =3D =
cpu_to_le32(scb->sg_busaddr);=0A=
          }=0A=
 =0A=
+         scb->cmd.basic_io.segment_4G =3D 0;=0A=
          scb->cmd.basic_io.command_id =3D IPS_COMMAND_ID(ha, scb);=0A=
          scb->cmd.basic_io.log_drv =3D scb->target_id;=0A=
          scb->cmd.basic_io.sg_count =3D scb->sg_len;=0A=
-         scb->cmd.basic_io.sg_addr =3D =
cpu_to_le32(scb->data_busaddr);=0A=
 =0A=
          if (scb->cmd.basic_io.lba)=0A=
             scb->cmd.basic_io.lba =3D =
cpu_to_le32(le32_to_cpu(scb->cmd.basic_io.lba) +=0A=
@@ -3773,7 +3730,6 @@=0A=
 =0A=
          scb->cmd.basic_io.sector_count =3D cpu_to_le16(scb->data_len =
/ IPS_BLKSIZE);=0A=
 =0A=
-         scb->cmd.basic_io.reserved =3D 0;=0A=
 =0A=
          if (cpu_to_le16(scb->cmd.basic_io.sector_count) =3D=3D 0) =
{=0A=
             /*=0A=
@@ -3795,6 +3751,8 @@=0A=
       case MODE_SENSE:=0A=
          scb->cmd.basic_io.op_code =3D IPS_CMD_ENQUIRY;=0A=
          scb->cmd.basic_io.command_id =3D IPS_COMMAND_ID(ha, scb);=0A=
+	 scb->cmd.basic_io.segment_4G =3D 0;=0A=
+	 scb->cmd.basic_io.enhanced_sg =3D 0;=0A=
          scb->data_len =3D sizeof(*ha->enq);=0A=
          scb->data_busaddr =3D pci_map_single(ha->pcidev, ha->enq,=0A=
                                             scb->data_len, =
IPS_DMA_DIR(scb));=0A=
@@ -3853,10 +3811,6 @@=0A=
 =0A=
    /* setup DCDB */=0A=
    if (scb->bus > 0) {=0A=
-      if (!scb->sg_len)=0A=
-         scb->cmd.dcdb.op_code =3D IPS_CMD_DCDB;=0A=
-      else=0A=
-         scb->cmd.dcdb.op_code =3D IPS_CMD_DCDB_SG;=0A=
 =0A=
       /* If we already know the Device is Not there, no need to =
attempt a Command   */=0A=
       /* This also protects an NT FailOver Controller from getting =
CDB's sent to it */=0A=
@@ -3872,15 +3826,19 @@=0A=
                                                (unsigned long)scb);=0A=
       scb->cmd.dcdb.reserved =3D 0;=0A=
       scb->cmd.dcdb.reserved2 =3D 0;=0A=
-      scb->cmd.dcdb.reserved3 =3D 0;   =0A=
+      scb->cmd.dcdb.reserved3 =3D 0;=0A=
+      scb->cmd.dcdb.segment_4G =3D 0;=0A=
+      scb->cmd.dcdb.enhanced_sg =3D 0;=0A=
 =0A=
       TimeOut =3D scb->scsi_cmd->timeout_per_command;=0A=
 =0A=
       if (ha->subsys->param[4] & 0x00100000) {          /* If NEW Tape =
DCDB is Supported */=0A=
-         if (!scb->sg_len)=0A=
+         if (!scb->sg_len) {=0A=
             scb->cmd.dcdb.op_code =3D IPS_CMD_EXTENDED_DCDB;=0A=
-         else=0A=
+         } else {=0A=
             scb->cmd.dcdb.op_code =3D IPS_CMD_EXTENDED_DCDB_SG;=0A=
+            scb->cmd.dcdb.enhanced_sg =3D IPS_USE_ENH_SGLIST(ha) ? =
0xFF : 0;=0A=
+         }=0A=
  =0A=
          tapeDCDB =3D (IPS_DCDB_TABLE_TAPE *) &scb->dcdb; /* Use Same =
Data Area as Old DCDB Struct */=0A=
          tapeDCDB->device_address =3D ((scb->bus - 1) << 4) | =
scb->target_id;=0A=
@@ -3899,13 +3857,23 @@=0A=
          tapeDCDB->cdb_length =3D scb->scsi_cmd->cmd_len;=0A=
          tapeDCDB->reserved_for_LUN =3D 0;=0A=
          tapeDCDB->transfer_length =3D scb->data_len;=0A=
-         tapeDCDB->buffer_pointer =3D =
cpu_to_le32(scb->data_busaddr);=0A=
+         if(scb->cmd.dcdb.op_code =3D=3D IPS_CMD_EXTENDED_DCDB_SG)=0A=
+            tapeDCDB->buffer_pointer =3D =
cpu_to_le32(scb->sg_busaddr);=0A=
+         else=0A=
+            tapeDCDB->buffer_pointer =3D =
cpu_to_le32(scb->data_busaddr);=0A=
          tapeDCDB->sg_count =3D scb->sg_len;=0A=
          tapeDCDB->sense_length =3D sizeof(tapeDCDB->sense_info);=0A=
          tapeDCDB->scsi_status =3D 0;=0A=
          tapeDCDB->reserved =3D 0;=0A=
          memcpy(tapeDCDB->scsi_cdb, scb->scsi_cmd->cmnd, =
scb->scsi_cmd->cmd_len);=0A=
       } else {=0A=
+         if (!scb->sg_len) {=0A=
+            scb->cmd.dcdb.op_code =3D IPS_CMD_DCDB;=0A=
+         } else {=0A=
+            scb->cmd.dcdb.op_code =3D IPS_CMD_DCDB_SG;=0A=
+            scb->cmd.dcdb.enhanced_sg =3D IPS_USE_ENH_SGLIST(ha) ? =
0xFF : 0;=0A=
+         }=0A=
+=0A=
          scb->dcdb.device_address =3D ((scb->bus - 1) << 4) | =
scb->target_id;=0A=
          scb->dcdb.cmd_attribute |=3D IPS_DISCONNECT_ALLOWED;=0A=
 =0A=
@@ -3921,7 +3889,10 @@=0A=
          scb->dcdb.transfer_length =3D scb->data_len;=0A=
          if ( scb->dcdb.cmd_attribute & IPS_TRANSFER64K ) =0A=
              scb->dcdb.transfer_length =3D 0;=0A=
-         scb->dcdb.buffer_pointer =3D =
cpu_to_le32(scb->data_busaddr);=0A=
+         if(scb->cmd.dcdb.op_code =3D=3D IPS_CMD_DCDB_SG)=0A=
+            scb->dcdb.buffer_pointer =3D =
cpu_to_le32(scb->sg_busaddr);=0A=
+         else=0A=
+            scb->dcdb.buffer_pointer =3D =
cpu_to_le32(scb->data_busaddr);=0A=
          scb->dcdb.cdb_length =3D scb->scsi_cmd->cmd_len;=0A=
          scb->dcdb.sense_length =3D sizeof(scb->dcdb.sense_info);=0A=
          scb->dcdb.sg_count =3D scb->sg_len;=0A=
@@ -4146,7 +4117,7 @@=0A=
    strncpy(inquiry.ProductId, "SERVERAID       ", 16);=0A=
    strncpy(inquiry.ProductRevisionLevel, "1.00", 4);=0A=
 =0A=
-   memcpy(scb->scsi_cmd->request_buffer, &inquiry, =
scb->scsi_cmd->request_bufflen);=0A=
+   ips_scmd_buf_write(scb->scsi_cmd, &inquiry, sizeof(inquiry));=0A=
 =0A=
    return (1);=0A=
 }=0A=
@@ -4162,17 +4133,17 @@=0A=
 =
/***********************************************************************=
*****/=0A=
 static int=0A=
 ips_rdcap(ips_ha_t *ha, ips_scb_t *scb) {=0A=
-   IPS_SCSI_CAPACITY *cap;=0A=
+   IPS_SCSI_CAPACITY cap;=0A=
 =0A=
    METHOD_TRACE("ips_rdcap", 1);=0A=
 =0A=
    if (scb->scsi_cmd->bufflen < 8)=0A=
       return (0);=0A=
 =0A=
-   cap =3D (IPS_SCSI_CAPACITY *) scb->scsi_cmd->request_buffer;=0A=
+   cap.lba =3D =
cpu_to_be32(le32_to_cpu(ha->adapt->logical_drive_info.drive_info[scb->ta=
rget_id].sector_count) - 1);=0A=
+   cap.len =3D cpu_to_be32((uint32_t) IPS_BLKSIZE);=0A=
 =0A=
-   cap->lba =3D =
cpu_to_be32(le32_to_cpu(ha->adapt->logical_drive_info.drive_info[scb->ta=
rget_id].sector_count) - 1);=0A=
-   cap->len =3D cpu_to_be32((uint32_t) IPS_BLKSIZE);=0A=
+   ips_scmd_buf_write(scb->scsi_cmd, &cap, sizeof(cap));=0A=
 =0A=
    return (1);=0A=
 }=0A=
@@ -4250,7 +4221,7 @@=0A=
       return (0);=0A=
    } /* end switch */=0A=
 =0A=
-   memcpy(scb->scsi_cmd->request_buffer, &mdata, =
scb->scsi_cmd->request_bufflen);=0A=
+   ips_scmd_buf_write(scb->scsi_cmd, &mdata, sizeof(mdata));=0A=
 =0A=
    return (1);=0A=
 }=0A=
@@ -4277,7 +4248,7 @@=0A=
    reqsen.AdditionalSenseCode =3D IPS_SCSI_REQSEN_NO_SENSE;=0A=
    reqsen.AdditionalSenseCodeQual =3D IPS_SCSI_REQSEN_NO_SENSE;=0A=
 =0A=
-   memcpy(scb->scsi_cmd->request_buffer, &reqsen, =
scb->scsi_cmd->request_bufflen);=0A=
+   ips_scmd_buf_write(scb->scsi_cmd, &reqsen, sizeof(reqsen));=0A=
 =0A=
    return (1);=0A=
 }=0A=
@@ -4356,8 +4327,8 @@=0A=
 static int=0A=
 ips_deallocatescbs(ips_ha_t *ha, int cmds) {=0A=
    if (ha->scbs) {=0A=
-      pci_free_consistent(ha->pcidev,sizeof(IPS_SG_LIST) * IPS_MAX_SG =
*=0A=
-                          cmds, ha->scbs->sg_list, =
ha->scbs->sg_busaddr);=0A=
+      pci_free_consistent(ha->pcidev, IPS_SGLIST_SIZE(ha) * IPS_MAX_SG =
*=0A=
+                          cmds, ha->scbs->sg_list.list, =
ha->scbs->sg_busaddr);=0A=
       pci_free_consistent(ha->pcidev, sizeof(ips_scb_t) * cmds,=0A=
                           ha->scbs, ha->scbs->scb_busaddr);=0A=
       ha->scbs =3D NULL;=0A=
@@ -4377,7 +4348,7 @@=0A=
 static int=0A=
 ips_allocatescbs(ips_ha_t *ha) {=0A=
    ips_scb_t *scb_p;=0A=
-   IPS_SG_LIST* ips_sg;=0A=
+   IPS_SG_LIST ips_sg;=0A=
    int        i;=0A=
    dma_addr_t command_dma, sg_dma;=0A=
    =0A=
@@ -4388,9 +4359,9 @@=0A=
 	                           &command_dma);=0A=
    if (ha->scbs =3D=3D NULL)=0A=
       return 0;=0A=
-   ips_sg =3D pci_alloc_consistent(ha->pcidev, sizeof(IPS_SG_LIST) * =
IPS_MAX_SG * =0A=
-	                         ha->max_cmds, &sg_dma);=0A=
-   if(ips_sg =3D=3D NULL){=0A=
+   ips_sg.list =3D pci_alloc_consistent(ha->pcidev, =
IPS_SGLIST_SIZE(ha) * IPS_MAX_SG *=0A=
+                                    ha->max_cmds, &sg_dma);=0A=
+   if(ips_sg.list =3D=3D NULL){=0A=
       pci_free_consistent(ha->pcidev,ha->max_cmds * =
sizeof(ips_scb_t),ha->scbs, command_dma);=0A=
       return 0;=0A=
    }=0A=
@@ -4401,8 +4372,13 @@=0A=
       scb_p =3D &ha->scbs[i];=0A=
       scb_p->scb_busaddr =3D command_dma + sizeof(ips_scb_t) * i;=0A=
       /* set up S/G list */=0A=
-      scb_p->sg_list =3D ips_sg + i * IPS_MAX_SG;=0A=
-      scb_p->sg_busaddr =3D sg_dma + sizeof(IPS_SG_LIST) * IPS_MAX_SG =
* i;=0A=
+      if (IPS_USE_ENH_SGLIST(ha)) {=0A=
+         scb_p->sg_list.enh_list =3D ips_sg.enh_list + i * =
IPS_MAX_SG;=0A=
+         scb_p->sg_busaddr =3D sg_dma + IPS_SGLIST_SIZE(ha) * =
IPS_MAX_SG * i;=0A=
+      } else {=0A=
+         scb_p->sg_list.std_list =3D ips_sg.std_list + i * =
IPS_MAX_SG;=0A=
+         scb_p->sg_busaddr =3D sg_dma + IPS_SGLIST_SIZE(ha) * =
IPS_MAX_SG * i;=0A=
+      }=0A=
 =0A=
       /* add to the free list */=0A=
       if (i < ha->max_cmds - 1) {=0A=
@@ -4426,14 +4402,14 @@=0A=
 =
/***********************************************************************=
*****/=0A=
 static void=0A=
 ips_init_scb(ips_ha_t *ha, ips_scb_t *scb) {=0A=
-   IPS_SG_LIST *sg_list;=0A=
+   IPS_SG_LIST sg_list;=0A=
    uint32_t cmd_busaddr, sg_busaddr;=0A=
    METHOD_TRACE("ips_init_scb", 1);=0A=
 =0A=
    if (scb =3D=3D NULL)=0A=
       return ;=0A=
 =0A=
-   sg_list =3D scb->sg_list;=0A=
+   sg_list.list =3D scb->sg_list.list;=0A=
    cmd_busaddr =3D scb->scb_busaddr;=0A=
    sg_busaddr =3D scb->sg_busaddr;=0A=
    /* zero fill */=0A=
@@ -4449,7 +4425,7 @@=0A=
    /* set bus address of scb */=0A=
    scb->scb_busaddr =3D cmd_busaddr;=0A=
    scb->sg_busaddr =3D sg_busaddr;=0A=
-   scb->sg_list =3D sg_list;=0A=
+   scb->sg_list.list =3D sg_list.list;=0A=
 =0A=
    /* Neptune Fix */=0A=
    scb->cmd.basic_io.cccr =3D cpu_to_le32((uint32_t) IPS_BIT_ILE);=0A=
@@ -4503,8 +4479,7 @@=0A=
 =0A=
    METHOD_TRACE("ips_freescb", 1);=0A=
    if(scb->flags & IPS_SCB_MAP_SG)=0A=
-      pci_unmap_sg(ha->pcidev, scb->scsi_cmd->request_buffer,=0A=
-                   scb->scsi_cmd->use_sg,=0A=
+      pci_unmap_sg(ha->pcidev,scb->scsi_cmd->request_buffer, =
scb->scsi_cmd->use_sg,=0A=
                    IPS_DMA_DIR(scb));=0A=
    else if(scb->flags & IPS_SCB_MAP_SINGLE)=0A=
       pci_unmap_single(ha->pcidev, scb->data_busaddr, =
scb->data_len,=0A=
@@ -5620,7 +5595,6 @@=0A=
    scb->cmd.basic_io.lba =3D 0;=0A=
    scb->cmd.basic_io.sector_count =3D 0;=0A=
    scb->cmd.basic_io.log_drv =3D 0;=0A=
-   scb->cmd.basic_io.reserved =3D 0;=0A=
    scb->data_len =3D sizeof(*ha->enq);=0A=
    scb->data_busaddr =3D pci_map_single(ha->pcidev, ha->enq, =
scb->data_len,=0A=
                                       IPS_DMA_DIR(scb));=0A=
@@ -5665,7 +5639,6 @@=0A=
    scb->cmd.basic_io.lba =3D 0;=0A=
    scb->cmd.basic_io.sector_count =3D 0;=0A=
    scb->cmd.basic_io.log_drv =3D 0;=0A=
-   scb->cmd.basic_io.reserved =3D 0;=0A=
    scb->data_len =3D sizeof(*ha->subsys);=0A=
    scb->data_busaddr =3D pci_map_single(ha->pcidev, ha->subsys,=0A=
                                       scb->data_len, =
IPS_DMA_DIR(scb));=0A=
@@ -6992,9 +6965,20 @@=0A=
     ha->subdevice_id =3D subdevice_id;=0A=
     ha->pcidev =3D pci_dev;=0A=
 =0A=
-    pci_set_dma_mask(ha->pcidev, (u64)0xffffffff);=0A=
+    /*=0A=
+     * Set the pci_dev's dma_mask.  Not all adapters support 64bit=0A=
+     * addressing so don't enable it if the adapter can't support=0A=
+     * it!  Also, don't use 64bit addressing if dma addresses=0A=
+     * are guaranteed to be < 4G.=0A=
+     */=0A=
+    if ( IPS_ENABLE_DMA64 && IPS_HAS_ENH_SGLIST(ha) &&=0A=
+         !pci_set_dma_mask(ha->pcidev, (u64)0xffffffffffffffff)) {=0A=
+       (ha)->flags |=3D IPS_HA_ENH_SG;=0A=
+    } else {=0A=
+       pci_set_dma_mask(ha->pcidev, (u64)0xffffffff);=0A=
+    }=0A=
 =0A=
-    ha->enq =3D kmalloc(sizeof(IPS_ENQ), GFP_KERNEL);=0A=
+    ha->enq =3D kmalloc(sizeof(IPS_ENQ), IPS_INIT_GFP);=0A=
 =0A=
     if (!ha->enq) {=0A=
        printk(KERN_WARNING "Unable to allocate host inquiry =
structure\n" );=0A=
@@ -7010,21 +6994,21 @@=0A=
     ha->adapt->hw_status_start =3D dma_address;=0A=
     ha->dummy =3D (void *)(ha->adapt + 1);=0A=
 =0A=
-    ha->conf =3D kmalloc(sizeof(IPS_CONF), GFP_KERNEL);=0A=
+    ha->conf =3D kmalloc(sizeof(IPS_CONF), IPS_INIT_GFP);=0A=
 =0A=
     if (!ha->conf) {=0A=
        printk(KERN_WARNING "Unable to allocate host conf structure\n" =
);=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
-    ha->nvram =3D kmalloc(sizeof(IPS_NVRAM_P5), GFP_KERNEL);=0A=
+    ha->nvram =3D kmalloc(sizeof(IPS_NVRAM_P5), IPS_INIT_GFP);=0A=
 =0A=
     if (!ha->nvram) {=0A=
        printk(KERN_WARNING "Unable to allocate host NVRAM structure\n" =
);=0A=
        return ips_abort_init(ha, index);=0A=
     }=0A=
 =0A=
-    ha->subsys =3D kmalloc(sizeof(IPS_SUBSYS), GFP_KERNEL);=0A=
+    ha->subsys =3D kmalloc(sizeof(IPS_SUBSYS), IPS_INIT_GFP);=0A=
 =0A=
     if (!ha->subsys) {=0A=
        printk(KERN_WARNING "Unable to allocate host subsystem =
structure\n" );=0A=
@@ -7035,7 +7019,7 @@=0A=
          count < ips_ioctlsize;=0A=
          ha->ioctl_order++, count <<=3D 1);=0A=
 =0A=
-    ha->ioctl_data =3D (char *) __get_free_pages(GFP_KERNEL, =
ha->ioctl_order);=0A=
+    ha->ioctl_data =3D (char *) __get_free_pages(IPS_INIT_GFP, =
ha->ioctl_order);=0A=
     ha->ioctl_datasize =3D count;=0A=
 =0A=
     if (!ha->ioctl_data) {=0A=
diff -ur linux-2.5.59_p2/drivers/scsi/ips.h =
linux-2.5.59_p3/drivers/scsi/ips.h=0A=
--- linux-2.5.59_p2/drivers/scsi/ips.h	Mon Jan 20 09:46:27 2003=0A=
+++ linux-2.5.59_p3/drivers/scsi/ips.h	Mon Jan 20 11:43:56 2003=0A=
@@ -59,9 +59,7 @@=0A=
    extern int ips_eh_abort(Scsi_Cmnd *);=0A=
    extern int ips_eh_reset(Scsi_Cmnd *);=0A=
    extern int ips_queue(Scsi_Cmnd *, void (*) (Scsi_Cmnd *));=0A=
-   extern int ips_slave_configure(Scsi_Device *);=0A=
    extern const char * ips_info(struct Scsi_Host *);=0A=
-   extern void do_ips(int, void *, struct pt_regs *);=0A=
 =0A=
    /*=0A=
     * Some handy macros=0A=
@@ -70,6 +68,13 @@=0A=
       #define LinuxVersionCode(x,y,z)  (((x)<<16)+((y)<<8)+(z))=0A=
    #endif=0A=
 =0A=
+   #if LINUX_VERSION_CODE >=3D LinuxVersionCode(2,4,20) || defined =
CONFIG_HIGHIO=0A=
+      #define IPS_HIGHIO=0A=
+      #define IPS_HIGHMEM_IO     .highmem_io =3D 1,=0A=
+   #else=0A=
+      #define IPS_HIGHMEM_IO=0A=
+   #endif=0A=
+=0A=
    #define IPS_HA(x)                   ((ips_ha_t *) x->hostdata)=0A=
    #define IPS_COMMAND_ID(ha, scb)     (int) (scb - ha->scbs)=0A=
    #define IPS_IS_TROMBONE(ha)         (((ha->device_id =3D=3D =
IPS_DEVICEID_COPPERHEAD) && \=0A=
@@ -87,6 +92,11 @@=0A=
                                          ((IPS_IS_TROMBONE(ha) || =
IPS_IS_CLARINET(ha)) && \=0A=
                                           (ips_force_memio))) ? 1 : =
0)=0A=
 =0A=
+    #define IPS_HAS_ENH_SGLIST(ha)    (IPS_IS_MORPHEUS(ha) || =
IPS_IS_MARCO(ha))=0A=
+    #define IPS_USE_ENH_SGLIST(ha)    ((ha)->flags & IPS_HA_ENH_SG)=0A=
+    #define IPS_SGLIST_SIZE(ha)       (IPS_USE_ENH_SGLIST(ha) ? \=0A=
+                                         sizeof(IPS_ENH_SG_LIST) : =
sizeof(IPS_STD_SG_LIST))=0A=
+=0A=
    #if LINUX_VERSION_CODE < LinuxVersionCode(2,4,4)=0A=
       #define pci_set_dma_mask(dev,mask) (1)=0A=
       #define scsi_set_pci_device(sh,dev) (0)=0A=
@@ -105,6 +115,24 @@=0A=
       #define min(x,y) ((x) < (y) ? x : y)=0A=
    #endif=0A=
 =0A=
+   #define pci_dma_lo32(a)         (a & 0xffffffff)=0A=
+=0A=
+   #if (BITS_PER_LONG > 32) || (defined CONFIG_HIGHMEM64G && defined =
IPS_HIGHIO)=0A=
+      #define IPS_ENABLE_DMA64        (1)=0A=
+      #define pci_dma_hi32(a)         (a >> 32)=0A=
+   #else=0A=
+      #define IPS_ENABLE_DMA64        (0)=0A=
+      #define pci_dma_hi32(a)         (0)=0A=
+   #endif=0A=
+=0A=
+   #if defined(__ia64__)=0A=
+      #define IPS_ATOMIC_GFP	(GFP_DMA | GFP_ATOMIC)=0A=
+      #define IPS_INIT_GFP	GFP_DMA=0A=
+   #else=0A=
+      #define IPS_ATOMIC_GFP    GFP_ATOMIC=0A=
+      #define IPS_INIT_GFP	GFP_KERNEL=0A=
+   #endif=0A=
+=0A=
    /*=0A=
     * Adapter address map equates=0A=
     */=0A=
@@ -458,7 +486,7 @@=0A=
 #endif=0A=
 =0A=
 /*=0A=
- * IBM PCI Raid Command Formats=0A=
+ * Raid Command Formats=0A=
  */=0A=
 typedef struct {=0A=
    uint8_t  op_code;=0A=
@@ -468,7 +496,8 @@=0A=
    uint32_t lba;=0A=
    uint32_t sg_addr;=0A=
    uint16_t sector_count;=0A=
-   uint16_t reserved;=0A=
+   uint8_t  segment_4G;=0A=
+   uint8_t  enhanced_sg;=0A=
    uint32_t ccsar;=0A=
    uint32_t cccr;=0A=
 } IPS_IO_CMD, *PIPS_IO_CMD;=0A=
@@ -519,7 +548,9 @@=0A=
    uint16_t reserved;=0A=
    uint32_t reserved2;=0A=
    uint32_t dcdb_address;=0A=
-   uint32_t reserved3;=0A=
+   uint16_t reserved3;=0A=
+   uint8_t  segment_4G;=0A=
+   uint8_t  enhanced_sg;=0A=
    uint32_t ccsar;=0A=
    uint32_t cccr;=0A=
 } IPS_DCDB_CMD, *PIPS_DCDB_CMD;=0A=
@@ -963,7 +994,20 @@=0A=
 typedef struct ips_sglist {=0A=
    uint32_t address;=0A=
    uint32_t length;=0A=
-} IPS_SG_LIST, *PIPS_SG_LIST;=0A=
+} IPS_STD_SG_LIST;=0A=
+=0A=
+typedef struct ips_enh_sglist {=0A=
+   uint32_t address_lo;=0A=
+   uint32_t address_hi;=0A=
+   uint32_t length;=0A=
+   uint32_t reserved;=0A=
+} IPS_ENH_SG_LIST;=0A=
+=0A=
+typedef union {=0A=
+   void             *list;=0A=
+   IPS_STD_SG_LIST  *std_list;=0A=
+   IPS_ENH_SG_LIST  *enh_list;=0A=
+} IPS_SG_LIST;=0A=
 =0A=
 typedef struct _IPS_INFOSTR {=0A=
    char *buffer;=0A=
@@ -1063,6 +1107,7 @@=0A=
    char              *ioctl_data;         /* IOCTL data area           =
 */=0A=
    uint32_t           ioctl_datasize;     /* IOCTL data size           =
 */=0A=
    uint32_t           cmd_in_progress;    /* Current command in =
progress*/=0A=
+   int                flags;              /*                           =
 */=0A=
    uint8_t            waitflag;           /* are we waiting for cmd    =
 */=0A=
    uint8_t            active;=0A=
    int                ioctl_reset;        /* IOCTL Requested Reset =
Flag */=0A=
@@ -1110,7 +1155,7 @@=0A=
    uint32_t          sg_len;=0A=
    uint32_t          flags;=0A=
    uint32_t          op_code;=0A=
-   IPS_SG_LIST      *sg_list;=0A=
+   IPS_SG_LIST       sg_list;=0A=
    Scsi_Cmnd        *scsi_cmd;=0A=
    struct ips_scb   *q_next;=0A=
    ips_scb_callback  callback;=0A=

------_=_NextPart_000_01C2CE0B.C6DF99E0--
