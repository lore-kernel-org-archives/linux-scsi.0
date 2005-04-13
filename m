From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: Address sparse warnings (update)
Date: Wed, 13 Apr 2005 14:34:58 -0700
Message-ID: <1113428098.1509.35.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:56464 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261203AbVDMVfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 17:35:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

This patch addresses the sparse -Wbitwise warnings that Christoph wanted
me to eliminate.  This mostly consisted of making data structure
elements of hardware associated structures the __le* equivalent.
Although there were a couple places where there was mixing of cpu and le
variable math.  These changes have been tested on both an x86 and ppc
machine running bonnie++.  The usage of the LE32_ALL_ONES macro has been
eliminated.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/aachba.c 1.35 vs edited =====
--- 1.35/drivers/scsi/aacraid/aachba.c	2005-03-30 09:40:26 -08:00
+++ edited/drivers/scsi/aacraid/aachba.c	2005-04-11 09:34:45 -07:00
@@ -562,7 +562,7 @@
 	inqstrcpy ("V1.0", str->prl);
 }
 
-void set_sense(u8 *sense_buf, u8 sense_key, u8 sense_code,
+static void set_sense(u8 *sense_buf, u8 sense_key, u8 sense_code,
 		    u8 a_sense_code, u8 incorrect_length,
 		    u8 bit_pointer, u16 field_pointer,
 		    u32 residue)
@@ -813,7 +813,7 @@
 	aac_io_done(scsicmd);
 }
 
-int aac_read(struct scsi_cmnd * scsicmd, int cid)
+static int aac_read(struct scsi_cmnd * scsicmd, int cid)
 {
 	u32 lba;
 	u32 count;
@@ -1893,7 +1893,9 @@
 		}
 		/* hba wants the size to be exact */
 		if(byte_count > scsicmd->request_bufflen){
-			psg->sg[i-1].count -= (byte_count - scsicmd->request_bufflen);
+			u32 temp = le32_to_cpu(psg->sg[i-1].count) - 
+				(byte_count - scsicmd->request_bufflen);
+			psg->sg[i-1].count = cpu_to_le32(temp);
 			byte_count = scsicmd->request_bufflen;
 		}
 		/* Check for command underflow */
