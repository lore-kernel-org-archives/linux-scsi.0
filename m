Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647A6C5ACAE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 05:37:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4157F20856
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 05:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbfILFh0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 01:37:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42971 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfILFh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2019 01:37:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id q14so26920775wrm.9
        for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2019 22:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VUGqX89aN/h9WiQvlTwAysK/8trN7MZD6p8i7Ooppvw=;
        b=HW4MZxLNCnV+BXJivlPX7leKPtVQG1FQlmVlkyMQJb5Lmuep0SKrziHHMYlpvQJc7g
         KNP+ukpo7xC4gMkEWr18Rysy6Sb9S263facMRopBwtWg9gShf1dG84jkYaC1fQvREzJs
         YlqvNcXKPf9ersNy0wzrlq2KpSn8SzeGW2HPQTlNR8kqWKIJv64S9xfL1O/lOJ/lKS0Z
         rg/yZgN5H11K1oc0OeUoIprcjjC1EfRn5oFfibaKD8/4YjWJV53LmsNJA3hvY+tTO4W6
         xNAT+HMXa83yB/nQRdZ4jnkTl7iWC6SHlSl8WcsduLywn467hk8V8Zqk3urcOWdL0eWf
         YPhA==
X-Gm-Message-State: APjAAAW5K4gcGdJo/8kRk1XWAUN6MeDKTzkX06AgExnwyN0lGhSCrYqA
        KcynrI+5vYosgIT/Q40R0j+moe+x7v4=
X-Google-Smtp-Source: APXvYqxFIvw/HAVCjWCmggFb8h8HjZbkgFamPzPjeICkY3tjEynbf2/WGPizzav4506s8DwGCp74jQ==
X-Received: by 2002:adf:ea8a:: with SMTP id s10mr4006569wrm.57.1568266644113;
        Wed, 11 Sep 2019 22:37:24 -0700 (PDT)
Received: from [10.0.4.250] (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id 189sm7772258wma.6.2019.09.11.22.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 22:37:23 -0700 (PDT)
Subject: Re: [PATCH 0/4] scsi: qla2xxx: Bug fixes
To:     Roman Bolshakov <r.bolshakov@yadro.com>, linux-scsi@vger.kernel.org
Cc:     Quinn Tran <qtran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
References: <20190912003919.8488-1-r.bolshakov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8774334a-b1e7-1a5e-0da3-82db68f963b6@acm.org>
Date:   Thu, 12 Sep 2019 06:37:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190912003919.8488-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/19 1:39 AM, Roman Bolshakov wrote:
> This series has a few bug fixes for the driver.
> 
> Note, #1 only fixes the crash in the kernel. The complete fix for clean
> ACL deletion from initiator side is in works and requires a discussion.
> 
> As of now initiator is not aware that target no longer wants talking to
> it, that implies unneeded timeout. It might be fixed by making LOGO
> explicit on session deletion but it's an issue I want to raise first
> before making the change. Whether we need implicit LOGO in qla2xxx,
> explicit or use both.
> 
> Also, an unsolicited ABTS from a port without session would still result
> in BA_RJT response instead of frame discard and LOGO ELS, as specified
> in FCP (12.3.3 Target FCP_Port response to Exchange termination):
> 
>    When an ABTS-LS is received at the target FCP_Port, it shall abort
>    the designated Exchange and return one of the following responses:
> 
>    a) the target FCP_Port shall discard the ABTS-LS and transmit a LOGO
>       ELS if the Nx_Port issuing the ABTS-LS is not currently logged in
>       (i.e., no N_Port Login exists);
> 
> FWIW, the target driver can receive ABTS as part of ABORT TASK/LUN
> RESET/CLEAR TASK SET TMFs and in case of failed sequence retransmission
> requests, exchange or sequence errors. IIRC, some initiators requeue
> SCSI commands if BA_RJT is received. Therefore, a timely LOGO will
> prevent a perceived session freeze on the initiators.

Hi Roman,

Has this patch series been prepared against Linus' master branch,
against Martin's 5.3/scsi-fixes or against Martin's 5.4/scsi-queue
branch? I'm asking this because some patches in this series look similar
to patches that are already present in the 5.4/scsi-queue branch.

Thanks,

Bart.

