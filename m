From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
Date: Mon, 11 Aug 2014 21:53:34 +0200
Message-ID: <53E91F3E.6000308@redhat.com>
References: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com> <20140811181905.GA25727@roeck-us.net> <53E9118B.3020309@redhat.com> <20140811190823.GA18503@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbaHKTxn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2014 15:53:43 -0400
In-Reply-To: <20140811190823.GA18503@roeck-us.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sanjeev Sharma <sanjeev_sharma@mentor.com>, gregkh@linuxfoundation.org, kraxel@redhat.com, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

On 08/11/2014 09:08 PM, Guenter Roeck wrote:
> On Mon, Aug 11, 2014 at 08:55:07PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 08/11/2014 08:19 PM, Guenter Roeck wrote:
>>> On Mon, Aug 11, 2014 at 01:29:26PM +0530, Sanjeev Sharma wrote:
>>>> spin_is_locked() always return false in uniprocessor configuration and therefore it
>>>> would be advise to repalce with assert_spin_locked().
>>>>
>>>> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
>>>> ---
>>>>  drivers/usb/storage/uas.c | 8 ++++----
>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
>>>> index 3f42785..8e5877d 100644
>>>> --- a/drivers/usb/storage/uas.c
>>>> +++ b/drivers/usb/storage/uas.c
>>>> @@ -154,7 +154,7 @@ static void uas_mark_cmd_dead(struct uas_dev_info *devinfo,
>>>>  	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
>>>>  
>>>>  	uas_log_cmd_state(cmnd, caller);
>>>> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
>>>> +	assert_spin_locked(&devinfo->lock);
>>>
>>> Seems to me that replacing WARN_ON_ONCE (which may be annoying but only
>>> creates a traceback, and only once) with assert_spin_locked (which
>>> crashes the kernel) is a bit drastic.
>>
>> I can see your point, but so far these paranoia checks have never triggered,
>> and having them trigger _always_ one some uni-processor (which is the reason
>> for this patch) to me seems the worse problem of the 2.
>>
> If those are just paranoia checks, it might make sense to use
> lockdep_assert_held() to reduce runtime overhead if lockdep
> debugging is disabled.

Ah yes, that is a good idea.

Sanjeev, can you please send a v2 using lockdep_assert_held() ?

Thanks & Regards,

Hans (the uas driver maintainer)
