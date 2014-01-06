From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 6/6] scsi_debug: add ability to enable clustering
Date: Mon, 6 Jan 2014 22:00:50 +0900
Message-ID: <CAC5umyhT3MmdM+XrBFpH+zveAu_20C=qkEcL6Dra-JiWJv30oQ@mail.gmail.com>
References: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
	<1388964792-3546-7-git-send-email-akinobu.mita@gmail.com>
	<52CA036F.4030404@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:55791 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaAFNAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2014 08:00:51 -0500
Received: by mail-oa0-f43.google.com with SMTP id m1so1033519oag.30
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2014 05:00:50 -0800 (PST)
In-Reply-To: <52CA036F.4030404@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

2014/1/6 Douglas Gilbert <dgilbert@interlog.com>:
>> @@ -2787,6 +2788,7 @@ module_param_named(opts, scsi_debug_opts, int,
>> S_IRUGO | S_IWUSR);
>>   module_param_named(physblk_exp, scsi_debug_physblk_exp, int, S_IRUGO);
>>   module_param_named(ptype, scsi_debug_ptype, int, S_IRUGO | S_IWUSR);
>>   module_param_named(removable, scsi_debug_removable, bool, S_IRUGO |
>> S_IWUSR);
>> +module_param_named(clustering, scsi_debug_clustering, bool, S_IRUGO);
>
>
> Umm, clustering is writeable, so: S_IRUGO | S_IWUSR

OK, it makes sense to make this parameter writable when we adds
scsi_debug hosts dynamically through 'add_host' driver attribute.

>>   module_param_named(scsi_level, scsi_debug_scsi_level, int, S_IRUGO);
>>   module_param_named(sector_size, scsi_debug_sector_size, int, S_IRUGO);
>>   module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int,
>> S_IRUGO);
>> @@ -3953,6 +3955,8 @@ static int sdebug_driver_probe(struct device * dev)
>>         sdbg_host = to_sdebug_host(dev);
>>
>>         sdebug_driver_template.can_queue = scsi_debug_max_queue;
>> +       if (scsi_debug_clustering)
>> +               sdebug_driver_template.use_clustering = ENABLE_CLUSTERING;
>>         hpnt = scsi_host_alloc(&sdebug_driver_template,
>> sizeof(sdbg_host));
>>         if (NULL == hpnt) {
>>                 printk(KERN_ERR "%s: scsi_register failed\n", __func__);
>>
>
> And please document this extra parameter for modinfo.
> Something like:
>   MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=0)");
>
> placed in alphabetical order.

I'll update this patch and resend it.

Thanks for your review.
