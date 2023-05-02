Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47601C77B78
	for <linux-scsi@archiver.kernel.org>; Tue,  2 May 2023 23:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjEBXwQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 May 2023 19:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjEBXwP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2023 19:52:15 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB85030E4;
        Tue,  2 May 2023 16:52:13 -0700 (PDT)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 7630B75874;
        Tue,  2 May 2023 23:52:12 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id 641F63364A;
        Tue,  2 May 2023 23:52:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id nH8Ha2tdXozh; Tue,  2 May 2023 23:52:12 +0000 (UTC)
Received: from [192.168.48.17] (host-192.252-165-26.dyn.295.ca [192.252.165.26])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 6F18D33649;
        Tue,  2 May 2023 23:52:11 +0000 (UTC)
Message-ID: <585941de-3e17-d5aa-311b-17773c6fbf1f@interlog.com>
Date:   Tue, 2 May 2023 19:52:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2 0/6] scsi:scsi_debug: Add error injection for single
 device
To:     Wenchao Hao <haowenchao2@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linfeilong@huawei.com, louhongxiang@huawei.com
References: <20230428013320.347050-1-haowenchao2@huawei.com>
Content-Language: en-CA
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20230428013320.347050-1-haowenchao2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023-04-27 21:33, Wenchao Hao wrote:
> The original error injection mechanism was based on scsi_host which
> could not inject fault for a single SCSI device.
> 
> This patchset provides the ability to inject errors for a single
> SCSI device. Now we supports inject timeout errors, queuecommand
> errors, and hostbyte, driverbyte, statusbyte, and sense data for
> specific SCSI Command.
> 
> The first two patch add an debugfs interface to add and inquiry single
> device's error injection info; the third patch defined how to remove
> an injection which has been added. The following 3 patches use the
> injection info and generate the related error type.
> 
> V2:
>    - Using debugfs rather than sysfs attribute interface to manage error
> 
> Wenchao Hao (6):
>    scsi:scsi_debug: create scsi_debug directory in the debugfs filesystem
>    scsi:scsi_debug: Add interface to manage single device's error inject
>    scsi:scsi_debug: Define grammar to remove added error injection
>    scsi:scsi_debug: timeout command if the error is injected
>    scsi:scsi_debug: Return failed value if the error is injected
>    scsi:scsi_debug: set command's result and sense data if the error is
>      injected
> 
>   drivers/scsi/scsi_debug.c | 318 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 318 insertions(+)

Been playing around with this patchset and it seems to work as expected. Took me
a while to work my way through interface description at the beginning of
   [PATCH v2 2/6] scsi:scsi_debug: Add interface to manage single device's error 
inject

so I cut and paste it into my scsi_debug.html page and did some work on it, see:
    https://doug-gilbert.github.io/scsi_debug.html

There is a new chapter titled: Per device error injection
Kept the ASCII art so it could be ported back to [PATCH v2 2/6]'s description
if Wenchao is agreeable.

So for the whole series:
   Acked-by: Douglas Gilbert <dgilbert@interlog.com>


One suggestion for later work: perhaps the Command opcode field could be
expanded to: x8[,x16] so optionally a Service Action (in hex) could be
given (e.g. '9e,10' for the READ CAPACITY (16) command).

Doug Gilbert

