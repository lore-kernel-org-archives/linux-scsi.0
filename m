From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 03/18 ver3] libosd: OSDv1 Headers
Date: Wed, 12 Nov 2008 10:59:45 -0800
Message-ID: <20081112105945.f4ec0089.randy.dunlap@oracle.com>
References: <491073BB.4000900@panasas.com>
	<1225817046-5946-1-git-send-email-bharrosh@panasas.com>
	<4916F934.4090205@panasas.com>
	<20081110092940.57b4c169.randy.dunlap@oracle.com>
	<491AD697.9030305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754119AbYKLTBq@vger.kernel.org>
In-Reply-To: <491AD697.9030305@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, open-osd development <osd-dev@open-osd.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 12 Nov 2008 15:13:59 +0200 Boaz Harrosh wrote:

> 
> Headers only patch.
> 
> osd_protocol.h
> 	Contains a C-fied definition of the T10 OSD standard
> osd_types.h
> 	Contains CPU order common used types
> osd_initiator.h
> 	API definition of the osd_initiator library
> osd_sec.h
> 	Contains High level API for the security manager.
> 
> [Note that checkpatch spews errors on things that are valid in this context
> and will not be fixed]
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Reviewed-by: Benny Halevy <bhalevy@panasas.com>
> ---
>  include/scsi/osd_initiator.h |  332 ++++++++++++++++++++++++++++
>  include/scsi/osd_protocol.h  |  497 ++++++++++++++++++++++++++++++++++++++++++
>  include/scsi/osd_sec.h       |   45 ++++
>  include/scsi/osd_types.h     |   40 ++++
>  4 files changed, 914 insertions(+), 0 deletions(-)
>  create mode 100644 include/scsi/osd_initiator.h
>  create mode 100644 include/scsi/osd_protocol.h
>  create mode 100644 include/scsi/osd_sec.h
>  create mode 100644 include/scsi/osd_types.h

> diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
> new file mode 100644
> index 0000000..ce678c5
> --- /dev/null
> +++ b/include/scsi/osd_protocol.h
> @@ -0,0 +1,497 @@
> +#ifndef __OSD_PROTOCOL_H__
> +#define __OSD_PROTOCOL_H__

...

> +/* osd2r03: 5.2.1 Overview */
> +struct osd_cdb_head {
> +	struct scsi_varlen_cdb_hdr varlen_cdb;
> +/*10*/	u8		options;
> +	u8		command_specific_options;
> +	u8		timestamp_control;
> +/*13*/	u8		reserved1[3];
> +/*16*/	__be64		partition;
> +/*24*/	__be64		object;
> +/*32*/	union { /* V1 vs V2 alignment differences */
> +		struct __osdv1_cdb_addr_len {
> +/*32*/			__be32 		list_identifier;/* Rarely used */
> +/*36*/			__be64		length;
> +/*44*/			__be64		start_address;
> +		} __packed v1;
> +	};
> +/*52*/	union { /* selected attributes mode Page/List/Single */
> +		struct osd_attributes_page_mode {
> +/*52*/			__be32		get_attr_page;
> +/*56*/			__be32		get_attr_alloc_length;
> +/*60*/			osd_cdb_offset	get_attr_offset;
> +
> +/*64*/			__be32		set_attr_page;
> +/*68*/			__be32		set_attr_id;
> +/*72*/			__be32		set_attr_length;
> +/*76*/			osd_cdb_offset	set_attr_offset;
> +		} __packed attrs_page;
> +
> +		struct osd_attributes_list_mode {
> +/*52*/			__be32		get_attr_desc_bytes;
> +/*56*/			osd_cdb_offset	get_attr_desc_offset;
> +
> +/*60*/			__be32		get_attr_alloc_length;
> +/*64*/			osd_cdb_offset	get_attr_offset;
> +
> +/*68*/			__be32		set_attr_bytes;
> +/*72*/			osd_cdb_offset	set_attr_offset;
> +			__be32 not_used;
> +		} __packed attrs_list;
> +
> +		/* osd2r03:5.2.4.2 Set one attribute value using CDB fields */
> +		struct osd_attributes_cdb_mode {
> +/*52*/			__be32		set_attr_page;
> +/*56*/			__be32		set_attr_id;
> +/*60*/			__be16		set_attr_len;
> +/*62*/			u8		set_attr_val[80-62];

ugh

> +		} __packed attrs_cdb;
> +/*52*/		u8 get_set_attributes_parameters[80-52];

ugh

> +	};
> +} __packed;
> +/*80*/


> +/* (osd-r10:4.9.2.2)
> + * osd2r03:4.11.2.2 Capability format
> + */
> +struct osd_capability_head {
> +	u8 format; /* low nibble */
> +	u8 integrity_algorithm__key_version; /* MAKE_BYTE(integ_alg, key_ver) */
> +	u8 security_method;
> +	u8 reserved1;
> +/*04*/	struct osd_timestamp expiration_time;
> +/*10*/	u8 audit[30-10];
> +/*30*/	u8 discriminator[42-30];
> +/*42*/	struct osd_timestamp object_created_time;
> +/*48*/	u8 object_type;
> +	u8 permissions_bit_mask[54-49];

more of the same

> +/*54*/	u8 reserved2;
> +/*55*/	u8 object_descriptor_type; /* high nibble */
> +} __packed;
> +
> +/*56 v1*/
> +struct osdv1_cap_object_descriptor {
> +	union {
> +		struct {
> +/*56*/			__be32 policy_access_tag;
> +/*60*/			__be64 allowed_partition_id;
> +/*68*/			__be64 allowed_object_id;
> +/*76*/			__be32 reserved;
> +		} __packed obj_desc;
> +
> +		u8 object_descriptor[80-56];/*24*/

ditto.  nice comment ;)

> +	};
> +} __packed;
> +/*80 v1*/
> +
> +#endif /* ndef __OSD_PROTOCOL_H__ */


Thanks for the fixes.

---
~Randy
