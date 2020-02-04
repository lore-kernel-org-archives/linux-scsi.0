Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FD9C3524A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 03:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DC8720732
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 03:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgBDDM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 22:12:59 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38850 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgBDDM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 22:12:59 -0500
Received: by mail-pf1-f194.google.com with SMTP id x185so8688206pfc.5;
        Mon, 03 Feb 2020 19:12:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=M+auj8u/G0hOUSjRgclLo4TJfIPU+Iqke+O3mqmT0Qg=;
        b=h/JrE5AKgR3ENXpzdpExp8wBQgLkJ4WYPh7xwn77Gc1AU39JugJcRaN8RpyASAEzsT
         BpvVqEIvkiYbKuC0exEpFBov46JYVwBlJs4TjxcUUj/9x7teRdyHCGNCg5ZHx9nlkpkY
         ScWmTCKvzg47Ky6V0sK2J7FZ0bbqczCqkidQ6Q4fjWCU28gTuab1rhyF6Ff8Eeu2sIft
         cvc/7pwTgFAu+f8zpoOfYCFEdX3Lu5lWgAwO1/6GpMSI+zOxJivVYQh5NbEwLIb5KouG
         WqWYRtLtFlZl6b5T4qb6Tb6NJeo7+sYSRlpYpoE1q5lv2wcxmZXJtt2eiaGqpF2cbogw
         sKEw==
X-Gm-Message-State: APjAAAXB608Qhtk2mFPxjDtK0zKOyJ2sP89qXHK9GRzC1/Z877T8wfMF
        eukqaO6AhKG0aGnoBch8gDVNbGSl
X-Google-Smtp-Source: APXvYqxOmjEmEQQTHoXRq/1SojYDnyCpu0Vw8WNDCoHImQKkLHAzJTjo6LFTEDdxELBpKTkQeHOtug==
X-Received: by 2002:a63:646:: with SMTP id 67mr11747056pgg.376.1580785977499;
        Mon, 03 Feb 2020 19:12:57 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:39ff:b3e1:a9e7:4382? ([2601:647:4000:d7:39ff:b3e1:a9e7:4382])
        by smtp.gmail.com with ESMTPSA id d69sm19765959pfd.72.2020.02.03.19.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 19:12:56 -0800 (PST)
Subject: Re: [PATCH v4 1/8] scsi: ufs: Flush exception event before suspend
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Sayali Lokhande <sayalil@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-2-git-send-email-cang@codeaurora.org>
 <525e4f67-f471-54a6-aaea-b3772a550af1@acm.org>
 <82723efc44714e8677505cb7999d3fd5@codeaurora.org>
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
Message-ID: <12716695-d9a3-a40c-e563-fa0365183b0e@acm.org>
Date:   Mon, 3 Feb 2020 19:12:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <82723efc44714e8677505cb7999d3fd5@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-02 22:23, Can Guo wrote:
> On 2020-01-26 11:29, Bart Van Assche wrote:
>> On 2020-01-22 23:25, Can Guo wrote:
>>>              break;
>>>          case UPIU_TRANSACTION_REJECT_UPIU:
>>>              /* TODO: handle Reject UPIU Response */
>>> @@ -5215,7 +5222,14 @@ static void
>>> ufshcd_exception_event_handler(struct work_struct *work)
>>>
>>>  out:
>>>      scsi_unblock_requests(hba->host);
>>> -    pm_runtime_put_sync(hba->dev);
>>> +    /*
>>> +     * pm_runtime_get_noresume is called while scheduling
>>> +     * eeh_work to avoid suspend racing with exception work.
>>> +     * Hence decrement usage counter using pm_runtime_put_noidle
>>> +     * to allow suspend on completion of exception event handler.
>>> +     */
>>> +    pm_runtime_put_noidle(hba->dev);
>>> +    pm_runtime_put(hba->dev);
>>>      return;
>>>  }
>>>
>>> @@ -7901,6 +7915,7 @@ static int ufshcd_suspend(struct ufs_hba *hba,
>>> enum ufs_pm_op pm_op)
>>>              goto enable_gating;
>>>      }
>>>
>>> +    flush_work(&hba->eeh_work);
>>>      ret = ufshcd_link_state_transition(hba, req_link_state, 1);
>>>      if (ret)
>>>          goto set_dev_active;
>>
>> I think this patch introduces a new race condition, namely the following:
>> - ufshcd_slave_destroy() tests pm_op_in_progress and reads the value
>>   zero from that variable.
>> - ufshcd_suspend() sets hba->pm_op_in_progress to one.
>> - ufshcd_slave_destroy() calls schedule_work().
>>
>> How about fixing this race condition by calling
>> pm_runtime_get_noresume() before checking pm_op_in_progress and by
>> reallowing resume if no work is scheduled?
> 
> If you apply this patch, you will find the change is not in
> ufshcd_slave_destroy(), but in ufshcd_transfer_rsp_status().
> So the racing you mentioned above does not exist.

Hi Can,

Apparently I got a function name wrong. Can the following race condition
happen:
- ufshcd_transfer_rsp_status() tests pm_op_in_progress and reads the
  value zero from that variable.
- ufshcd_suspend() sets hba->pm_op_in_progress to one.
- ufshcd_suspend() calls flush_work(&hba->eeh_work).
- ufshcd_transfer_rsp_status() calls schedule_work(&hba->eeh_work).

Thanks,

Bart.
