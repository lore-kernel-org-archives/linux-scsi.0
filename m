From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH 05/25] scsi: hisi_sas: allocate memories and create pools
Date: Tue, 13 Oct 2015 17:42:19 +0800
Message-ID: <561CD1FB.1060003@linaro.org>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <1444663237-238302-6-git-send-email-john.garry@huawei.com> <13409618.ra2GB8eyNb@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33185 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbbJMJmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2015 05:42:25 -0400
Received: by pabrc13 with SMTP id rc13so16826388pab.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2015 02:42:25 -0700 (PDT)
In-Reply-To: <13409618.ra2GB8eyNb@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, John Garry <john.garry@huawei.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de

Hi, Arnd

On 10/12/2015 11:15 PM, Arnd Bergmann wrote:
> On Monday 12 October 2015 23:20:17 John Garry wrote:
>> +       interrupt_count = of_property_count_u32_elems(np, "interrupts");
>> +       if (interrupt_count < 0)
>> +               goto err_out;
>> +
>> +       if (of_property_read_u32(np, "#interrupt-cells", &interrupt_cells))
>> +               goto err_out;
>> +
>> +       hisi_hba->int_names = devm_kcalloc(&pdev->dev,
>> +                                          interrupt_count / interrupt_cells,
>> +                                          HISI_SAS_NAME_LEN,
>> +                                          GFP_KERNEL);
>>
>
> This computation looks wrong: the "interrupts" property refers to interrupts
> that are referenced by this node and provided by an interrupt-controller,
> while the "#interrupt-cells" property refers to interrupts provided by
> this node. They don't need to have any relation.
>
We will use of_irq_count instead.

Thanks
