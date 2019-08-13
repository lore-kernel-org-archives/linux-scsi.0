Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09962C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 15:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE01820844
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 15:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t2CeC6mt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbfHMPC3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 11:02:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42524 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729698AbfHMPC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 11:02:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id b16so11352700wrq.9
        for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2019 08:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z7Dmwu3NvM4EVDKo63p/xdtZ+TtWJUXj2RkugIVOSr4=;
        b=t2CeC6mtNnAdAq/OptzTNdCWbbeZeKOfLFYM6RAyQrZ+0HjWV7exL8BKTMrkb0IRDM
         w1Li2BGhGTUgB9ErTS9tgo1Yz6QM8ou/fnQvFN6GD0Mq7HXZ87yNGkmCJUWLXt6rKs6k
         PvKCClFv1ahlbnQuGeqpjbwvAm2MCWcT62/V8Td+35/tG+7ESPRSxLHC2rzBwxnuGt+N
         JimGsJMRY0GhBQWRwIO0JxQxJdHd67iGC8UwP5rCsyfQz/WRr5Bsj314c7Az6UMjqbaN
         eTmFEZ3FqInxcxhQiSqHVgIkIWsh+eMXoow+ZwoSg2w2a+BAHbQJr2ibqD7HnpeGDhzo
         kvPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z7Dmwu3NvM4EVDKo63p/xdtZ+TtWJUXj2RkugIVOSr4=;
        b=iB1Jo5Y0TJ5JkhP4C+TKM+q8mq4wG7AOgQLmoo7o9kMrU6RzVQ2KYaR7MkmgwZZN0N
         OTzlNyizuogfztK6indX0IK0/hhxwoimWlGODCBOzROArj5D/v5Tnl0rcSoni8nKPAIk
         sz+0wr/tkjBY8l+f2nUOS+13d5DlnNIWqaqXBVm8ZPZM7Y45HyNpV3imSCE6pyK+XgJH
         VV4MdPGj1YqfW7M3Z+yI6IbJeIxERk3nM1R5r4UpLqWseA+3ANzoINNNZ8JJAZDfm8Md
         3qmTHlSKR9t0GGrfpeHIXT0R5OQzXji2NDDi9eJ5wKD0DPWecaUF1KKS7p01zou2/ZHQ
         LzzA==
X-Gm-Message-State: APjAAAUOG2VpdN967X4kGBnmZ1Qfek1fz356eI7TeI5bn9VLe32dxDeq
        j1cIDnWhId/NctYR9/hWuvVL5w==
X-Google-Smtp-Source: APXvYqzczT++Iinfypzj8ZDHy/UBigh5SKekIk8qmEwWyiX/x1k1vy+Nz2A/tkdRk+Iew06bsxv+eA==
X-Received: by 2002:a5d:670d:: with SMTP id o13mr36840270wru.289.1565708546723;
        Tue, 13 Aug 2019 08:02:26 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:e8f7:125b:61e9:733d])
        by smtp.gmail.com with ESMTPSA id p13sm42846847wrw.90.2019.08.13.08.02.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 08:02:26 -0700 (PDT)
Date:   Tue, 13 Aug 2019 16:02:21 +0100
From:   Matthias Maennich <maennich@google.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, maco@android.com,
        kernel-team@android.com, arnd@arndb.de, geert@linux-m68k.org,
        hpa@zytor.com, jeyu@kernel.org, joel@joelfernandes.org,
        kstewart@linuxfoundation.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-modules@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, lucas.de.marchi@gmail.com,
        maco@google.com, michal.lkml@markovi.net, mingo@redhat.com,
        oneukum@suse.com, pombredanne@nexb.com, sam@ravnborg.org,
        sboyd@codeaurora.org, sspatil@google.com,
        stern@rowland.harvard.edu, tglx@linutronix.de,
        usb-storage@lists.one-eyed-alien.net, x86@kernel.org,
        yamada.masahiro@socionext.com
Subject: Re: [PATCH v2 10/10] RFC: usb-storage: export symbols in USB_STORAGE
 namespace
Message-ID: <20190813150221.GA107461@google.com>
References: <20180716122125.175792-1-maco@android.com>
 <20190813121733.52480-1-maennich@google.com>
 <20190813121733.52480-11-maennich@google.com>
 <20190813124708.GC12475@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190813124708.GC12475@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 13, 2019 at 02:47:08PM +0200, Greg KH wrote:
>On Tue, Aug 13, 2019 at 01:17:07PM +0100, Matthias Maennich wrote:
>> Modules using these symbols are required to explicitly import the
>> namespace. This patch was generated with the following steps and serves
>> as a reference to use the symbol namespace feature:
>>
>>  1) Define DDEFAULT_SYMBOL_NAMESPACE in the corresponding Makefile
>>  2) make  (see warnings during modpost about missing imports)
>>  3) make nsdeps
>>
>> Instead of a DEFAULT_SYMBOL_NAMESPACE definition, the EXPORT_SYMBOL_NS
>> variants can be used to explicitly specify the namespace. The advantage
>> of the method used here is that newly added symbols are automatically
>> exported and existing ones are exported without touching their
>> respective EXPORT_SYMBOL macro expansion.
>
>Ok, I can't read text, this answers my previous question.
>
>But, as an example, shouldn't we also have some code here that uses the
>EXPORT_SYMBOL_NS() macro to ensure that it actually works?
>
I will create another patch for a different subsystem where the use of
the macros is more appropriate. Then we have both use cases covered.

Cheers,
Matthias

