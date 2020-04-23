Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59530C55191
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 02:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3782E2077D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 02:57:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WhE27PNt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgDWC5r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 22:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgDWC5r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 22:57:47 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C656C03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 19:57:47 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d184so2205779pfd.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 19:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qh4GIbq4AVVqHita2uLEZU/wDq0Z7OYlG3P5E1aK0Mk=;
        b=WhE27PNtnBQ1sX7BO9Oc99g4N1fa6O/X7hvXneY3dgmQ/PlVzIzm2qRA8bEz9hmm5P
         XOkp/RRkOo1mgVMpLZoXvb6T+kMypt3NMtnUT4KSdY+fMTL3/i/tcAllYHRGNbGEX5KG
         6lZVch36vha1V6CQhYMlaq6YBjGge2wPhxyX7iP0VUHTBO/Ejpazwg/2XZY0KaLNiS2r
         ZEmuojBskZwAnb2OwoYqIA0bMpTaKL+RdUfBSBwxoDsVigL2Rw6fuV6Yx+BPJnML9p6x
         SfUcYE0S//Gn97Mha6wUXmV78IIL9oWP8QXiWXsUQe3S9nmMy+q88ByYqLO7fVAOAJd9
         GsYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qh4GIbq4AVVqHita2uLEZU/wDq0Z7OYlG3P5E1aK0Mk=;
        b=DvNXPZBCTqcsGtrY6NfDN1jhhMuv0NF4YpQKN0eOfUaEEPLranEIvrYiXes81EtSP9
         ACXI/wpswI/lASszeo8yNTFhBcgtFCRbuT5Y6Cm++1h81ErGMk/rJtbOY2HZk76w4XDp
         jlF+Wee29m/MLD1IVF/i2kr096bk08Y9ZEIAWxwMKh4H5PhQrilypmfMdT/oBcgest18
         A1U28hLPgYlPPeB9qcoXZp4kpLRFer6FpG3bp9pFsyUyZ14pNTEJdTiO2exMUcEdB22z
         Hq5uigeWCjs70LUStV7U4AAhttkSqMo0djOfiDbZohV8th6SAjIUeuUH5a/SMgRY6kAM
         jusQ==
X-Gm-Message-State: AGi0Pua+4086X4g47VHcxMVSgYa03eUNmX0lTwfG1mU9GHyaosI0sO0b
        p4WRmJAApOGridKEWqMGUFQ=
X-Google-Smtp-Source: APiQypKeOKIoS9htd2TGrQkUL2yg14w5AX0v7z/30MD8YroZafOGXQbdlgpzCvMT1W2ahu9V3P7uRg==
X-Received: by 2002:aa7:8006:: with SMTP id j6mr1553915pfi.187.1587610667123;
        Wed, 22 Apr 2020 19:57:47 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 13sm953373pfv.95.2020.04.22.19.57.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 19:57:46 -0700 (PDT)
Subject: Re: [PATCH v3 15/31] elx: efct: Data structures and defines for hw
 operations
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-16-jsmart2021@gmail.com>
 <d1b6cda5-6f58-a906-7b93-c0bb1c42a6a9@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <cb19ecba-8102-4561-3e34-95af712c74ed@gmail.com>
Date:   Wed, 22 Apr 2020 19:57:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d1b6cda5-6f58-a906-7b93-c0bb1c42a6a9@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/2020 11:51 PM, Hannes Reinecke wrote:
...
> 
> Please consider running 'pahole' on this structure and rearrange it.
> Looks like it'll required quite some padding which could be avoided.

we will

Thanks.

-- james

