Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB7EC07E9B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 03:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B1EF611CE
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 03:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhGUDMw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 23:12:52 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:45869 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhGUDMw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jul 2021 23:12:52 -0400
Received: by mail-pl1-f182.google.com with SMTP id p17so300413plf.12
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jul 2021 20:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DqioBHCLkeOnC61JuXJC6Ae8yCAyPeiN11BIq+L4C6U=;
        b=cbSp5Vi2dsT6KYcMcdQJkgA4JfC/S21DK8sgmrp6nMVJACMP9OkK+VhLvL84MJPJ/U
         0fWbWeBWJhjn3AGy/oTSnSCJiAln0XWCyrA/2l2AlkU5nc6eIzMsQgluWSPOUiCqmh76
         hXbgyjkMEledwA0bvsn/s5E50U2tlGarD3WN6C76jUuEwpWKATXHvZ4djptiwlO7RvPw
         +eoiPpmFvnQq+j+lkrYHRQWNKo28WZ6jwRyWRW8ycCX4qR5F1AqwBbuPTDo6cG6uvbLY
         2DFczhwQIOH/rvTaruhdBWRgZxWxpSqOwYYUpsEedNAaS7e37+0GSfN4u2KcYEM8QjoT
         80Xg==
X-Gm-Message-State: AOAM531veeK4zXPLRGraViH+uTlN2QDKSCnCn+LEnPZ0hVOL0vscYqpQ
        v37T/fepgQvwoJMkCZc9BsPWRrbEplk=
X-Google-Smtp-Source: ABdhPJxjm6hGpxpZynJcZo3zmro/9h73HgCXOOJ/ggoWPuRrq4wOE5+u70nxxt9QoaHHC0hrpn/ZEQ==
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr1745867pjo.194.1626839608869;
        Tue, 20 Jul 2021 20:53:28 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:bd8c:907c:e656:914d? ([2601:647:4000:d7:bd8c:907c:e656:914d])
        by smtp.gmail.com with ESMTPSA id s195sm490226pfs.119.2021.07.20.20.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 20:53:28 -0700 (PDT)
Subject: Re: [PATCH 00/15] Subject: Protection information and block size
 cleanup
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <c1c075c5-5b2d-afbe-95ee-c5c02ecba1a0@acm.org>
 <yq1a6mj13n8.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <02f3fa00-8f9c-0a49-8afe-581a59003f6b@acm.org>
Date:   Tue, 20 Jul 2021 20:53:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <yq1a6mj13n8.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/21 6:43 PM, Martin K. Petersen wrote:
> Yes. Still haven't pushed my 5.15 tree because I had several issues with
> -rc1, including the configfs bug which broke most of my test setup.
Hi Martin,

To test my configfs patch I used LIO scripts that I wrote many years
ago. It was only after I received a bug report that I realized that
these scripts only write configfs attributes but do not read any
configfs attribute. The configfs breakage shouldn't have happened but
this explains how read testing got overlooked.

Bart.
