From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Fri, 27 Jul 2007 02:09:05 +0900
Message-ID: <20070726020657P.tomof@acm.org>
References: <20070726190913A.fujita.tomonori@lab.ntt.co.jp>
	<664A4EBB07F29743873A87CF62C26D708B3A65@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:34117 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762342AbXGZRJX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 13:09:23 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D708B3A65@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Thu, 26 Jul 2007 10:32:45 -0600

> On Thursday, July 26, 2007 4:09 AM, FUJITA Tomonori wrote: 
> > The SMP response's function result wasn't set correctly? bsg's
> > smp_rep_manufacturer didn't check the result so it showed garbase, I
> > guess.
> > 
> > BTW, I took the code to check the result from Doug's smp_utils and put
> > bsg's smp_rep_manufacturer:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/tomo/smp/
> > 
> > or
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/sgv4-tools.git
> 
> Thanks.    with Doug Gilberts help, I have solved the git dilema thru
> firewall.  I need a socks proxy, which I found from
> http://tsocks.sourceforge.net/

Nice.


> > That's the reason why I said before, sense buffer is not used for smp
> > and using sense buffer would be the easiest way to push up the mpt
> > unique response to userspace.
> 
> do you suggest the scsi llds would would need to translate there own
> codes (in my case iocstatus/loginfo/sasstatus) into common sense
> sk/asc/ascq ?

No, I don't.

struct sg_io_v4 {
	__s32 guard;		/* [i] 'Q' to differentiate from v3 */
	__u32 protocol;		/* [i] 0 -> SCSI , .... */
	__u32 subprotocol;	/* [i] 0 -> SCSI command, 1 -> SCSI task
				   management function, .... */

	__u32 request_len;	/* [i] in bytes */
	__u64 request;		/* [i], [*i] {SCSI: cdb} */
	__u32 request_attr;	/* [i] {SCSI: task attribute} */
	__u32 request_tag;	/* [i] {SCSI: task tag (only if flagged)} */
	__u32 request_priority;	/* [i] {SCSI: task priority} */
	__u32 max_response_len;	/* [i] in bytes */
	__u64 response;		/* [i], [*o] {SCSI: (auto)sense data} */

	/* "din_" for data in (from device); "dout_" for data out (to device) */
	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
	__u64 dout_xferp;	/* [i], [*i] */
	__u64 din_xferp;	/* [i], [*o] */

...
	__u32 response_len;	/* [o] bytes of response actually written */


Use-space applications can put four memory addresses in the bsg (sg
v4) interface: request, response, dout_xferp, and din_xferp.

For scsi commands, we use:

request -> pointer to a scsi command (cmdp in sgv3)
response -> pointer to a sense buffer (sbp in sgv3)
dout_xferp -> pointer to out data
din_xferp -> pointer to in data

For smp request/response, we use:

request -> not used
response -> not used
dout_xferp -> pointer to a smp request frame
din_xferp -> pointer to a smp response frame


So we could use response field to send vendor's unique response to
user space.

bsg wrongly assues the response field is used for sense buffer so the
maxium length is SCSI_SENSE_BUFFERSIZE, 96 bytes. I think that it's a
bit small for mpt's unique response. But, I'll fix the length
limitation bug soon.


> > 
> > Here's an updated patch.
> > 
> 
>  The patch looks good.  It can be applied upstream.  I tested on x86_64,
> not big endian (I could try out on a ppc64 when I have time).  Here is
> the output from your latest tool with various expanders I have in my
> lab.
> 
> # ./smp_rep_manufacturer /sys/class/bsg/sas_host2
>   SAS-1.1 format: 0
>   vendor identification: LSI
>   product identification: Virtual SMP Port
>   product revision level:
> 
> # ./smp_rep_manufacturer /sys/class/bsg/expander-3:0
>   SAS-1.1 format: 1
>   vendor identification: LSILOGIC
>   product identification: x36-00.00.06.00
>   product revision level: 0000
>   component vendor identification: LSI
>   component id: 531
> 
> # ./smp_rep_manufacturer /sys/class/bsg/expander-3:1
>   SAS-1.1 format: 1
>   vendor identification: XYRATEX
>   product identification: SAS-01
>   product revision level: 03A
>   component vendor identification: LSI
>   component id: 517
> 
> # ./smp_rep_manufacturer /sys/class/bsg/expander-3:2
>   SAS-1.1 format: 1
>   vendor identification: HP
>   product identification: MSA 50-10D25G1
>   product revision level:
>   component vendor identification: LSI
>   component id: 512
>   component revision level: 1
> 
> # ./smp_rep_manufacturer /sys/class/bsg/expander-3:3
>   SAS-1.1 format: 0
>   vendor identification: LSILOGIC
>   product identification: SASx12 A.0
>   product revision level:

Looks great. Thanks.
