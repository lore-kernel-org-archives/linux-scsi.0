From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 10/14] scsi: osd: fix device_register() error handling
Date: Mon, 20 Sep 2010 18:31:48 +0200
Message-ID: <4C978C74.1040104@panasas.com>
References: <1284900907-24621-1-git-send-email-segooon@gmail.com>	 <20100919142653.GF6236@bicker> <1284983897.2973.11.camel@mulgrave.site>	 <20100920151029.GA25386@suse.de>  <20100920151317.GA25506@suse.de>	 <1284996062.2973.85.camel@mulgrave.site>  <4C9780D5.8000804@panasas.com> <1284998106.2973.125.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:63070 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752048Ab0ITQbz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2010 12:31:55 -0400
In-Reply-To: <1284998106.2973.125.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Greg KH <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>, Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>

On 09/20/2010 05:55 PM, James Bottomley wrote:
> On Mon, 2010-09-20 at 17:42 +0200, Boaz Harrosh wrote:
>> I think I have a compromise. If it is indeed the dev_set_name() leak
>> then we can just deallocate the name on the error return path. Therefore
>> any drivers that have the device embedded and rely on it been freed without
>> calling _put will be fine as before. And these calling _put will be fine
>> as well.
>>
>> See below
>> Boaz
>> ---
>> git diff --stat -p -M drivers/base/core.c
>>  drivers/base/core.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index d1b2c9a..054fac2 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -1068,6 +1068,7 @@ done:
>>  	if (parent)
>>  		put_device(parent);
>>  name_error:
>> +	kfree(dev->kobj.name);
>>  	kfree(dev->p);
>>  	dev->p = NULL;
>>  	goto done;
> 
> That's not really good enough ... it will result in a double free
> because the final put (if there is one) will free the name again.
> 
> This would work, but it feels a bit wrong to be poking at the kobject
> from within the driver core ... perhaps a kobject_free_name() call might
> be better?
> 

It would not be the first place to directly access kobj. members but sure
that will work as well.

> James
> 
> ---
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index d1b2c9a..88ffaca 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1067,6 +1067,8 @@ done:
>  	cleanup_device_parent(dev);
>  	if (parent)
>  		put_device(parent);
> +	kfree(dev->kobj.name);
> +	dev->kobj.name = NULL;

Rrr thanks, the NULL. Therefore the lack of a signed-off ;-)

I take it that you agree with me that for some code it would be nice
if we add support for not mandating a device_put after a device_register
for the embedded types? For sake of already written code?

>  name_error:
>  	kfree(dev->p);
>  	dev->p = NULL;
> 
> 

Thanks
Boaz
