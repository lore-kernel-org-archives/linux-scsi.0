From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] Move FC definitions from zfcp to global header
Date: Thu, 12 Jun 2008 19:50:23 +0300
Message-ID: <485153CF.3010207@panasas.com>
References: <20080612130245.GA13761@schmichrtp.de.ibm.com> <20080612152624.GY30405@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13675 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751574AbYFLQwf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2008 12:52:35 -0400
In-Reply-To: <20080612152624.GY30405@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jun 12, 2008 at 03:02:46PM +0200, Christof Schmitt wrote:
>> This was suggested a while ago, now i finally put together a patch
>> that moves the Fibre Channel protocol definitions from zfcp to a new
>> global header file. With the global header, the definitions can be
>> shared across all FC drives.
> 
> I think this is a great step forward, thank you for doing it.
> 
>> +struct ct_hdr {
>> +	u8 revision;
>> +	u8 in_id[3];
>> +	u8 gs_type;
>> +	u8 gs_subtype;
>> +	u8 options;
>> +	u8 reserved0;
>> +	u16 cmd_rsp_code;
>> +	u16 max_res_size;
>> +	u8 reserved1;
>> +	u8 reason_code;
>> +	u8 reason_code_expl;
>> +	u8 vendor_unique;
>> +} __attribute__ ((packed));
> 
> I question the need for packed.  Looking at <scsi/scsi.h>, none of the
> structures there are packed.  Everything is naturally aligned and
> explicitly padded ('reserved1', etc).  Also, those structs use __be16
> instead of u16 to allow sparse to check the correct endian conversion
> functions are used.
> 

It's best to use the "__packed" macro which might be defined differently 
for some tool-chains.

And it is best to *do* keep the __packed. At above example the biggest type
is be16 so for >=32 bit arches it's packed the same, by all gcc versions. But
if you start having bigger-then-natural types in a structure then different
size arches will pack things differently. I have been bitten by this, even 
though I kept everything well defined.

Also I like the __packed as a warning to fellow programmers that this is
something on-the-wired defined.

And yes please use __be16 this is SCSI.

> (same comment applies to other structs in the file)
> 
>> +struct fcp_cmnd_iu {
>> +	u64 fcp_lun;
> 
> Should be a struct scsi_lun?
> 
>> +	u8  crn;
>> +#if defined(__BIG_ENDIAN_BITFIELD)
>> +	u8  reserved0:5;
>> +	u8  task_attribute:3;
>> +	u8  task_management_flags;
>> +	u8  add_fcp_cdb_length:6;
>> +	u8  rddata:1;
>> +	u8  wddata:1;
>> +#elif defined(__LITTLE_ENDIAN_BITFIELD)
>> +	u8  wddata:1;
>> +	u8  rddata:1;
>> +	u8  add_fcp_cdb_length:6;
>> +	u8  task_management_flags;
>> +	u8  task_attribute:3;
>> +	u8  reserved0:5;
>> +#endif
> 
> This isn't right; the endianness has you confused.
> 
> +#elif defined(__LITTLE_ENDIAN_BITFIELD)
> +	u8  task_attribute:3;
> +	u8  reserved0:5;
> +	u8  task_management_flags;
> +	u8  wddata:1;
> +	u8  rddata:1;
> +	u8  add_fcp_cdb_length:6;
> +#endif
> 

Yes, that GCC bug on some ARCHES, rrrr. 
Matthew is right the T10 standard always define the exact 
byte-order which does not change. best just define:

	u8  task_attribute;
	u8  task_management_flags;
	u8  wd_rd_add_fcp_cdb_length;

and use things like:
enum {
	task_attribute_mask = 0xc0,
	task_attribute_shift = 5,
	wd_flag = 0x80,
	rd_flag = 0x40,
	add_fcp_cdb_length_mask = 0x3F
};

>> +	u8  fcp_cdb[FCP_CDB_LENGTH];
>> +} __attribute__((packed));
> 
> I also wonder if we shouldn't define the fields that are in FCP-3.
> 
> I also wonder whether we should define bitfields or whether we should
> let drivers mask and shift themselves.  That's jejb's call, IMO.
> 

My $0.017
Boaz
