Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9435CA0EC3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 09:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbjILJBr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 05:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbjILJB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 05:01:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743E310DE;
        Tue, 12 Sep 2023 02:00:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6369C433C9;
        Tue, 12 Sep 2023 09:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694509256;
        bh=uB6NBCia8j7lCfVRxg9y7/CUA7Jyy1+qX4ogEzcYYQ4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nZzQxemJGTrIHrso+LPiYkb4EfRP3YptYERjm/oCqNSSIWyIfi0mHDY9gpE9texJp
         I0iyuU9GURdF9PyVOmEQsqN08C3XwozT27E5RS3wE9uvETt+t5kERGJCBOrt9DyfqY
         i0AF58xyjvSWgXdscI7a8b9sbuN3LGkzo2K0g7hHbprD4nYoFsPAePzJrDQqMmVocF
         5gBDG1hfWpR3MKWVai+om5Inw8Ce9o0F7+8SLl8L++zewkh0Qr97Ic8M8zkMO+LjoN
         WLPu0qv6/tjcYJNx+8rBb4+PbH09m9MGxE9SaFfYrxDqhm3cRr9ft1LoPou1Qdsbt5
         Z9gTMeD2fOfhA==
Message-ID: <7f690cc0-cfc1-8e31-debe-baac032d97da@kernel.org>
Date:   Tue, 12 Sep 2023 18:00:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 03/19] ata: libata-scsi: link ata port and scsi device
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-4-dlemoal@kernel.org>
 <e8ca70d1-9c88-4a80-83e4-a65f4bbe6b72@suse.de>
 <8874a3d5-355e-c354-fd85-0dfa7ab77b54@kernel.org>
 <5825b4b9-0bc8-4c27-d576-070c7113e1f8@oracle.com>
 <f56e4e80-1905-0dcd-fb59-aaba7a9f8adb@kernel.org>
 <764fa7a6-109f-0ea5-5d25-3e39874e9c8a@oracle.com>
 <b3af36cd-a126-24ac-739c-5d1a192c2b2b@kernel.org>
 <bb89fdf9-7f7a-c7ee-7295-edbb4563dd2a@oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <bb89fdf9-7f7a-c7ee-7295-edbb4563dd2a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/23 17:49, John Garry wrote:
>> +int sas_ata_slave_configure(struct scsi_device *sdev)
>> +{
>> +       struct domain_device *dev = sdev_to_domain_dev(sdev);
>> +       struct ata_port *ap = dev->sata_dev.ap;
>> +       struct device *sdev_dev = &sdev->sdev_gendev;
>> +       struct device_link *link;
>> +
>> +       ata_sas_slave_configure(sdev, ap);
>> +
>> +       link = device_link_add(sdev_dev, &ap->tdev,
>> +                              DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
> 
> I am not sure what is the point of this. For libsas/pm8001 driver, there 
> is no ata_port -> .. -> host dev link, right? If so, it just seems that 
> you are are adding a dependency to a device (&ap->tdev) which has no 
> dependency to a real device itself.

For libata, the point is to have PM order suspend resume operations correctly:
suspend: scsi dev first, then ata_port
resume: ata_port first then scsi dev

Strictly speaking, we should do that with ata_dev and scsi dev, but libata PM
operations are defined for ata_port, not ata_dev.

For libsas, the PM operations come from scsi, so scsi bus operations for
devices. And given that:
1) we should already have the dev chain:
hba dev -> scsi host ->scsi target -> scsi dev
2) libsas does its own ata PM control when suspending & resuming the HBA (if I
understand things correctly)

we should thus not need anything special for libsas. ata devices suspend/resume
will be done in the right order without an extra link. I do not really
understand why hisi_sas need to create that link. If it is indeed needed, then
we probably should have it created always by libsas generic code...

-- 
Damien Le Moal
Western Digital Research

