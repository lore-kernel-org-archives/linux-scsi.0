From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND 1/2] SCSI: use scsi_device->timeout consistently
Date: Tue, 21 Nov 2006 11:14:49 +0900
Message-ID: <45626119.10509@gmail.com>
References: <20061119125115.GJ2184@htj.dyndns.org> <Pine.LNX.4.64.0611192353590.4946@kai.makisara.local> <4560E825.3080504@gmail.com> <Pine.LNX.4.64.0611202311280.6260@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:64335 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S966896AbWKUCO7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 21:14:59 -0500
Received: by nf-out-0910.google.com with SMTP id c2so6033nfe
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2006 18:14:58 -0800 (PST)
In-Reply-To: <Pine.LNX.4.64.0611202311280.6260@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Hello,

Kai Makisara wrote:
>>> I don't think there is anything in the midlevel or low-level code to set the
>>> timeout based on the device characteristics. This is left to the ULD.
>> Low level driver should configure timeout or retries to a known value iff it
>> knows what it's doing, when it knows both transport and device-type specific
>> characteristic.
> 
> I am not so optimistic ;-)
> 
>>                 AFAICS, the only driver which modifies sdev->timeout is ipr
>> and it does so only when it knows the device is of certain type.  So, I don't
>> think it will cause any trouble, and using different initialization in
>> different ULDs is too subtle.
>>
> It does not cause trouble now but I think it is an accident waiting to 
> happen. The ULD probably knows more about the device characteristics than 
> the low-level driver. (I admit that there are other than device specific 
> aspects in setting timeouts and these should not be in ULD.)

Yeah, in general, ULD should be in charge for determining default values 
but, then again, SCSI ULDs are driving extremely wide variety of devices 
hanging off all sorts of transports these days.

> What about this variant:
> 	if (SDp->timeout < ST_TIMEOUT)
> 		SDp->timeout = ST_TIMEOUT;
> 
> It does guarantee that the timeout is long enough for tape drives. It also 
> lets the low-level driver set a longer timeout if it has some reason to 
> make it longer than the ULD does.

I don't know enough about tape devices to determine what's right here. 
I think it's better for me to leave st and osst to people who know 
better.  I'll re-submit without os and osst changes.

Thanks.

-- 
tejun
