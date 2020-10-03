Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62051C41604
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 17:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 131312064C
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 17:19:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJI1A3OZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgJCRTd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Oct 2020 13:19:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbgJCRTd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Oct 2020 13:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601745572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3OI2b+OH/Ffb09d8c8/GpQaOv6pnoyDYlXcT1L6c/cw=;
        b=cJI1A3OZQDwIIv6J+5wovrHvhb/KXo0WBQk0kc6QL4MDf6FHCWEAFxHnaT4vSN3RCECKXg
        ODM5nUZL8DiSTiTI0QveWI7GKK1+Jd6MsuVC77tQYiWeUMr51ZgZ7xCm4EwjN9c6eJaWvf
        pOrNbPTxfzNHff9QwlYNmVkIghI8o0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-DiSxL1M6Pgy_EVr2lqGgwA-1; Sat, 03 Oct 2020 13:19:28 -0400
X-MC-Unique: DiSxL1M6Pgy_EVr2lqGgwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71DC2801FDA;
        Sat,  3 Oct 2020 17:19:27 +0000 (UTC)
Received: from [10.40.192.25] (unknown [10.40.192.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C73717E46E;
        Sat,  3 Oct 2020 17:19:25 +0000 (UTC)
Subject: Re: [PATCH] Revert "scsi: target/iscsi: Detect conn_cmd_list
 corruption early"
To:     Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20201002073341.12470-1-mlombard@redhat.com>
 <ce44115e-f8ac-0307-88bd-f6a2e9d7f7f3@acm.org>
 <fea1f8a6-615e-6d44-ec20-b4f46da10d55@redhat.com>
 <49bcd5f9-a528-f52d-3093-494e76eaac10@acm.org>
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <e2f1f376-45c5-35b0-b8fd-09bef76ce410@redhat.com>
Date:   Sat, 3 Oct 2020 19:19:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <49bcd5f9-a528-f52d-3093-494e76eaac10@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Dne 03. 10. 20 v 17:17 Bart Van Assche napsal(a):
> On 2020-10-03 00:46, Maurizio Lombardi wrote:
>> Dne 03. 10. 20 v 2:23 Bart Van Assche napsal(a):
>>> I agree that the same WARN_ON() occurs inside __iscsit_free_cmd(). What is not
>>> clear to me is how removing the WARN_ON() statement from iscsit_free_cmd() can
>>> help since an identical statement occurs inside __iscsit_free_cmd()?
>>
>> It doesn't help indeed, this patch just removes one duplicate warning but doesn't
>> really change anything.
>>
>> The bug I am trying to fix will need a different patch to prevent the race condition.
> 
> How about addressing both issues with a single patch?

I've nothing against it, I will just need a bit more time to come
up with a patch.

Maurizio

