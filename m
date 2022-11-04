Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6094DC43219
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 17:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiKDRVH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 13:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiKDRVE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 13:21:04 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1644199B
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 10:20:59 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso8862199pjc.0
        for <linux-scsi@vger.kernel.org>; Fri, 04 Nov 2022 10:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OczEUwDaDCJagzs0QtMr8aHYN/ko8ymZX7lVummJVOs=;
        b=uAw80S9vBEJp3aHojoMEpA/68sS1rwm2/DWeE+ULXnA6VihFLM1tIcWa71PfRN9kBY
         0Dv2ncNI3cIHP1goXyeXZom0/uBfoDaO30ASdZEL4aGfHRhvJUIMCG8nrQlvfooqmoJO
         hUAuGLtFkFgLnDesYbOIb/h2RG1W4Vfgffao9TGfEveZhdIZofkxgjiB9PJaysiRvxez
         qh27EMHRn8B9dhv5bFV0Gj3bOcrEvWTaLB9Ua8Lz3QnnrjBVMODvXVdUSprTVXviQ9hj
         D+qpWlXKArSY4d+JaCwNiIRypZgFLSZR3fDUcNuaeyz///hny0BZ0cHpkYlDAwWb4Z7k
         HJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OczEUwDaDCJagzs0QtMr8aHYN/ko8ymZX7lVummJVOs=;
        b=U9sv/jP62DysCnZqYjLwR/caaTP1AWIEljth58DLVLzzyxt+gbbWNgXgc3IbaDQc+N
         7DBYR+a9WDDGgGX6HlyBFQhXVUTqIYRG+IrTYLdmF+gJYx7hg6jC4765BcA9o6Rc0BBZ
         zIJxkuYnKPxfW9Dsg5jTgrTYgexAg9/88E67kZEufoCvLvSndiXufr/qW/xYXvq+kaGE
         0s40Jzz15l/piEmvPJfqKUCkcrLzgln/9vRKwv1dC75qiUGRlctK81cXdYcdppM65HFu
         xX3tlRTmG8AqcCdbQD77+h63WyXPaWMUU+pf+5C3SK7t0gJIrUeQu30TUxa125Hbz73E
         cWSA==
X-Gm-Message-State: ACrzQf2WwEfQEh0BauzcG/w6lzNs/sXORXOtlw0kpNL7dhiBY7iL/Ljb
        ir8/SV5FA9ajO/+64uBDXBPb7Q==
X-Google-Smtp-Source: AMsMyM7qXmb1tKLbXoG2RN7MYH+OBDKZmahcKO3ZgUlIGFzbY77VBHGSlWccWa4sVOHz9dNTYKbNgg==
X-Received: by 2002:a17:90a:6045:b0:212:fe9a:5792 with SMTP id h5-20020a17090a604500b00212fe9a5792mr53370678pjm.178.1667582458816;
        Fri, 04 Nov 2022 10:20:58 -0700 (PDT)
Received: from [10.255.167.72] ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id x16-20020aa79a50000000b0056e0ff577edsm2990000pfj.43.2022.11.04.10.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 10:20:58 -0700 (PDT)
Message-ID: <17b88750-53c2-0653-045a-dde921e37e0c@bytedance.com>
Date:   Sat, 5 Nov 2022 01:20:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.0
Subject: Re: [PATCH v3 0/9] PCI/AER: Fix and optimize usage of status clearing
 api
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc:     ruscur@russell.cc, oohall@gmail.com, fancer.lancer@gmail.com,
        jdmason@kudzu.us, dave.jiang@intel.com, allenbh@gmail.com,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        bhelgaas@google.com, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ntb@lists.linux.dev, linux-scsi@vger.kernel.org
References: <20220928105946.12469-1-chenzhuo.1@bytedance.com>
Content-Language: en-US
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
In-Reply-To: <20220928105946.12469-1-chenzhuo.1@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bjorn, a gentle reminder.

Thanks and regards.

On 9/28/22 6:59 PM, Zhuo Chen wrote:
> Hello.
> 
> Here comes patch v3, which contains some fixes and optimizations of
> aer api usage. The v1 and v2 can be found on the mailing list.
> 
> v3:
> - Modifications to comments proposed by Sathyanarayanan. Remove
>    pci_aer_clear_nonfatal_status() call in NTB and improve commit log.
> 
> v2:
> - Modifications to comments proposed by Bjorn. Split patch into more
>    obvious parts.
> 
> Zhuo Chen (9):
>    PCI/AER: Add pci_aer_clear_uncorrect_error_status() to PCI core
>    PCI/DPC: Use pci_aer_clear_uncorrect_error_status() to clear
>      uncorrectable error status
>    NTB: Remove pci_aer_clear_nonfatal_status() call
>    scsi: lpfc: Change to use pci_aer_clear_uncorrect_error_status()
>    PCI/AER: Unexport pci_aer_clear_nonfatal_status()
>    PCI/AER: Move check inside pcie_clear_device_status().
>    PCI/AER: Use pcie_aer_is_native() to judge whether OS owns AER
>    PCI/ERR: Clear fatal error status when pci_channel_io_frozen
>    PCI/AER: Refine status clearing process with api
> 
>   drivers/ntb/hw/idt/ntb_hw_idt.c |  2 --
>   drivers/pci/pci.c               |  7 +++--
>   drivers/pci/pci.h               |  2 ++
>   drivers/pci/pcie/aer.c          | 45 +++++++++++++++++++--------------
>   drivers/pci/pcie/dpc.c          |  3 +--
>   drivers/pci/pcie/err.c          | 15 ++++-------
>   drivers/pci/pcie/portdrv_core.c |  3 +--
>   drivers/scsi/lpfc/lpfc_attr.c   |  4 +--
>   include/linux/aer.h             |  4 +--
>   9 files changed, 44 insertions(+), 41 deletions(-)
> 

-- 
Zhuo Chen
