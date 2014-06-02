From: Alain Kalker <a.c.kalker@gmail.com>
Subject: Re: [PATCH V2] sd: Reduce log level to KERN_NOTICE for missing caching
 mode page
Date: Mon, 02 Jun 2014 21:31:28 +0200
Message-ID: <538CD110.5040605@gmail.com>
References: <1401734883-9540-1-git-send-email-a.c.kalker@gmail.com> <1401736473.12939.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38195 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaFBTbc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 15:31:32 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so5260965wiw.10
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 12:31:30 -0700 (PDT)
In-Reply-To: <1401736473.12939.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 06/02/2014 09:14 PM, James Bottomley wrote:
> On Mon, 2014-06-02 at 20:48 +0200, Alain Kalker wrote:
>> Reduce the lernel log level to KERN_NOTICE for messages related
>> to a missing caching mode page.
>>
>> Reasons why I think this change is justified:
>> - The condition is not an error; the existing workaround of assuming
>>    a write through cache doesn't limit functionality in any way.
>
> That's not actually correct.  The condition may be an error.  We have
> some USB attached storage devices with writeback caches which don't
> supply caching information.  Treating a writeback device as writethrough
> is a potential error because you may lose data as a result of it.

Aha, I thought that the write through treatment would always make sure 
that the device has written all the data before returning. If that's not 
always true, then I agree that the condition could be an error.

> The error is that we've made an assumption which may damage your data.
>
> The problem for us is that we can't tell if the assumption is going to
> be fatal or not ... the message is harmless for older USB devices.

I think that I wrongly assumed that only (older?) writethrough devices 
might not return caching information. If there are also writeback 
devices which don't return (correct) information, then I have to agree.

>> - It doesn't warrant a warning either: as it is most likely
>>    a hardware limitation, there is little that an ordinary user can do
>>    about it besides replacing the affected hardware.
>>    Making it a warning would still break quiet boot (kernel commandline
>>    parameter 'quiet'), and may still trip log monitoring software
>>    unneccessarily, either on every boot or whenever an affected
>>    external device is plugged in.
>> - It should be a notice, for it is a normal but significant condition,
>>    as it may impact write performance. This would bring it on par with
>>    the log messages in the same function.
>
> But this message may serve a purpose:  If you see it and you find you do
> have a USB device with a writeback cache, you can set the boot system to
> correct the cache type assumption and we'll send the correcting
> synchronize cache commands.

Very informative, thanks!
I do think that this should be documented somewhere, especially with 
regard to the risk of data loss. People might think that falling back on 
writethrough is always a 'safe bet' where it actually might not be.

> It certainly helps bug triagers identify issues which may require adding
> a particular device to the list that need to be treated as writeback.

Thanks for your feedback, much appreciated.

Alain
