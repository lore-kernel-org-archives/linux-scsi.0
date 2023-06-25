Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086E7EB64DC
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Jun 2023 20:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjFYUZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Jun 2023 16:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjFYUZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jun 2023 16:25:08 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436C79B
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jun 2023 13:25:07 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1b6824141b4so23957135ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jun 2023 13:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687724706; x=1690316706;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vixwPqOZUifIbNeiDJu91f746ygXNTiMwHtUlMltqj4=;
        b=GRwFYhEyMsVUV2tNklDjkgoAk05YUwjL+2Hcdt9hX5uHSRyWbv+RzoI+J6S8uSQycn
         R732sqYXOViKAiB6hbjDUbye5fuQAL4FBFJeeE9O+1ADj92AWQ/dFaMONqbbXiT9+sJX
         n1Dt6HWK+jGG0adsjg+RqA/SwCZJs9tlx5402shaARvzey6x1YkXRYgZzUZPCL8ONzPx
         Ye3aOgcpeiYYH6iDpFgEU2eXuFf8Prr1kTF8pO16ActjRwEeSER3pwr2Z7oibN2BOS8P
         oDiQq0S8UM9KYOx7u1MPhsng95gFScDgRUu762Mog16TzovF/Ryr/DjAv8nkKZ/YriOS
         p8pg==
X-Gm-Message-State: AC+VfDwwpjPtPp9HhlZsPfjCcu12Ko4zcW6MqoiMIwmPsSh9w/jMy1Wl
        2+Gp0WFNDW3bIcffUwyYoRI=
X-Google-Smtp-Source: ACHHUZ6ina+wTSff/Qf76Kp6qaM332YloKgcvZAf0RU0CmLPOdW717Tlm2rR0u57KaWV/O7XTk6B7Q==
X-Received: by 2002:a17:902:d4c6:b0:1b6:797e:da62 with SMTP id o6-20020a170902d4c600b001b6797eda62mr7018672plg.30.1687724706339;
        Sun, 25 Jun 2023 13:25:06 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j16-20020a170902da9000b001ab0159b9edsm2746645plx.250.2023.06.25.13.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jun 2023 13:25:05 -0700 (PDT)
Message-ID: <ee3dfa22-6663-ed4a-051f-ad588e0d9544@acm.org>
Date:   Sun, 25 Jun 2023 13:25:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] scsi: sd: support specify probe type of build-in driver
Content-Language: en-US
To:     Jianlin Lv <iecedge@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, jianlv@ebay.com,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20230606051217.2064-1-iecedge@gmail.com>
 <6ad5fba3-926a-7a23-b21b-abffd33708be@acm.org>
 <CAFA-uR_Zn4MdFKs6U6dqPjuVS60yN4RcYU4jJzjknqy7-RWyEQ@mail.gmail.com>
 <e9b8b9c5-f400-9152-0f4b-537b05203dd2@acm.org>
 <CAFA-uR83jHJsDXnn-3LWcrw251S4MizHC_JPJssYrgoD6kLoAg@mail.gmail.com>
 <5b898dde-2f76-51af-5d2e-c4572719a5be@acm.org>
 <CAFA-uR_jk6jCmf9DTebSVBRwtoLuXuyvf1Biq+OObqRVAOZbBw@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAFA-uR_jk6jCmf9DTebSVBRwtoLuXuyvf1Biq+OObqRVAOZbBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/24/23 04:45, Jianlin Lv wrote:
> On Fri, Jun 9, 2023 at 12:23 AM Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> On 6/7/23 19:51, Jianlin Lv wrote:
>>> On Thu, Jun 8, 2023 at 1:07 AM Bart Van Assche <bvanassche@acm.org> wrote:
>>>> On 6/7/23 08:55, Jianlin Lv wrote:
>>>> I see two possible solutions:
>>>> - Change the volume provisioner such that it uses disk references that do
>>>>      not depend on the probing order, e.g. /dev/disk/by-id/...
>>>
>>> Yes, The "/dev/disk/by-id/" can uniquely identify SCSI devices. However,
>>> I don't think it is suitable for the volume provisioner workflow.
>>> For nodes of the same SKU , a unified YAML file will be defined to instruct
>>> the volume provisioner on how to manage the local disks.
>>> If use WWID, it would mean that a unique YAML file needs to be defined
>>> for each node. This approach becomes impractical when dealing with a large
>>> number of work nodes.
>> Please consider using the paths available in /dev/disk/by-path.
> 
> Sorry for the late reply.
> I carefully checked the server in the production environment and found
> some corner cases where there are differences in the dev/disk/by-path/ of
> nodes with the same SKU. These differences are caused by inconsistent
> target_numbers.
> 
> For example:
> 
> diff -y aa-by-path bb-by-path
> pci-0000:86:00.0-scsi-0:3:86:0 -> ../../sda |
> pci-0000:86:00.0-scsi-0:3:88:0 -> ../../sda
> pci-0000:86:00.0-scsi-0:3:87:0 -> ../../sdb |
> pci-0000:86:00.0-scsi-0:3:89:0 -> ../../sdb
> pci-0000:86:00.0-scsi-0:3:88:0 -> ../../sdc |
> pci-0000:86:00.0-scsi-0:3:90:0 -> ../../sdc
> pci-0000:86:00.0-scsi-0:3:89:0 -> ../../sdd |
> pci-0000:86:00.0-scsi-0:3:91:0 -> ../../sdd
> pci-0000:86:00.0-scsi-0:3:90:0 -> ../../sde |
> pci-0000:86:00.0-scsi-0:3:92:0 -> ../../sde
> pci-0000:86:00.0-scsi-0:3:92:0 -> ../../sdf |
> pci-0000:86:00.0-scsi-0:3:93:0 -> ../../sdf
> pci-0000:86:00.0-scsi-0:3:93:0 -> ../../sdg |
> pci-0000:86:00.0-scsi-0:3:94:0 -> ../../sdg
> pci-0000:86:00.0-scsi-0:3:94:0 -> ../../sdh |
> pci-0000:86:00.0-scsi-0:3:95:0 -> ../../sdh
> 
> I'm still not sure what causes the target_numbers to be different.
> However, the existence of such corner cases makes /dev/disk/by-path
> unusable for the volume provisioner, similar to /dev/disk/by-id/.
> 
> So, If it's not possible to configure disk serialization detection, then
> it seems that implementing predictable disk names is the only option.

I think the following code from the systemd source file 
src/udev/udev-builtin-path_id.c generates the last part of the path ID:

	[ ... ]
         if (sscanf(name, "%d:%d:%d:%d", &host, &bus, &target, &lun)!=4)
		return NULL;
	[ ... ]
         path_prepend(path, "scsi-%i:%i:%i:%i", host, bus, target, lun);
	[ ... ]

Is megasas_add_remove_devices() the code that adds SCSI devices on your 
setup? In that code I see that scsi_device_lookup() is called in a loop 
until channel and target numbers are found that are not in use. I think 
this is what makes the target numbers unpredictable on your setup. There 
must be a better way for the megaraid driver to assign a target number.

Bart.
