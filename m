Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7494E82CAB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 16:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbjI0QDN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 12:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjI0QDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 12:03:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF00B30C7;
        Wed, 27 Sep 2023 08:52:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67364C433C7;
        Wed, 27 Sep 2023 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695829947;
        bh=XE6IRm/qPb5ydUnPslE/44F4AsycyvGXOdRWqW3ikI0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=butvh9xmh3IsfnVqYp1myW4ClpvA1sWtmpJ2aM2MuCLBrjF7UihLnUB+6V7b8sY3S
         91VAxfHM6akPpoaFxK03ADI+2htltu322ZMe6ALuT/j9D0NdK2Wgk9PT1XMVejlLkj
         EM+cvJQY2aduICZW74ouPUSwojotH2roGFjP02hksDvvkYrz07Suk9MAxwHGFu7gIi
         RyfPJR0yZ9QkLMonPGbPC4Q1JPykqTsRtJLAn/8HeOThCr80AvQI+zY97OHg94wxkH
         eZCdXj/l5JNXZbYQ8enxKLqPeirDDgyWRsBUMCjoYIz8oENHN2hPr2FBp7h1kn2OgH
         X5zk9vPqq/48g==
Message-ID: <901bcb25-1b30-6d36-c838-33944e0260ec@kernel.org>
Date:   Wed, 27 Sep 2023 17:52:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v7 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230926081507.69346-1-dlemoal@kernel.org>
 <20230926081507.69346-10-dlemoal@kernel.org>
 <540deb44-d213-4c55-8227-894b74eae27c@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <540deb44-d213-4c55-8227-894b74eae27c@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/27 16:55, Bart Van Assche wrote:
> On 9/26/23 01:14, Damien Le Moal wrote:
>> @@ -3891,21 +3895,26 @@ static int sd_suspend_runtime(struct device *dev)
>>   static int sd_resume(struct device *dev, bool runtime)
>>   {
>>   	struct scsi_disk *sdkp = dev_get_drvdata(dev);
>> -	int ret;
>> +	int ret = 0;
>>   
>>   	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
>>   		return 0;
> 
> As far as I can tell there is nothing that prevents system wide
> suspend or resume after a SCSI disk has been discovered and before
> sd_probe() is called(). So I think that "sdkp->suspended = false;"
> has to be added in the above if-statement. This is the how SCSI
> disks are registered (synchronous case only):

The above if statement being "if (!sdkp)", if I add "sdkp->suspended = false;",
I will get a NULL pointer dereference. So I do not understand your point here...

> 
> scsi_probe_and_add_lun(target, bflagsp, sdevp, rescan, hostdata)
>    scsi_alloc_sdev(starget, lun, hostdata)
>      __scsi_init_queue(&sdev->host)
>      scsi_sysfs_device_initialize(sdev)
>      shost->hostt->slave_alloc(sdev)
>    scsi_probe_lun(sdev, ...)
>      scsi_execute_req(sdev, INQUIRY)
>    scsi_add_lun(sdev, ...)
>      scsi_device_set_state(sdev, SDEV_RUNNING)
>      sdev->host->hostt->slave_configure(sdev) /* may do I/O */
>      scsi_sysfs_add_sdev(sdev) /* enables runtime PM */
>        scsi_target_add(starget)
>        device_add(&sdev->sdev_gendev)
>          kobject_add(&dev->kobj, ...)
>          bus_add_device(dev)
>          bus_probe_device(dev)
>            device_initial_probe(dev)
>              __device_attach(dev, /*allow_async=*/true)
>                __device_attach_driver(drv, dev, ...)
>                  driver_probe_device(drv, dev)
>                    really_probe(dev, drv)
>                      dev->bus->probe(dev) = sd_probe(dev)
>                        gd = blk_mq_alloc_disk_for_queue()
>                        device_add(&sdkp->dev)
>                        sd_revalidate_disk(gd)
>                        device_add_disk(dev, gd, NULL)
>        device_add(&sdev->sdev_dev)
>        bsg_scsi_register_queue(rq, &sdev->sdev_gendev)
> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

