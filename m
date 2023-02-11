Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92B0C636CC
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Feb 2023 08:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjBKItL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Feb 2023 03:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjBKItJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Feb 2023 03:49:09 -0500
X-Greylist: delayed 353 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 11 Feb 2023 00:48:41 PST
Received: from pio-pvt-msa1.bahnhof.se (pio-pvt-msa1.bahnhof.se [79.136.2.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E363AB4;
        Sat, 11 Feb 2023 00:48:41 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa1.bahnhof.se (Postfix) with ESMTP id C4E173FAD3;
        Sat, 11 Feb 2023 09:42:45 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from pio-pvt-msa1.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XDBT9IO96Ady; Sat, 11 Feb 2023 09:42:45 +0100 (CET)
Received: by pio-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id B88143F785;
        Sat, 11 Feb 2023 09:42:44 +0100 (CET)
Received: from 90-224-97-87-no521.tbcn.telia.com ([90.224.97.87]:36104 helo=[192.168.1.18])
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1pQlT1-0001kM-8T; Sat, 11 Feb 2023 09:42:44 +0100
Message-ID: <b2e0cb60-c8d5-2bd2-2954-d3b32252572a@tnonline.net>
Date:   Sat, 11 Feb 2023 09:42:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/2] target: iscsi: free cmds before session free
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20230125083309.24678-1-d.bogdanov@yadro.com>
 <20230125083309.24678-3-d.bogdanov@yadro.com>
Content-Language: sv-SE
From:   Forza <forza@tnonline.net>
In-Reply-To: <20230125083309.24678-3-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2023-01-25 09:33, Dmitry Bogdanov wrote:
> Commands from recovery entries are freed after its session has been
> closed. That leads to use-after-free at command free or NPE with such
> call trace:
> 
> Time2Retain timer expired for SID: 1, cleaning up iSCSI session.
> BUG: kernel NULL pointer dereference, address: 0000000000000140
> RIP: 0010:sbitmap_queue_clear+0x3a/0xa0
> Call Trace:
>   target_release_cmd_kref+0xd1/0x1f0 [target_core_mod]
>   transport_generic_free_cmd+0xd1/0x180 [target_core_mod]
>   iscsit_free_cmd+0x53/0xd0 [iscsi_target_mod]
>   iscsit_free_connection_recovery_entries+0x29d/0x320 [iscsi_target_mod]
>   iscsit_close_session+0x13a/0x140 [iscsi_target_mod]
>   iscsit_check_post_dataout+0x440/0x440 [iscsi_target_mod]
>   call_timer_fn+0x24/0x140
> 
> Move cleanup of recovery enrties to before session freeing.
> 
> Reported-by: Forza <forza@tnonline.net>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>   drivers/target/iscsi/iscsi_target.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index f6008675dd3f..0748cbfb9631 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4521,6 +4521,9 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
>   	iscsit_stop_time2retain_timer(sess);
>   	spin_unlock_bh(&se_tpg->session_lock);
>   
> +	if (sess->sess_ops->ErrorRecoveryLevel == 2)
> +		iscsit_free_connection_recovery_entries(sess);
> +
>   	/*
>   	 * transport_deregister_session_configfs() will clear the
>   	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process context
> @@ -4544,9 +4547,6 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
>   
>   	transport_deregister_session(sess->se_sess);
>   
> -	if (sess->sess_ops->ErrorRecoveryLevel == 2)
> -		iscsit_free_connection_recovery_entries(sess);
> -
>   	iscsit_free_all_ooo_cmdsns(sess);
>   
>   	spin_lock_bh(&se_tpg->session_lock);

I have not had any more issues since applying the patch, which is good 
news :)

Will this be backported to earlier stable kernels like 5.15.x and 6.1.x

Regards,
Forza
