From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 10/14] scsi: osd: fix device_register() error handling
Date: Mon, 20 Sep 2010 17:42:13 +0200
Message-ID: <4C9780D5.8000804@panasas.com>
References: <1284900907-24621-1-git-send-email-segooon@gmail.com>	 <20100919142653.GF6236@bicker> <1284983897.2973.11.camel@mulgrave.site>	 <20100920151029.GA25386@suse.de>  <20100920151317.GA25506@suse.de> <1284996062.2973.85.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:19740 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756812Ab0ITPmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2010 11:42:20 -0400
In-Reply-To: <1284996062.2973.85.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Greg KH <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>, Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On 09/20/2010 05:21 PM, James Bottomley wrote:
> On Mon, 2010-09-20 at 08:13 -0700, Greg KH wrote:
>> On Mon, Sep 20, 2010 at 08:10:29AM -0700, Greg KH wrote:
>>> On Mon, Sep 20, 2010 at 06:58:17AM -0500, James Bottomley wrote:
>>>> On Sun, 2010-09-19 at 16:26 +0200, Dan Carpenter wrote:
>>>>> On Sun, Sep 19, 2010 at 04:55:07PM +0400, Vasiliy Kulikov wrote:
>>>>>> If device_register() fails then call put_device().
>>>>>> See comment to device_register.
>>>>>>
>>>>>> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
>>>>>> ---
>>>>>>  compile tested.
>>>>>>
>>>>>>  drivers/scsi/osd/osd_uld.c |    4 +++-
>>>>>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
>>>>>> index cefb2c0..3e0edc2 100644
>>>>>> --- a/drivers/scsi/osd/osd_uld.c
>>>>>> +++ b/drivers/scsi/osd/osd_uld.c
>>>>>> @@ -474,7 +474,7 @@ static int osd_probe(struct device *dev)
>>>>>>  	error = device_register(&oud->class_dev);
>>>>>>  	if (error) {
>>>>>>  		OSD_ERR("device_register failed => %d\n", error);
>>>>>> -		goto err_put_cdev;
>>>>>> +		goto err_put_device;
>>>>>>  	}
>>>>>>  
>>>>>>  	get_device(&oud->class_dev);
>>>>>> @@ -482,6 +482,8 @@ static int osd_probe(struct device *dev)
>>>>>>  	OSD_INFO("osd_probe %s\n", disk->disk_name);
>>>>>>  	return 0;
>>>>>>  
>>>>>
>>>>> Hm...  So if device_register() fails then we should always call
>>>>> device_put()?  It seems like a lot of existing code does that but I
>>>>> hadn't realized until now that that is how it works.
>>>>
>>>> Heh, it wasn't a bug when most of the code was written.  It became a bug
>>>> when dev_set_name() was added because now the storage allocated for the
>>>> name has to be freed with a put.  Previous to this, the advice was just
>>>> to free the device if device_register() failed.
>>
>> That was a long time ago.  When the driver core changed, all callers
>> were audited from what I recall.
>>
>>>>> Why can't the device_put() just be added inside the device_register() so
>>>>> the unwinding works automatically?
>>>>
>>>> Since Greg and Kay didn't actually alter any of the device_register()
>>>> failure paths, this does sound to be the better course of action ... of
>>>> course, every device_register() introduced after the dev_set_name()
>>>> change may call put_device() on the cleanup path ... someone needs to
>>>> check.
>>>
>>> Yes, this patch series should not be needed at all.  If there's a
>>> problem with the driver core here, it should be fixed, not forcing the
>>> issue to all of the individual callers.
>>
>> Nope, I'm wrong, sorry, this is correct.  We can't just free the device
>> ourselves in the driver core because other parts that the device might
>> be embedded in need to be cleaned up before it can go away.
> 
> We're not asking you to free it; that would be wrong.  We're discussing
> doing a put on add fail.  This will free the name allocation and would
> call the release method if one exists, but most of these devices that
> use device_register() seem not to have one (being embedded).  The
> ultimate free would be done either directly in the error path or
> indirectly via release.
> 
> This would make the bug you and Kay introduced with the dev_set_name()
> patch series go away silently.  As I said ... this change would require
> verification since device_register() calls introduced after that patch
> series may do the put.
> 
> The question is really which is more effort.  Every device_register() up
> until the beginning of 2009 has been made buggy by the dev_set_name()
> patch set.  The chances are at least a few uses added after would be
> rendered wrong (although most look to use copy and paste from existing
> uses).
> 
> James
> 

I think I have a compromise. If it is indeed the dev_set_name() leak
then we can just deallocate the name on the error return path. Therefore
any drivers that have the device embedded and rely on it been freed without
calling _put will be fine as before. And these calling _put will be fine
as well.

See below
Boaz
---
git diff --stat -p -M drivers/base/core.c
 drivers/base/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d1b2c9a..054fac2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1068,6 +1068,7 @@ done:
 	if (parent)
 		put_device(parent);
 name_error:
+	kfree(dev->kobj.name);
 	kfree(dev->p);
 	dev->p = NULL;
 	goto done;
