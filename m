From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [PATCH 2.5] megaraid driver updates 1/4
Date: Wed, 30 Oct 2002 16:14:14 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210301613420.29157-100000@humbolt.us.dell.com>
References: <Pine.LNX.4.44.0210301606300.29157-100000@humbolt.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0210301606300.29157-100000@humbolt.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

You can import this changeset into BK by piping this whole message to
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.808.11.1, 2002-10-22 11:30:04-05:00, Matt_Domsch@dell.com
  megaraid: remove mega_{reorder,swap}_hosts
  
  Patch posted to l-k by Mike Anderson <andmike@us.ibm.com> on
  21-Oct-2002.


 megaraid.c |  182 -------------------------------------------------------------
 megaraid.h |    2 
 2 files changed, 2 insertions, 182 deletions


diff -Nru a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c	Wed Oct 30 15:55:53 2002
+++ b/drivers/scsi/megaraid.c	Wed Oct 30 15:55:53 2002
@@ -3217,7 +3217,6 @@
 	count += mega_findCard (pHostTmpl, PCI_VENDOR_ID_AMI,
 				PCI_DEVICE_ID_AMI_MEGARAID3, BOARD_QUARTZ);
 
-	mega_reorder_hosts ();
 
 #ifdef CONFIG_PROC_FS
 	if (count) {
@@ -3483,173 +3482,6 @@
 }
 
 
