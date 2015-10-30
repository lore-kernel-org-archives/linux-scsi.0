From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 25/32] scsi: hisi_sas: add abnormal irq handler
Date: Fri, 30 Oct 2015 16:58:02 +0000
Message-ID: <5633A19A.1010900@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
 <1445868903-183817-26-git-send-email-john.garry@huawei.com>
 <3709094.hsDE2JcmxW@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3709094.hsDE2JcmxW@wuerfel>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 30/10/2015 14:10, Arnd Bergmann wrote:
> On Monday 26 October 2015 22:14:56 John Garry wrote:
>> Add abnormal irq handler. This handler is concerned with
>> phy down event.
>> Also add port formed and port deformed handlers.
>>
>> Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> I noticed a couple more coding style issues in this patch than elsewhere, so here
> is a slightly more detailed review.
>
>> +static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
>> +{
>> +	struct sas_ha_struct *sas_ha = sas_phy->ha;
>> +	struct hisi_hba *hisi_hba = NULL;
>> +	int i = 0;
>> +	struct hisi_sas_phy *phy = sas_phy->lldd_phy;
>> +	struct asd_sas_port *sas_port = sas_phy->port;
>> +	struct hisi_sas_port *port;
>> +	unsigned long flags = 0;
>
> Here and in general, please avoid initializing local variables
> to zero, as that prevents gcc from warning about uses that
> come before the real initialization.
>
> The flags that get passed into spin_lock_irqsave() are architecture
> specific, so you cannot rely on '0' to have a particular meaning.
>

Noted. Will change.

>> +	if (!sas_port)
>> +		return;
>> +
>> +	while (sas_ha->sas_phy[i]) {
>
> Using a for() loop would avoid the initialization here.
>

Yes.

>> +		if (sas_ha->sas_phy[i] == sas_phy) {
>> +			hisi_hba = (struct hisi_hba *)sas_ha->lldd_ha;
>
> lldd_ha is a void pointer, so you don't need a cast.
>

Noted.

>> +			port = &hisi_hba->port[i];
>> +			break;
>> +		}
>> +		i++;
>> +	}
>
> The loop is really odd, as you apparently only try to find the
> array index to a pointer you already have. Is there no space for
> driver-specific data in 'asd_sas_phy'? If there is, just point to
> per-phy structure that you define yourself and put the index into
> that structure. I believe you already have a struct like that.
>

This code is a remnant from when we used to have the driver designed in 
such a way that we had a single Scsi Host and which had multiple cores 
(and hisi_hba's). Will address.

>> +	if (hisi_hba == NULL) {
>
> When checking a pointer for validity, do not compare against
> NULL, but write this as 'if (!hisi_hba)', which is the more
> normal coding style.

OK.

>
>> +		pr_err("%s: could not find hba\n", __func__);
>> +		return;
>> +	}
>
> Better use dev_err() to print the device name, but remove the __func__
> argument. Again, when you have the per-phy structure, put a pointer
> to the device in there.
>
>> +
>> +	if (lock)
>> +		spin_lock_irqsave(&hisi_hba->lock, flags);
>> +	port->port_attached = 1;
>> +	port->id = phy->port_id;
>> +	phy->port = port;
>> +	sas_port->lldd_port = port;
>> +
>> +	if (lock)
>> +		spin_unlock_irqrestore(&hisi_hba->lock, flags);
>> +}
>
> This breaks some checking tools that try to validate the uses of
> locks. Better wrap the function in another one depending on the
> caller. When using spinlocks in general, it's also better to replace
> the "I have no clue where I'm called from" spin_lock_irqsave()
> call with either spin_lock() or spin_lock_irq() if at all possible.
>
Ok, I can remove the lock check. I know that the function can be called 
from irq context in my irq handler and also from multiple functions in 
libsas (whose context I am unsure of).
> 	Arnd
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> .
>

Thanks for the detailed review. I'll try and address your comments for 
other patches.

john

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
