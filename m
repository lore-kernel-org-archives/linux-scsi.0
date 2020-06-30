Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDA1C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 19:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5213320702
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 19:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgF3TXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 15:23:17 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33181 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgF3TXP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 15:23:15 -0400
Received: by mail-pg1-f196.google.com with SMTP id o13so7432903pgf.0;
        Tue, 30 Jun 2020 12:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QZj82NExrpqYflGaBGVJcXnUJ+dW5BAAUFbwh+Xp7LQ=;
        b=R+7mCDgQh+w1hRzONP69RgRvJesLAmf7fQduJrPWLPYnkQX2co6khxzc/a1l5lfChV
         c7oaYsqN1cijlu5pbCs9uzQSmXpu9XH5/ftrep4fMOkk8lIpyNfzlBDKCcCaL9gHM91Y
         1tc7D4AcJMjgPngKvxNHnPe0UPjKN40qZpX2A8AHgVN/ucu6gVHLNl3d2+kkIGPqAwoT
         WL2+twvrjtJTFJQTWihlI1yszf8stei94QrTZAHK0rAZE4tTbaQyoR+2Tl+CDrDgaqvN
         0f/omCx1EpKGZ7+T1YebfZREzM4DU2P7CI5dI4VNYEebaxtsotxEX9aGIrHD1KIs9mlJ
         uvsQ==
X-Gm-Message-State: AOAM5325Tjnw4tw0oVxLXz2I6WwjrY1kT35IPEE0UtayeMqR5/2U4HPL
        mJnrnzAIShhzV1WvX/o/ViXTFZPs
X-Google-Smtp-Source: ABdhPJy6ltsGoEORnSiK/nWRrBOWV5/GjQVTUu0isSo6QlXsWUDfPgUgPSrSJxRzqCV+GTP2Gu40LQ==
X-Received: by 2002:a62:e206:: with SMTP id a6mr13526628pfi.24.1593544995157;
        Tue, 30 Jun 2020 12:23:15 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id o2sm2880575pjp.53.2020.06.30.12.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 12:23:14 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
 <c19f1938-ae47-2357-669d-5b4021aec154@puri.sm>
 <20200629161536.GA405175@rowland.harvard.edu>
 <5231c57d-3f4e-1853-d4d5-cf7f04a32246@acm.org>
 <20200630180255.GA459638@rowland.harvard.edu>
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
Message-ID: <1804723c-4aaf-a820-d3ef-e70125017cad@acm.org>
Date:   Tue, 30 Jun 2020 12:23:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200630180255.GA459638@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-30 11:02, Alan Stern wrote:
> Right now there doesn't seem to be any mechanism for resuming the queue 
> if an REQ_PREEMPT request is added while the queue is suspended.

I do not agree with the above statement. My understanding is that resuming
happens as follows if a request is submitted against a runtime suspended
queue owned by a SCSI LLD:

blk_queue_enter()
  -> blk_pm_request_resume()
    -> pm_request_resume(dev)
      -> __pm_runtime_resume(dev, RPM_ASYNC)
        -> rpm_resume(dev, RPM_ASYNC)
          -> dev->power.request = RPM_REQ_RESUME;
          -> queue_work(pm_wq, &dev->power.work)
            -> pm_runtime_work()
              -> rpm_resume(dev, RPM_NOWAIT)
                -> callback = scsi_runtime_resume;
                -> rpm_callback(callback, dev);
                  -> scsi_runtime_resume(dev);
                    -> sdev_runtime_resume(dev);
                      -> blk_pre_runtime_resume(sdev->request_queue);
                        -> q->rpm_status = RPM_RESUMING;
                      -> sd_resume(dev);
                        -> sd_start_stop_device(sdkp);
                          -> sd_pm_ops.runtime_resume == scsi_execute(sdp, START);
                            -> blk_get_request(..., ..., BLK_MQ_REQ_PREEMPT)
                              -> blk_mq_alloc_request()
                                -> blk_queue_enter()
                                -> __blk_mq_alloc_request()
                            -> blk_execute_rq()
                            -> blk_put_request()
                      -> blk_post_runtime_resume(sdev->request_queue);
                        -> q->rpm_status = RPM_ACTIVE;
                        -> pm_runtime_mark_last_busy(q->dev);
                        -> pm_request_autosuspend(q->dev);

Bart.
