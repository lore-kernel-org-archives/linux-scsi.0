From: Lars Melin <larsm17-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Mon, 07 Jul 2014 22:51:13 +0700
Message-ID: <53BAC1F1.5090006@gmail.com>
References: <CANudz+sYkDthT9-xpt_hdqXHj+pSeTR5UcNmsPa4uP+YCvzSiw@mail.gmail.com>	<20140707092029.GA19630@localhost.localdomain>	<CANudz+uUuhLdfkVSseXXHW6ugm126Q4Taau+s7wavAP=Z9=4XA@mail.gmail.com>	<53BAB5DF.5090606@gmail.com>	<063D6719AE5E284EB5DD2968C1650D6D1726D887@AcuExch.aculab.com> <CANudz+uOS3VVyz6FcHoui8z678R6Xc0CQrdqFRdS5NyfCB59Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANudz+uOS3VVyz6FcHoui8z678R6Xc0CQrdqFRdS5NyfCB59Zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: loody <miloody-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>
Cc: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 2014-07-07 22:39, loody wrote:
> hi David:
>
> 2014-07-07 23:06 GMT+08:00 David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>:
>> From: Lars Melin
>> ...
>>> sgread is not included in BusyBox but you should have "touch".
>>> Create a dummy file on the disk and let cron touch it every 4 minutes.
>> You don't need 'touch' a shell redirect eg ": >file" will do open(..., O_CREAT|O_TRUNC).
>> However that still might not force an actual disc access.
>>
>> In any case you really only want to do a read, doing a write will kill the NAND memory.
> actually I have searched the scsi/usb layer for possible dummy read,
> even read sector 0 is fine, but in vain.
>
> I found the read
> a. determined by VFS -> block layer,
> b. Block layer put it in queue
> c. call scsi pre-queue function to usb layer.
>
> That mean if I try to read sector from usb devices, I have to create a
> queue and follow above b) and c) rule.
> is there any already kernel API I can use?
>
> sincerely appreciate all yours help,
dd if=/dev/sda of=/dev/null count=1
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
