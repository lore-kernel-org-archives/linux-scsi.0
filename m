Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09663C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 17:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E81B160F4A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 17:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbhI0RkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 13:40:03 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:44802 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237875AbhI0Rio (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 13:38:44 -0400
Received: by mail-pf1-f182.google.com with SMTP id 145so16507479pfz.11
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 10:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DQVknjMwYPZL2nVAD1Hmb7J+N2/rhSePPmhEZrtPJlg=;
        b=Wn4yiBIV6tC0MsYpMj0qh43/MKs35p8XNlYvWWAYRQdYERIO0BrROhabN+Wf3eAJX3
         0be61FgoPZPnIa5wRZbZGvKaFk+qCFZRZnaFWSVIR2//lRvMho9jj1CLxl+RCYGeEoT8
         OFHM06frQdtD5n3J0OaBHDWbNfjvwv7Ofb0Dgdc1w1Z1WyyuSA3+A39o11RVDZLm0/hd
         zYewnP8II1QMmsWbDXdo0Z7aF2HlmKqAmzk/g4CB3zL09CcFLISlH6qqu7vQm5Rj1EPO
         tgSrgb6l7qTT9tYfsBGLW/XenAnZTmhhWPgfvSFziYGnuBneeBMwuD+voBZ6Q/YxqrqO
         bKYg==
X-Gm-Message-State: AOAM532IXkqKZ+A/pRQaeu1QU6YvMTaBQaB4gpQm+LKfH6nNogQIoEoc
        x/1Dd+A999gbisNmlDqKqEI=
X-Google-Smtp-Source: ABdhPJwOVvcQhG+wY+e2mGazhmC7ebnn94Kq+kU8YK3Rx/hskCf+WR293x5SKA5mr80a71n8QnzjRw==
X-Received: by 2002:a63:2a07:: with SMTP id q7mr726893pgq.221.1632764226114;
        Mon, 27 Sep 2021 10:37:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:eed8:744a:6ba3:d1b])
        by smtp.gmail.com with ESMTPSA id 130sm4848033pfz.77.2021.09.27.10.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 10:37:05 -0700 (PDT)
Subject: Re: [PATCH 2/2] scsi: Register SCSI device sysfs attributes earlier
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Don Brace <don.brace@microchip.com>,
        Brian King <brking@us.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Hannes Reinecke <hare@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
References: <20210924232635.1637763-1-bvanassche@acm.org>
 <20210924232635.1637763-3-bvanassche@acm.org> <YU7l02I/eT3+8410@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7e38336a-cb2d-61fc-b1b8-babb99d74cd3@acm.org>
Date:   Mon, 27 Sep 2021 10:37:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YU7l02I/eT3+8410@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/25/21 2:03 AM, Greg Kroah-Hartman wrote:
> On Fri, Sep 24, 2021 at 04:26:35PM -0700, Bart Van Assche wrote:
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -226,6 +226,8 @@ struct scsi_device {
>>   
>>   	struct device		sdev_gendev,
>>   				sdev_dev;
>> +	struct attribute_group  gendev_first_attr_group;
>> +	const struct attribute_group *gendev_attr_groups[6];
> 
> Where does 6 come from?

1 + 4 + 1: one array entry for the SCSI core sysfs attributes, four for the
device driver attributes (this is the current limit) and one entry for the NULL
terminating entry.

>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index 5afdc094a445..aa1207ab9d2e 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -481,7 +481,7 @@ struct scsi_host_template {
>>   	/*
>>   	 * Pointer to the SCSI device properties for this host, NULL terminated.
>>   	 */
>> -	struct device_attribute **sdev_attrs;
>> +	struct attribute **sdev_attrs;
> 
> Same here, "const struct attribute_group **groups;" ?

I will make this change.

Thanks,

Bart.
