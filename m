Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7ECECA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 800C921D7B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p5OsG6fm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfJYWKT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 18:10:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35714 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYWKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 18:10:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id v6so3514683wmj.0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 15:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zivFqQLZdgYBkxIweW0dcWWWDLblvf44uV5tDQXfePY=;
        b=p5OsG6fmuM7A3kOFGpWbZ4Q19Zld+oFaZndtt6YQS2W+SvqUZFn9N3ugoCtY+melel
         +LAhViBn8z5rt3pal3ZD+6Wqtj45tgZi79eicjnJ9ih9prrtYxI4zWatoW9Fo7X2cGvW
         6DAFd0nmCFmCfCnBcpHxliknpJfpnAchitUcAh8vN1fQ29ORs4U3Mut4iKb/zBbSsEUL
         U/wpz7rCYdk+IcQ5HwN+ZCRBbnqiMQW6SJl3AygUnOZyxipc9rypI6eyK9DvUXD0wfNm
         84OAvTMbG5F5r2w9fFRRKS+eWw0hjcTSRpb6Zw68VJ1E21PJYDqerCcvcRMqyvOV6e3t
         9udA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zivFqQLZdgYBkxIweW0dcWWWDLblvf44uV5tDQXfePY=;
        b=arfQXC9J17xb0HL8gVsmOgfgU6tv8sfcK5mFlJJUGN/jlMhOy1+4lVW2bDo8w2LtFh
         6/UwiINzlA6J/L7u8mT0Ab5pytcO25h+jHHyjNetIMCDhYQJgKq7zni7dEcpQRxlCRzN
         +V7KOr1S8b80f8IxjaNAlgVSuZfKidsJBcK8dOFShvG3PQG0f11u26Zf3TScEpzvKVcs
         yqNQduWWkEJI7JpFFeruc+wycI7QgYf+x0WSzHX+or3ZAKhpUbfrfW+exshZ060hPDbX
         yCJX2aeitvndjHF/ywhlZDJqBqTFfWkcBW5J9+jTtOO6LT6Fl6TomXSBTaswm1S5GI9w
         5saA==
X-Gm-Message-State: APjAAAUalSrZWHcCHZB1SBJEww3dtAD5QEKKOBzW1c4aro1svJyfbkxM
        9ZvqM/a53UY0xxeQhdoSZlw=
X-Google-Smtp-Source: APXvYqxDVM29liH0JtsWe/2bm2ZlOqXuDcdB5g99OpQMzz/Wt+Xz7OnEubPYFEf2OvmnsM6SeLIDXA==
X-Received: by 2002:a7b:cc0c:: with SMTP id f12mr5271681wmh.40.1572041416098;
        Fri, 25 Oct 2019 15:10:16 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l11sm2994173wmh.34.2019.10.25.15.10.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 15:10:15 -0700 (PDT)
Subject: Re: [PATCH 03/32] elx: libefc_sli: Data structures and defines for
 mbox commands
To:     Steffen Maier <maier@linux.ibm.com>,
        Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-4-jsmart2021@gmail.com>
 <20191025111944.hdgfnslk57njngfi@beryllium.lan>
 <aac32b49-663f-2803-94f2-8240a01714a5@linux.ibm.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <1dde5a35-0557-d6db-2779-616d7097230b@gmail.com>
Date:   Fri, 25 Oct 2019 15:10:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <aac32b49-663f-2803-94f2-8240a01714a5@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/2019 5:20 AM, Steffen Maier wrote:
> Protect the macro argument in the expansion with parentheses to prevent 
> unintended operator precedence during evaluation?
> As with (b) of SLI_ROUND_PAGE(b) above.
> 
> (((val) &  ... ))

yep, agree.  Thanks

-- james

