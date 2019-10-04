Return-Path: <SRS0=tG2Y=X5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9567FC4360C
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 05:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CC2E207FF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 05:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387573AbfJDFFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Oct 2019 01:05:46 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34298 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfJDFFp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Oct 2019 01:05:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id k7so2583106pll.1
        for <linux-scsi@vger.kernel.org>; Thu, 03 Oct 2019 22:05:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=opE3XcoVMSUEh/9oCFw1a5sDni6JU5ea4pvu+5GUU2k=;
        b=O29bWOaBnmjCdSjgm68UMrHORMDektt691Uf9fihZSOybSIrK4r0fJBWI10nCCWEKg
         K3sflq3nfozujqd1vsRr4NfE8VDTh9GCpv9Z7qJTRyOHMVYE2VfbK9MbhjlltH0hsCiG
         NYPKvK1QAa7qDlZVepkRQG0ippdfF6sUFccg3hTk2k/7IzO73JnW/Mcd218n1U4G3CMy
         AzV7a4JubjnIrIzcNdRVckXBdxMjb8HAMVcQU7uvgHtCQ1x5PtPmGxFVhfwu+YfnPNM5
         KPivmU/qMveT97PJcrI9XAr1xii1zlPAy5NkKilnKlo5kn/dTHFpd9aMt5AyFhLkmUCq
         o+MA==
X-Gm-Message-State: APjAAAVApTQsNcPwlk3cGZFo+QMQu2uKATheG4sGEIGvWLntLRVYrQIu
        d/KlONoXl/gvuT1ozV6FtKA=
X-Google-Smtp-Source: APXvYqy8vonOtxZ30yua2e7/GrWJmoyZ7HvN8SKRDDfMSXjOJENUFD59O+fjbxEXWI8ezfMmpzlOuQ==
X-Received: by 2002:a17:902:d202:: with SMTP id t2mr12723548ply.245.1570165544332;
        Thu, 03 Oct 2019 22:05:44 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d5:319d:7604:e220:42f5])
        by smtp.gmail.com with ESMTPSA id u18sm5231464pge.69.2019.10.03.22.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 22:05:43 -0700 (PDT)
Subject: Re: [PATCH v2] fixup "qla2xxx: Optimize NPIV tear down process"
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Daniel Wagner <dwagner@suse.de>
References: <20191002154126.30847-1-martin.wilck@suse.com>
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
Message-ID: <e038c81f-b824-f57b-4fef-fd4a9342b3f3@acm.org>
Date:   Thu, 3 Oct 2019 22:05:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191002154126.30847-1-martin.wilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-02 08:41, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hello Martin,
> 
> this patch fixes two issues in patch 02/14 in Himanshu's latest
> qla2xxx series ("qla2xxx: Bug fixes for the driver") from
> Sept. 12th, which you applied onto 5.4/scsi-fixes already.
> See https://marc.info/?l=linux-scsi&m=156951704106671&w=2
> 
> I'm assuming that Himanshu and Quinn are working on another
> series of fixes, in which case that should take precedence
> over this patch. I just wanted to provide this so that the
> already known problems are fixed in your tree.
> 
> v2: check loop condition only once (Bart van Assche)
> 
> Commit message follows:
> 
> Fix two issues with the previously submitted patch
> "qla2xxx: Optimize NPIV tear down process": a missing negation
> in a wait_event_timeout() condition, and a missing loop end
> condition.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Fixes: f5187b7d1ac6 ("scsi: qla2xxx: Optimize NPIV tear down process")
> ---
>  drivers/scsi/qla2xxx/qla_mid.c | 8 +++++---
>  drivers/scsi/qla2xxx/qla_os.c  | 8 +++++---
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
> index 6afad68e5ba2..238240984bc1 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -76,9 +76,11 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
>  	 * ensures no active vp_list traversal while the vport is removed
>  	 * from the queue)
>  	 */
> -	for (i = 0; i < 10 && atomic_read(&vha->vref_count); i++)
> -		wait_event_timeout(vha->vref_waitq,
> -		    atomic_read(&vha->vref_count), HZ);
> +	for (i = 0; i < 10; i++) {
> +		if (wait_event_timeout(vha->vref_waitq,
> +		    !atomic_read(&vha->vref_count), HZ) > 0)
> +			break;
> +	}
>  
>  	spin_lock_irqsave(&ha->vport_slock, flags);
>  	if (atomic_read(&vha->vref_count)) {
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 6e627e521562..ee5b6cba9872 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1119,9 +1119,11 @@ qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
>  
>  	qla2x00_mark_all_devices_lost(vha, 0);
>  
> -	for (i = 0; i < 10; i++)
> -		wait_event_timeout(vha->fcport_waitQ, test_fcport_count(vha),
> -		    HZ);
> +	for (i = 0; i < 10; i++) {
> +		if (wait_event_timeout(vha->fcport_waitQ,
> +		    test_fcport_count(vha), HZ) > 0)
> +			break;
> +	}
>  
>  	flush_workqueue(vha->hw->wq);
>  }

This patch looks fine to me although I'm still wondering what the
difference is between a loop with wait_event_timeout() calls and a
single wait_event_timeout() call with a longer timeout?

Thanks,

Bart.