@@ -1922,7 +1924,7 @@
 {
 	struct aac_dev *dev;
 	unsigned long byte_count = 0;
-	u64 le_addr;
+	u64 addr;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	// Get rid of old data
@@ -1943,16 +1945,18 @@
 		byte_count = 0;
 
 		for (i = 0; i < sg_count; i++) {
-			le_addr = cpu_to_le64(sg_dma_address(sg));
-			psg->sg[i].addr[1] = (u32)(le_addr>>32);
-			psg->sg[i].addr[0] = (u32)(le_addr & 0xffffffff);
+			addr = sg_dma_address(sg);
+			psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
+			psg->sg[i].addr[1] = cpu_to_le32(addr>>32);
 			psg->sg[i].count = cpu_to_le32(sg_dma_len(sg));
 			byte_count += sg_dma_len(sg);
 			sg++;
 		}
 		/* hba wants the size to be exact */
 		if(byte_count > scsicmd->request_bufflen){
-			psg->sg[i-1].count -= (byte_count - scsicmd->request_bufflen);
+			u32 temp = le32_to_cpu(psg->sg[i-1].count) - 
+				(byte_count - scsicmd->request_bufflen);
+			psg->sg[i-1].count = cpu_to_le32(temp);
 			byte_count = scsicmd->request_bufflen;
 		}
 		/* Check for command underflow */
@@ -1962,15 +1966,14 @@
 		}
 	}
 	else if(scsicmd->request_bufflen) {
-		dma_addr_t addr; 
+		u64 addr; 
 		addr = pci_map_single(dev->pdev,
 				scsicmd->request_buffer,
 				scsicmd->request_bufflen,
 				scsicmd->sc_data_direction);
 		psg->count = cpu_to_le32(1);
-		le_addr = cpu_to_le64(addr);
-		psg->sg[0].addr[1] = (u32)(le_addr>>32);
-		psg->sg[0].addr[0] = (u32)(le_addr & 0xffffffff);
+		psg->sg[0].addr[0] = cpu_to_le32(addr & 0xffffffff);
+		psg->sg[0].addr[1] = cpu_to_le32(addr >> 32);
 		psg->sg[0].count = cpu_to_le32(scsicmd->request_bufflen);  
 		scsicmd->SCp.dma_handle = addr;
 		byte_count = scsicmd->request_bufflen;
===== drivers/scsi/aacraid/aacraid.h 1.30 vs edited =====
--- 1.30/drivers/scsi/aacraid/aacraid.h	2005-03-29 09:31:47 -08:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2005-04-13 14:27:51 -07:00
@@ -89,11 +89,21 @@
  *	on 64 bit systems not all cards support the 64 bit version
  */
 struct sgentry {
+	__le32	addr;	/* 32-bit address. */
+	__le32	count;	/* Length. */
+};
+
+struct user_sgentry {
 	u32	addr;	/* 32-bit address. */
 	u32	count;	/* Length. */
 };
 
 struct sgentry64 {
+	__le32	addr[2];	/* 64-bit addr. 2 pieces for data alignment */
+	__le32	count;	/* Length. */
+};
+
+struct user_sgentry64 {
 	u32	addr[2];	/* 64-bit addr. 2 pieces for data alignment */
 	u32	count;	/* Length. */
 };
@@ -106,15 +116,25 @@
  */
 
 struct sgmap {
-	u32		count;
+	__le32		count;
 	struct sgentry	sg[1]; 
 };
 
-struct sgmap64 {
+struct user_sgmap {
 	u32		count;
+	struct user_sgentry	sg[1]; 
+};
+
+struct sgmap64 {
+	__le32		count;
 	struct sgentry64 sg[1];
 };
 
+struct user_sgmap64 {
+	u32		count;
+	struct user_sgentry64 sg[1];
+};
+
 struct creation_info
 {
 	u8 		buildnum;		/* e.g., 588 */
@@ -123,14 +143,14 @@
 						 * 	 2 = API
 						 */
 	u8	 	year;		 	/* e.g., 1997 = 97 */
-	u32		date;			/*
+	__le32		date;			/*
 						 * unsigned 	Month		:4;	// 1 - 12
 						 * unsigned 	Day		:6;	// 1 - 32
 						 * unsigned 	Hour		:6;	// 0 - 23
 						 * unsigned 	Minute		:6;	// 0 - 60
 						 * unsigned 	Second		:6;	// 0 - 60
 						 */
-	u32		serial[2];			/* e.g., 0x1DEADB0BFAFAF001 */
+	__le32		serial[2];			/* e.g., 0x1DEADB0BFAFAF001 */
 };
 
 
@@ -175,8 +195,8 @@
  */
 
 struct aac_entry {
-	u32 size;          /* Size in bytes of Fib which this QE points to */
-	u32 addr; /* Receiver address of the FIB */
+	__le32 size; /* Size in bytes of Fib which this QE points to */
+	__le32 addr; /* Receiver address of the FIB */
 };
 
 /*
@@ -185,9 +205,10 @@
  */
  
 struct aac_qhdr {
-	u64 header_addr;		/* Address to hand the adapter to access to this queue head */
-	u32 *producer;			/* The producer index for this queue (host address) */
-	u32 *consumer;			/* The consumer index for this queue (host address) */
+	__le64 header_addr;/* Address to hand the adapter to access 
+			      to this queue head */
+	__le32 *producer; /* The producer index for this queue (host address) */
+	__le32 *consumer; /* The consumer index for this queue (host address) */
 };
 
 /*
@@ -261,19 +282,23 @@
  */
 
 struct aac_fibhdr {
-	u32 XferState;			// Current transfer state for this CCB
-	u16 Command;			// Routing information for the destination
-	u8 StructType;			// Type FIB
-	u8 Flags;			// Flags for FIB
-	u16 Size;			// Size of this FIB in bytes
-	u16 SenderSize;			// Size of the FIB in the sender (for response sizing)
-	u32 SenderFibAddress;		// Host defined data in the FIB
-	u32 ReceiverFibAddress;		// Logical address of this FIB for the adapter
-	u32 SenderData;			// Place holder for the sender to store data
+	__le32 XferState;	/* Current transfer state for this CCB */
+	__le16 Command;		/* Routing information for the destination */
+	u8 StructType;		/* Type FIB */
+	u8 Flags;		/* Flags for FIB */
+	__le16 Size;		/* Size of this FIB in bytes */
+	__le16 SenderSize;	/* Size of the FIB in the sender 
+				   (for response sizing) */
+	__le32 SenderFibAddress;  /* Host defined data in the FIB */
+	__le32 ReceiverFibAddress;/* Logical address of this FIB for 
+				     the adapter */
+	u32 SenderData;		/* Place holder for the sender to store data */
 	union {
 		struct {
-		    u32 _ReceiverTimeStart; 	// Timestamp for receipt of fib
-		    u32 _ReceiverTimeDone;	// Timestamp for completion of fib
+		    __le32 _ReceiverTimeStart; 	/* Timestamp for 
+						   receipt of fib */
+		    __le32 _ReceiverTimeDone;	/* Timestamp for 
+						   completion of fib */
 		} _s;
 	} _u;
 };
@@ -385,19 +410,20 @@
 
 struct aac_init
 {
-	u32	InitStructRevision;
-	u32	MiniPortRevision;
-	u32	fsrev;
-	u32	CommHeaderAddress;
-	u32	FastIoCommAreaAddress;
-	u32	AdapterFibsPhysicalAddress;
-	u32	AdapterFibsVirtualAddress;
-	u32	AdapterFibsSize;
-	u32	AdapterFibAlign;
-	u32	printfbuf;
-	u32	printfbufsiz;
-	u32	HostPhysMemPages;		// number of 4k pages of host physical memory
-	u32	HostElapsedSeconds;		// number of seconds since 1970.
+	__le32	InitStructRevision;
+	__le32	MiniPortRevision;
+	__le32	fsrev;
+	__le32	CommHeaderAddress;
+	__le32	FastIoCommAreaAddress;
+	__le32	AdapterFibsPhysicalAddress;
+	__le32	AdapterFibsVirtualAddress;
+	__le32	AdapterFibsSize;
+	__le32	AdapterFibAlign;
+	__le32	printfbuf;
+	__le32	printfbufsiz;
+	__le32	HostPhysMemPages;   /* number of 4k pages of host 
+				       physical memory */
+	__le32	HostElapsedSeconds; /* number of seconds since 1970. */
 };
 
 enum aac_log_level {
@@ -763,27 +789,27 @@
  
 struct aac_adapter_info
 {
-	u32	platform;
-	u32	cpu;
-	u32	subcpu;
-	u32	clock;
-	u32	execmem;
-	u32	buffermem;
-	u32	totalmem;
-	u32	kernelrev;
-	u32	kernelbuild;
-	u32	monitorrev;
-	u32	monitorbuild;
-	u32	hwrev;
-	u32	hwbuild;
-	u32	biosrev;
-	u32	biosbuild;
-	u32	cluster;
-	u32	clusterchannelmask; 
-	u32	serial[2];
-	u32	battery;
-	u32	options;
-	u32	OEM;
+	__le32	platform;
+	__le32	cpu;
+	__le32	subcpu;
+	__le32	clock;
+	__le32	execmem;
+	__le32	buffermem;
+	__le32	totalmem;
+	__le32	kernelrev;
+	__le32	kernelbuild;
+	__le32	monitorrev;
+	__le32	monitorbuild;
+	__le32	hwrev;
+	__le32	hwbuild;
+	__le32	biosrev;
+	__le32	biosbuild;
+	__le32	cluster;
+	__le32	clusterchannelmask; 
+	__le32	serial[2];
+	__le32	battery;
+	__le32	options;
+	__le32	OEM;
 };
 
 /*
@@ -1016,83 +1042,102 @@
 
 struct aac_read
 {
-	u32	 	command;
-	u32 		cid;
-	u32 		block;
-	u32 		count;
+	__le32	 	command;
+	__le32 		cid;
+	__le32 		block;
+	__le32 		count;
 	struct sgmap	sg;	// Must be last in struct because it is variable
 };
 
 struct aac_read64
 {
-	u32	 	command;
-	u16 		cid;
-	u16 		sector_count;
-	u32 		block;
-	u16		pad;
-	u16		flags;
+	__le32	 	command;
+	__le16 		cid;
+	__le16 		sector_count;
+	__le32 		block;
+	__le16		pad;
+	__le16		flags;
 	struct sgmap64	sg;	// Must be last in struct because it is variable
 };
 
 struct aac_read_reply
 {
-	u32	 	status;
-	u32 		count;
+	__le32	 	status;
+	__le32 		count;
 };
 
 struct aac_write
 {
-	u32		command;
-	u32 		cid;
-	u32 		block;
-	u32 		count;
-	u32	 	stable;	// Not used
+	__le32		command;
+	__le32 		cid;
+	__le32 		block;
+	__le32 		count;
+	__le32	 	stable;	// Not used
 	struct sgmap	sg;	// Must be last in struct because it is variable
 };
 
 struct aac_write64
 {
-	u32	 	command;
-	u16 		cid;
-	u16 		sector_count;
-	u32 		block;
-	u16		pad;
-	u16		flags;
+	__le32	 	command;
+	__le16 		cid;
+	__le16 		sector_count;
+	__le32 		block;
+	__le16		pad;
+	__le16		flags;
 	struct sgmap64	sg;	// Must be last in struct because it is variable
 };
 struct aac_write_reply
 {
-	u32		status;
-	u32 		count;
-	u32		committed;
+	__le32		status;
+	__le32 		count;
+	__le32		committed;
 };
 
 #define CT_FLUSH_CACHE 129
 struct aac_synchronize {
-	u32		command;	/* VM_ContainerConfig */
-	u32		type;		/* CT_FLUSH_CACHE */
-	u32		cid;
-	u32		parm1;
-	u32		parm2;
-	u32		parm3;
-	u32		parm4;
-	u32		count;	/* sizeof(((struct aac_synchronize_reply *)NULL)->data) */
+	__le32		command;	/* VM_ContainerConfig */
+	__le32		type;		/* CT_FLUSH_CACHE */
+	__le32		cid;
+	__le32		parm1;
+	__le32		parm2;
+	__le32		parm3;
+	__le32		parm4;
+	__le32		count;	/* sizeof(((struct aac_synchronize_reply *)NULL)->data) */
 };
 
 struct aac_synchronize_reply {
-	u32		dummy0;
-	u32		dummy1;
-	u32		status;	/* CT_OK */
-	u32		parm1;
-	u32		parm2;
-	u32		parm3;
-	u32		parm4;
-	u32		parm5;
+	__le32		dummy0;
+	__le32		dummy1;
+	__le32		status;	/* CT_OK */
+	__le32		parm1;
+	__le32		parm2;
+	__le32		parm3;
+	__le32		parm4;
+	__le32		parm5;
 	u8		data[16];
 };
 
 struct aac_srb
 {
+	__le32		function;
+	__le32		channel;
+	__le32		id;
+	__le32		lun;
+	__le32		timeout;
+	__le32		flags;
+	__le32		count;		// Data xfer size
+	__le32		retry_limit;
+	__le32		cdb_size;
+	u8		cdb[16];
+	struct	sgmap	sg;
+};
+
+/*
+ * This and assocated data structs are used by the 
+ * ioctl caller and are in cpu order.
+ */
+struct user_aac_srb
+{
 	u32		function;
 	u32		channel;
 	u32		id;
@@ -1103,20 +1148,18 @@
 	u32		retry_limit;
 	u32		cdb_size;
 	u8		cdb[16];
-	struct	sgmap	sg;
+	struct	user_sgmap	sg;
 };
 
-
-
 #define		AAC_SENSE_BUFFERSIZE	 30
 
 struct aac_srb_reply
 {
-	u32		status;
-	u32		srb_status;
-	u32		scsi_status;
-	u32		data_xfer_length;
-	u32		sense_data_size;
+	__le32		status;
+	__le32		srb_status;
+	__le32		scsi_status;
+	__le32		data_xfer_length;
+	__le32		sense_data_size;
 	u8		sense_data[AAC_SENSE_BUFFERSIZE]; // Can this be SCSI_SENSE_BUFFERSIZE
 };
 /*
@@ -1223,14 +1266,14 @@
  */
 
 struct aac_fsinfo {
-	u32  fsTotalSize;	/* Consumed by fs, incl. metadata */
-	u32  fsBlockSize;
-	u32  fsFragSize;
-	u32  fsMaxExtendSize;
-	u32  fsSpaceUnits;
-	u32  fsMaxNumFiles;
-	u32  fsNumFreeFiles;
-	u32  fsInodeDensity;
+	__le32  fsTotalSize;	/* Consumed by fs, incl. metadata */
+	__le32  fsBlockSize;
+	__le32  fsFragSize;
+	__le32  fsMaxExtendSize;
+	__le32  fsSpaceUnits;
+	__le32  fsMaxNumFiles;
+	__le32  fsNumFreeFiles;
+	__le32  fsInodeDensity;
 };	/* valid iff ObjType == FT_FILESYS && !(ContentState & FSCS_NOTCLEAN) */
 
 union aac_contentinfo {
@@ -1243,32 +1286,32 @@
 
 #define CT_GET_CONFIG_STATUS 147
 struct aac_get_config_status {
-	u32		command;	/* VM_ContainerConfig */
-	u32		type;		/* CT_GET_CONFIG_STATUS */
-	u32		parm1;
-	u32		parm2;
-	u32		parm3;
-	u32		parm4;
-	u32		parm5;
-	u32		count;	/* sizeof(((struct aac_get_config_status_resp *)NULL)->data) */
+	__le32		command;	/* VM_ContainerConfig */
+	__le32		type;		/* CT_GET_CONFIG_STATUS */
+	__le32		parm1;
+	__le32		parm2;
+	__le32		parm3;
+	__le32		parm4;
+	__le32		parm5;
+	__le32		count;	/* sizeof(((struct aac_get_config_status_resp *)NULL)->data) */
 };
 
 #define CFACT_CONTINUE 0
 #define CFACT_PAUSE    1
 #define CFACT_ABORT    2
 struct aac_get_config_status_resp {
-	u32		response; /* ST_OK */
-	u32		dummy0;
-	u32		status;	/* CT_OK */
-	u32		parm1;
-	u32		parm2;
-	u32		parm3;
-	u32		parm4;
-	u32		parm5;
+	__le32		response; /* ST_OK */
+	__le32		dummy0;
+	__le32		status;	/* CT_OK */
+	__le32		parm1;
+	__le32		parm2;
+	__le32		parm3;
+	__le32		parm4;
+	__le32		parm5;
 	struct {
-		u32	action; /* CFACT_CONTINUE, CFACT_PAUSE or CFACT_ABORT */
-		u16	flags;
-		s16	count;
+		__le32	action; /* CFACT_CONTINUE, CFACT_PAUSE or CFACT_ABORT */
+		__le16	flags;
+		__le16	count;
 	}		data;
 };
 
@@ -1279,8 +1322,8 @@
 #define CT_COMMIT_CONFIG 152
 
 struct aac_commit_config {
-	u32		command;	/* VM_ContainerConfig */
-	u32		type;		/* CT_COMMIT_CONFIG */
+	__le32		command;	/* VM_ContainerConfig */
+	__le32		type;		/* CT_COMMIT_CONFIG */
 };
 
 /*
@@ -1289,16 +1332,16 @@
 
 #define CT_GET_CONTAINER_COUNT 4
 struct aac_get_container_count {
-	u32		command;	/* VM_ContainerConfig */
-	u32		type;		/* CT_GET_CONTAINER_COUNT */
+	__le32		command;	/* VM_ContainerConfig */
+	__le32		type;		/* CT_GET_CONTAINER_COUNT */
 };
 
 struct aac_get_container_count_resp {
-	u32		response; /* ST_OK */
-	u32		dummy0;
-	u32		MaxContainers;
-	u32		ContainerSwitchEntries;
-	u32		MaxPartitions;
+	__le32		response; /* ST_OK */
+	__le32		dummy0;
+	__le32		MaxContainers;
+	__le32		ContainerSwitchEntries;
+	__le32		MaxPartitions;
 };
 
 
@@ -1308,15 +1351,19 @@
  */
 
 struct aac_mntent {
-	u32    			oid;
-	u8			name[16];	// if applicable
-	struct creation_info	create_info;	// if applicable
-	u32			capacity;
-	u32			vol;    	// substrate structure
-	u32			obj;	        // FT_FILESYS, FT_DATABASE, etc.
-	u32			state;		// unready for mounting, readonly, etc.
-	union aac_contentinfo	fileinfo;	// Info specific to content manager (eg, filesystem)
-	u32			altoid;		// != oid <==> snapshot or broken mirror exists
+	__le32    		oid;
+	u8			name[16];	/* if applicable */
+	struct creation_info	create_info;	/* if applicable */
+	__le32			capacity;
+	__le32			vol;    	/* substrate structure */
+	__le32			obj;	        /* FT_FILESYS, 
+						   FT_DATABASE, etc. */
+	__le32			state;		/* unready for mounting, 
+						   readonly, etc. */
+	union aac_contentinfo	fileinfo;	/* Info specific to content 
+						   manager (eg, filesystem) */
+	__le32			altoid;		/* != oid <==> snapshot or 
+						   broken mirror exists */
 };
 
 #define FSCS_NOTCLEAN	0x0001  /* fsck is neccessary before mounting */
@@ -1324,40 +1371,40 @@
 #define FSCS_HIDDEN	0x0004	/* should be ignored - set during a clear */
 
 struct aac_query_mount {
-	u32		command;
-	u32		type;
-	u32		count;
+	__le32		command;
+	__le32		type;
+	__le32		count;
 };
 
 struct aac_mount {
-	u32		status;
-	u32	   	type;           /* should be same as that requested */
-	u32		count;
+	__le32		status;
+	__le32	   	type;           /* should be same as that requested */
+	__le32		count;
 	struct aac_mntent mnt[1];
 };
 
 #define CT_READ_NAME 130
 struct aac_get_name {
-	u32		command;	/* VM_ContainerConfig */
-	u32		type;		/* CT_READ_NAME */
-	u32		cid;
-	u32		parm1;
-	u32		parm2;
-	u32		parm3;
-	u32		parm4;
-	u32		count;	/* sizeof(((struct aac_get_name_resp *)NULL)->data) */
+	__le32		command;	/* VM_ContainerConfig */
+	__le32		type;		/* CT_READ_NAME */
+	__le32		cid;
+	__le32		parm1;
+	__le32		parm2;
+	__le32		parm3;
+	__le32		parm4;
+	__le32		count;	/* sizeof(((struct aac_get_name_resp *)NULL)->data) */
 };
 
 #define CT_OK        218
 struct aac_get_name_resp {
-	u32		dummy0;
-	u32		dummy1;
-	u32		status;	/* CT_OK */
-	u32		parm1;
-	u32		parm2;
-	u32		parm3;
-	u32		parm4;
-	u32		parm5;
+	__le32		dummy0;
+	__le32		dummy1;
+	__le32		status;	/* CT_OK */
+	__le32		parm1;
+	__le32		parm2;
+	__le32		parm3;
+	__le32		parm4;
+	__le32		parm5;
 	u8		data[16];
 };
 
@@ -1366,8 +1413,8 @@
  */
 
 struct aac_close {
-	u32	command;
-	u32	cid;
+	__le32	command;
+	__le32	cid;
 };
 
 struct aac_query_disk
@@ -1573,8 +1620,8 @@
  */
 
 struct aac_aifcmd {
-	u32 command;		/* Tell host what type of notify this is */
-	u32 seqnum;		/* To allow ordering of reports (if necessary) */
+	__le32 command;		/* Tell host what type of notify this is */
+	__le32 seqnum;		/* To allow ordering of reports (if necessary) */
 	u8 data[1];		/* Undefined length (from kernel viewpoint) */
 };
 
===== drivers/scsi/aacraid/commctrl.c 1.10 vs edited =====
--- 1.10/drivers/scsi/aacraid/commctrl.c	2005-03-30 09:43:23 -08:00
+++ edited/drivers/scsi/aacraid/commctrl.c	2005-04-11 09:34:45 -07:00
@@ -86,7 +86,7 @@
 		return -EFAULT;
 	}
 
-	if (kfib->header.Command == cpu_to_le32(TakeABreakPt)) {
+	if (kfib->header.Command == cpu_to_le16(TakeABreakPt)) {
 		aac_adapter_interrupt(dev);
 		/*
 		 * Since we didn't really send a fib, zero out the state to allow 
@@ -94,7 +94,7 @@
 		 */
 		kfib->header.XferState = 0;
 	} else {
-		int retval = fib_send(kfib->header.Command, fibptr,
+		int retval = fib_send(le16_to_cpu(kfib->header.Command), fibptr,
 				le16_to_cpu(kfib->header.Size) , FsaNormal,
 				1, 1, NULL, NULL);
 		if (retval) {
@@ -114,7 +114,7 @@
 	 *	was already included by the adapter.)
 	 */
 
-	if (copy_to_user(arg, (void *)kfib, kfib->header.Size)) {
+	if (copy_to_user(arg, (void *)kfib, le16_to_cpu(kfib->header.Size))) {
 		fib_free(fibptr);
 		return -EFAULT;
 	}
@@ -391,8 +391,8 @@
 	struct revision response;
 
 	response.compat = 1;
-	response.version = dev->adapter_info.kernelrev;
-	response.build = dev->adapter_info.kernelbuild;
+	response.version = le32_to_cpu(dev->adapter_info.kernelrev);
+	response.build = le32_to_cpu(dev->adapter_info.kernelbuild);
 
 	if (copy_to_user(arg, &response, sizeof(response)))
 		return -EFAULT;
@@ -405,12 +405,13 @@
  *
  */
 
-int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
+static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 {
 	struct fib* srbfib;
 	int status;
 	struct aac_srb *srbcmd;
-	struct aac_srb __user *user_srb = arg;
+	struct user_aac_srb *user_srbcmd = NULL;
+	struct user_aac_srb __user *user_srb = arg;
 	struct aac_srb_reply __user *user_reply;
 	struct aac_srb_reply* reply;
 	u32 fibsize = 0;
@@ -450,7 +451,8 @@
 		goto cleanup;
 	}
 
-	if(copy_from_user(srbcmd, user_srb,fibsize)){
+	user_srbcmd = kmalloc(GFP_KERNEL, fibsize);
+	if(copy_from_user(user_srbcmd, user_srb,fibsize)){
 		printk(KERN_DEBUG"aacraid: Could not copy srb from user\n"); 
 		rcode = -EFAULT;
 		goto cleanup;
@@ -458,18 +460,19 @@
 
 	user_reply = arg+fibsize;
 
-	flags = srbcmd->flags;
+	flags = user_srbcmd->flags; /* from user in cpu order */
 	// Fix up srb for endian and force some values
+
 	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);	// Force this
-	srbcmd->channel  = cpu_to_le32(srbcmd->channel);
-	srbcmd->id	 = cpu_to_le32(srbcmd->id);
-	srbcmd->lun      = cpu_to_le32(srbcmd->lun);
-	srbcmd->flags    = cpu_to_le32(srbcmd->flags);
-	srbcmd->timeout  = cpu_to_le32(srbcmd->timeout);
-	srbcmd->retry_limit =cpu_to_le32(0); // Obsolete parameter
-	srbcmd->cdb_size = cpu_to_le32(srbcmd->cdb_size);
+	srbcmd->channel = cpu_to_le32(user_srbcmd->channel);
+	srbcmd->id = cpu_to_le32(user_srbcmd->id);
+	srbcmd->lun = cpu_to_le32(user_srbcmd->lun);
+	srbcmd->flags = cpu_to_le32(user_srbcmd->flags);
+	srbcmd->timeout = cpu_to_le32(user_srbcmd->timeout);
+	srbcmd->retry_limit = 0; 
+	srbcmd->cdb_size = cpu_to_le32(user_srbcmd->cdb_size);
 	
-	switch (srbcmd->flags & (SRB_DataIn | SRB_DataOut)) {
+	switch (flags & (SRB_DataIn | SRB_DataOut)) {
 	case SRB_DataOut:
 		data_dir = DMA_TO_DEVICE;
 		break;
@@ -483,60 +486,61 @@
 		data_dir = DMA_NONE;
 	}
 	if (dev->dac_support == 1) {
-		struct sgmap64* psg = (struct sgmap64*)&srbcmd->sg;
+		struct user_sgmap64* upsg = (struct user_sgmap64*)&user_srbcmd->sg;
+		struct sgmap64* psg = (struct sgmap64*)&user_srbcmd->sg;
 		byte_count = 0;
 
 		/*
 		 * This should also catch if user used the 32 bit sgmap
 		 */
 		actual_fibsize = sizeof(struct aac_srb) - 
-			sizeof(struct sgentry) + ((srbcmd->sg.count & 0xff) * 
-			 	sizeof(struct sgentry64));
+			sizeof(struct sgentry) + 
+			((user_srbcmd->sg.count & 0xff) * 
+		 	sizeof(struct sgentry64));
 		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
 			printk(KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n");
 			rcode = -EINVAL;
 			goto cleanup;
 		}
-		if ((data_dir == DMA_NONE) && psg->count) { 
+		if ((data_dir == DMA_NONE) && upsg->count) { 
 			printk(KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n");
 			rcode = -EINVAL;
 			goto cleanup;
 		}
 
-		for (i = 0; i < psg->count; i++) {
-			dma_addr_t addr; 
-			u64 le_addr;
+		for (i = 0; i < upsg->count; i++) {
+			u64 addr; 
 			void* p;
-			p = kmalloc(psg->sg[i].count,GFP_KERNEL|__GFP_DMA);
+			p = kmalloc(upsg->sg[i].count, GFP_KERNEL|__GFP_DMA);
 			if(p == 0) {
 				printk(KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
-				psg->sg[i].count,i,psg->count);
+				upsg->sg[i].count,i,upsg->count);
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			sg_user[i] = (void __user *)psg->sg[i].addr;
+			sg_user[i] = (void __user *)upsg->sg[i].addr;
 			sg_list[i] = p; // save so we can clean up later
 			sg_indx = i;
 
 			if( flags & SRB_DataOut ){
-				if(copy_from_user(p,sg_user[i],psg->sg[i].count)){
+				if(copy_from_user(p,sg_user[i],upsg->sg[i].count)){
 					printk(KERN_DEBUG"aacraid: Could not copy sg data from user\n"); 
 					rcode = -EFAULT;
 					goto cleanup;
 				}
 			}
-			addr = pci_map_single(dev->pdev, p, psg->sg[i].count, data_dir);
+			addr = pci_map_single(dev->pdev, p, upsg->sg[i].count, data_dir);
 
-			le_addr = cpu_to_le64(addr);
-			psg->sg[i].addr[1] = (u32)(le_addr>>32);
-			psg->sg[i].addr[0] = (u32)(le_addr & 0xffffffff);
-			psg->sg[i].count = cpu_to_le32(psg->sg[i].count);  
-			byte_count += psg->sg[i].count;
+			psg->sg[i].addr[0] = cpu_to_le32(addr & 0xffffffff);
+			psg->sg[i].addr[1] = cpu_to_le32(addr >> 32);
+			psg->sg[i].count = cpu_to_le32(upsg->sg[i].count);  
+			byte_count += upsg->sg[i].count;
 		}
 
 		srbcmd->count = cpu_to_le32(byte_count);
 		status = fib_send(ScsiPortCommand64, srbfib, actual_fibsize, FsaNormal, 1, 1,NULL,NULL);
 	} else {
+		struct user_sgmap* upsg = &user_srbcmd->sg;
 		struct sgmap* psg = &srbcmd->sg;
 		byte_count = 0;
 
@@ -548,37 +552,39 @@
 			rcode = -EINVAL;
 			goto cleanup;
 		}
-		if ((data_dir == DMA_NONE) && psg->count) {
+		if ((data_dir == DMA_NONE) && upsg->count) {
 			printk(KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n");
 			rcode = -EINVAL;
 			goto cleanup;
 		}
-		for (i = 0; i < psg->count; i++) {
+		for (i = 0; i < upsg->count; i++) {
 			dma_addr_t addr; 
 			void* p;
-			p = kmalloc(psg->sg[i].count,GFP_KERNEL);
+			p = kmalloc(upsg->sg[i].count, GFP_KERNEL);
 			if(p == 0) {
 				printk(KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
-				psg->sg[i].count,i,psg->count);
+				upsg->sg[i].count, i, upsg->count);
 				rcode = -ENOMEM;
 				goto cleanup;
 			}
-			sg_user[i] = (void __user *)(psg->sg[i].addr);
+			sg_user[i] = (void __user *)upsg->sg[i].addr; 
 			sg_list[i] = p; // save so we can clean up later
 			sg_indx = i;
 
 			if( flags & SRB_DataOut ){
-				if(copy_from_user(p,sg_user[i],psg->sg[i].count)){
+				if(copy_from_user(p, sg_user[i], 
+							upsg->sg[i].count)) {
 					printk(KERN_DEBUG"aacraid: Could not copy sg data from user\n"); 
 					rcode = -EFAULT;
 					goto cleanup;
 				}
 			}
-			addr = pci_map_single(dev->pdev, p, psg->sg[i].count, data_dir);
+			addr = pci_map_single(dev->pdev, p, 
+					upsg->sg[i].count, data_dir);
 
 			psg->sg[i].addr = cpu_to_le32(addr);
-			psg->sg[i].count = cpu_to_le32(psg->sg[i].count);  
-			byte_count += psg->sg[i].count;
+			psg->sg[i].count = cpu_to_le32(upsg->sg[i].count);  
+			byte_count += upsg->sg[i].count;
 		}
 		srbcmd->count = cpu_to_le32(byte_count);
 		status = fib_send(ScsiPortCommand, srbfib, actual_fibsize, FsaNormal, 1, 1, NULL, NULL);
@@ -609,6 +615,7 @@
 	}
 
 cleanup:
+	kfree(user_srbcmd);
 	for(i=0; i <= sg_indx; i++){
 		kfree(sg_list[i]);
 	}
@@ -625,7 +632,7 @@
 };
 
 
-int aac_get_pci_info(struct aac_dev* dev, void __user *arg)
+static int aac_get_pci_info(struct aac_dev* dev, void __user *arg)
 {
         struct aac_pci_info pci_info;
 
===== drivers/scsi/aacraid/comminit.c 1.11 vs edited =====
--- 1.11/drivers/scsi/aacraid/comminit.c	2005-03-03 13:01:32 -08:00
+++ edited/drivers/scsi/aacraid/comminit.c	2005-04-11 09:49:11 -07:00
@@ -152,8 +152,8 @@
 	init_waitqueue_head(&q->qfull);
 	spin_lock_init(&q->lockdata);
 	q->lock = &q->lockdata;
-	q->headers.producer = mem;
-	q->headers.consumer = mem+1;
+	q->headers.producer = (__le32 *)mem;
+	q->headers.consumer = (__le32 *)(mem+1);
 	*(q->headers.producer) = cpu_to_le32(qsize);
 	*(q->headers.consumer) = cpu_to_le32(qsize);
 	q->entries = qsize;
@@ -204,7 +204,7 @@
  *		0 - If there were errors initing. This is a fatal error.
  */
  
-int aac_comm_init(struct aac_dev * dev)
+static int aac_comm_init(struct aac_dev * dev)
 {
 	unsigned long hdrsize = (sizeof(u32) * NUMBER_OF_COMM_QUEUES) * 2;
 	unsigned long queuesize = sizeof(struct aac_entry) * TOTAL_QUEUE_ENTRIES;
===== drivers/scsi/aacraid/commsup.c 1.11 vs edited =====
--- 1.11/drivers/scsi/aacraid/commsup.c	2005-03-30 09:45:07 -08:00
+++ edited/drivers/scsi/aacraid/commsup.c	2005-04-11 09:49:32 -07:00
@@ -102,7 +102,7 @@
 		fibptr->next = fibptr+1;	/* Forward chain the fibs */
 		init_MUTEX_LOCKED(&fibptr->event_wait);
 		spin_lock_init(&fibptr->event_lock);
-		hw_fib_va->header.XferState = 0xffffffff;
+		hw_fib_va->header.XferState = cpu_to_le32(0xffffffff);
 		hw_fib_va->header.SenderSize = cpu_to_le16(sizeof(struct hw_fib));
 		fibptr->hw_fib_pa = hw_fib_pa;
 		hw_fib_va = (struct hw_fib *)((unsigned char *)hw_fib_va + sizeof(struct hw_fib));
@@ -658,9 +658,8 @@
 			}
 			if (aac_insert_entry(dev, index, AdapHighRespQueue,  (nointr & (int)aac_config.irq_mod)) != 0) {
 			}
-		}
-		else if (hw_fib->header.XferState & NormalPriority) 
-		{
+		} else if (hw_fib->header.XferState & 
+				cpu_to_le32(NormalPriority)) {
 			u32 index;
 
 			if (size) {
@@ -832,8 +831,8 @@
 			aifcmd = (struct aac_aifcmd *) hw_fib->data;
 			if (aifcmd->command == cpu_to_le32(AifCmdDriverNotify)) {
 				/* Handle Driver Notify Events */
-				*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
-				fib_adapter_complete(fib, sizeof(u32));
+				*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
+				fib_adapter_complete(fib, (u16)sizeof(u32));
 			} else {
 				struct list_head *entry;
 				/* The u32 here is important and intended. We are using
@@ -916,7 +915,7 @@
 				/*
 				 *	Set the status of this FIB
 				 */
-				*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
+				*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
 				fib_adapter_complete(fib, sizeof(u32));
 				spin_unlock_irqrestore(&dev->fib_lock, flagv);
 			}
===== drivers/scsi/aacraid/dpcsup.c 1.6 vs edited =====
--- 1.6/drivers/scsi/aacraid/dpcsup.c	2004-05-10 13:23:18 -07:00
+++ edited/drivers/scsi/aacraid/dpcsup.c	2005-04-11 09:34:45 -07:00
@@ -99,7 +99,7 @@
 			/*
 			 *	Doctor the fib
 			 */
-			*(u32 *)hwfib->data = cpu_to_le32(ST_OK);
+			*(__le32 *)hwfib->data = cpu_to_le32(ST_OK);
 			hwfib->header.XferState |= cpu_to_le32(AdapterProcessed);
 		}
 
@@ -107,7 +107,7 @@
 
 		if (hwfib->header.Command == cpu_to_le16(NuFileSystem))
 		{
-			u32 *pstatus = (u32 *)hwfib->data;
+			__le32 *pstatus = (__le32 *)hwfib->data;
 			if (*pstatus & cpu_to_le32(0xffff0000))
 				*pstatus = cpu_to_le32(ST_OK);
 		}
@@ -205,7 +205,7 @@
 			/*
 			 *	Set the status of this FIB
 			 */
-			*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
+			*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
 			fib_adapter_complete(fib, sizeof(u32));
 			spin_lock_irqsave(q->lock, flags);
 		}		
===== drivers/scsi/aacraid/linit.c 1.47 vs edited =====
--- 1.47/drivers/scsi/aacraid/linit.c	2005-03-10 10:36:35 -08:00
+++ edited/drivers/scsi/aacraid/linit.c	2005-04-13 14:27:01 -07:00
@@ -215,7 +215,7 @@
  *	Returns a static string describing the device in question
  */
 
-const char *aac_info(struct Scsi_Host *shost)
+static const char *aac_info(struct Scsi_Host *shost)
 {
 	struct aac_dev *dev = (struct aac_dev *)shost->hostdata;
 	return aac_drivers[dev->cardtype].name;
@@ -288,7 +288,7 @@
 	 *	translations ( 64/32, 128/32, 255/63 ).
 	 */
 	buf = scsi_bios_ptable(bdev);
-	if(*(unsigned short *)(buf + 0x40) == cpu_to_le16(0xaa55)) {
+	if((*(__le16 *)(buf + 0x40)) == cpu_to_le16(0xaa55)) {
 		struct partition *first = (struct partition * )buf;
 		struct partition *entry = first;
 		int saved_cylinders = param->cylinders;
===== drivers/scsi/aacraid/rkt.c 1.8 vs edited =====
--- 1.8/drivers/scsi/aacraid/rkt.c	2005-03-30 09:46:46 -08:00
+++ edited/drivers/scsi/aacraid/rkt.c	2005-04-11 09:34:45 -07:00
@@ -288,8 +288,8 @@
 	if (status & KERNEL_PANIC) {
 		char * buffer;
 		struct POSTSTATUS {
-			u32 Post_Command;
-			u32 Post_Address;
+			__le32 Post_Command;
+			__le32 Post_Address;
 		} * post;
 		dma_addr_t paddr, baddr;
 		int ret;
===== drivers/scsi/aacraid/rx.c 1.14 vs edited =====
--- 1.14/drivers/scsi/aacraid/rx.c	2005-03-30 09:47:39 -08:00
+++ edited/drivers/scsi/aacraid/rx.c	2005-04-11 09:34:45 -07:00
@@ -63,7 +63,7 @@
 	{
 		bellbits = rx_readl(dev, OutboundDoorbellReg);
 		if (bellbits & DoorBellPrintfReady) {
-			aac_printf(dev, le32_to_cpu(rx_readl (dev, IndexRegs.Mailbox[5])));
+			aac_printf(dev, rx_readl(dev, IndexRegs.Mailbox[5]));
 			rx_writel(dev, MUnit.ODR,DoorBellPrintfReady);
 			rx_writel(dev, InboundDoorbellReg,DoorBellPrintfDone);
 		}
@@ -288,8 +288,8 @@
 	if (status & KERNEL_PANIC) {
 		char * buffer;
 		struct POSTSTATUS {
-			u32 Post_Command;
-			u32 Post_Address;
+			__le32 Post_Command;
+			__le32 Post_Address;
 		} * post;
 		dma_addr_t paddr, baddr;
 		int ret;
===== drivers/scsi/aacraid/sa.c 1.14 vs edited =====
--- 1.14/drivers/scsi/aacraid/sa.c	2005-03-30 09:48:15 -08:00
+++ edited/drivers/scsi/aacraid/sa.c	2005-04-11 09:34:45 -07:00
@@ -89,7 +89,7 @@
  *	Notify the adapter of an event
  */
  
-void aac_sa_notify_adapter(struct aac_dev *dev, u32 event)
+static void aac_sa_notify_adapter(struct aac_dev *dev, u32 event)
 {
 	switch (event) {
 
@@ -230,7 +230,7 @@
 	 *	First clear out all interrupts.  Then enable the one's that 
 	 *	we can handle.
 	 */
-	sa_writew(dev, SaDbCSR.PRISETIRQMASK, cpu_to_le16(0xffff));
+	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
 	sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, (PrintfReady | DOORBELL_1 | DOORBELL_2 | DOORBELL_3 | DOORBELL_4));
 	/* We can only use a 32 bit address here */
 	sa_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa, &ret);


-- 
Mark Haverkamp <markh@osdl.org>

