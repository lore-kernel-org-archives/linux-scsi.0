From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] uas: Set no_report_opcodes
Date: Tue, 09 Sep 2014 21:21:23 +0200
Message-ID: <540F5333.80201@redhat.com>
References: <1410274800-11578-1-git-send-email-hdegoede@redhat.com> <1410274800-11578-2-git-send-email-hdegoede@redhat.com> <20140909160150.GA15724@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140909160150.GA15724-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 09/09/2014 06:01 PM, Christoph Hellwig wrote:
> On Tue, Sep 09, 2014 at 04:59:59PM +0200, Hans de Goede wrote:
>> asm1051e usb <-> sata bridges hang when receiving a report opcodes scsi cmnd.
>> Take a page out of the usb-storage book, and simple disable no_report_opcodes
>> outright.
>
> Given that this device also seems broken in other ways can we wait a bit
> before using the big hammer?

Actually the big hammer I would like to avoid is disabling uas all together
on these devices, as they work fine with 2 out of 3 of the 3 disks I've
tested with, as long as no report opcodes is not used.

Which is why my other patch also includes a log message to explain how
to enable uas despite the blacklist, but that will only work if we don't
send report opcodes.

 > I'm still hoping UAS might give us some
> better SCSI implementation so that we don't have to disable any kind of
> advanced feature.

I understand, so an alternative would be to make this a quirk and only
set it for ASM1051/ASM1053 bridges.

Even better would be to combine this with figuring out why the bridge is
becoming unhappy when paired with a crucial m500 ssd, and fix that +
a report opcodes quirk, so that we don't have the blacklist it at all.

Any ideas how to fix the unhappiness ? I've already tried setting all
the sdev flags the usb-storage driver sets, but that does not help.

Regards,

Hans



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
