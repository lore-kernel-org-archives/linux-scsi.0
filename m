From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [patch 1/8] mptfusion: delete MPTSCSIH_DBG_TIMEOUT
Date: Thu, 18 Nov 2004 16:32:55 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C546777@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C4CDC6.EDEE69A0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:12735 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261451AbUKSQLR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 11:11:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C4CDC6.EDEE69A0
Content-Type: text/plain;
	charset="iso-8859-1"

This removes MPTSCSIH_DBG_TIMEOUT associated 
code in the driver.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>





------_=_NextPart_000_01C4CDC6.EDEE69A0
Content-Type: application/octet-stream;
	name="mptfusion-1.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptfusion-1.patch"

diff -uarN b/drivers/message/fusion/mptbase.h =
a/drivers/message/fusion/mptbase.h=0A=
--- b/drivers/message/fusion/mptbase.h	2004-11-17 16:24:38.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptbase.h	2004-11-18 09:47:28.000000000 =
-0700=0A=
@@ -573,12 +573,6 @@=0A=
 	int			 eventTypes;	/* Event logging parameters */=0A=
 	int			 eventContext;	/* Next event context */=0A=
 	int			 eventLogSize;	/* Max number of cached events */=0A=
-#ifdef MPTSCSIH_DBG_TIMEOUT=0A=
-	int			timeout_hard;=0A=
-	int			timeout_delta;=0A=
-	int			timeout_cnt;=0A=
-	int			timeout_maxcnt;=0A=
-#endif=0A=
 	struct _mpt_ioctl_events *events;	/* pointer to event log */=0A=
 	u8			*cached_fw;	/* Pointer to FW */=0A=
 	dma_addr_t	 	cached_fw_dma;=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-11-17 16:24:38.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-11-18 09:46:54.000000000 =
-0700=0A=
@@ -250,10 +250,6 @@=0A=
 static struct mptscsih_driver_setup=0A=
 	driver_setup =3D MPTSCSIH_DRIVER_SETUP;=0A=
 =0A=
-#ifdef MPTSCSIH_DBG_TIMEOUT=0A=
-static struct scsi_cmnd *foo_to[8];=0A=
-#endif=0A=
-=0A=
 static struct scsi_host_template driver_template;=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -653,27 +649,6 @@=0A=
 	pScsiReq =3D (SCSIIORequest_t *) mf;=0A=
 	pScsiReply =3D (SCSIIOReply_t *) mr;=0A=
 =0A=
