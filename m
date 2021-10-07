Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E907BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 09:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB66A61019
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 09:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240592AbhJGJkO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 05:40:14 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:52659 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232678AbhJGJkN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Oct 2021 05:40:13 -0400
Received: from [192.168.0.2] (ip5f5aef71.dynamic.kabel-deutschland.de [95.90.239.113])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id ECEA561E64784;
        Thu,  7 Oct 2021 11:38:17 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH V2 09/11] smartpqi: fix duplicate device
 nodes for tape changers
To:     Don Brace <Don.Brace@microchip.com>
Cc:     Kevin.Barnett@microchip.com, Scott.Teel@microchip.com,
        Justin.Lindley@microchip.com, Scott.Benesh@microchip.com,
        Gerry.Morong@microchip.com, Mahesh.Rajashekhara@microchip.com,
        Mike.McGowen@microchip.com, Murthy.Bhat@microchip.com,
        Balsundar.P@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, john.p.donnelly@oracle.com,
        mwilck@suse.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
References: <20210928235442.201875-1-don.brace@microchip.com>
 <20210928235442.201875-10-don.brace@microchip.com>
 <1351a25f-5310-cae3-ae47-01c842e0a185@molgen.mpg.de>
 <SN6PR11MB2848E6A6F6824C55641FB6FEE1AF9@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <3d4832bd-9781-9194-2b33-a0e20a9ff913@molgen.mpg.de>
Date:   Thu, 7 Oct 2021 11:38:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848E6A6F6824C55641FB6FEE1AF9@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Don,


Am 05.10.21 um 22:23 schrieb Don.Brace@microchip.com:

>> Our controller FW lists both LUNs in the RPL results.
> 
> Please document the firmware version (and controller) you tested with in the commit message.
> 
> DON: Done in V3, thanks for your review.

When I understood Martin correctly, he already pulled the patches in. 
It’d be great if you added it in an answer then.

> Shortly describing the implementation (new struct member ignore_device) would be nice.
> DON: Don in V3, thanks for your review.
> 
>>        u8      rescan : 1;
>> +     u8      ignore_device : 1;
> 
> Why not type bool?
> Don: They both take the same amount of memory and since the other members are also u8, the new member was also u8 for consistency.

Well, the below struct members are declared as bool.

         u8      volume_offline : 1;
         u8      rescan : 1;
         bool    aio_enabled;            /* only valid for physical disks */

It’d be great, if you could clean that up in the future.

>> -                     device->lun = sdev->lun;
>> -                     device->target_lun_valid = true;
> 
> Off topic, with `u8 target_lun_valid : 1`, why is `true` used.
> Don: Has the same behavior, and carried forward from other member fields.

In my opinion, if bool is used, true/false should be used too.

>> +                     if (device->target_lun_valid) {
>> +                             device->ignore_device = true;
>> +                     } else {
>> +                             device->target = sdev_id(sdev);
>> +                             device->lun = sdev->lun;
>> +                             device->target_lun_valid = true;
>> +                     }
> 
> If the LUN should be ignored, is it actually valid? Why not extend target_lun_valid and add a third option (enums?) to ignore it?
> 
> Don: The reason is that it takes advantage of the order the devices are added and how slave_alloc and slave_configure fit into this order.

Ok. My answer should have also been to use a bitfield. Sorry about that. 
It does not look nice to me to add new attributes to work around 
firmware isuses.

>> +     return device->devtype == TYPE_TAPE || device->devtype ==
>> +TYPE_MEDIUM_CHANGER;
> 
> Why also check for TYPE_TAPE? The function name should be updated then?
> Don: Because our tape changer consisted of the changer and one or more tape units and both were duplicated.

Yes, I figured. But the function name is still incorrect/misleading then?

>>    static int pqi_slave_configure(struct scsi_device *sdev)
>> +     if (pqi_is_tape_changer_device(device) && device->ignore_device) {
>> +             rc = -ENXIO;
>> +             device->ignore_device = false;
> 
> I’d add a `return -ENXIO` here, and remove the variable.
> Don: This works in conjunction with slave_alloc and is needed.

Instead of

+	if (pqi_is_tape_changer_device(device) && device->ignore_device) {
+		rc = -ENXIO;
+		device->ignore_device = false;
+	}
+
+	return rc;

I meant

+	if (pqi_is_tape_changer_device(device) && device->ignore_device) {
+		device->ignore_device = false;
+		return -ENXIO;
+	}
+
+	return 0;

Lastly, some (debug) log messages would always be helpful in my opinion, 
if stuff is worked around.


Kind regards,

Paul
