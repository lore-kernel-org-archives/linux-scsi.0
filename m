Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724CDCA9EC7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 03:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F668214B2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 03:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfKEDxD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 22:53:03 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44473 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729711AbfKEDxC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 22:53:02 -0500
Received: by mail-pf1-f193.google.com with SMTP id q26so14109738pfn.11
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 19:53:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rkgyVC+OHuPOQsxRSUKUdeaSwTtfsnMxNQ4Be2vjMX0=;
        b=jkCs7z0nyK5EktSWNY78/Tk3qQIFkD9KZ2ePa+zpk1Nd9YqeCWizYH3qHW+0C4Je6d
         LwR2Iv9eYH4vLzZUdyTlESaabAyXwsoqnEMMnmT0xPzcT25NrZMwx9wpsDf4BcTqWwNq
         scn0t++dGTQgsnpdx2JSOIAVb4L7B6x02XHcPX/4DE2wqDKTbQoueZvYrNIg6cHwgQK0
         gTPumUQt3nEDmi2LeJaQL0akpxDFZHhz80edbQstzPAz6Zi+bTwuGz8UHYEJGKgBwx3b
         80v1Ry4kxfT3N5cwV7d0/diN3LJDOISkvuJT5FrJFSiJQfn7CyIw7t7EJbz8LwxWA4v5
         QnbQ==
X-Gm-Message-State: APjAAAW5OZU4OMwu4oZcbwUAMYs7Nh6Mx1zb9934QdXHXzvnxA46LrMW
        JRPAZ4OGLRRmQTRkJOdknrI=
X-Google-Smtp-Source: APXvYqzNWEdscEBSDZMWDFLxzo5OtChvKIAXLSWgWJbOa+IunmqtCvkucNNVUXwvp9ZUZtJ4oAIshQ==
X-Received: by 2002:a17:90a:c505:: with SMTP id k5mr3423292pjt.84.1572925981939;
        Mon, 04 Nov 2019 19:53:01 -0800 (PST)
Received: from localhost.localdomain ([2601:647:4000:1075:7888:d8f7:5d82:844a])
        by smtp.gmail.com with ESMTPSA id 198sm5198958pgf.47.2019.11.04.19.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 19:53:00 -0800 (PST)
Subject: Re: [scsi] 74eb6c22dc: suspend_stress.fail
To:     kernel test robot <oliver.sang@intel.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>, lkp@lists.01.org
References: <20191104085021.GF13369@xsang-OptiPlex-9020>
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
Message-ID: <824c5a0b-a31a-b0a2-b14a-ab6edd294d07@acm.org>
Date:   Mon, 4 Nov 2019 19:52:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191104085021.GF13369@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-04 00:50, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-7):
> 
> commit: 74eb6c22dc70e395b333c9ca579855cd88db8845 ("[RFC PATCH V3 2/2] scsi: core: don't limit per-LUN queue depth for SSD")
> url: https://github.com/0day-ci/linux/commits/Ming-Lei/scsi-core-avoid-host-wide-host_busy-counter-for-scsi_mq/20191009-015827
> base: https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git for-next
> 
> in testcase: suspend_stress
> with following parameters:
> 
> 	mode: freeze
> 	iterations: 10

Hi Ming,

This is the second report by the build robot that this patch causes the
suspend_stress test to fail. I assume that that means that that test
failure is not a coincidence. The previous report (Oct-22) is available
at https://lore.kernel.org/linux-scsi/20191023003027.GD12647@shao2-debian/.

Bart.
