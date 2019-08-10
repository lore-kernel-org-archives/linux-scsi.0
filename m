Return-Path: <SRS0=1VAV=WG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C365C433FF
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Aug 2019 23:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DED620872
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Aug 2019 23:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfHJXz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Aug 2019 19:55:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbfHJXz6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 10 Aug 2019 19:55:58 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF7023086208;
        Sat, 10 Aug 2019 23:55:57 +0000 (UTC)
Received: from [10.10.120.238] (ovpn-120-238.rdu2.redhat.com [10.10.120.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D85A2100197A;
        Sat, 10 Aug 2019 23:55:56 +0000 (UTC)
Subject: Re: [PATCH] tcmu: avoid use-after-free after command timeout
To:     Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
References: <20190810211903.6572-1-dmitry.fomichev@wdc.com>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5D4F598C.9000207@redhat.com>
Date:   Sat, 10 Aug 2019 18:55:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <20190810211903.6572-1-dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Sat, 10 Aug 2019 23:55:57 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/10/2019 04:19 PM, Dmitry Fomichev wrote:
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
>  drivers/target/target_core_user.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 04eda111920e..a0231491fa36 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1132,14 +1132,16 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
>  	struct se_cmd *se_cmd = cmd->se_cmd;
>  	struct tcmu_dev *udev = cmd->tcmu_dev;
>  	bool read_len_valid = false;
> -	uint32_t read_len = se_cmd->data_length;
> +	uint32_t read_len;
>  
>  	/*
>  	 * cmd has been completed already from timeout, just reclaim
>  	 * data area space and free cmd
>  	 */
> -	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
> +	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
> +		WARN_ON_ONCE(se_cmd);

If you are adding a warn here, I think you want to also add a warn in
tcmu_reset_ring where there is another code path we do the same sequence
of operations where we check the bit then access the se_cmd after if not
set.

