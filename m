Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6884C38145
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 16:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiIHQsU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 12:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIHQsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 12:48:18 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A70184EEF
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 09:48:17 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id b144so13723934pfb.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 09:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=PeZGwymXtBGFKuCMR4erF/KaOJdEDcKCrw2TQel6Z4M=;
        b=usUbdpU4NXCuJRfpwhW8xk+LBsj97w1g8rjY16V22/Oz4gL4YtDUY40PE1hN6ulljB
         M8/7Jlmm3Z9QxY14IoVIJIdYZocsMbnzxz93rQyoXMyPWkxBha3liHHlHDVIPpuqcds8
         EmToHdmbznQuFN/I3xCUGM0mBPjpu9Mm5LVkn+TZV+edIkS+4rDAjcXr/qe1qch/FzcY
         h4+QKWmn83564PsuO3E6U2NzwYi2elqLbGAqc5+Ym7UCg8GGim68ox6N/vEbzIMGdcor
         8A2WtGapfB4ftjFEmKnHiMBco7YFOY9C0r+qifnRuiLBP7yZMSpQ/Dct/ThJSBfzrpbz
         dUDg==
X-Gm-Message-State: ACgBeo29Ja9UQP1dEFkMgwXBazRwpHc7cgxMFh98FYErqqtOS+h+0EBp
        OOGpuqz/ZnFM6s84yzZlwW6hX5UR6Lk=
X-Google-Smtp-Source: AA6agR7iBOfVP5X7307nEfY7A4Z/gUEY6lxSXOzMWYLsoCwCGWVzykR1PsEr/If9JFUR41VqSJ6zyA==
X-Received: by 2002:a63:6948:0:b0:433:5e5b:54b2 with SMTP id e69-20020a636948000000b004335e5b54b2mr8485887pgc.286.1662655696756;
        Thu, 08 Sep 2022 09:48:16 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:71db:3cdf:3590:2e95? ([2620:15c:211:201:71db:3cdf:3590:2e95])
        by smtp.gmail.com with ESMTPSA id b77-20020a621b50000000b0053b2681b0e4sm6463376pfb.67.2022.09.08.09.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 09:48:16 -0700 (PDT)
Message-ID: <8f0c0748-d8dd-6771-6ee3-c8534178012b@acm.org>
Date:   Thu, 8 Sep 2022 09:48:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 2/2] scsi: core: Introduce a new list for SCSI proc
 directory entries
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220830210509.1919493-1-bvanassche@acm.org>
 <20220830210509.1919493-3-bvanassche@acm.org>
 <1a530d46-03e3-0ec4-b633-3ebd2297a525@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1a530d46-03e3-0ec4-b633-3ebd2297a525@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/8/22 09:03, Mike Christie wrote:
> On 8/30/22 4:05 PM, Bart Van Assche wrote:
>>   void scsi_proc_host_rm(struct Scsi_Host *shost)
>>   {
>> +	struct scsi_proc_entry *e;
>>   	char name[10];
>>   
>> -	if (!shost->hostt->proc_dir)
> 
> 
> Hey Bart, Would it better to replace those two checks with a
> 
> if (!sht->show_info)
> 	return;
> 
> like is done in scsi_proc_hostdir_add/scsi_proc_hostdir_rm? In those
> hostdir functions if show_info is not set, you will not add an entry to
> scsi_proc_list. So in the above functions if that callout is not set
> you know there is no entry on &scsi_proc_list and don't need to grab the
> global_host_template_mutex for those cases.

That sounds like an interesting idea to me.

> I can't really test but someone did say they had 1000s of scsi_hosts for
> iscsi. I'm not really sure how big a deal it is since we wouldn't be
> doing a lot of work with that mutex hold, but it seems like a simple and
> nice change just in case.

How about switching from a linked list to a hash table?

Thanks,

Bart.
