Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19F9C25B06
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Aug 2022 21:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiHNVIG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Aug 2022 17:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiHNVIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2022 17:08:05 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8856348
        for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2022 14:08:04 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 542C9700F6;
        Sun, 14 Aug 2022 21:08:03 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 3805B60951;
        Sun, 14 Aug 2022 21:08:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id qSndPJHais2W; Sun, 14 Aug 2022 21:08:02 +0000 (UTC)
Received: from [192.168.48.17] (host-104-157-202-215.dyn.295.ca [104.157.202.215])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 3939D60556;
        Sun, 14 Aug 2022 21:08:01 +0000 (UTC)
Message-ID: <ce3ae6cc-bd66-6139-f503-adeee3884313@interlog.com>
Date:   Sun, 14 Aug 2022 17:07:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 0/4] Remove procfs support
Content-Language: en-CA
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220812204553.2202539-1-bvanassche@acm.org>
 <DM6PR04MB6575F397E1B519922D3C2C5AFC699@DM6PR04MB6575.namprd04.prod.outlook.com>
 <e71a33f6-0a65-561b-33b9-6772239c21df@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <e71a33f6-0a65-561b-33b9-6772239c21df@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-08-14 10:27, Bart Van Assche wrote:
> On 8/14/22 05:54, Avri Altman wrote:
>>> The SCSI sysfs interface made the procfs interface superfluous. sysfs support
>  >
>> Field application engineers are using #cat /proc/scsi/scsi to get the 
>> devices's fw version - Rev: xxx
>> Where should they look for that now?
> 
> Hi Avri,
> 
> Please take a look at the output of the following command:
> 
> find /sys -name inquiry | xargs grep -aH .

# find /sys -name inquiry | xargs grep -aH .
/sys/devices/pseudo_0/adapter1/host1/target1:0:0/1:0:0:0/inquiry:[
/sys/devices/pseudo_0/adapter1/host1/target1:0:0/1:0:0:0/inquiry:Linux 
scsi_debug      019120210520��!
/sys/devices/pseudo_0/adapter2/host2/target2:0:0/2:0:0:0/inquiry:[
/sys/devices/pseudo_0/adapter2/host2/target2:0:0/2:0:0:0/inquiry:Linux 
scsi_debug      019120210520��!
/sys/devices/pseudo_0/adapter0/host0/target0:0:0/0:0:0:0/inquiry:[
/sys/devices/pseudo_0/adapter0/host0/target0:0:0/0:0:0:0/inquiry:Linux 
scsi_debug      019120210520��!

That is on Fedora 36, lk 5.18.16-200.fc36.x86_64 . Not exactly informative
unless you already know what you are looking for.

How about lsscsi ?
# lsscsi
[0:0:0:0]    disk    Linux    scsi_debug       0191  /dev/sda
[1:0:0:0]    disk    Linux    scsi_debug       0191  /dev/sdb
[2:0:0:0]    disk    Linux    scsi_debug       0191  /dev/sdc
[N:0:1:1]    disk    SKHynix_HFS512GDE9X081N__1                 /dev/nvme0n1

I plan to add JSON output to lsscsi in the near future.

Doug Gilbert