-static void mega_reorder_hosts (void)
-{
-	struct Scsi_Host *shpnt;
-	struct Scsi_Host *shone;
-	struct Scsi_Host *shtwo;
-	mega_host_config *boot_host;
-	int i;
-
-	/*
-	 * Find the (first) host which has it's BIOS enabled
-	 */
-	boot_host = NULL;
-	for (i = 0; i < MAX_CONTROLLERS; i++) {
-		if (mega_hbas[i].is_bios_enabled) {
-			boot_host = mega_hbas[i].hostdata_addr;
-			break;
-		}
-	}
-
-	if (boot_host == NULL) {
-		printk (KERN_WARNING "megaraid: no BIOS enabled.\n");
-		return;
-	}
-
-	/*
-	 * Traverse through the list of SCSI hosts for our HBA locations
-	 */
-	shone = shtwo = NULL;
-	for (shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next) {
-		/* Is it one of ours? */
-		for (i = 0; i < MAX_CONTROLLERS; i++) {
-			if ((mega_host_config *) shpnt->hostdata ==
-			    mega_hbas[i].hostdata_addr) {
-				/* Does this one has BIOS enabled */
-				if (mega_hbas[i].hostdata_addr == boot_host) {
-
-					/* Are we first */
-					if (shtwo == NULL)	/* Yes! */
-						return;
-					else {	/* :-( */
-						shone = shpnt;
-					}
-				} else {
-					if (!shtwo) {
-						/* were we here before? xchng first */
-						shtwo = shpnt;
-					}
-				}
-				break;
-			}
-		}
-		/*
-		 * Have we got the boot host and one which does not have the bios
-		 * enabled.
-		 */
-		if (shone && shtwo)
-			break;
-	}
-	if (shone && shtwo) {
-		mega_swap_hosts (shone, shtwo);
-	}
-
-	return;
-}
-
-static void mega_swap_hosts (struct Scsi_Host *shone, struct Scsi_Host *shtwo)
-{
-	struct Scsi_Host *prevtoshtwo;
-	struct Scsi_Host *prevtoshone;
-	struct Scsi_Host *save = NULL;;
-
-	/* Are these two nodes adjacent */
-	if (shtwo->next == shone) {
-
-		if (shtwo == scsi_hostlist && shone->next == NULL) {
-
-			/* just two nodes */
-			scsi_hostlist = shone;
-			shone->next = shtwo;
-			shtwo->next = NULL;
-		} else if (shtwo == scsi_hostlist) {
-			/* first two nodes of the list */
-
-			scsi_hostlist = shone;
-			shtwo->next = shone->next;
-			scsi_hostlist->next = shtwo;
-		} else if (shone->next == NULL) {
-			/* last two nodes of the list */
-
-			prevtoshtwo = scsi_hostlist;
-
-			while (prevtoshtwo->next != shtwo)
-				prevtoshtwo = prevtoshtwo->next;
-
-			prevtoshtwo->next = shone;
-			shone->next = shtwo;
-			shtwo->next = NULL;
-		} else {
-			prevtoshtwo = scsi_hostlist;
-
-			while (prevtoshtwo->next != shtwo)
-				prevtoshtwo = prevtoshtwo->next;
-
-			prevtoshtwo->next = shone;
-			shtwo->next = shone->next;
-			shone->next = shtwo;
-		}
-
-	} else if (shtwo == scsi_hostlist && shone->next == NULL) {
-		/* shtwo at head, shone at tail, not adjacent */
-
-		prevtoshone = scsi_hostlist;
-
-		while (prevtoshone->next != shone)
-			prevtoshone = prevtoshone->next;
-
-		scsi_hostlist = shone;
-		shone->next = shtwo->next;
-		prevtoshone->next = shtwo;
-		shtwo->next = NULL;
-	} else if (shtwo == scsi_hostlist && shone->next != NULL) {
-		/* shtwo at head, shone is not at tail */
-
-		prevtoshone = scsi_hostlist;
-		while (prevtoshone->next != shone)
-			prevtoshone = prevtoshone->next;
-
-		scsi_hostlist = shone;
-		prevtoshone->next = shtwo;
-		save = shtwo->next;
-		shtwo->next = shone->next;
-		shone->next = save;
-	} else if (shone->next == NULL) {
-		/* shtwo not at head, shone at tail */
-
-		prevtoshtwo = scsi_hostlist;
-		prevtoshone = scsi_hostlist;
-
-		while (prevtoshtwo->next != shtwo)
-			prevtoshtwo = prevtoshtwo->next;
-		while (prevtoshone->next != shone)
-			prevtoshone = prevtoshone->next;
-
-		prevtoshtwo->next = shone;
-		shone->next = shtwo->next;
-		prevtoshone->next = shtwo;
-		shtwo->next = NULL;
-
-	} else {
-		prevtoshtwo = scsi_hostlist;
-		prevtoshone = scsi_hostlist;
-		save = NULL;;
-
-		while (prevtoshtwo->next != shtwo)
-			prevtoshtwo = prevtoshtwo->next;
-		while (prevtoshone->next != shone)
-			prevtoshone = prevtoshone->next;
-
-		prevtoshtwo->next = shone;
-		save = shone->next;
-		shone->next = shtwo->next;
-		prevtoshone->next = shtwo;
-		shtwo->next = save;
-	}
-	return;
-}
-
 static inline void mega_freeSgList (mega_host_config * megaCfg)
 {
 	int i;
@@ -4684,12 +4516,7 @@
 		/*
 		 * Find this host
 		 */
-		for( shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next ) {
-			if( shpnt->hostdata == (unsigned long *)megaCtlrs[adapno] ) {
-				megacfg = (mega_host_config *)shpnt->hostdata;
-				break;
-			}
-		}
+		shpnt = megaCtlrs[adapno]->host;
 		if(shpnt == NULL)  return -ENODEV;
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
@@ -4804,12 +4631,7 @@
 		/*
 		 * Find this host
 		 */
-		for( shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next ) {
-			if( shpnt->hostdata == (unsigned long *)megaCtlrs[adapno] ) {
-				megacfg = (mega_host_config *)shpnt->hostdata;
-				break;
-			}
-		}
+		shpnt = megaCtlrs[adapno]->host;
 		if(shpnt == NULL)  return -ENODEV;
 
 		/*
diff -Nru a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h	Wed Oct 30 15:55:53 2002
+++ b/drivers/scsi/megaraid.h	Wed Oct 30 15:55:53 2002
@@ -988,8 +988,6 @@
 			      int lock, int intr);
 
 static int mega_is_bios_enabled (mega_host_config *);
-static void mega_reorder_hosts (void);
-static void mega_swap_hosts (struct Scsi_Host *, struct Scsi_Host *);
 
 static void mega_create_proc_entry (int index, struct proc_dir_entry *);
 static int mega_support_ext_cdb(mega_host_config *);

===================================================================


This BitKeeper patch contains the following changesets:
1.808.11.1
## Wrapped with gzip_uu ##


begin 664 bkpatch29018
M'XL(`&E5P#T``\55VV[30!!]SG[%2GT$VS-[\0U2!1IN@JI549\0JC;VMK82
M>R.ODU)A_IU-HC;ETB0-(.R5;(UF1F?/G+-[0,^M;M+>L6K;BZ&I;%:0`_K6
MV#;MY7HR\3-3N<"9,2X0%*;2094OTX+1.)B4]>R+QWSI5?I*-:K,B4L^56U6
MT+EN;-I#G]]%VINI3GMGK]Z<?WAQ1DB_3X\*55_IC[JE_3YI33-7D]P.5%M,
M3.VWC:IMI5NUP-#=I78,@+E78L1!AAV&(*(NPQQ1"=0Y,!&'8MUM@7EC+P1,
M@,N0B8[QF"=D2-&/(?81?:3``H2`,8J8<DA!>"!3`'J/L,$M4?0)HQZ0E_3O
M;N6(9/26WY0VNC)SO0Q<?&VT:7+=/+77:OKMHG!CLR[9K17C4Q?0N8-#)]Z8
MCF[H<3G6]$7M2JRIZ7-5YY6+#&;6+T?5`MPA-;4K9^B=9*VWP.>3]Y2)4#)R
MNIX7\1[Y$`(*R.$69O*F7,@FL)DM@]LM^]D]G@1`T@'R2'0Q))=JE'&6728\
M@O"W(]G8$H$Q#%G"91<"YW)/?,4O^!B*N!,9)C$3,E:"\TNGH$?@*W[&!Y(Q
MN?3,`QO:[J`_(I>H\;0:Y.65-CO0"@E*'DG>N3\GX(6A&%];"<(4DY3C-BMA
M_&_,M-5"KRG&KMPI?Z6+$^HUU\OEE'SZT`CV,,60,P84W=>!HQA&9"C".*(A
M>2?"Q!TZI->SQ;1V!^02[E$[:>PGE:MI;3Y[APNTSUQ)#*N2&'<L>5A(Q;Y"
MVM$%9%XV9E"YQO[4SGR=SS;WBQBZ?K$;)4J6K`YGA!^TQ"`5X48M`?78_U.2
HP^V4M#3P3D(J]A%2DB!EZ]LW*W0VMK.J#Y!+`9$BWP$XPS@\Z@<`````
`
end

