Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5CCC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 17:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D1E220828
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 17:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfLJR5l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 12:57:41 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35322 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbfLJR5l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 12:57:41 -0500
Received: by mail-qt1-f195.google.com with SMTP id s8so3618416qte.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2019 09:57:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ctDHY/IKcJzvYGJqYP6UViWIk/0eCFCxyc99+sGop/4=;
        b=KXVHdLiVT2bGsX/+fXk5PnycEbOyg0DYQcUwEOnwE8RCgjkR/O5l6gmIXF82xMGf+C
         wsEtQHJKuSnKU2PStwqwS0ZmjySllyKWjP58jSZpRSmj6cLF+GZK56n+8pTR5nxEOB42
         z0OueKB0NhEQUXKEJIEklH27CsRe2EO4zzMwOKNTETJHizthTaPQj0UPQKbYBUaQXcJw
         rTcmQup4XcxArVzP5p36FidQ/wI6YTDxG2G8M60XCN7Ktux2qaRs1YR0JIu2S2aU4oRP
         aD2T4LXAksrrDc5j7xwHQWVbmxqmvsw3LqKD/A+a9OLIgYjTbkx+6MzZZJzaS3S6oR7v
         LvfA==
X-Gm-Message-State: APjAAAWao5nKjL6oc3Fyp6ZMTS0PI3ebWZpJPQ5Pf75wLoqjp9hIcf3U
        zj3Yrl20bztGm1yIwf3ZqQA=
X-Google-Smtp-Source: APXvYqwWoufz6hJ/2foe/JeSg6WqKsgz6lEu4OjzLYuiD9M6teRVer0hYgva1dCW7S1TsQAv34UyRQ==
X-Received: by 2002:ac8:6697:: with SMTP id d23mr3976350qtp.349.1576000660453;
        Tue, 10 Dec 2019 09:57:40 -0800 (PST)
Received: from ?IPv6:2620:0:1003:512:62e9:2658:28c:bd76? ([2620:0:1003:512:62e9:2658:28c:bd76])
        by smtp.gmail.com with ESMTPSA id y11sm1356941qtj.81.2019.12.10.09.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 09:57:39 -0800 (PST)
Subject: Re: [PATCH 2/4] qla2xxx: Simplify the code for aborting SCSI commands
To:     Martin Wilck <mwilck@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-3-bvanassche@acm.org>
 <f7a05e5696b1942b3303e20fe0e6891bc9a61090.camel@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <658d52fb-c614-9ee5-f95f-81509a9de771@acm.org>
Date:   Tue, 10 Dec 2019 12:57:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f7a05e5696b1942b3303e20fe0e6891bc9a61090.camel@suse.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/10/19 6:47 AM, Martin Wilck wrote:
> blk_mq_request_started() returns true for requests in MQ_RQ_COMPLETE
> state. Is this really an equivalent condition?
> 
> That said, the condition in the current code is sort of strange, as
> it's equivalent to !(sp->completed && sp->aborted). I'm wondering what
> it means if a command is both completed and aborted. Naïvely thinking
> (and inferring from the current code) this condition could never be
> met, and thus its negation would hold for every command. Perhaps Quinn
> meant "!(sp->completed || sp->aborted)" ?

Hi Martin,

The only caller of qla2x00_abort_srb() is qla2x00_abort_all_cmds(). That
function should only be called after completion interrupts have been
disabled. In other words, I don't think that we have to worry about
blk_mq_request_started() encountering the MQ_RQ_COMPLETE state. No
request should have that state when qla2x00_abort_all_cmds() is called.

Bart.
