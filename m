From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [Q] In sg_io_v4 what to use as flag for "queue at_head"
Date: Mon, 19 Jan 2009 13:18:47 +0200
Message-ID: <49746197.200@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:27219 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZASLSx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2009 06:18:53 -0500
Received: by ug-out-1314.google.com with SMTP id 39so187454ugf.37
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2009 03:18:51 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Douglas Gilbert <dougg@torque.net> wrote ...
> struct sg_io_v4 {
> 	__s32 guard;		/* [i] 'Q' to differentiate from v3 */
> 	__u32 protocol;		/* [i] 0 -> SCSI , .... */
> 	__u32 subprotocol;	/* [i] 0 -> SCSI command, 1 -> SCSI task
> 				   management function, .... */
> 
> 	__u32 request_len;	/* [i] in bytes */
> 	__u64 request;		/* [i], [*i] {SCSI: cdb} */
> 	__u64 request_tag;	/* [i] {SCSI: task tag (only if flagged)} */
> 	__u32 request_attr;	/* [i] {SCSI: task attribute} */
> 	__u32 request_priority;	/* [i] {SCSI: task priority} */
> 	__u32 request_extra;	/* [i] {spare, for padding} */
> 	__u32 max_response_len;	/* [i] in bytes */
> 	__u64 response;		/* [i], [*o] {SCSI: (auto)sense data} */
> 
>         /* "dout_": data out (to device); "din_": data in (from device) */
> 	__u32 dout_iovec_count;	/* [i] 0 -> "flat" dout transfer else
> 				   dout_xfer points to array of iovec */
> 	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
> 	__u32 din_iovec_count;	/* [i] 0 -> "flat" din transfer */
> 	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
> 	__u64 dout_xferp;	/* [i], [*i] */
> 	__u64 din_xferp;	/* [i], [*o] */
> 
> 	__u32 timeout;		/* [i] units: millisecond */
> 	__u32 flags;		/* [i] bit mask */
> 	__u64 usr_ptr;		/* [i->o] unused internally */
> 	__u32 spare_in;		/* [i] */
>       ...

Currently because of a twisted accident sg and bsg queue their async
request with the "at_head" flag set when calling blk_execute_rq_nowait.

Since sg_io_v4 is new and as plenty of possible choices, what would be
the best place to put the "at_head" flag?

Douglas ?
What was your intention with the above:
 	__u32 request_priority;	/* [i] {SCSI: task priority} */

[And while at it, what was:
 	__u32 request_attr;	/* [i] {SCSI: task attribute} */
]

Should I define (bsg.h):
enum {
	BSG_AT_HEAD = 0, /* compatible with old code */
	BSG_AT_TAIL,
}
And put it in request_priority

or define:
#define SG_FLAG_AT_TAIL 0x10  /* See sg.h for more/other flags (sg.h flags are ignored by bsg) */

And OR that into the old flags member that is otherwise
unused by current bsg code

Thanks
Boaz