-#ifdef MPTSCSIH_DBG_TIMEOUT=0A=
-	if (ioc->timeout_cnt > 0) {=0A=
-		int ii, left =3D 0;=0A=
-=0A=
-		for (ii=3D0; ii < 8; ii++) {=0A=
-			if (sc =3D=3D foo_to[ii]) {=0A=
-				printk(MYIOC_s_INFO_FMT "complete (%p, %ld)\n",=0A=
-					ioc->name, sc, jiffies);=0A=
-				foo_to[ii] =3D NULL;=0A=
-			}=0A=
-			if (foo_to[ii] !=3D NULL)=0A=
-				left++;=0A=
-		}=0A=
-=0A=
-		if (left =3D=3D 0) {=0A=
-			ioc->timeout_maxcnt =3D 0;=0A=
-			ioc->timeout_cnt =3D 0;=0A=
-		}=0A=
-	}=0A=
-#endif=0A=
-=0A=
 	if (pScsiReply =3D=3D NULL) {=0A=
 		/* special context reply handling */=0A=
 		;=0A=
@@ -1259,14 +1234,6 @@=0A=
 	/* Moved Earlier Pam D */=0A=
 	/* ioc->sh =3D sh;	*/=0A=
 =0A=
-#ifdef MPTSCSIH_DBG_TIMEOUT=0A=
-	ioc->timeout_hard =3D 0;=0A=
-	ioc->timeout_delta =3D 30 * HZ;=0A=
-	ioc->timeout_maxcnt =3D 0;=0A=
-	ioc->timeout_cnt =3D 0;=0A=
-	for (ii=3D0; ii < 8; ii++)=0A=
-		foo_to[ii] =3D NULL;=0A=
-#endif=0A=
 	if (hd->is_spi) {=0A=
 		/* Update with the driver setup=0A=
 		 * values.=0A=
@@ -1676,129 +1643,6 @@=0A=
 	return ((info.pos > info.offset) ? info.pos - info.offset : 0);=0A=
 }=0A=
 =0A=
-#ifndef MPTSCSIH_DBG_TIMEOUT=0A=
-static int mptscsih_user_command(MPT_ADAPTER *ioc, char *pbuf, int =
len)=0A=
-{=0A=
-	/* Not yet implemented */=0A=
-	return len;=0A=
-}=0A=
-#else=0A=
-#define is_digit(c)	((c) >=3D '0' && (c) <=3D '9')=0A=
-#define digit_to_bin(c)	((c) - '0')=0A=
-#define is_space(c)	((c) =3D=3D ' ' || (c) =3D=3D '\t')=0A=
-=0A=
-#define UC_DBG_TIMEOUT		0x01=0A=
-#define UC_DBG_HARDRESET	0x02=0A=
-=0A=
-static int skip_spaces(char *ptr, int len)=0A=
-{=0A=
-	int cnt, c;=0A=
-=0A=
-	for (cnt =3D len; cnt > 0 && (c =3D *ptr++) && is_space(c); cnt =
--);=0A=
-=0A=
-	return (len - cnt);=0A=
-}=0A=
-=0A=
-static int get_int_arg(char *ptr, int len, ulong *pv)=0A=
-{=0A=
-	int cnt, c;=0A=
-	ulong	v;=0A=
-	for (v =3D  0, cnt =3D len; cnt > 0 && (c=3D*ptr++) && is_digit(c); =
cnt --) {=0A=
-		v =3D (v * 10) + digit_to_bin(c);=0A=
-	}=0A=
-=0A=
-	if (pv)=0A=
-		*pv =3D v;=0A=
-=0A=
-	return (len - cnt);=0A=
-}=0A=
-=0A=
-=0A=
-static int is_keyword(char *ptr, int len, char *verb)=0A=
-{=0A=
-	int verb_len =3D strlen(verb);=0A=
-=0A=
-	if (len >=3D strlen(verb) && !memcmp(verb, ptr, verb_len))=0A=
-		return verb_len;=0A=
-	else=0A=
-		return 0;=0A=
-}=0A=
-=0A=
-#define SKIP_SPACES(min_spaces)						\=0A=
-	if ((arg_len =3D skip_spaces(ptr,len)) < (min_spaces))		\=0A=
-		return -EINVAL;						\=0A=
-	ptr +=3D arg_len;							\=0A=
-	len -=3D arg_len;=0A=
-=0A=
-#define GET_INT_ARG(v)							\=0A=
-	if (!(arg_len =3D get_int_arg(ptr,len, &(v))))			\=0A=
-		return -EINVAL;						\=0A=
-	ptr +=3D arg_len;							\=0A=
-	len -=3D arg_len;=0A=
-=0A=
-static int mptscsih_user_command(MPT_ADAPTER *ioc, char *buffer, int =
length)=0A=
-{=0A=
-	char *ptr =3D buffer;=0A=
-	char btmp[24];	/* REMOVE */=0A=
-	int arg_len;=0A=
-	int len	=3D length;=0A=
-	int cmd;=0A=
-	ulong number =3D 1;=0A=
-	ulong delta =3D 10;=0A=
-=0A=
-	if ((len > 0) && (ptr[len -1] =3D=3D '\n'))=0A=
-		--len;=0A=
-=0A=
-	if (len < 22) {=0A=
-		strncpy(btmp, buffer, len);=0A=
-		btmp[len+1]=3D'\0';=0A=
-	} else {=0A=
-		strncpy(btmp, buffer, 22);=0A=
-		btmp[23]=3D'\0';=0A=
-	}=0A=
-	printk("user_command:  ioc %d, buffer %s, length %d\n",=0A=
-			ioc->id, btmp, length);=0A=
-=0A=
-	if ((arg_len =3D is_keyword(ptr, len, "timeout")) !=3D 0)=0A=
-		cmd =3D UC_DBG_TIMEOUT;=0A=
-	else if ((arg_len =3D is_keyword(ptr, len, "hardreset")) !=3D 0)=0A=
-		cmd =3D UC_DBG_HARDRESET;=0A=
-	else=0A=
-		return -EINVAL;=0A=
-=0A=
-	ptr +=3D arg_len;=0A=
-	len -=3D arg_len;=0A=
-=0A=
-	switch(cmd) {=0A=
-		case UC_DBG_TIMEOUT:=0A=
-			SKIP_SPACES(1);=0A=
-			GET_INT_ARG(number);=0A=
-			SKIP_SPACES(1);=0A=
-			GET_INT_ARG(delta);=0A=
-			break;=0A=
-	}=0A=
-=0A=
-	printk("user_command: cnt=3D%ld delta=3D%ld\n", number, delta);=0A=
-=0A=
-	if (len)=0A=
-		return -EINVAL;=0A=
-	else {=0A=
-		if (cmd =3D=3D UC_DBG_HARDRESET) {=0A=
-			ioc->timeout_hard =3D 1;=0A=
-		} else if (cmd =3D=3D UC_DBG_TIMEOUT) {=0A=
-			/* process this command ...=0A=
-			 */=0A=
-			ioc->timeout_maxcnt =3D 0;=0A=
-			ioc->timeout_delta =3D delta < 2 ? 2 : delta;=0A=
-			ioc->timeout_cnt =3D 0;=0A=
-			ioc->timeout_maxcnt =3D number < 8 ? number: 8;=0A=
-		}=0A=
-	}=0A=
-	/* Not yet implemented */=0A=
-	return length;=0A=
-}=0A=
-#endif=0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /**=0A=
  *	mptscsih_proc_info - Return information about MPT adapter=0A=
@@ -1812,7 +1656,7 @@=0A=
  * 	hostno: scsi host number=0A=
  *	func:   if write =3D 1; if read =3D 0=0A=
  */=0A=
-static int =0A=
+static int=0A=
 mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, =
off_t offset,=0A=
 			int length, int func)=0A=
 {=0A=
@@ -1821,7 +1665,9 @@=0A=
 	int size =3D 0;=0A=
 =0A=
 	if (func) {=0A=
-		size =3D mptscsih_user_command(ioc, buffer, length);=0A=
+		/* =0A=
+		 * write is not supported =0A=
+		 */=0A=
 	} else {=0A=
 		if (start)=0A=
 			*start =3D buffer;=0A=
@@ -1832,7 +1678,6 @@=0A=
 	return size;=0A=
 }=0A=
 =0A=
-=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 #define ADD_INDEX_LOG(req_ent)	do { } while(0)=0A=
 =0A=
@@ -2022,18 +1867,6 @@=0A=
 			}=0A=
 		}=0A=
 =0A=
