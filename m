Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A44C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 03:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D8F12145D
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 03:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgIHDpj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 23:45:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45554 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgIHDpi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 23:45:38 -0400
Received: by mail-pf1-f194.google.com with SMTP id k15so9806745pfc.12;
        Mon, 07 Sep 2020 20:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TuLKe93KPLY6WBrd7Iwq3wSAjEhzyElprgeAGdDDDAg=;
        b=GWeYq+TpopAsJZ40RzV4cfCBvbZ2oQq4/qAwux3j7TCQzoNLGiP7YaoowHP0P+EnO+
         W/xU7JyeszmNgLfrPQ2ioHME5GYSnPtflk7t9o3vTcY7OzBAnP27TEp8SxAFAj3Buolf
         xAKyBoDLKOAZJm9pv/0wifXQvEh0DQdIQhts1GWW9fDWWG5DlWW5Fl0XC3N6u/EfGD2+
         TM8jIlNNBDA2DT7nQXH7o4s4WgUDluXVPEMYaAEVrlIoaFrfjBVDPA8hv+yLSPJkypBC
         UhiugHy/S9DNRHLsh1+pyrJLMnudm5KoDi3MCUZ5ZA42MVQ9k1ywlOfcGDVx438ZvcMj
         Thrg==
X-Gm-Message-State: AOAM531k1tpsH42cS4tld4gjQXnWLtMfcArFsdO+53GqMNs3DygKc1p4
        CHW/tRTNgO2FtZ+DSJOzbuyTgi/FuIY=
X-Google-Smtp-Source: ABdhPJySipkimenrVklLdli6vNNBw0VO4Ec4szUopH0rvZh58EfMBup1MKk+AFPU3b8bLxAgBJSe+w==
X-Received: by 2002:a62:e40a:: with SMTP id r10mr23328984pfh.52.1599536735249;
        Mon, 07 Sep 2020 20:45:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:ff58:da99:dd6f:be14? ([2601:647:4000:d7:ff58:da99:dd6f:be14])
        by smtp.gmail.com with ESMTPSA id z4sm1302479pfr.197.2020.09.07.20.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 20:45:33 -0700 (PDT)
Subject: Re: [PATCH V5] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
To:     Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org
References: <20200907071048.1078838-1-ming.lei@redhat.com>
 <4da219e6-7c2b-b93b-c6d0-2e18aa8ce11f@acm.org>
 <20200908014708.GA1091256@T590>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <a51b0af4-219c-4cfc-f224-0cfff3d07ec3@acm.org>
