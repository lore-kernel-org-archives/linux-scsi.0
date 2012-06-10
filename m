From: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/3] usb: storage: update usb devices for write cache
 quirk in quirk list.
Date: Sun, 10 Jun 2012 09:45:08 +0900
Message-ID: <CAKYAXd9Evpo6jn+_+bnyNeaX9vmPicVp5Xm-12tp_U4=wb6Pgw@mail.gmail.com>
References: <1339263678-4075-1-git-send-email-linkinjeon@gmail.com>
	<4FD39998.4020903@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FD39998.4020903-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Pankaj Kumar <pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

2012/6/10, Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>:
> Hello.
>
> On 06/09/2012 09:41 PM, Namjae Jeon wrote:
>
>> Update information of Seagate Portable HDD and WD My Passport HDD in
>> quirk list.
>
>> Signed-off-by: Namjae Jeon<namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Pankaj Kumar<pankaj.km-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> Signed-off-by: Amit Sahrawat<a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> ---
>>   drivers/usb/storage/unusual_devs.h |   24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>
>> diff --git a/drivers/usb/storage/unusual_devs.h
>> b/drivers/usb/storage/unusual_devs.h
>> index 1719886..64f0369 100644
>> --- a/drivers/usb/storage/unusual_devs.h
>> +++ b/drivers/usb/storage/unusual_devs.h
>> @@ -1267,6 +1267,18 @@ UNUSUAL_DEV( 0x0af0, 0xd357, 0x0000, 0x0000,
>>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>   		0 ),
>>
>> +/* Reported by Namjae Jeon<namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> + * Even though write cache is enabled by default,
>> + * SCSI driver assume that cache is not enabled
>> + * which in turn might lead loss of data
>                                ^ to the
>
>> + * since data still will be in cache.
>> + * So this entry is needed for assuming that cache is enabled.
>> + */
>> +UNUSUAL_DEV(0x0bc2, 0x2300, 0x0000, 0x9999,
>> +		"Seagate",
>> +		"Portable HDD",
>> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_WRITE_CACHE),
>> +
>>   /* Reported by Ben Efros<ben-sBIqA0PYact54TAoqtyWWQ@public.gmane.org>  */
>>   UNUSUAL_DEV( 0x0bc2, 0x3010, 0x0000, 0x0000,
>>   		"Seagate",
>> @@ -1468,6 +1480,18 @@ UNUSUAL_DEV(  0x1058, 0x0704, 0x0000, 0x9999,
>>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>>   		US_FL_SANE_SENSE),
>>
>> +/* Reported by Namjae Jeon<namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> + * Even though write cache is enabled by default,
>> + * SCSI driver assume that cache is not enabled
>> + * which in turn might lead loss of data
>                                ^ to the
to the ? Sorry, I don't understand what you want to change.
like this ? "Even though write cache is enabled by default, SCSI
driver assume that cache is not enabled and it in turn might lead the
loss of data. "

>
> WBR, Sergei
>
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