-#ifdef MPTSCSIH_DBG_TIMEOUT=0A=
-		if (hd->ioc->timeout_cnt < hd->ioc->timeout_maxcnt) {=0A=
-			foo_to[hd->ioc->timeout_cnt] =3D SCpnt;=0A=
-			hd->ioc->timeout_cnt++;=0A=
-			//mod_timer(&SCpnt->eh_timeout, jiffies + =
hd->ioc->timeout_delta);=0A=
-			issueCmd =3D 0;=0A=
-			printk(MYIOC_s_WARN_FMT=0A=
-				"to pendingQ: (sc=3D%p, mf=3D%p, time=3D%ld)\n",=0A=
-				hd->ioc->name, SCpnt, mf, jiffies);=0A=
-		}=0A=
-#endif=0A=
-=0A=
 		if (issueCmd) {=0A=
 			mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);=0A=
 			dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=3D%p =
idx=3D%d\n",=0A=
@@ -2216,11 +2049,6 @@=0A=
 		}=0A=
 	}=0A=
 =0A=
-#ifdef MPTSCSIH_DBG_TIMEOUT=0A=
-	if (hd->ioc->timeout_hard)=0A=
-		rc =3D 1;=0A=
-#endif=0A=
-=0A=
 	/* Only fall through to the HRH if this is a bus reset=0A=
 	 */=0A=
 	if ((type =3D=3D MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS) && (rc ||=0A=
@@ -3125,10 +2953,6 @@=0A=
 			mpt_free_msg_frame(ioc, hd->tmPtr);=0A=
 		}=0A=
 =0A=
-#ifdef MPTSCSIH_DBG_TIMEOUT=0A=
-		ioc->timeout_hard =3D 0;=0A=
-#endif=0A=
-=0A=
 		dtmprintk((MYIOC_s_WARN_FMT "Pre-Reset complete.\n", ioc->name));=0A=
 =0A=
 	} else {=0A=

------_=_NextPart_000_01C4CDC6.EDEE69A0--
