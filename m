Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960A4C35247
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 21:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73190222D9
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 21:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgBFVBJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 16:01:09 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46792 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBFVBI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 16:01:08 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so3342530pgb.13
        for <linux-scsi@vger.kernel.org>; Thu, 06 Feb 2020 13:01:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XFT6nyD3+FRumg+1UXkhupjjEHz8QUtsa6GKXSkz+m0=;
        b=JJWZh7d8TfmeR8UW56BAt3odFGnTpqu+zTGX9nu9b40owKVChs60Odaes9htyYYZPx
         cxxWET41TC0b5r5f6BaLNLUuFVxtA3rFNrLr6F0LgQcXUM9JpqFOTjSX1laBIfyUjQZE
         E5wpRW3TeVIQK6HC/9tePVis/KvlCOPFrW6HFtZPqltftIUaRsx0S4MgiDA/+maxBdrz
         4yZK5xStBFAdY/UNy+ukfM1ALY1woFf4ErkWG4t/O9XzKsAtlJvZcf4v6W8ruvK9hMTN
         omy72894TScIsJ3IQCWJnc+TiCzc3JnAC/a12DDAMssfaoZJOjoUU+e4ZKeHfzLuR7mt
         QMQA==
X-Gm-Message-State: APjAAAW+ei5HWzvjt7L6aBV3zQ5aZ0ZrXeo6fPlxbArCYGej1cEi2WkH
        hxOeq+Ghyepm8MJdGb+p/jE5twbv
X-Google-Smtp-Source: APXvYqy939GmcFh7JYzyKWO2JGlfCSURc7Howri9WopbpyDaSYy+cJrKtFl2qeDOCPaXhrjhRzutSA==
X-Received: by 2002:a62:fc93:: with SMTP id e141mr5843235pfh.262.1581022868226;
        Thu, 06 Feb 2020 13:01:08 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 13sm299012pfi.78.2020.02.06.13.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 13:01:07 -0800 (PST)
Subject: Re: [PATCH 0/4] qla2xxx patches for kernel v5.6
To:     Martin Wilck <mwilck@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, "dwagner@suse.de" <dwagner@suse.de>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <bb273446a0f294e37dc0afb2c450fb761e345260.camel@suse.com>
 <559ee60f-43e8-b228-f14b-7453d62e7780@acm.org>
 <cb2ad8b48a412ad164ebbe809bc80b238b16a0b4.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4478372c-7e34-c35f-6ccc-dff1422b6256@acm.org>
Date:   Thu, 6 Feb 2020 13:01:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cb2ad8b48a412ad164ebbe809bc80b238b16a0b4.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/20 12:52 PM, Martin Wilck wrote:
> On Thu, 2020-02-06 at 12:49 -0800, Bart Van Assche wrote:
>>
>> The first patch of this series has been queued by Martin Petersen
>> for
>> the v5.7 merge window. I plan to repost patches 2/4 and 4/4 of this
>> series after the merge window has closed. Patch 3/4 (the fix for
>> point-to-point mode) has been dropped because I'm not confident that
>> my
>> fix is a proper fix.
> 
> Well, Himanshu had ack'd it, and Roman too IIRC ... have you given up
> on the subject?

That patch is not sufficient to make point-to-point mode work reliably 
on 8 Gb/s adapters, the adapter type on which I noticed that 
point-to-point mode is broken. If anyone else wants to fix 
point-to-point mode on older adapters that would be welcome.

Bart.
