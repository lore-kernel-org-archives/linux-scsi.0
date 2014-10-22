From: Song Liu <songliubraving@fb.com>
Subject: RE: [PATCH 0/5] Feature enhancements for ses module
Date: Wed, 22 Oct 2014 23:01:35 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBC7D124@PRN-MBX02-4.TheFacebook.com>
References: <1408987546-2418-1-git-send-email-songliubraving@fb.com>
 <C709E4D363AAB64590BFAC54D4C478AAEBC4ABA5@PRN-MBX02-4.TheFacebook.com>
 <54480181.1010001@fb.com> <54482F99.6070306@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3347 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932743AbaJVXCH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2014 19:02:07 -0400
In-Reply-To: <54482F99.6070306@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>

Hi Doug, 

I am not sure whether I fully understand the scenario. Actually patch 5 tries to clear all reserved bits:

+ dest_desc[0] = 0;
+ /* only clear byte 1 for ENCLOSURE_COMPONENT_DEVICE */
+ if (ecomp->type == ENCLOSURE_COMPONENT_DEVICE)
+   dest_desc[1] = 0;
+ dest_desc[2] &= 0xde;
+ dest_desc[3] &= 0x3c;

Would this work for device that rejects request with 1 in RESERVED areas? 

Thanks,
Song

> -----Original Message-----
> From: Douglas Gilbert [mailto:dgilbert@interlog.com]
> Sent: Wednesday, October 22, 2014 3:29 PM
> To: Jens Axboe; Song Liu; linux-scsi@vger.kernel.org
> Cc: Hannes Reinecke; Dan Williams; Christoph Hellwig
> Subject: Re: [PATCH 0/5] Feature enhancements for ses module
> 
> On 14-10-22 09:12 PM, Jens Axboe wrote:
> > On 08/25/2014 11:34 AM, Song Liu wrote:
> >> From: Song Liu [mailto:songliubraving@fb.com]
> >> Sent: Monday, August 25, 2014 10:26 AM
> >> To: Song Liu
> >> Subject: [PATCH 0/5] Feature enhancements for ses module
> >>
> >> These patches include a few enhancements to ses module:
> >>
> >> 1: close potential race condition by at enclosure race condition
> >>
> >> 2,3,4: add enclosure id and device slot, so we can create symlink
> >>         in /dev/disk/by-slot:
> >>    # ls -d /dev/disk/by-slot/*
> >>      /dev/disk/by-slot/enclosure-0x5000ae41fc1310ff-slot0
> >>
> >> 5: add ability to power on/off device with power_status file in
> >>     sysfs.
> 
> Had a rude awakening with sg_ses recently when setting a field in the
> enclosure control dpage. That is what is being done in point 5: above.
> 
> The time honoured technique is to read the corresponding enclosure status
> dpage, find the correct element, twiddle the field of interest, set the SELECT bit
> and write it back. The idea is maintain any other field settings in that element.
> And this is what the ses module does.
> 
> There is at least one SES device out there that rejects the write if there are bits
> set in RESERVED locations. According to SPC-4 a device may do that. Look at
> the status (read) and control (write) variants of each element type: many times
> the control variant has less fields.
> 
> To fix that the read-modify-write cycle needs to be changed to a read-mask-
> modify-write cycle where the "mask" is the allowable write mask (there would
> be one for each element type).
> 
> This is ugly and may create problems in the future if and when
> T10 adds a new field in an element. About that time T10 should think about
> refining the meaning of RESERVED in SES to outlaw SES devices creating this
> particular time waster.
> 
> Doug Gilbert
> 
> >> Dan Williams (4):
> >>    SES: close potential registration race
> >>    SES: generate KOBJ_CHANGE on enclosure attach
> >>    SES: add enclosure logical id
> >>    SES: add reliable slot attribute
> >>
> >> Song Liu (1):
> >>    SES: Add power_status to SES enclosure component
> >
> > Guys, where are we with these? Seemed like they got reviewed (and
> > updates/fixes posted), then nothing else happened. Would be nice to
> > get these upstream, so we don't have to carry them at FB.
> >

