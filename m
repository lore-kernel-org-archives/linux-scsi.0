From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 1/4] [SCSI]stex: fix id mapping issue
Date: Mon, 2 Apr 2007 10:46:17 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F0327EBB2@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:49097 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752900AbXDBRoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 13:44:46 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org] 
> Sent: Saturday, March 31, 2007 2:27 AM
> To: Ed Lin
> Cc: linux-scsi; linux-kernel; james.Bottomley; jeff; Promise_Linux
> Subject: Re: [PATCH 1/4] [SCSI]stex: fix id mapping issue
> 
> 
> On Fri, Mar 30, 2007 at 03:21:33PM -0700, Ed Lin wrote:
> > +	if (hba->cardtype == st_shasta) {
> >  		req->lun = lun;
> >  		req->target = id;
> > +	} else if (hba->cardtype == st_yosemite){
> > +		req->lun = id * ST_MAX_LUN_PER_TARGET + lun;
> > +		req->target = 0;
> > +	} else {
> > +		/* st_vsc and st_vsc1 */
> > +		req->lun = 0;
> > +		req->target = id * ST_MAX_LUN_PER_TARGET + lun;
> 
> I don't get why you can't export id as targer and lun as lun for
> the !st_shasta types.  Could you explain in detail what the problem
> with that approach would be?
> 
>

Of course I can do that. That will result in 1 target and 128 lun
for st_yosemite and 128 target and 1 lun for st_vsc. That seems
a little weird and I am afraid it will be turned down. Also
I can keep a same mapping for the console in the original code.

If you think it's ok, that's really better, because it makes the
hot path a bit faster. Also because of the CONFIG_SCSI_MULTI_LUN
option, I have to map lun to channel otherwise many entities
will disappear when that option is not selected. Plus I have to
reserve a slot for the RAID console, so the final mapping may be:

channel:0~7, id:0~16(st_shasta, channel 0,id 16 is reserved for console)
channel:0~127, id:0~1(st_yosemite, channel 0,id 1 is reserved for
console)
channel:0, id:0~128(st_vsc, channel 0,id 128 is reserved for console)

I don't know whether this is acceptable. 
