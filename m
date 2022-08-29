Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4870ECAAD2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 09:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiH2JGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 05:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiH2JGw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 05:06:52 -0400
Received: from out29-170.mail.aliyun.com (out29-170.mail.aliyun.com [115.124.29.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA01657E38;
        Mon, 29 Aug 2022 02:06:49 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07815871|-1;BR=01201311R101S09rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00625813-0.00362955-0.990112;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047199;MF=michael@allwinnertech.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.P2U-Gt-_1661764004;
Received: from 192.168.220.136(mailfrom:michael@allwinnertech.com fp:SMTPD_---.P2U-Gt-_1661764004)
          by smtp.aliyun-inc.com;
          Mon, 29 Aug 2022 17:06:47 +0800
Message-ID: <e69414ae-3181-5c33-d625-f30867869836@allwinnertech.com>
Date:   Mon, 29 Aug 2022 17:06:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] scsi: core: Fix block I/O error of USB card reader during
 resume
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220817083438.118293-1-michael@allwinnertech.com>
 <ceba3c96-5f32-9b5a-bacc-0eb942b9b90b@acm.org>
 <6412c518-426a-69a4-e419-83dc97bebe27@allwinnertech.com>
 <5ba28a61-0aa2-14d7-61f0-0e9316844f70@acm.org>
From:   Michael Wu <michael@allwinnertech.com>
In-Reply-To: <5ba28a61-0aa2-14d7-61f0-0e9316844f70@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/27/2022 6:05 AM, Bart Van Assche wrote:
> On 8/23/22 03:16, Michael Wu wrote:
>> Yes... My patch did seem suspicious. Here's the scene about the block 
>> I/O error: Some card reader does not respond the command 'MEDIUM 
>> REMOVAL PREVENT' correctly, as a result, the host does not send 
>> subsequent cmd 'MEDIUM REMOVAL ALLOW'/'MEDIUM REMOVAL PREVENT' 
>> before/after sleep, which leads to a enumeration failure after system 
>> resume.
>> I wonder, without changing the behavior of the device, is there's a 
>> better way to solve this? -- Modifying the scsi core should not be a 
>> good idea though :(
> 
> The above is not clear to me. My understanding is that "MEDIUM REMOVAL 
> PREVENT" is a sense code instead of a SCSI command?
> 
>> Thanks for your kindly notice. I looked around in the latest linux 
>> mainline repo, but could not find this code. Where can I get this 2002 
>> version of scsi_lib.c? Thank you.
> 
> Please take a look at 
> https://stackoverflow.com/questions/3264283/linux-kernel-historical-git-repository-with-full-history. 
> That web page has instructions for how to configure a git repository 
> such that history goes back before the time when Linus started using git.
> 
> Bart.
> 
Dear Bart,
Thank you. I'll try to figure it out and sync to you later.

-- 
Regards,
Michael Wu
