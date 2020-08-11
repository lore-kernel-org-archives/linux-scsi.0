Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83916C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 07:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64089206B2
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 07:35:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="ZYU0YGUJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgHKHff (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 03:35:35 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:57872 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726397AbgHKHff (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Aug 2020 03:35:35 -0400
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id BED732E14CB;
        Tue, 11 Aug 2020 10:35:31 +0300 (MSK)
Received: from unknown (unknown [::1])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id MJceGXGEeh-ZUviXBOc;
        Tue, 11 Aug 2020 10:35:31 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1597131331; bh=6IiLxbT+LjkEAMXwjLGaIHt0HIeIs+2/bTu196W6YRM=;
        h=Message-Id:Cc:Subject:In-Reply-To:Date:References:To:From;
        b=ZYU0YGUJV1U5OrDZlfObo7iJQUDlajSCzkx5kmSqhauYQ68CVo/55QuHBJ8KOpRIA
         FA4RX3sVQ5lbnUOpLftLDYILaArEeJkec1YhyMZdM1f8ANcdh0z/D67K/l2pTyJ/Mp
         oWK3wy9bwCKJ/IfyHY34G/3Y7KgjDhhTGfxR7SaU=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
X-Yandex-Sender-Uid: 1120000000084479
Received: by myt4-457577cc370d.qloud-c.yandex.net with HTTP;
        Tue, 11 Aug 2020 10:35:30 +0300
From:   =?utf-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?= 
        <dmtrmonakhov@yandex-team.ru>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
In-Reply-To: <fb7fa6c3-40e4-ba17-f16a-307fa1a1b68a@acm.org>
References: <20200809095501.23166-1-dmtrmonakhov@yandex-team.ru> <fb7fa6c3-40e4-ba17-f16a-307fa1a1b68a@acm.org>
Subject: Re: [PATCH] scsi_debugfs: dump allocted field in more convenient format
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Tue, 11 Aug 2020 10:35:30 +0300
Message-Id: <23451597129769@mail.yandex-team.ru>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



11.08.2020, 02:22, "Bart Van Assche" <bvanassche@acm.org>:
> On 2020-08-09 02:55, Dmitry Monakhov wrote:
>>  All request's data fields are formatted as key=val, the only exception is
>>  allocated field, which complicates parsing.
>>
>>  With that patch request looks like follows:
>>  0000000012a51451 {.op=WRITE, .cmd_flags=SYNC|IDLE, .rq_flags=STARTED|DONTPREP|ELVPRIV|IO_STAT, .state=in_flight, .tag=137, .internal_tag=188, .cmd=opcode=0x2a 2a 00 00 00 45 18 00 00 08 00, .retries=0, .result = 0x0, .flags=TAGGED|INITIALIZED|3, .timeout=30.000, .alloc_age=0.004}
>>
>>  Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
>>  ---
>>   drivers/scsi/scsi_debugfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>  diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
>>  index c19ea7a..6ce22b1 100644
>>  --- a/drivers/scsi/scsi_debugfs.c
>>  +++ b/drivers/scsi/scsi_debugfs.c
>>  @@ -45,7 +45,7 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
>>                      cmd->retries, cmd->result);
>>           scsi_flags_show(m, cmd->flags, scsi_cmd_flags,
>>                           ARRAY_SIZE(scsi_cmd_flags));
>>  - seq_printf(m, ", .timeout=%d.%03d, allocated %d.%03d s ago",
>>  + seq_printf(m, ", .timeout=%d.%03d, .alloc_age=%d.%03d",
>>                      timeout_ms / 1000, timeout_ms % 1000,
>>                      alloc_ms / 1000, alloc_ms % 1000);
>>   }
>
> Hi Dmitry,
>
> These messages are intended for humans and are not intended for processing
> by any kind of software. I think the current message is easier to understand
> by a human than the new message introduced by the above patch.

Let me disagree. I try to write test for issue like  [1]
My test does random fault injection and scan  /sys/kernel/debug/block/*/*/busy for stuck requests
The object's format looks sane and well structured for parsers, the only exception is "allocated" field, see below:
  0000000012a51451 {.op=WRITE, .state=in_flight, .tag=137.... .timeout=30.000, allocated 41255.568 s ago}

All I want to do is just make it looks unified with other fields, see below:
  0000000012a51451 {.op=WRITE, .state=in_flight, .tag=137.... .timeout=30.000, .alloc_age=41255.568}

If field name 'alloc_age' is not descriptive enough please suggest me a better one. But we definitely need
to unify  it  to .NAME=VALUE format.

Footnotes:
[1]  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b554db147feea39617b533ab6bca247c91c6198a




>
> Thanks,
>
> Bart.
