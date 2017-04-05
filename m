From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] scsi: ses: don't get power status of SES device slot on probe
Date: Wed, 5 Apr 2017 07:41:32 -0700
Message-ID: <CAPcyv4g1WB6GfxaqvVK6g87rt=ayRG3z-wNRcU7qVa1L-RuG8Q@mail.gmail.com>
References: <1490835730-13181-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <CAPcyv4jqgh97JVnWMFC5kLJDeu6zaY2zZtaYAHTM0w2a0hBmSw@mail.gmail.com> <1f73a9c2-8f59-2636-0685-3ede755648aa@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36668 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752977AbdDEOle (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 10:41:34 -0400
Received: by mail-oi0-f45.google.com with SMTP id r203so17556241oib.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2017 07:41:33 -0700 (PDT)
In-Reply-To: <1f73a9c2-8f59-2636-0685-3ede755648aa@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, gpiccoli@linux.vnet.ibm.com

On Wed, Apr 5, 2017 at 6:13 AM, Mauricio Faria de Oliveira
<mauricfo@linux.vnet.ibm.com> wrote:
> Hi Dan,
>
> Thanks for reviewing.
>
> On 04/04/2017 06:07 PM, Dan Williams wrote:
>>>
>>> @@ -594,6 +594,10 @@ static ssize_t get_component_power_status(struct
>>> device *cdev,
>>>
>>>         if (edev->cb->get_power_status)
>>>                 edev->cb->get_power_status(edev, ecomp);
>>> +
>>> +       if (ecomp->power_status == -1)
>>> +               return -EINVAL;
>>> +
>>
>> Can we ever hit this if get_power_status is non-null?
>
>
> I admit that is cautionary, and more for consistency with the chance
> of an uninitialized state being still in place, so not to return any
> (incorrect) value in that state.
>
> But, yes, in a few cases -- although unlikely.
>
> 1) imagine .get_power_status couldn't update the 'power_status' field
>    (it's a bit unlikely with the in-tree ses driver, but in the case
>     that ses_get_page2_descriptor() returns NULL, ses_get_power_status()
>     doesn't update 'power_status').

Ok, in that case we should probably return -EIO, if get_power_status
is non-NULL, but the power_status is still -1.

> 2) an out-of-tree module employs another enclosure_component_callbacks
>    structure, which doesn't implement a .get_power_status hook.

If get_power_status is null and power_status is -1 I think we should
return -ENOTTY to indicate the failure.

> 3) or it does, but that failed, and didn't update 'power_status' (e.g.,
>    like case 1)

I think we're back -EIO for this.

>
>
>>> +static bool power_status_on_probe;     /* default: false, 0. */
>>> +module_param(power_status_on_probe, bool, 0644);
>>> +MODULE_PARM_DESC(power_status_on_probe, "get power status of SES device
>>> slots "
>>> +                                       "(enclosure components) at probe
>>> time "
>>> +                                       "(warning: may delay total probe
>>> time)");
>>> +
>>
>> I don't think we need this module parameter as long as the only way to
>> read the power status is through sysfs. We can always just leave it to
>> be read on-demand when needed.
>
>
> I agree for the in-tree module.  My only concern, as described in the
> commit message, is the case someone is using an out-of-tree module /
> has an implementation that depends on that (e.g., reading the 'power_
> status' field directly, instead of using .get_power_status.
>
> I've been a bit overzealous when considering why that call was inserted
> in ses_enclosure_data_process(), and didn't want to break them.
>
> However, for an in-tree usage, it's clear that just dropping that line
> seemed to be sufficient -- the rest in the patch is just consideration
> for whoever might be using it in out-of-tree ways.
>
> (and if such consideration is deemed not to be required in this case,
>  I'd be fine with dropping the related changes and making this patch
>  a one-line. :- )

Let's not carry module parameters that only theoretically help an out
of tree module. If such a driver exists its owner can just holler if
this policy change breaks their usage, and then we can have a
discussion about why their driver isn't upstream already.
