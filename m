Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA70910FA;
	Wed, 20 Mar 2024 16:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.252.227.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710953930; cv=none; b=kn2dJGJagOwlPaP3gEolDBITZTCk10IQTzBOBOYMkVzIRqo2i59zF9qVCmDDdVIMxqoIxIxFEr9R5mM3ThhrSNKrXoBwGZ5YwIcp3oa1a1LRJh2u+Z8OgiWD3CAfbGIO340s/wWBG024afFcvqisZN1pzJ3n+qbel/i1UiW5w1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710953930; c=relaxed/simple;
	bh=TxQReDTPFeYIzxbmKhjwiCFg5+LQu3KfvGpmrlrOVdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WmoMzgAvaE7KJ8UB1GZzr95xI8GY4vOqevzs6fJZ5TB0E6PCt+zLIJyc+lly/IVy7wvstqYJ8jVby9GgRbTh4tR1YRkptGH6/8oN9UcSBy/HvKgL6EwEhfa33fKvpX0WfxNs18JWI9InM6pxpHV2coqKkHJenrHapr2aS97OJrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de; spf=pass smtp.mailfrom=wetzel-home.de; dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b=ljodIoNn; arc=none smtp.client-ip=5.252.227.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="ljodIoNn"
Message-ID: <c2454690-4cb4-41ac-b4f3-b1591ca472e7@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
	s=wetzel-home; t=1710953922;
	bh=TxQReDTPFeYIzxbmKhjwiCFg5+LQu3KfvGpmrlrOVdU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ljodIoNnKZ2pjEBGTdKvK6V189Yee7CXKotw6bYdU5ViA/B3hweS4YFx0AM+aEr+I
	 Ci7eUncg3QPpI9beTqIQZj/mzjbe27LpbHw2sNMZymR/LDz7ZUrwUbCDgmNMcCA3xC
	 EITpbsuIIbf4E1w6gIWeZhEwIuVWlryhOUegK50c=
Date: Wed, 20 Mar 2024 17:58:42 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sg: Avoid sg device teardown race
To: Bart Van Assche <bvanassche@acm.org>, dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
References: <20240318175021.22739-1-Alexander@wetzel-home.de>
 <20240320110809.12901-1-Alexander@wetzel-home.de>
 <8b8e5aca-4b97-4662-9ae0-fc36db2436b4@acm.org>
Content-Language: en-US, de-DE
From: Alexander Wetzel <alexander@wetzel-home.de>
In-Reply-To: <8b8e5aca-4b97-4662-9ae0-fc36db2436b4@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20.03.24 16:02, Bart Van Assche wrote:
> On 3/20/24 04:08, Alexander Wetzel wrote:
>> sg_remove_sfp_usercontext() must not use sg_device_destroy() after
>> calling scsi_device_put().
>>
>> sg_device_destroy() is accessing the parent scsi device request_queue.
>> Which will already be set to NULL when the preceding call to
>> scsi_device_put() removed the last reference to the parent scsi device.
>>
>> The resulting NULL pointer exception will then crash the kernel.
>>
>> Link: 
>> https://lore.kernel.org/r/20240305150509.23896-1-Alexander@wetzel-home.de
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
>> ---
>> Changes compared to V1:
>> Reworked the commit message
>>
>> Alexander
>> ---
>>   drivers/scsi/sg.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 86210e4dd0d3..80e0d1981191 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -2232,8 +2232,8 @@ sg_remove_sfp_usercontext(struct work_struct *work)
>>               "sg_remove_sfp: sfp=0x%p\n", sfp));
>>       kfree(sfp);
>> -    scsi_device_put(sdp->device);
>>       kref_put(&sdp->d_ref, sg_device_destroy);
>> +    scsi_device_put(sdp->device);
>>       module_put(THIS_MODULE);
>>   }
> 
> Is it guaranteed that the above kref_put() call is the last kref_put()
> call on sdp->d_ref? If not, how about inserting code between the
> kref_put() call and the scsi_device_put() call that waits until
> sg_device_destroy() has finished?
> 

While I'm not familiar with the code, I'm pretty sure kref_put() is 
removing the last reference to d_ref here. Anything else would be odd, 
based on my - really sketchy - understanding of the flows.

Also waiting for another process looks wrong. I guess we would then have 
to delay the call to sg_release().

And at least for me it's always the last d_ref reference.
I changed the section to:

         kref_put(&sdp->d_ref, sg_device_destroy);
         printk("XXXX scsi=%u, dref=%u\n", \
		kref_read(&sdp->device->sdev_gendev.kobj.kref), \
		kref_read(&sdp->d_ref));
         scsi_device_put(sdp->device);

And connected/disconnected my test USB device a few times:
  XXXX scsi=2, dref=0
  XXXX scsi=1, dref=0
  XXXX scsi=2, dref=0
  XXXX scsi=1, dref=0
  XXXX scsi=1, dref=0
  XXXX scsi=1, dref=0
  XXXX scsi=1, dref=0
  XXXX scsi=1, dref=0
  XXXX scsi=1, dref=0
  XXXX scsi=1, dref=0

(scsi=1 are the cases which would cause the NULL pointer exceptions with 
the unpatched driver.)

Alexander

