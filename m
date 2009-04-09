From: Justin Madru <jdm64-u1xxEuL7cY4AvxtiuMwx3w@public.gmane.org>
Subject: Re: 2.6.30-rc1: OOPS on usb disk insert
Date: Wed, 08 Apr 2009 23:46:37 -0700
Message-ID: <49DD99CD.4090201@gawab.com>
References: <49DC3094.5010607@gawab.com> <20090407223828.c9d2cb75.akpm@linux-foundation.org> 	<49DC3F1F.9040306@gawab.com> <ac3eb2510904080625m228ddc4dl611c3c5c368fab2a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ac3eb2510904080625m228ddc4dl611c3c5c368fab2a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Kay Sievers wrote:
> On Tue, Apr 7, 2009 at 23:07, Justin Madru <jdm64-u1xxEuL7cY4AvxtiuMwx3w@public.gmane.org> wrote:
>   
>> Andrew Morton wrote:
>>     
>>> On Tue, 07 Apr 2009 22:05:24 -0700 Justin Madru <jdm64-u1xxEuL7cY4AvxtiuMwx3w@public.gmane.org> wrote:
>>>       
>
>   
>>>> Testing out .30-rc1 and usb devises don't work. I insert my flash disk
>>>> and get this oops.
>>>>         
>
>   
>>> The trace appears to be claiming that kernel/async.c:async_new.func is
>>> NULL.
>>>
>>> But it cannot be - it's initialised at compilation time.  Unless
>>> something scribbled on it of course.
>>>       
>
> I've seen async problems with other subsystem too, maybe caused by a
> corruption which is fixed by:
>   http://patchwork.kernel.org/patch/16776/
>
>   -static void __init acpi_battery_init_async(void *unused, ...
>   +static void acpi_battery_init_async(void *unused, ...
>
> Kay
>
>   
I've applied the following patches (to try to fix other bugs) and I no 
longer get a BUG/OOPS
although the patches might have not been the cause of the fix, but 
inserting the disk still doesn't works.

http://patchwork.kernel.org/patch/17199/
http://patchwork.kernel.org/patch/17025/
http://patchwork.kernel.org/patch/17039/

It now complains of: FAT: IO charset cp437 not found
Which I've found a work around by:

<insert flash disk>
syslog complains: FAT: IO charset cp437 not found
sudo modprobe -r nls_cp437
sudo modprobe -i nls_cp437
<remove then reinsert flash disk>
syslog complains: FAT: IO charset iso8859_1 not found
sudo modprobe -r nls_iso8859_1
sudo modprobe -i nls_iso8859_1
<insert flash disk>
profit!!

So, I have to insert the disk 3 times before it works. although after 
that it just works, until I reboot and I have to repeat the unload/load 
modules.

Justin Madru

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
