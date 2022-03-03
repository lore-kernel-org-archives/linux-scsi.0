Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC56C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 18:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbiCCShg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 13:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiCCShe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 13:37:34 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BB419E002
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 10:36:47 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id u10so7563172wra.9
        for <linux-scsi@vger.kernel.org>; Thu, 03 Mar 2022 10:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gSsCl/XOESNqiNL4KQnFJzGeYGKZJS/OXefqIbgZZJY=;
        b=xv4zkThkBLX7HuXqZhTfHDYEZKNHRIBCccoLghrxv746zdKoMUitS4RnI/cGuGlDPQ
         vfANpAF7D/SOQuhdavvwEHHH47Qe4rpi+IsklXWeODKqDiVmFthh1F6OigEyCr/o27Gd
         Zlx44ZPUSEX8vFl2XZ5eEXc5WRHRksczAMyu2nxfK4OXd4FLzkuC7Fx+PO2LKk4Sj7k2
         lAVUF6SBc5gRRYNmWr6bFsQFcG3+ERQzr4uXhWYF+qnNkFDC0G+4pOrPugWGltcGxKei
         uHeqxuFvKXtDxibeNqrmYwAlqmHnsFQKAUqkvIDqpRvMP9f5y/5Uw4MYYGF+P4M4GCG4
         9b4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gSsCl/XOESNqiNL4KQnFJzGeYGKZJS/OXefqIbgZZJY=;
        b=PwOS32gb0+tAi/BE5OAQqPAkwoY2LcICZdksN5Vn+/iqIPcTtHFd3eyLBOBi0of5zt
         7o2E+PrG9vnt22S3bzpxHRiZC1eI6IqJctta9UyTRabRp9Pa4AaEtEFQEfDwW9JWRGte
         hebTd4bslei3xHzN2pyOdvBEY3AEG3XcK6ROI4IAJuFuqluU37L6/t4JGwQcuCpy991G
         dxFmOl3qaEWeK2oCHrY9JPEc/D5jBNARQK2fanEdWUUCi5OEMK3hDM5DI1aMGjXr7Jpr
         uri1BuY0uMR54I05aMVBYV5rUTLd48hD1kLr3Cf+2bl484/UDJ+az3NtxGs3dlgTWvhG
         LJpA==
X-Gm-Message-State: AOAM531NNv6ThdoBytRmwp1S0Vm1Wkraw+2apzrlAOkaSoYeCS0LcUeI
        CXrcqxb/11DfzYzZ0zw4dEcYhw==
X-Google-Smtp-Source: ABdhPJxWp//CMSQXMH4wlOTWsuUAaFU8DcmiZw37tn30FWgGhLmSgbx50j5GThznhd1HjqQ4Zon/5g==
X-Received: by 2002:a5d:61cb:0:b0:1f0:2598:88ff with SMTP id q11-20020a5d61cb000000b001f0259888ffmr7318696wrv.444.1646332605416;
        Thu, 03 Mar 2022 10:36:45 -0800 (PST)
Received: from [172.16.10.50] (213.16.240.129.dsl.dyn.forthnet.gr. [213.16.240.129])
        by smtp.gmail.com with ESMTPSA id x15-20020adfdd8f000000b001f0473a0a3fsm2705941wrl.14.2022.03.03.10.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 10:36:44 -0800 (PST)
Message-ID: <0e63b59c-779c-d85b-693e-79d2924acbe0@arrikto.com>
Date:   Thu, 3 Mar 2022 20:36:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Content-Language: en-US
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com >> Martin K. Petersen" 
        <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        "kbus >> Keith Busch" <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "clm@fb.com" <clm@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
        "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.com" <jack@suse.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
 <012723a9-2e9c-c638-4944-fa560e1b0df0@arrikto.com>
 <c4124f39-1ee9-8f34-e731-42315fee15f9@nvidia.com>
From:   Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <c4124f39-1ee9-8f34-e731-42315fee15f9@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 23:32, Chaitanya Kulkarni wrote:
> Nikos,
> 
>>> [8] https://kernel.dk/io_uring.pdf
>>
>> I would like to participate in the discussion too.
>>
>> The dm-clone target would also benefit from copy offload, as it heavily
>> employs dm-kcopyd. I have been exploring redesigning kcopyd in order to
>> achieve increased IOPS in dm-clone and dm-snapshot for small copies over
>> NVMe devices, but copy offload sounds even more promising, especially
>> for larger copies happening in the background (as is the case with
>> dm-clone's background hydration).
>>
>> Thanks,
>> Nikos
> 
> If you can document your findings here it will be great for me to
> add it to the agenda.
> 

Hi,

Give me a few days to gather my notes, because it's been a while since
the last time I worked on this, and I will come back with a summary of
my findings.

Nikos
