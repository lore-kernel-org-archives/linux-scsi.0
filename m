Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46245C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 03:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2482720721
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 03:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfKUD0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 22:26:34 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:46768 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUD0e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 22:26:34 -0500
Received: by mail-pf1-f172.google.com with SMTP id 193so889843pfc.13
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2019 19:26:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ns8oW8VOnxmruGY1xGHN7N6ZQhB0cFjMwITUu/crYdI=;
        b=iqrwPcuv681MJqWcXr+a0vbJRmQakWpl6n7mARYW3aRBZZiuwCZ2bxgD2cXGLkJftu
         uvAaSzqXnURstHTOW3PX5S9M20DFjxU8eKxIexHTMQfaKjlzZvJBX79l/ouvJ4i4E+Pv
         ay29uo0Yzo9xApRzppajORd7kqlE/ZKzqAmbiwUVzbH6fDdMGEi9PybJ5jIxgUoxOFI7
         xdEn0OYaZxpqlqD5/2TPBr4Nf8PfsqBxAetaRXtQjyHop5VcvzUvGIZmlQcJXsnWVUKw
         CBZPUyWJDoCkHPsFHnAAFKpu/g70kEx9x0Yeu91uS9R+O/RWqQyNKUmvMgSjb1p/4ojz
         bMbg==
X-Gm-Message-State: APjAAAUVVbSFxyC8/2eAytMcYaZ9bNo1dihljv0GxrUVj32cKCTuiAYJ
        LEuKQdXIfRy8L7+vpgsDGvxZzMW2
X-Google-Smtp-Source: APXvYqxGzcqKjQW51c3JSgJT4GTaA9KhqnHjwqqlwxwryjgeznUXEY46LC2ec4hi++mzf+d6QKsBPw==
X-Received: by 2002:a62:7643:: with SMTP id r64mr7694191pfc.191.1574306793660;
        Wed, 20 Nov 2019 19:26:33 -0800 (PST)
Received: from ?IPv6:2601:647:4000:df:44ee:9e53:c622:9674? ([2601:647:4000:df:44ee:9e53:c622:9674])
        by smtp.gmail.com with ESMTPSA id a6sm689357pja.30.2019.11.20.19.26.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 19:26:32 -0800 (PST)
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
 <32187dd9-f222-fbed-cc93-1c6abca6e06c@acm.org>
 <19433666-FCA3-4340-8A81-707F85B87F02@marvell.com>
 <1dac96c3-54d5-11bf-292b-c25a62a3c919@acm.org>
 <fa7d57ec-77b3-3397-063e-d949716abaa8@acm.org>
 <22154B05-853E-42D2-9B3B-749FEB9D1E51@marvell.com>
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
Message-ID: <7391e4c5-e40d-1016-e950-46678a86456b@acm.org>
Date:   Wed, 20 Nov 2019 19:26:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <22154B05-853E-42D2-9B3B-749FEB9D1E51@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-20 13:39, Himanshu Madhani wrote:
> Sorry for delay. Can you send me log file with
> ql2xextended_error_logging=0x5200b000 to see why you are seeing issue
> in your setup and if possible trigger FW dump and send me that as well
> right after you see this issue. I’ll have to check with my firmware
> guys on the behavior you are seeing.

Hi Himanshu,

Logs are available at
https://drive.google.com/file/d/195QDMr2Yj_y4JAbkL6zKlqP5txI0Bvv-/

Creating a firmware dump failed unfortunately:
root@ubuntu-vm:~# qaucli -fwdump 21-00-00-24-FF-46-B8-E9 fwdump.bin
Using config file: /opt/QLogic_Corporation/QConvergeConsoleCLI/qaucli.cfg
Installation directory: /opt/QLogic_Corporation/QConvergeConsoleCLI
Working dir: /root
Option is unsupported with selected HBA (Instance 1 - QLE2562)!

This test was run against Martin's 5.5/scsi-queue branch (commit
65309ef6b258 ("scsi: bnx2fc: timeout calculation invalid for
bnx2fc_eh_abort()")).

Please let me know if you need more information.

Bart.
