Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BB3C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 05:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345339AbiETFMU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 01:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236697AbiETFMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 01:12:19 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CEBA5ABB
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 22:12:17 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id c22so6844766pgu.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 22:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kVIZt+sWcKuPTmNDcTquVfKLTXe1Fe0Ut9j7n/sEIeY=;
        b=cmwvD4pqyi+ZpQSuAWNZ4LQGJjPW7pAZ9MRz+O+6gCjpbZnynSULuDuKeoLGh7+kQP
         gFrL6n8Tv8WCc0RGU9ZmS5uaH2q2VdvpiROsdfC22uFxUefTRzvrCD1cXdQ9SGaziqiN
         1m+bOd19AkL+wvyVibN/N90Io2JsaIEa5LapcqbA1qVq3M+szuCYf6FOcQ+Y4ELitMCw
         sSK2ohumzTpJEFdIZW5cPn7SpoBt7avaA5TrH+/RJpsG5vYtZS5/PYthjQOroAZChm9l
         PRI6dKyyes7R8d1vrVtWnFNZeZkhFfQf02d2Z7lsqHeB4LO3vZmzlWMtq3UM5iwTUZ7c
         pF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kVIZt+sWcKuPTmNDcTquVfKLTXe1Fe0Ut9j7n/sEIeY=;
        b=Hh7aTCBHHpyJQCEvNwzN6mTIbaV3dhhm7VbdIYvfCFgetfvl0a17e48C0xSNk4tCLm
         58JPSWlN//X5YOQkelRUhI8xHub4xJbH46XT+0sk0diSp+VdmOeFH/t8MnK+fgkrx5Rw
         eRZ2rjRDzl2NAlRG2lpeMvPD8E0v4hMW8uFbE9E383Cy3dv96HkcnE8Pi201lmJuinwO
         WTmgSkejs4Fnxirgw1CI353agFXnWF3vfPj9cG/wW2H1B+ZTcvx6OOvtic3Sw4KvFYZs
         PZVR0IYuC27Mm3VFiMTOw2MdEQHE1qP5ZFDxHVupB2vlT/EXN4Iox0mXukfOeGDQMOou
         2pGg==
X-Gm-Message-State: AOAM532dDzwVMMHV0a6LH3ttFs4WS9v63qq3mIScG/bG2chu7ba+sIRE
        ELsgenbHDmUr0IFOHkG0/9IXqbFufhs=
X-Google-Smtp-Source: ABdhPJyqL5kPEgc6zaPLNHt8mS3hUW4NptrbvbIukw3vNegCu+jMD1L1EtcBihJhrJGpnGdvkRv+0Q==
X-Received: by 2002:a63:1716:0:b0:3f2:52bc:b4f3 with SMTP id x22-20020a631716000000b003f252bcb4f3mr6959346pgl.610.1653023536531;
        Thu, 19 May 2022 22:12:16 -0700 (PDT)
Received: from [192.168.1.7] (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id s2-20020a17090a1c0200b001dd16b86fc0sm767365pjs.19.2022.05.19.22.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 22:12:15 -0700 (PDT)
Message-ID: <f5819334-f3c1-b587-9ec9-af3b25f55504@gmail.com>
Date:   Thu, 19 May 2022 22:12:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [bug report] scsi: lpfc: Commonize VMID code location
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <YoZM9m49PjYMKqxn@kili>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <YoZM9m49PjYMKqxn@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/19/2022 6:58 AM, Dan Carpenter wrote:
> Hello James Smart,
> 
> The patch e0063f4ad51c: "scsi: lpfc: Commonize VMID code location"
> from May 10, 2022, leads to the following Smatch static checker
> warning:
> 
> 	drivers/scsi/lpfc/lpfc_vmid.c:248 lpfc_vmid_get_appid()
> 	warn: sleeping in atomic context
> 

Thanks Dan.

It's existing code that just moved location so was now checked. Looking 
to see how best to resolve.

-- james

