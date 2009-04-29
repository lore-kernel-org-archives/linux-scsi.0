From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] scsi: ses check name in enclosure_component_register
Date: Tue, 28 Apr 2009 18:02:23 -0700
Message-ID: <49F7A71F.5040709@kernel.org>
References: <49F6678D.3080207@kernel.org>	 <1240957589.3380.67.camel@mulgrave.int.hansenpartnership.com>	 <49F7979A.8040302@kernel.org> <1240964289.3380.73.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:59581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbZD2BDM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Apr 2009 21:03:12 -0400
In-Reply-To: <1240964289.3380.73.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Tue, 2009-04-28 at 16:56 -0700, Yinghai Lu wrote:
>> James Bottomley wrote:
>>> On Mon, 2009-04-27 at 19:18 -0700, Yinghai Lu wrote:
>>>> dev_set_name will use sprintf to copy the name.
>>>> need to check if the name does valid.
>>>>
>>>> otherwise will error from device_add later.
>>> I think what you mean to say is that empty names aren't allowed in the
>>> device model.
>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
>>>> index 3cf61ec..68743a9 100644
>>>> --- a/drivers/misc/enclosure.c
>>>> +++ b/drivers/misc/enclosure.c
>>>> @@ -255,7 +255,7 @@ enclosure_component_register(struct enclosure_device *edev,
>>>>  	ecomp->number = number;
>>>>  	cdev = &ecomp->cdev;
>>>>  	cdev->parent = get_device(&edev->edev);
>>>> -	if (name)
>>>> +	if (name && name[0])
>>>>  		dev_set_name(cdev, name);
>>> Actually, I think this should become
>>>
>>> dev_set_name(cdev, "%s", name);
>>>
>>> as well, otherwise any name with a percent in it will get interpreted in
>>> ways we're not expecting at all.
>> i tried that it still failed.
> 
> I didn't say it was the fix to your problem.  I said on looking at the
> code it's another potential problem source.  Your problem is that
> filesystems don't support empty file names.

dev_set_name(cdev, name);

the name become fmt. 

YH

