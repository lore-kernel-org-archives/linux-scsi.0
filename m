From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: ses: don't get power status of SES device slot on
 probe
Date: Wed, 5 Apr 2017 10:13:15 -0300
Message-ID: <1f73a9c2-8f59-2636-0685-3ede755648aa@linux.vnet.ibm.com>
References: <1490835730-13181-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <CAPcyv4jqgh97JVnWMFC5kLJDeu6zaY2zZtaYAHTM0w2a0hBmSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37087 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753722AbdDENNb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 09:13:31 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v35D8iD5115163
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 09:13:31 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29n075ks12-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2017 09:13:30 -0400
Received: from localhost
        by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 5 Apr 2017 10:13:28 -0300
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v35DDQ2934472190
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 10:13:26 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v35DDPi5005489
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 10:13:26 -0300
In-Reply-To: <CAPcyv4jqgh97JVnWMFC5kLJDeu6zaY2zZtaYAHTM0w2a0hBmSw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, gpiccoli@linux.vnet.ibm.com

Hi Dan,

Thanks for reviewing.

On 04/04/2017 06:07 PM, Dan Williams wrote:
>> @@ -594,6 +594,10 @@ static ssize_t get_component_power_status(struct device *cdev,
>>
>>         if (edev->cb->get_power_status)
>>                 edev->cb->get_power_status(edev, ecomp);
>> +
>> +       if (ecomp->power_status == -1)
>> +               return -EINVAL;
>> +
> Can we ever hit this if get_power_status is non-null?

I admit that is cautionary, and more for consistency with the chance
of an uninitialized state being still in place, so not to return any
(incorrect) value in that state.

But, yes, in a few cases -- although unlikely.

1) imagine .get_power_status couldn't update the 'power_status' field
    (it's a bit unlikely with the in-tree ses driver, but in the case
     that ses_get_page2_descriptor() returns NULL, ses_get_power_status()
     doesn't update 'power_status').

2) an out-of-tree module employs another enclosure_component_callbacks
    structure, which doesn't implement a .get_power_status hook.

3) or it does, but that failed, and didn't update 'power_status' (e.g.,
    like case 1)


>> +static bool power_status_on_probe;     /* default: false, 0. */
>> +module_param(power_status_on_probe, bool, 0644);
>> +MODULE_PARM_DESC(power_status_on_probe, "get power status of SES device slots "
>> +                                       "(enclosure components) at probe time "
>> +                                       "(warning: may delay total probe time)");
>> +
> I don't think we need this module parameter as long as the only way to
> read the power status is through sysfs. We can always just leave it to
> be read on-demand when needed.

I agree for the in-tree module.  My only concern, as described in the
commit message, is the case someone is using an out-of-tree module /
has an implementation that depends on that (e.g., reading the 'power_
status' field directly, instead of using .get_power_status.

I've been a bit overzealous when considering why that call was inserted
in ses_enclosure_data_process(), and didn't want to break them.

However, for an in-tree usage, it's clear that just dropping that line
seemed to be sufficient -- the rest in the patch is just consideration
for whoever might be using it in out-of-tree ways.

(and if such consideration is deemed not to be required in this case,
  I'd be fine with dropping the related changes and making this patch
  a one-line. :- )

cheers,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
