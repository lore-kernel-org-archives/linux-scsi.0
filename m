From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Add US_FL_NO_ULD_ATTACH usb mass storage unusal dev flag ?
Date: Sun, 04 Apr 2010 23:39:09 +0200
Message-ID: <4BB906FD.8000207@redhat.com>
References: <4BB8A7BF.6090908@redhat.com> <4BB8E0DC.8090606@draisberghof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BB8E0DC.8090606-Pw1IEfbnKvGTBPm/0KVrCA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josua Dietze <digidietze-Pw1IEfbnKvGTBPm/0KVrCA@public.gmane.org>
Cc: linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 04/04/2010 08:56 PM, Josua Dietze wrote:
> Hans de Goede schrieb:
>
>> But one of the variants (usb id 1908:1320) still hits a usb-reset
>> when drivers/scsi/sr.c does a READ_CAPACITY from get_sector_size().
>> After the initial READ_CAPACITY failure and the usb reset, the
>> second READ_CAPACITY succeeds.
>
>
> Did you try to set the AVOID_RESET_QUIRK attribute? This was
> originally targeted at those mode-switching devices, but might be
> useful in this case too.
>

Thanks for the hint. although not really what I was looking for
this has prompted me to investigate this issue further as I was
not completely happy with the NO_ULD_ATTACH solution.

After turning on full debugging in the usb-storage driver it
turns out the out enabling of US_FL_SANE_SENSE was the culprit,
when I explicitly specify US_FL_BAD_SENSE, thus disabling the
auto enabling of SANE_SENSE, things are much better, the
first 2 READ_CAPACITY calls still fail (stalled endpoint), but
no longer result in a full device reset.

I'll do a patch adding these devices to unusual_devs.h with
the US_FL_BAD_SENSE quirk tomorrow.

Thanks all for your input.

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
