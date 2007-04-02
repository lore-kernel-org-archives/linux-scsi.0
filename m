From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 1/4] [SCSI]stex: fix id mapping issue
Date: Mon, 2 Apr 2007 10:59:15 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F0327EBB9@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:50967 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752869AbXDBR5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 13:57:37 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Saturday, March 31, 2007 7:22 AM
> To: Ed Lin
> Cc: linux-scsi; linux-kernel; jeff; Promise_Linux
> Subject: Re: [PATCH 1/4] [SCSI]stex: fix id mapping issue
> 
> 
> On Fri, 2007-03-30 at 15:21 -0700, Ed Lin wrote:
> > The internal id/lun mapping of st_vsc and st_vsc1 
> controllers is different
> > from st_shasta. The original driver code can only  map 
> first 16 'entities'
> > for st_vsc and st_vsc1 while there are actually 128 available.
> > 
> > Also the  ST_MAX_LUN_PER_TARGET should be 8, although this can do
> > no harm because inquiries beyond boundary are discarded by firmware.
> > 
> > The correct internal mapping should be:
> > id:0~15, lun:0~7 (st_shasta)
> > id:0, lun:0~127 (st_yosemite)
> > id:0~127, lun:0 (st_vsc and st_vsc1)
> > To scsi mid layer they are all channel:0~7, id:0~15, lun:0, 
> with a maximun
> > 'entity' number of 128. The RAID console only interfaces to 
> scsi mid layer
> > and is always mapped at channel:0, id:16, lun:0.
> 
> I'm with Christoph here ... if we're going to break the backwards
> compatibility of the mappings (which your code does) then we 
> could just
> dump channel and use the SCSI id and lun directly.
> 
> Understanding this code is predicated on this quirky definition in
> stex_queuecommand:
> 
> 	id = cmd->device->id;
> 	lun = cmd->device->channel; /* firmware lun issue work around */
>                            ^^^^^^^
> 
> > @ -645,12 +645,16 @@ stex_queuecommand(struct scsi_cmnd *cmd,
> >  
> >  	req = stex_alloc_req(hba);
> >  
> > -	if (hba->cardtype == st_yosemite) {
> > -		req->lun = lun * (ST_MAX_TARGET_NUM - 1) + id;
> 
> This looks to be correct, it goes up id 0 to ST_MAX_TARGET_NUM -1 then
> takes the next channel.
> 
> > -		req->target = 0;
> > -	} else {
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
> These both look to be wrong.  You're taking the channel as the lowest
> common denominator, so your first target is on channel 1 id 
> 0, your next
> on channel 2, id 0 and so on.  That's really going to mess with the
> ordering (which will be user visible) is that really what you want?
> 

Well the firmware doesn't care about the scanning order. You can jump
first on 0,8,16... and then go back to 1,9,17... These are consistent
to the user if the code is that way(may break previous impression
though).
Anyway this is a simulation and I can make whatever necessary
adjustment.


 
