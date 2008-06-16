From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC] Move FC definitions from zfcp to global header
Date: Mon, 16 Jun 2008 13:14:10 +0200
Message-ID: <20080616111409.GC7228@schmichrtp.de.ibm.com>
References: <20080612130245.GA13761@schmichrtp.de.ibm.com> <20080612152624.GY30405@parisc-linux.org> <485153CF.3010207@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:27926 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYFPLON (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jun 2008 07:14:13 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate7.uk.ibm.com (8.13.8/8.13.8) with ESMTP id m5GBEB0M485728
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 11:14:11 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5GBEBbK2084968
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 12:14:11 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5GBEAtl023449
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 12:14:10 +0100
Content-Disposition: inline
In-Reply-To: <485153CF.3010207@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Thu, Jun 12, 2008 at 07:50:23PM +0300, Boaz Harrosh wrote:
> Matthew Wilcox wrote:
> > On Thu, Jun 12, 2008 at 03:02:46PM +0200, Christof Schmitt wrote:
> >> This was suggested a while ago, now i finally put together a patch
> >> that moves the Fibre Channel protocol definitions from zfcp to a new
> >> global header file. With the global header, the definitions can be
> >> shared across all FC drives.
> > 
> > I think this is a great step forward, thank you for doing it.
> > 
> >> +struct ct_hdr {
> >> +	u8 revision;
> >> +	u8 in_id[3];
> >> +	u8 gs_type;
> >> +	u8 gs_subtype;
> >> +	u8 options;
> >> +	u8 reserved0;
> >> +	u16 cmd_rsp_code;
> >> +	u16 max_res_size;
> >> +	u8 reserved1;
> >> +	u8 reason_code;
> >> +	u8 reason_code_expl;
> >> +	u8 vendor_unique;
> >> +} __attribute__ ((packed));
> > 
> > I question the need for packed.  Looking at <scsi/scsi.h>, none of the
> > structures there are packed.  Everything is naturally aligned and
> > explicitly padded ('reserved1', etc).  Also, those structs use __be16
> > instead of u16 to allow sparse to check the correct endian conversion
> > functions are used.
> > 
> 
> It's best to use the "__packed" macro which might be defined differently 
> for some tool-chains.
> 
> And it is best to *do* keep the __packed. At above example the biggest type
> is be16 so for >=32 bit arches it's packed the same, by all gcc versions. But
> if you start having bigger-then-natural types in a structure then different
> size arches will pack things differently. I have been bitten by this, even 
> though I kept everything well defined.
> 
> Also I like the __packed as a warning to fellow programmers that this is
> something on-the-wired defined.
> 
> And yes please use __be16 this is SCSI.

To use the above example, i this would be changed to:

struct ct_hdr {
	u8 revision;
	u8 in_id[3];
	u8 gs_type;
	u8 gs_subtype;
	u8 options;
	u8 reserved0;
	__be16 cmd_rsp_code;
	__be16 max_res_size;
	u8 reserved1;
	u8 reason_code;
	u8 reason_code_expl;
	u8 vendor_unique;
} __packed;

> > (same comment applies to other structs in the file)
> > 
> >> +struct fcp_cmnd_iu {
> >> +	u64 fcp_lun;
> > 
> > Should be a struct scsi_lun?

It is used in the same way, i will change it to struct scsi_lun.

> > This isn't right; the endianness has you confused.
> > 
> > +#elif defined(__LITTLE_ENDIAN_BITFIELD)
> > +	u8  task_attribute:3;
> > +	u8  reserved0:5;
> > +	u8  task_management_flags;
> > +	u8  wddata:1;
> > +	u8  rddata:1;
> > +	u8  add_fcp_cdb_length:6;
> > +#endif
> > 
> 
> Yes, that GCC bug on some ARCHES, rrrr. 
> Matthew is right the T10 standard always define the exact 
> byte-order which does not change. best just define:
> 
> 	u8  task_attribute;
> 	u8  task_management_flags;
> 	u8  wd_rd_add_fcp_cdb_length;
> 
> and use things like:
> enum {
> 	task_attribute_mask = 0xc0,
> 	task_attribute_shift = 5,
> 	wd_flag = 0x80,
> 	rd_flag = 0x40,
> 	add_fcp_cdb_length_mask = 0x3F

This would be correct, i think:
	wd_flag = 0x01,
	rd_flag = 0x02,
 	add_fcp_cdb_len_mask = 0xFC,

#define add_fcp_cdb_len_shift 2

> };
> 
> >> +	u8  fcp_cdb[FCP_CDB_LENGTH];
> >> +} __attribute__((packed));
> > 
> > I also wonder if we shouldn't define the fields that are in FCP-3.
> > 
> > I also wonder whether we should define bitfields or whether we should
> > let drivers mask and shift themselves.  That's jejb's call, IMO.
> > 

As i wrote before, i am currently focussing on the definitions used
for zfcp. If others require the FCP-3 fields, they can add them.

For the simple fields, the drivers can set them directly, e.g.
fcp_cmnd_iu.wd_rd_add_fcp_cdb_length |= rd_flag;

For things like the cdb_len, i would like to have a helper like
static inline set_add_fcp_cdb_len(struct fcp_cmnd_iu *fcp_cmnd_iu, u8 len)
{
	fcp_cmnd_iu->wd_rd_add_fcp_cdb_length |= (len << add_fcp_cdb_len_shift);
}

I will wait with the patch rework until we have completed some pending
zfcp cleanup patches, since changing the structs will conflict with
the other patches.

> My $0.017
> Boaz

Thanks for the feedback.

Christof
