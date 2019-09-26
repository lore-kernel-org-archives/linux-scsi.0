Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D17C432C2
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 05:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2D7B21A4A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 05:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389600AbfIZFBL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 01:01:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731361AbfIZFBL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Sep 2019 01:01:11 -0400
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C55054E919
        for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2019 05:01:10 +0000 (UTC)
Received: by mail-pf1-f200.google.com with SMTP id a2so901164pfo.12
        for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2019 22:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xQhoAUabi0ck+laQwaWiJC+2AXNGicrQtCWuvtB/rXI=;
        b=abOHQoHuEJJ+rgmgECfYyDodY6aJj2JPEaqu2/SGHcft3rjPzbX10cfeQnlPm/vLfJ
         hSF7ZF0JrQAgq/fMYTDBVuUZPkIwqk+qo9ll5BiRwtnjrK6ud524QRVfv/OvfiZd2XFy
         OR+Y/veQUzVmh4l7oj64LKukOyViB94YnJ1H+RxGgIDQiTHxfxnnmSvSgQVuBBsEB+c2
         Yq50PqjyPgZFqholuhAbDcxfyBfeTvaank192WiYrThd8srXBXSMU2PwdQOzp5YPvJ+6
         bgawzouzdDPHi1jMeZ3QKH5oQxpZuGKSUbvyRVf7dIkukt6cYzhXgw0cN0QjLJFdp06p
         1W/A==
X-Gm-Message-State: APjAAAW6bkDF8BHUUXLpgkid6rWITnZpVFUlD9ixUZOcATJ2k4Pj7TN2
        TMeT5z/HK8a0mB+guIbJK7me73eWhU65VDoa0GOMRPxO7sx+Ful1YhNarvNRGQZ8CLKwgcYuP69
        t/gFB2AH2Jw8GFcRzs/0Zmg==
X-Received: by 2002:a17:902:8f92:: with SMTP id z18mr1885997plo.248.1569474069946;
        Wed, 25 Sep 2019 22:01:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxcUCXn5jzjUbzHlAKrE41fUCLr0dAwYxICUC4oMrTySJKWJt761OhGJ0Xgymix9SgF3IyGVA==
X-Received: by 2002:a17:902:8f92:: with SMTP id z18mr1885962plo.248.1569474069536;
        Wed, 25 Sep 2019 22:01:09 -0700 (PDT)
Received: from [10.76.0.124] ([125.16.200.50])
        by smtp.gmail.com with ESMTPSA id 6sm836051pfa.162.2019.09.25.22.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 22:01:08 -0700 (PDT)
Reply-To: mgandhi@redhat.com
Subject: Re: [PATCH] scsi: core: Log SCSI command age with errors
To:     Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Laurence Oberman <loberman@redhat.com>
References: <20190923060122.GA9603@machine1>
 <c28778e6-62a1-b510-f6aa-fd67b54ca54c@acm.org>
From:   "Milan P. Gandhi" <mgandhi@redhat.com>
Organization: Red Hat
Message-ID: <01be9696-b7ce-4601-0a0b-a7cbb234b1ce@redhat.com>
Date:   Thu, 26 Sep 2019 10:31:05 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c28778e6-62a1-b510-f6aa-fd67b54ca54c@acm.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/25/19 9:15 PM, Bart Van Assche wrote:
> On 9/22/19 11:01 PM, Milan P. Gandhi wrote:
>> +    off += scnprintf(logbuf + off, logbuf_len - off,
>> +             "cmd-age=%lus", cmd_age);
> 
> Have you considered to change cmd-age into cmd_age? I'm afraid otherwise someone might interpret the hyphen as a subtraction sign...

Thanks for your suggestion Bart.
Yes, it would be better to use cmd_age to avoid any confusion.
I will change it and send the updated patch.

Thanks,
Milan.
