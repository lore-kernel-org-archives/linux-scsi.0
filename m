From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: JMS56x not working reliably with uas driver
Date: Wed, 21 Dec 2016 12:54:19 +0100
Message-ID: <dcf2ff86-2d40-b9a9-4bc2-16a6b23ba480@redhat.com>
References: <585A69E6.6040009@caviumnetworks.com>
 <1482320547.7638.7.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482320547.7638.7.camel-IBi9RG/b67k@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, George Cherian <gcherian-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Cc: stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 21-12-16 12:42, Oliver Neukum wrote:
> On Wed, 2016-12-21 at 17:09 +0530, George Cherian wrote:
>> Hi Oliver,
>>
>> I was working with this JMicron device and using the uas driver.
>> I am seeing the following 2 issues.
>>
>> 1) On connect I see the following messages.
>
> Thanks. Do you want to submit it to Greg?
> The patch is fine.
>
>> 2) On disconnect I am seeing the following issue
>>
>>   scsi host4: uas_post_reset: alloc streams error -19 after reset
>>   sd 4:0:0:0: [sdb] Synchronizing SCSI cache
>>
>> This is more fatal because after these messages the USB port becomes
>> unusable. Even an lsusb invocation hangs for ever.
>
> Ouch. That points to a logic error. We should not reset if
> a device is gone.

Ah good point, so instead of just seeing a disconnect, something
is triggering a reset, and then we try to alloc stream on the
disconnected usb port and that apparently makes the xhci controller
quite unhappy.

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
