Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552DBC00140
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Aug 2022 16:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbiHOQXX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 12:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiHOQXG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 12:23:06 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A480275C1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 09:21:29 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 45F5B6FC7F;
        Mon, 15 Aug 2022 16:21:28 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 27CB661C61;
        Mon, 15 Aug 2022 16:21:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id ShxPmGGPYIdo; Mon, 15 Aug 2022 16:21:27 +0000 (UTC)
Received: from [192.168.48.17] (host-104-157-202-215.dyn.295.ca [104.157.202.215])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 7EF83604B0;
        Mon, 15 Aug 2022 16:21:26 +0000 (UTC)
Message-ID: <e5560738-883a-bc38-f2fb-842648a4a0dd@interlog.com>
Date:   Mon, 15 Aug 2022 12:21:20 -0400
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
 <ce3ae6cc-bd66-6139-f503-adeee3884313@interlog.com>
 <5b83ac46-9c69-6eba-c19d-5124a022e86a@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <5b83ac46-9c69-6eba-c19d-5124a022e86a@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-08-15 09:38, Bart Van Assche wrote:
> On 8/14/22 14:07, Douglas Gilbert wrote:
>> How about lsscsi ?
>> # lsscsi
>> [0:0:0:0]    disk    Linux    scsi_debug       0191  /dev/sda
>> [1:0:0:0]    disk    Linux    scsi_debug       0191  /dev/sdb
>> [2:0:0:0]    disk    Linux    scsi_debug       0191  /dev/sdc
>> [N:0:1:1]    disk    SKHynix_HFS512GDE9X081N__1 /dev/nvme0n1
>>
>> I plan to add JSON output to lsscsi in the near future.
> 
> Hi Doug,
> 
> It was not clear to me whether or not Avri needs to retrieve the version 
> information on an Android system. Neither /proc/scsi nor lsscsi are available on 
> recent Android systems. I will see whether I can include the sg3_utils package 
> in Android.

The lsscsi utility is in a package by itself. It is Linux specific and
does sysfs datamining so it does not need:
    - root access,
    - to issue SCSI commands, nor
    - any support from libsgutils

Adding JSON complicates that picture a little as I use a slightly modified
https://github.com/json-parser/json-builder (license: BSD-2-Clause) in
sg3_utils. Smaller bits of libsgutils have been spun off (e.g.
sg_unaligned.h is used as-is in smartmontools) and I will probably do
something similar for JSON support in lsscsi.

Doug Gilbert

