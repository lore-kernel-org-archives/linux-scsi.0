From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Move FC definitions from zfcp to global header
Date: Thu, 12 Jun 2008 09:26:24 -0600
Message-ID: <20080612152624.GY30405@parisc-linux.org>
References: <20080612130245.GA13761@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37714 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYFLP0Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2008 11:26:25 -0400
Content-Disposition: inline
In-Reply-To: <20080612130245.GA13761@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 12, 2008 at 03:02:46PM +0200, Christof Schmitt wrote:
> This was suggested a while ago, now i finally put together a patch
> that moves the Fibre Channel protocol definitions from zfcp to a new
> global header file. With the global header, the definitions can be
> shared across all FC drives.

I think this is a great step forward, thank you for doing it.

> +struct ct_hdr {
> +	u8 revision;
> +	u8 in_id[3];
> +	u8 gs_type;
> +	u8 gs_subtype;
> +	u8 options;
> +	u8 reserved0;
> +	u16 cmd_rsp_code;
> +	u16 max_res_size;
> +	u8 reserved1;
> +	u8 reason_code;
> +	u8 reason_code_expl;
> +	u8 vendor_unique;
> +} __attribute__ ((packed));

I question the need for packed.  Looking at <scsi/scsi.h>, none of the
structures there are packed.  Everything is naturally aligned and
explicitly padded ('reserved1', etc).  Also, those structs use __be16
instead of u16 to allow sparse to check the correct endian conversion
functions are used.

(same comment applies to other structs in the file)

> +struct fcp_cmnd_iu {
> +	u64 fcp_lun;

Should be a struct scsi_lun?

> +	u8  crn;
> +#if defined(__BIG_ENDIAN_BITFIELD)
> +	u8  reserved0:5;
> +	u8  task_attribute:3;
> +	u8  task_management_flags;
> +	u8  add_fcp_cdb_length:6;
> +	u8  rddata:1;
> +	u8  wddata:1;
> +#elif defined(__LITTLE_ENDIAN_BITFIELD)
> +	u8  wddata:1;
> +	u8  rddata:1;
> +	u8  add_fcp_cdb_length:6;
> +	u8  task_management_flags;
> +	u8  task_attribute:3;
> +	u8  reserved0:5;
> +#endif

This isn't right; the endianness has you confused.

+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	u8  task_attribute:3;
+	u8  reserved0:5;
+	u8  task_management_flags;
+	u8  wddata:1;
+	u8  rddata:1;
+	u8  add_fcp_cdb_length:6;
+#endif

> +	u8  fcp_cdb[FCP_CDB_LENGTH];
> +} __attribute__((packed));

I also wonder if we shouldn't define the fields that are in FCP-3.

I also wonder whether we should define bitfields or whether we should
let drivers mask and shift themselves.  That's jejb's call, IMO.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
