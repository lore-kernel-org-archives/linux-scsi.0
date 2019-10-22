Return-Path: <SRS0=5qjn=YP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC6DCA9EA0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 14:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41CAC218AE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 14:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732186AbfJVOyT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 10:54:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39678 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732116AbfJVOyT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Oct 2019 10:54:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id p12so10102247pgn.6
        for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2019 07:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HUL/8CqD916Eqb8YpI3ZJg+uip38SxmzIa0zN1DmvmE=;
        b=ewpYOb6yfVW8kHYBIRxvH35TUn2DA02FVw2wCKXrdwBpM0QBB9+yHGMjg1tokoUoeG
         8ru23LwGIk9RNuUHQzTtNjczq8Saq1h1gBSJhvC7X91eccjKQcISR4jKh+QDhTXcuUWs
         SEOa5O9z5kZykU/ItwIOUru9qXsu+mn9UHSGlAEp2zkUp1FM9naoEQypgM8TPh8gasRv
         Ng8zPs+p8CsZwX/yKvGAFO1Wb+kPbJZkbgFdhCJuPyKnAQh/2YbNbDSLEXZb6ZfeFCYA
         AYeu03zM8FPOePwrxZ7MCFHwjFajWDjzA1U9/lEcip53HxIiGBXMO4PtLU3DmGUw+EYm
         x3ng==
X-Gm-Message-State: APjAAAWPam+CmsoG3qulkAGMqQWGtegNuPufZ8ASjBDRHhjB41soh48k
        wy9sKt6eSrOhgV+hVNW4W7B62byE
X-Google-Smtp-Source: APXvYqwfTnjksRZodj+CGlNRFD4g+ATAhCpffI9i2HLGECvlEpEmAg/fvv4w6iJUvRJ4J9fkzLrT8w==
X-Received: by 2002:aa7:838f:: with SMTP id u15mr4858098pfm.189.1571756057711;
        Tue, 22 Oct 2019 07:54:17 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:c3:ccbd:2d81:281:ddbd])
        by smtp.gmail.com with ESMTPSA id 2sm20648176pfo.91.2019.10.22.07.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 07:54:16 -0700 (PDT)
Subject: Re: [PATCH 18/24] st: return error code in st_scsi_execute()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-19-hare@suse.de>
 <3a5ac65a-b765-df88-0613-455f3d4cab46@acm.org>
 <a74e0dce-76c1-75b1-1ac7-5c758e096094@suse.de>
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
Message-ID: <e193b539-d1dd-6cd6-162d-f8a619ba304a@acm.org>
Date:   Tue, 22 Oct 2019 07:54:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <a74e0dce-76c1-75b1-1ac7-5c758e096094@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-21 23:28, Hannes Reinecke wrote:
> On 10/21/19 6:41 PM, Bart Van Assche wrote:
>> On 10/21/19 2:53 AM, Hannes Reinecke wrote:
>>> We should return the actual error code in st_scsi_execute(),
>>> avoiding the need to use DRIVER_ERROR.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>   drivers/scsi/st.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
>>> index e3266a64a477..5f38369cc62f 100644
>>> --- a/drivers/scsi/st.c
>>> +++ b/drivers/scsi/st.c
>>> @@ -549,7 +549,7 @@ static int st_scsi_execute(struct st_request
>>> *SRpnt, const unsigned char *cmd,
>>>               data_direction == DMA_TO_DEVICE ?
>>>               REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
>>>       if (IS_ERR(req))
>>> -        return DRIVER_ERROR << 24;
>>> +        return PTR_ERR(req);
>>>       rq = scsi_req(req);
>>>       req->rq_flags |= RQF_QUIET;
>>>   @@ -560,7 +560,7 @@ static int st_scsi_execute(struct st_request
>>> *SRpnt, const unsigned char *cmd,
>>>                         GFP_KERNEL);
>>>           if (err) {
>>>               blk_put_request(req);
>>> -            return DRIVER_ERROR << 24;
>>> +            return err;
>>>           }
>>>       }
>>
>> The patch description looks confusing to me. Is it perhaps because the
>> caller compares the st_scsi_execute() return value with zero and doesn't
>> use the return value in any other way that it is fine to return an
>> integer error code instead of a SCSI status?
>>
> Yes. The caller does:
> 
> 	ret = st_scsi_execute(SRpnt, cmd, direction, NULL, bytes, timeout,
> 			      retries);
> 	if (ret) {
> 		/* could not allocate the buffer or request was too large */
> 		(STp->buffer)->syscall_result = (-EBUSY);
> 		(STp->buffer)->last_SRpnt = NULL;
> 
> So it's immaterial _what_ we return here as long as it's non-zero.

Please make this clear in the patch description. I think that will make
this patch easier to review.

Thanks,

Bart.
