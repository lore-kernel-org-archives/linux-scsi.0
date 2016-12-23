From: George Cherian <gcherian@caviumnetworks.com>
Subject: Re: JMS56x not working reliably with uas driver
Date: Fri, 23 Dec 2016 08:31:53 +0530
Message-ID: <64608b5d-e90f-3839-eb80-7e3cd042a887@caviumnetworks.com>
References: <Pine.LNX.4.44L0.1612221734120.15794-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0067.outbound.protection.outlook.com ([104.47.32.67]:45837
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751097AbcLWDdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 22:33:37 -0500
In-Reply-To: <Pine.LNX.4.44L0.1612221734120.15794-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: oneukum@suse.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, hdegoede@redhat.com

Hi Alan,


On Friday 23 December 2016 04:14 AM, Alan Stern wrote:
> On Wed, 21 Dec 2016, George Cherian wrote:
>
>> Hi Oliver,
>>
>> I was working with this JMicron device and using the uas driver.
>> I am seeing the following 2 issues.
>>
>> 1) On connect I see the following messages.
>> xhci_hcd 0000:00:11.0: ERROR Transfer event for disabled endpoint or
>> incorrect stream ring
>>    This was eliminated using the following scissor patch.
>>
>> ---------------------------------8<------------------------------------
>> [PATCH] usb: storage: unusual_uas: Add JMicron JMS56x to unusual device
>>
>> This device gives the following error on detection.
>> xhci_hcd 0000:00:11.0: ERROR Transfer event for disabled endpoint or
>> incorrect stream ring
>>
>> The same error is not seen when it is added to unusual_device
>> list with US_FL_NO_REPORT_OPCODES passed.
>>
>> Signed-off-by: George Cherian <george.cherian@cavium.com>
>> ---
>>    drivers/usb/storage/unusual_uas.h | 7 +++++++
>>    1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/usb/storage/unusual_uas.h
>> b/drivers/usb/storage/unusual_uas.h
>> index cbea9f3..d292299 100644
>> --- a/drivers/usb/storage/unusual_uas.h
>> +++ b/drivers/usb/storage/unusual_uas.h
>> @@ -142,6 +142,13 @@ UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
>>    		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>    		US_FL_BROKEN_FUA | US_FL_NO_REPORT_OPCODES),
>>
>> +/* Reported-by George Cherian <george.cherian@cavium.com> */
>> +UNUSUAL_DEV(0x152d, 0x9561, 0x0000, 0x9999,
>> +                "JMicron",
>> +                "JMS56x",
>> +                USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>> +                US_FL_NO_REPORT_OPCODES),
>> +
>>    /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
>>    UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
>>    		"VIA",
>> --------------------------------->8------------------------------------
> I don't see how this patch fixes anything.  Unless I'm mistaken, it
> just avoids the problem by preventing the system from issuing the
> command that provokes the error, rather than really fixing the
> underlying error.
>
>> 2) On disconnect I am seeing the following issue
>>
>>    scsi host4: uas_post_reset: alloc streams error -19 after reset
>>    sd 4:0:0:0: [sdb] Synchronizing SCSI cache
>>
>> This is more fatal because after these messages the USB port becomes
>> unusable. Even an lsusb invocation hangs for ever.
> This problem looks pretty simple.  uas doesn't check properly to see if
> the device was disconnected following a reset.
>
> Try changing the line in uas_post_reset() that says:
>
> 	if (devinfo->shutdown)
>
> to:
>
> 	if (devinfo->shutdown ||
> 			devinfo->udev->state == USB_STATE_NOTATTACHED)
Yes this works for me but with a little bit change as follows, But am 
not sure whether we should goto reset_scsi in case of shutdown.
Please advice.

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 5ef014b..24db3fd 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1072,8 +1072,8 @@ static int uas_post_reset(struct usb_interface *intf)
         unsigned long flags;
         int err;

-       if (devinfo->shutdown)
-               return 0;
+       if (devinfo->shutdown || devinfo->udev->state == 
USB_STATE_NOTATTACHED)
+               goto reset_scsi;

         err = uas_configure_endpoints(devinfo);
         if (err) {
@@ -1083,6 +1083,7 @@ static int uas_post_reset(struct usb_interface *intf)
                 return 1;
         }

+reset_scsi:
         spin_lock_irqsave(shost->host_lock, flags);
         scsi_report_bus_reset(shost, 0);
         spin_unlock_irqrestore(shost->host_lock, flags);

> Alan Stern
>

