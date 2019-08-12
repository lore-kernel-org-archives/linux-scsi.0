Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B4BC31E40
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 15:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 952E22070C
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 15:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfHLPaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 11:30:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49245 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727503AbfHLPaU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 11:30:20 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 912E585536;
        Mon, 12 Aug 2019 15:30:20 +0000 (UTC)
Received: from [10.10.124.11] (ovpn-124-11.rdu2.redhat.com [10.10.124.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B55775C1B5;
        Mon, 12 Aug 2019 15:30:19 +0000 (UTC)
Subject: Re: [PATCH v2] tcmu: avoid use-after-free after command timeout
To:     Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
References: <20190811182510.1706-1-dmitry.fomichev@wdc.com>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5D51860B.1060902@redhat.com>
Date:   Mon, 12 Aug 2019 10:30:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <20190811182510.1706-1-dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 12 Aug 2019 15:30:20 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/11/2019 01:25 PM, Dmitry Fomichev wrote:
> In tcmu_handle_completion() function, the variable called read_len is
> always initialized with a value taken from se_cmd structure. If this
> function is called to complete an expired (timed out) out command, the
> session command pointed by se_cmd is likely to be already deallocated by
> the target core at that moment. As the result, this access triggers a
> use-after-free warning from KASAN.
> 
> This patch fixes the code not to touch se_cmd when completing timed out
> TCMU commands. It also resets the pointer to se_cmd at the time when the
> TCMU_CMD_BIT_EXPIRED flag is set because it is going to become invalid
> after calling target_complete_cmd() later in the same function,
> tcmu_check_expired_cmd().
> 
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---

Acked-by: Mike Christie <mchristi@redhat.com>