Date:   Mon, 7 Sep 2020 20:45:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200908014708.GA1091256@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-07 18:47, Ming Lei wrote:
> On Mon, Sep 07, 2020 at 09:52:42AM -0700, Bart Van Assche wrote:
>> On 2020-09-07 00:10, Ming Lei wrote:
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index 7affaaf8b98e..a05e431ee62a 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -551,8 +551,25 @@ static void scsi_run_queue_async(struct scsi_device *sdev)
>>>  	if (scsi_target(sdev)->single_lun ||
>>>  	    !list_empty(&sdev->host->starved_list))
>>>  		kblockd_schedule_work(&sdev->requeue_work);
>>> -	else
>>> -		blk_mq_run_hw_queues(sdev->request_queue, true);
>>> +	else {
>>
>> Please follow the Linux kernel coding style and balance braces.
> 
> Could you provide one document about such style? The patch does pass
> checkpatch, or I am happy to follow your suggestion if checkpatch is
> updated to this way.

Apparently the checkpatch script only warns about unbalanced braces with the
option --strict. From commit e4c5babd32f9 ("checkpatch: notice unbalanced
else braces in a patch") # v4.11:

    checkpatch: notice unbalanced else braces in a patch

    Patches that add or modify code like

            } else
                    <foo>
    or
            else {
                    <bar>

    where one branch appears to have a brace and the other branch does not
    have a brace should emit a --strict style message.

[ ... ]

+# check for single line unbalanced braces
+		if ($sline =~ /.\s*\}\s*else\s*$/ ||
+		    $sline =~ /.\s*else\s*\{\s*$/) {
+			CHK("BRACES", "Unbalanced braces around else statement\n" . $herecurr);
+		}
+

Anyway, I think the following output makes it clear that there are many more
balanced than non-balanced else statements:

$ git grep -c "} else {" | awk 'BEGIN {FS=":"} {total+=$2} END {print total}'
66944
$ git grep -Ec "$(printf "\t")else \{|\} else$" | awk 'BEGIN {FS=":"} {total+=$2} END {print total}'
12289

>>> +		/*
>>> +		 * smp_mb() implied in either rq->end_io or blk_mq_free_request
>>> +		 * is for ordering writing .device_busy in scsi_device_unbusy()
>>> +		 * and reading sdev->restarts.
>>> +		 */
>>> +		int old = atomic_read(&sdev->restarts);
>>
>> scsi_run_queue_async() has two callers: scsi_end_request() and scsi_queue_rq().
>> I don't see how ordering between scsi_device_unbusy() and the above atomic_read()
>> could be guaranteed if this function is called from scsi_queue_rq()?
>>
>> Regarding the I/O completion path, my understanding is that the I/O completion
>> path is as follows if rq->end_io == NULL:
>>
>> scsi_mq_done()
>>   blk_mq_complete_request()
>>     rq->q->mq_ops->complete(rq) = scsi_softirq_done
>>       scsi_finish_command()
>>         scsi_device_unbusy()
> 
> scsi_device_unbusy()
> 	atomic_dec(&sdev->device_busy);
> 
>>         scsi_cmd_to_driver(cmd)->done(cmd)
>>         scsi_io_completion()
>>           scsi_end_request()
>>             blk_update_request()
>>             scsi_mq_uninit_cmd()
>>             __blk_mq_end_request()
>>               blk_mq_free_request()
>>                 __blk_mq_free_request()
> 
> __blk_mq_free_request()
> 	blk_mq_put_tag
> 		smp_mb__after_atomic()
> 

Thanks for the clarification. How about changing the text "implied in either
rq->end_io or blk_mq_free_request" into "present in sbitmap_queue_clear()"
such that the person who reads the comment does not have to look up where
the barrier occurs?

>>
>>> +	/*
>>> +	 * Order writing .restarts and reading .device_busy. Its pair is
>>> +	 * implied by __blk_mq_end_request() in scsi_end_request() for
>>> +	 * ordering writing .device_busy in scsi_device_unbusy() and
>>> +	 * reading .restarts.
>>> +	 */
>>> +	smp_mb__after_atomic();
>>
>> What does "its pair is implied" mean? Please make the above comment
>> unambiguous.
> 
> See comment in scsi_run_queue_async().

How about making the above comment more by changing it into the following?
/*
 * Orders atomic_inc(&sdev->restarts) and atomic_read(&sdev->device_busy).
 * .restarts must be incremented before .device_busy is read because the code
 * in scsi_run_queue_async() depends on the order of these operations.
 */

>> Will that cause the queue to be run after a delay
>> although it should be run immediately?
> 
> Yeah, blk_mq_delay_run_hw_queues() will be called, however:
> 
> If scsi_run_queue_async() has scheduled run queue already, this code path
> won't queue a dwork successfully. On the other hand, if
> blk_mq_delay_run_hw_queues(SCSI_QUEUE_DELAY) has queued a dwork,
> scsi_run_queue_async() still can queue the dwork successfully, since the delay
> timer can be deactivated easily, see try_to_grab_pending(). In short, the case
> you described is an extremely unlikely event. Even though it happens,
> forward progress is still guaranteed.

I think I would sleep better if that race would be fixed. I'm concerned
that sooner or later someone will run a workload that triggers that scenario
systematically ...

Thanks,

Bart.
