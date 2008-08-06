From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 03/14] osd_uld: OSD scsi ULD
Date: Wed, 06 Aug 2008 20:25:18 +0300
Message-ID: <4899DE7E.9040601@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>	 <4888C023.7070105@panasas.com> <1217193375.3503.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20211 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754765AbYHFR05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 13:26:57 -0400
In-Reply-To: <1217193375.3503.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Benny Halevy <bhalevy@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>

James Bottomley wrote:
> On Thu, 2008-07-24 at 20:47 +0300, Boaz Harrosh wrote:
>> Add a Linux driver module that registers as a SCSI ULD and probes for OSD type
>> SCSI devices.
>>
>> When an OSD-type SCSI device is found a character device is created in the form
>> of /dev/osdX - where X goes from 0 up to hard coded 64.
>> The Major character device number used is *232*, which is free (as of Linux
>> v2.6.27). The same Major was used by the old IBM initiator project.
>>
>> TODO: How to dynamically allocate a Major and have a /dev/osdX entry linked
>> to it? Do I need/should reserve the minor range in advance, if not how?
>>
>> A single ioctl is currently supported that will invoke an in-kernel test on
>> the specified OSD device (lun).
> 
> The first thing that immediately leaps to mind is are you sure this
> should be a character device?  Since it's only open/close/ioctl (as in
> no read/write) you could then use all the file bdev handling to get back
> to struct osd_device, plus you can bind to bsg (and SG_IO) which is
> unaccountably missing in this prototype.

AN OSD device is by no means a BLOCK device and it does not export any
such functionality per-se. It is a completely new SCSI command-set and
does not inherent any SCSI block functionality. Except these commands 
explicitly specified that allow the device probing and login(iscsi).

There is a provision to send standard SCSI commnds (READ/WRITE etc..)
to individual objects inside the OSD. But only after all proper 
administration and security was set for the device, partition, and 
object in question.

We have thought about emulating such a layer where once login into
an OSD device. a scan will look for all objects that, say, have an
"export-block-device" special user defined attribute, and will export
these as scsi-block devices, which lives inside OSD objects. This
way you can have over commits, OSD-security, data migration, raid and
all kind of fun stuff. Over an OSD grid. But people we ask did not
like it. and frankly we didn't either. So we are not going to do that.

So an OSD can be used for data storage but not in the traditional sense
there must be an higher layer that makes policy decisions on how a traditional
file system sits over an OSD device. But this is not the scope of this layer.
We have in our labs two such higher beasts that do that. One is the 
pNFS-objects that caries out policy governed by a network Object-based file
system, and initiates all the proper OSD commands to read/write etc .. to
OSD targets. And an osdfs from IBM that we have converted to use our
Initiator. These higher level layers will make policy decisions (break
some eggs) and will have to issue the right OSD commands in the proper
state, for flushing read/write create and all these things that they
need to take care of. At this layer of Initiator library we cannot know
all this because we don't set any policy.

So to answer your question It's a char device because that was the easiest
way for us to export a Kernel API for issuing test vectors to OSD targets.
Perhaps we could make a sysfs API to do the same thing.

> 
> The second observation is that refcounting in this driver is
> non-existent.  Doing a kfree(osd_dev) from osd_remove makes open device
> remove module do something else look to be a certain oops ... you can
> use the refcounting models of sd or st to see how this is done.
> 

I will look into this thanks

I have done some tests and I saw that as long as I have files open the
cdev will not die. and since I'm only removed when .remove is called by
the scsi-ml then I'm some how protect as long as I'm working. So it looks
like the system protects me from deletion while working. (Note that I only
have synchronous ioctl)

What I have not checked, is the coupling between the driver module, and it's 
open devices. I assumed the Kernel takes care of that as long as I have files
open on devices made by the driver, but apparently I was wrong.

> There's a convention that gendisk->private_data points to a pointer to
> the driver.  This was originally a viro clever trick to allow the
> private_data to store both the driver and the uld device (struct
> osd_dev).  I think we've dispensed with needing the driver, so perhaps
> this trick is unnecessary, but you'll need something similar to do
> refcounting properly.
> 

I'm not sure I understand what you mean. I only have a 
struct osd_uld_device allocated per scsi_device that holds pointers to
allocated resources that are freed when .remove is called on the 
associated scsi_device. I do not keep any driver information.

If you meant that when I'll do a refcounting I will need one then
I thought I will just keep a global counter and locks so I don't need
a pointer per se.

> Since OSDs are currently potentially removable spinning media with
> caches, it looks like you potentially also need locking control.  You
> might also need a shutdown method to cope with object flushing before
> power down.
> 

Again as explained above this is out of scope here. This is not a file 
system or block device that exports any data storage to users. Higher
level systems like osdfs or pNFS-objects layout driver will (do) take
care of that at the proper state. This here is just a library that exports
OSD command set, and a ULD that let you issue test vectors to an OSD target.

> Somehow the capacity has to be plumbed in (this also really makes them
> block devices not character devices).  It looks like the total capacity
> attribute of the root information attributes page would be appropriate
> for this.
> 

Again an higher level that actually knows these things does that, this
OSD-library does not make any policy decisions.

> The ioctl flow needs to be plumbed into scsi_ioctl() since the gendisk
> ULD will need to handle all the standard SCSI ioctls.
> 
Again not at this level

> You can't have 232 char as the major for this ... it's already assigned
> to biometric devices (although I think 232 block is free).  Whatever
> number you choose has to be requested through lanana and
> Documentation/device-list.txt updated accordingly.
> 

Sorry last I checked it was free, or perhaps I did not identify it
correctly. I'll fix that.

> (as you noted, TYPE_OSD has to be correctly in the global headers)
> 
> Please don't use sysfs_create_file (it can be racy and accident prone);
> just do the extra files as declared attributes of the osd class and let
> drivers/base handle all the setup/teardown  (sd is a good template).
> 

I will not, thanks. Though currently I don't have any planed and it is
all in comments. I will remove these comments for the final version.

> James
> 
> 

Sorry for the late response I was cut up into something else.

As I said in introductory email. I have no good use planed for
an OSD ULD. It is only used for sending test vectors to make 
sure changes work and there are no new regressions.
I do not know what is the policy for these things in Linux
Should it stay out-of-tree and risk bit-rot or it should be in-tree
but Kconfigured in such a way that distributions don't end up
putting it on CDs. Please advise.

Thank you very much for the review
Boaz
