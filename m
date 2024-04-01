Received: from ns2.wdyn.eu (ns2.wdyn.eu [5.252.227.236])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3CD51C2B;
	Mon,  1 Apr 2024 19:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.252.227.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711998123; cv=none; b=OTtGOjt/c7Cv7OAcBvYcoPuoVREDBCflJ8PQ0KiY6ePXeiE8pCY8uTX3ZjOFeqXTjTyVZhAi8yoaoVl9y2qhljba5HWUSofnn3vf7+pGiS61rRkwVSmr4i7ZNHgth2KTe9fC/5i2HxPiBpDxUDdYPvRRPhCo62iKJRZr6g9Aio8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711998123; c=relaxed/simple;
	bh=zcx1JiWSTwMh76T+53t+ENEUyvzu/m9vpw98SiAWwR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ClgzJ1xnbM1pOtOhNGEBuP0uI7K8bTs8Ua2r3W0KKVlnGJQ+91XyUpYiapKtPJBCiE3kWAuwJYBJ3xDdR0VHX3Gn+Iq8wfl7lbkfwB88Z2RSGyAWZDXzaeHaN5lwt+q2A9bNsQceHz6gfg7cQktRYEak/Ypc6j4B3vh5RUjXHHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de; spf=pass smtp.mailfrom=wetzel-home.de; dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b=mtANK2cY; arc=none smtp.client-ip=5.252.227.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wetzel-home.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="mtANK2cY"
Message-ID: <5bad35f6-70e1-4887-8e31-01e437ba3b94@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
	s=wetzel-home; t=1711998116;
	bh=zcx1JiWSTwMh76T+53t+ENEUyvzu/m9vpw98SiAWwR4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mtANK2cY79o19r6zXPWQEU+rmYS3Xa8P+ez5A6F518n8BrAfqHmFbxZdgzvAAYwqt
	 pGdohL+Ix6GiHR+uX7R6FtDBlzPt0roRnariCtJ8hkF9/3DjqvUIDW/J4tcdQZ1Hoy
	 87r4x7VAlTAKJxstW78yh27sNyyvEii6fTCJsU80=
Date: Mon, 1 Apr 2024 21:01:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sg: Avoid race in error handling & drop bogus
 warn
To: Bart Van Assche <bvanassche@acm.org>, dgilbert@interlog.com
Cc: gregkh@linuxfoundation.org, sachinp@linux.ibm.com,
 linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 martin.petersen@oracle.com, stable@vger.kernel.org
References: <81266270-42F4-48F9-9139-8F0C3F0A6553@linux.ibm.com>
 <20240401100317.5395-1-Alexander@wetzel-home.de>
 <a8b8aabf-250d-46c0-a9b8-fba414e3cfcc@acm.org>
Content-Language: en-US, de-DE
From: Alexander Wetzel <alexander@wetzel-home.de>
In-Reply-To: <a8b8aabf-250d-46c0-a9b8-fba414e3cfcc@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 01.04.24 19:09, Bart Van Assche wrote:
> On 4/1/24 03:03, Alexander Wetzel wrote:
>> commit 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")
>> introduced an incorrect WARN_ON_ONCE() and missed a sequence where
>> sg_device_destroy() was used after scsi_device_put().
> 
> Isn't that too negative? I think that the WARN_ON_ONCE() mentioned above
> has proven to be useful: it helped to catch a bug.
> 

It helped to find the other issue. But the WARN_ON_ONCE() here is still 
plain wrong. Any only explained by my lack of understanding of the code 
and stupid assumptions I should have checked a bit more.

The warning always triggers when we have more than one user of the sg 
device (and then free one of them).
While trying to understand the issue I tripped over the other wrong 
sequence. Which is probably very seldom really executed...

That said I can of course update the wording when you have a better 
suggestion. But I only have some variations of "Ups... sorry. I thought 
that was a good idea. Turns out it's not"


>> sg_device_destroy() is accessing the parent scsi_device request_queue 
>> which
>> will already be set to NULL when the preceding call to scsi_device_put()
>> removed the last reference to the parent scsi_device.
>>
>> Drop the incorrect WARN_ON_ONCE() - allowing more than one concurrent
>> access to the sg device - and make sure sg_device_destroy() is not used
>> after scsi_device_put() in the error handling.
>>
>> Link: 
>> https://lore.kernel.org/all/5375B275-D137-4D5F-BE25-6AF8ACAE41EF@linux.ibm.com
>> Fixes: 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")
> 
> The "goto sg_put" removed by this patch was introduced by commit
> cc833acbee9d ("sg: O_EXCL and other lock handling"). Since the latter
> commit is older than the one mentioned above, shouldn't the Fixes tag
> refer to the latter commit?
> 

The order was not wrong till commit db59133e9279 ("scsi: sg: fix 
blktrace debugfs entries leakage"), the one my original patch tried to 
fix. Prior to that one sg_device_destroy() was not using the scsi device 
request_queue.

I guess I (or one maintainer) could add that commit here again, too...

My reasoning here is, that this patch here fixes what my first patch got 
wrong.
Which is already heading into the stable trees. And I would prefer to 
not have any kernel release with commit 27f58c04a8f4 ("scsi: sg: Avoid 
sg device teardown race")  without this fix, too.


>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 386981c6976a..833c9277419b 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -372,8 +372,9 @@ sg_open(struct inode *inode, struct file *filp)
>>   error_out:
>>       scsi_autopm_put_device(sdp->device);
>>   sdp_put:
>> +    kref_put(&sdp->d_ref, sg_device_destroy);
>>       scsi_device_put(sdp->device);
>> -    goto sg_put;
>> +    return retval;
>>   }
> 
> Please add a comment above "return retval" that explains which code will
> drop the sg reference.
> 

Hm, don't get that. That kref_put() is the one dropping the reference.
The matching kref_get() is in sg_add_sfp(). Which is called a few lines 
prior to the code here (line 350).

The patch is literally only swapping the order of scsi_device_put() and 
kref_put().

Which *again* causes a use-after free. So I'll send out v3 immediately 
and if any of the thinks discussed here require a v4 we'll do that.

Alexander
