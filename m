Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C77C432C2
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 01:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8281B222BF
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 01:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389684AbfIZBdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Sep 2019 21:33:39 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42732 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388759AbfIZBdi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Sep 2019 21:33:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id q12so699241pff.9;
        Wed, 25 Sep 2019 18:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VT62aQpiFmM90t8KPXncZuFr4GQKpQihFjlgHu3WrqE=;
        b=O0VVbarP83rhisThpLKUGKadggLVaG22OCtmEp8Ut45pz1WlrrAkito1M/0ZCzSbsY
         Ct/8QjTuLCJthWeHaWYUu6kPFToyWWrhlnIPquWDpgBOmHXaF+H6u6/XQEPMstJsSEkF
         djJRe1+FnbueWS96FFmBH226kBMq+l9E0IFPjrP6chrCB0RoALh9YkeWtFXukYf41LaL
         mIjsJ5TbOhjTWJslYb0hOrAMNup+Fstc4i1PoDCRHXaSLAp+1/Jhu39GAmM/KL+weyv0
         SOc9URRdTAvyi12plgOu7xKD+pe81laOpBDGLMBJsSnn/3L/fR6YivvnpE0FiPiq0B2p
         /6jw==
X-Gm-Message-State: APjAAAWsNzZNR8Hz/HUzOOITlrp/2D5Xoao2JBihRNZ+c2WhnE9QJxrp
        nnAFBzB04qU+BBc10YdScJrPNcur
X-Google-Smtp-Source: APXvYqzi4Noidh86pp/3dw1R8rbHNEmT2BmGC+b96Q76RIQemd2S2tN6qm8UwXBs6/iI2j9a6vRprQ==
X-Received: by 2002:a63:9519:: with SMTP id p25mr881212pgd.54.1569461617677;
        Wed, 25 Sep 2019 18:33:37 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:a9:6557:55cf:c39e:7d21])
        by smtp.gmail.com with ESMTPSA id w188sm268035pgw.26.2019.09.25.18.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 18:33:36 -0700 (PDT)
Subject: Re: WARN_ON_ONCE in qla2x00_status_cont_entry
To:     Daniel Wagner <dwagner@suse.de>, qla2xxx-upstream@qlogic.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>
References: <20190925123928.kahpjtnikcmox7ug@beryllium.lan>
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
Message-ID: <2e47b106-12d7-908a-857f-3908336f2e1f@acm.org>
Date:   Wed, 25 Sep 2019 18:33:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190925123928.kahpjtnikcmox7ug@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-09-25 05:39, Daniel Wagner wrote:
> So I after starring on the code I am not sure if the WARN_ON_ONCE is
> correct. It assumes that after processing one status continuation,
> there is no more work. Though it looks like there is another element
> to process. Is it possible that two sense continuation are possible?

According to the firmware documentation it is possible that multiple
status continuations are emitted by the firmware. Do you want to submit
a patch or do you prefer that I do this myself?

Thanks,

Bart.
