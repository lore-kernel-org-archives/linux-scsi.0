From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] uas: Disable uas on ASM1051 devices
Date: Tue, 09 Sep 2014 21:13:15 +0200
Message-ID: <540F514B.90807@redhat.com>
References: <Pine.LNX.4.44L0.1409091120150.968-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1409091120150.968-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 09/09/2014 05:23 PM, Alan Stern wrote:
> On Tue, 9 Sep 2014, Hans de Goede wrote:
>
>> Even with REPORT SUPPORTED OPERATION CODES blacklisted the ASM1051 chipset
>> still does not work when combined with some disks, e.g. a Crucial M500 ssd.
>>
>> When used with a troublesome disk, the chipset throws all kinds of USB errors,
>> and eventually hangs, where as in BOT mode it works fine.
>>
>> To make matters worse the ASM1051 chipset and older versions of the ASM1053
>> chipset use the same usb-id.
>>
>> When connected over USB-3 the 2 can be told apart by the number of streams
>> they support. So this patch adds some less then pretty code to disable uas for
>> the ASM1051. When connected over USB-2, simply disable uas alltogether for
>> devices with the shared usb-id.
>>
>> This ends up disabling uas in many cases where it actually works fine, which
>> is unfortunate, but better then leaving some users with completely non working
>> external disks. This patch adds a log level explaining how perfomance conscious
>> users can re-enable uas.
>>
>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.16
>> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   drivers/usb/storage/uas-detect.h | 34 ++++++++++++++++++++++++++++++----
>>   1 file changed, 30 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
>> index 503ac5c..3119f3f 100644
>> --- a/drivers/usb/storage/uas-detect.h
>> +++ b/drivers/usb/storage/uas-detect.h
>> @@ -59,10 +59,6 @@ static int uas_use_uas_driver(struct usb_interface *intf,
>>   	unsigned long flags = id->driver_info;
>>   	int r, alt;
>>
>> -	usb_stor_adjust_quirks(udev, &flags);
>> -
>> -	if (flags & US_FL_IGNORE_UAS)
>> -		return 0;
>>
>>   	alt = uas_find_uas_alt_setting(intf);
>>   	if (alt < 0)
>> @@ -72,6 +68,36 @@ static int uas_use_uas_driver(struct usb_interface *intf,
>>   	if (r < 0)
>>   		return 0;
>>
>> +	/*
>> +	 * ASM1051 and older ASM1053 devices have the same usb-id, and UAS is
>> +	 * broken with some disks on the ASM1051, use the number of streams to
>> +	 * differentiate between the 2. Newer ASM1053 devices also support 32
>> +	 * streams, but have a different product-id.
>> +	 */
>> +	if (udev->descriptor.idVendor == 0x174c &&
>> +			udev->descriptor.idProduct == 0x55aa) {
>> +		if (udev->speed < USB_SPEED_SUPER) {
>> +			/* No streams info, assume ASM1051E */
>> +			dev_warn(&udev->dev, "Assuming ASM1051E chipset\n");
>> +			flags |= US_FL_IGNORE_UAS;
>> +		} else if (usb_ss_max_streams(&eps[1]->ss_ep_comp) == 32) {
>> +			dev_warn(&udev->dev, "Detected ASM1051E chipset\n");
>> +			flags |= US_FL_IGNORE_UAS;
>> +		}
>> +	}
>> +
>> +	usb_stor_adjust_quirks(udev, &flags);
>
> This won't work.  usb_stor_adjust_quirks masks out all the quirks that
> it handles before applying the user-specified quirks.  Therefore it
> will erase your US_FL_IGNORE_UAS flag.

Only if there is a matching quirk entry in the quirks parameter, and then
masking it out is fine, we want to allow this as we're setting the
US_FL_IGNORE_US flag on bridges where it is known to cause issues when
combined with *some* disks, while uas works fine with other disks, so
users may want to override it.

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
