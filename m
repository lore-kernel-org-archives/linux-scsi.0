From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/18] libosd: OSDv1 Headers
Date: Wed, 05 Nov 2008 14:54:12 +0200
Message-ID: <49119774.10706@panasas.com>
References: <491073BB.4000900@panasas.com>	<1225817046-5946-1-git-send-email-bharrosh@panasas.com> <20081104111037.bcae04e5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:56490 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbYKEMyS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 07:54:18 -0500
In-Reply-To: <20081104111037.bcae04e5.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sami.Iren@seagate.com, pw@padd.com

Andrew Morton wrote:
> On Tue,  4 Nov 2008 18:44:06 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
>=20
>> Headers only patch.
>>
>> osd_protocol.h
>> 	Contains a C-fied definition of the T10 OSD standard
>> osd_types.h
>> 	Contains CPU order common used types
>> osd_initiator.h
>> 	API definition of the osd_initiator library
>> osd_sec.h
>> 	Contains High level API for the security manager.
>>
>> [Note that checkpatch spews errors on things that are valid in this =
context
>> and will not be fixed]
>>
>> --- /dev/null
>> +++ b/include/scsi/osd_initiator.h
>=20
> This header uses quite a few things without including the header file=
s
> which define them.  That's a bit risky - it causes compile breakage
> across architectures, across config changes and across time.
>=20

It's OK. I'm very pedantic about these things.

The first header included at osd_initiator.c is this header precisely
for the check J=C3=B6rn has suggested. What happens is that all the typ=
es
in osd_initiator.h are actually derived from osd_protocol.h below.
osd_protocol.h does include exactly what it needs. (Also checked)

The only new definitions used by this header are from linux/blkdev.h
hence included here.

(I will re-check that osd_protocol.h is self-sustained)=20

>> @@ -0,0 +1,332 @@
>> +/*
>> + * osd_initiator.h - OSD initiator API definition
>> + *
>> + * Copyright (C) 2008 Panasas Inc.  All rights reserved.
>> + *
>> + * Authors:
>> + *   Boaz Harrosh <bharrosh@panasas.com>
>> + *   Benny Halevy <bhalevy@panasas.com>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License version 2
>> + *
>> + */
>> +#ifndef __OSD_INITIATOR_H__
>> +#define __OSD_INITIATOR_H__
>> +
>> +#include <linux/blkdev.h>
>> +
>> +#include "osd_protocol.h"
>> +#include "osd_types.h"
>> +
>> +/* Note: "NI" in comments below means "Not Implemented yet" */
>> +
>> +/*
>> + * Object-based Storage Device.
>> + * This object represents an OSD device.
>> + * It is not a full linux device in any way. It is only
>> + * a place to hang resources associated with a Linux
>> + * request Q and some default properties.
>> + */
>> +struct osd_dev {
>> +	struct scsi_device *scsi_dev;
>=20
> scsi_device
>=20
>> +	unsigned def_timeout;
>> +};
>> +
>> +void osd_dev_init(struct osd_dev *, struct scsi_device *scsi_dev);
>> +void osd_dev_fini(struct osd_dev *);
>> +
>> +struct osd_request;
>> +typedef void (osd_req_done_fn)(struct osd_request *, void *);
>> +
>> +struct osd_request {
>> +	struct osd_cdb cdb;
>> +	struct osd_data_out_integrity_info out_data_integ;
>> +	struct osd_data_in_integrity_info in_data_integ;
>> +
>> +	struct osd_dev *osd_dev;
>> +	struct request *request;
>> +
>> +	struct _osd_req_data_segment {
>> +		void *buff;
>> +		unsigned alloc_size; /* 0 here means not allocated by us */
>> +		unsigned total_bytes;
>> +	} set_attr, enc_get_attr, get_attr;
>> +
>> +	struct _osd_io_info {
>> +		struct bio *bio;
>> +		u64 total_bytes;
>=20
> u64(!)
>=20

Do you mean that I need to use __u64? or what do you mean?

I will change it. but just for curiosity, I have seen this mentioned
once before, but never understood. What's wrong with the uXX types?
I include linux/types.h and I get them as well as the __uXX set.
Why are we not suppose to use them? And if we are not, then why do
they exist? And also why the u8 is used everywhere but the u{16-64}
are not?

(Please for give me for attacking so strongly I just personally like
 them, style wise. I'm just sad to see them go ;) )

>> +		struct request *req;
>> +		struct _osd_req_data_segment *last_seg;
>> +		u8 *pad_buff;
>> +	} out, in;
>> +
>> +	gfp_t alloc_flags;
>=20
> gfp_t
>=20

I prefer my name. I've seen the gfp_t use in Kernel, but I needed
that name while thinking the code. But now it's OK I'll change it.
=20
>> +	unsigned timeout;
>> +	unsigned retries;
>> +	u8 sense[OSD_MAX_SENSE_LEN];
>> +	enum osd_attributes_mode attributes_mode;
>> +
>> +	osd_req_done_fn *async_done;
>> +	void *async_private;
>> +	int async_error;
>> +};
>=20
> etc, etc, etc.   Please review all that.
>=20

You mean the uXX =3D> __uXX? I'll change all that.

>> +struct osd_request *osd_start_request(struct osd_dev *, gfp_t gfp);
>> +int osd_finalize_request(struct osd_request *or,
>> +	u8 options, const void *cap, const u8 *cap_key);
>> +void osd_req_set_master_seed_xchg(struct osd_request *, ...);/* NI =
*/
>> +void osd_req_set_master_key(struct osd_request *, ...);/* NI */
>> +void osd_req_format(struct osd_request *, u64 tot_capacity);
>> +int osd_req_list_dev_partitions(struct osd_request *,
>> +	osd_id initial_id, struct osd_obj_id_list *list, unsigned nelem);
>=20
> hm.  It appears that someone made the decision to omit the name from
> the `struct osd_request *' parameter in the prototypes and to include
> the argument names for all other arguments.
>=20
> Not a bad idea, really.
>=20

It's a programing style thing. The "this" parameter name is dropped
for been obvious and redundant. I like to keep the Header files
most readable and self-documenting. I know that in C, the style is
to look at .c files for answers, but I borrowed the C++ way of
making it as easy as possible on the user and summarizing all exported
types and services at the header file. Not just for the sake of the com=
piler
but also for the reader.

Note that I put the kernel-doc comments in the header and not in the
source file.

Thank you for your comments
Boaz
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
