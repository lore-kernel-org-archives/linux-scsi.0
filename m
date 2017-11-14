From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate
 device
Date: Tue, 14 Nov 2017 18:44:49 +0100
Message-ID: <c03f33ff-81e8-1753-f648-94c107e994ad@redhat.com>
References: <Pine.LNX.4.44L0.1711141022580.1796-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57111 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751736AbdKNRow (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Nov 2017 12:44:52 -0500
In-Reply-To: <Pine.LNX.4.44L0.1711141022580.1796-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Hi,

On 11/14/2017 04:25 PM, Alan Stern wrote:
> On Tue, 14 Nov 2017, Hans de Goede wrote:
> 
>> Hi,
>>
>> On 14-11-17 15:00, Hans de Goede wrote:
>>> Just like all previous UAS capable Seagate disk enclosures, this
>>> one needs a US_FL_NO_ATA_1X quirk.
>>>
>>> Cc: stable@vger.kernel.org # 3.16
>>> Reported-by: Wido <wido.gg@gmail.com>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>>
>> So far we've been adding quirks for Seagate drives on a one by one
>> basis (I started this myself) hoping that one day they will fix
>> their ATA_1X pass-through support. But that does not seem to
>> be happening.
>>
>> Maybe we need to do something like this instead ?   :
>>
>> --- a/drivers/usb/storage/uas-detect.h
>> +++ b/drivers/usb/storage/uas-detect.h
>> @@ -111,6 +111,10 @@ static int uas_use_uas_driver(struct usb_interface *intf,
>>                   }
>>           }
>>
>> + /* All Seagate disk enclosures have broken ATA pass-through support */
>> + if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2)
>> +         flags |= US_FL_NO_ATA_1X;
>> +
>>           usb_stor_adjust_quirks(udev, &flags);
>>
>>           if (flags & US_FL_IGNORE_UAS) {
>>
>>
>> Then we can remove a whole lot of quirks and we avoid future
>> churn when new Seagate device ids show up.
> 
> That is a reasonable approach.  For what it's worth, usb-storage has
> had similar code for many years, affecting devices from Nokia, Nikon,
> Pentax, and Motorola.


Ok.

Greg, please do no merge the 2 recent uas seagate quirks I send
then. I will submit a patch with the new approach right away.

Once the patch with the new approach is merged I will
submit a patch to remove all the seagate quirks.

Regards,

Hans
