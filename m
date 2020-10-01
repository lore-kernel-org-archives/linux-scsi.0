Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE69AC4741F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 19:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89CF821481
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 19:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbgJATsS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 15:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729990AbgJATsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 15:48:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F3C0613D0;
        Thu,  1 Oct 2020 12:48:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF86014671C73;
        Thu,  1 Oct 2020 12:31:28 -0700 (PDT)
Date:   Thu, 01 Oct 2020 12:48:15 -0700 (PDT)
Message-Id: <20201001.124815.793423380665613978.davem@davemloft.net>
To:     colyli@suse.de
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, chaitanya.kulkarni@wdc.com,
        cleech@redhat.com, hch@lst.de, amwang@redhat.com,
        eric.dumazet@gmail.com, hare@suse.de, idryomov@gmail.com,
        jack@suse.com, jlayton@kernel.org, axboe@kernel.dk,
        lduncan@suse.com, michaelc@cs.wisc.edu,
        mskorzhinskiy@solarflare.com, philipp.reisner@linbit.com,
        sagi@grimberg.me, vvs@virtuozzo.com, vbabka@suse.com
Subject: Re: [PATCH v9 0/7] Introduce sendpage_ok() to detect misused
 sendpage in network related drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001.124345.2303686561459641833.davem@davemloft.net>
References: <20201001075408.25508-1-colyli@suse.de>
        <20201001.124345.2303686561459641833.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 12:31:29 -0700 (PDT)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVGh1LCAwMSBP
Y3QgMjAyMCAxMjo0Mzo0NSAtMDcwMCAoUERUKQ0KDQo+IFNlcmllcyBhcHBsaWVkIGFuZCBxdWV1
ZWQgdXAgZm9yIC1zdGFibGUsIHRoYW5rIHlvdS4NCg0KQWN0dWFsbHksIHRoaXMgZG9lc24ndCBl
dmVuIGJ1aWxkOg0KDQpJbiBmaWxlIGluY2x1ZGVkIGZyb20gLi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9idWcuaDo5MywNCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvYnVnLmg6
NSwNCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvbW1kZWJ1Zy5oOjUsDQog
ICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L21tLmg6OSwNCiAgICAgICAgICAg
ICAgICAgZnJvbSBuZXQvc29ja2V0LmM6NTU6DQpuZXQvc29ja2V0LmM6IEluIGZ1bmN0aW9uIKFr
ZXJuZWxfc2VuZHBhZ2WiOg0KLi9pbmNsdWRlL2FzbS1nZW5lcmljL2J1Zy5oOjk3OjM6IGVycm9y
OiB0b28gZmV3IGFyZ3VtZW50cyB0byBmdW5jdGlvbiChX193YXJuX3ByaW50a6INCiAgIDk3IHwg
ICBfX3dhcm5fcHJpbnRrKGFyZyk7ICAgICBcDQogICAgICB8ICAgXn5+fn5+fn5+fn5+fg0KDQpX
YXMgdGhpcyBldmVuIGJ1aWxkIHRlc3RlZD8NCg0K
