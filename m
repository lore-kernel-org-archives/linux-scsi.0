From: Andrew Morton <akpm@osdl.org>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Fri, 18 Feb 2005 11:21:38 -0800
Message-ID: <20050218112138.1841c6e6.akpm@osdl.org>
References: <000801c514c7$04ec0030$9300a8c0@erich2003>
	<20050218161021.GA21802@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:24719 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261433AbVBRTWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 14:22:04 -0500
In-Reply-To: <20050218161021.GA21802@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Christoph Hellwig <hch@infradead.org>
Cc: erich@areca.com.tw, James.Bottomley@SteelEye.com, arjan@infradead.org, linux-scsi@vger.kernel.org

Linux Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Feb 17, 2005 at 04:02:25PM +0800, erich wrote:
>  > Hi,Andrew Morton
>  > 
>  > I had clean up "arcmsr" for linux kernel 2.6.10.
>  > May be it looks more cleanly  than old version.
> 
>  Sorry, but I don't see that much of a difference ;-)

All the LINUX_VERSION_CODE tests went away.

>  To get the driver into a shape where we can actually
>  start a review, do run the shell script scripts/Lindent
>  from the kernel tree over the driver,

yup.  three seconds work.

> and please kill
>  all your SHOUTING typedefs for kernel types.

Yes, these:

+typedef int8_t CHAR, *PCHAR;
+typedef int16_t SHORT, *PSHORT;
+typedef int32_t LONG32, *PLONG32;
+typedef int64_t LONG64, *PLONG64;
+typedef uint8_t UCHAR, *PUCHAR;
+typedef uint16_t USHORT, *PUSHORT;
+typedef uint32_t ULONG32, *PULONG32;
+typedef uint64_t ULONG64, *PULONG64;
+typedef Scsi_Device SCSIDEV, *PSCSIDEV;
+typedef Scsi_Cmnd SCSICMD, *PSCSICMD;
+typedef void VOID, *PVOID;
+typedef struct Scsi_Host SH, *PSH;
+typedef struct scatterlist SGL, *PSGL;
+typedef void (*DPCFUN) (void *);
+typedef struct _MU MU, *PMU;
+typedef struct _CCB CCB, *PCCB;
+typedef struct _ACB ACB, *PACB;
+typedef struct _HCBARC HCBARC, *PHCBARC;
+typedef struct _DPC DPC, *PDPC;
+typedef struct _EVENT EVENT, *PEVENT;
+typedef struct _QBUFFER QBUFFER, *PQBUFFER;
+typedef struct _SG32ENTRY SG32ENTRY, *PSG32ENTRY;
+typedef struct _SG64ENTRY SG64ENTRY, *PSG64ENTRY;
+typedef struct _SGENTRY_UNION SGENTRY_UNION, PSGENTRY_UNION;
+typedef struct _SYSTEMTIME SYSTEMTIME, *PSYSTEMTIME;
+typedef struct _TIMERECORD TIMERECORD, *PTIMERECORD;
+typedef struct _SENSE_DATA SENSE_DATA, *PSENSE_DATA;
+typedef struct _ARCMSR_PCIINFO ARCMSR_PCIINFO, *PARCMSR_PCIINFO;
+typedef struct _ARCMSR_CDB ARCMSR_CDB, *PARCMSR_CDB;
+typedef struct _CMD_IO_CONTROL CMD_IO_CONTROL, *PCMD_IO_CONTROL;
+typedef struct _CMD_IOCTL_FIELD CMD_IOCTL_FIELD, *PCMD_IOCTL_FIELD;
+#if defined(__x86_64__)
+typedef uint64_t CPT2INT, *PCPT2INT;
+#else
+typedef uint32_t CPT2INT, *PCPT2INT;
+#endif

should be removed - just open-code the types within the .c code.

