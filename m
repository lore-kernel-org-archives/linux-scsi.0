Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4483C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 12:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 887BD61920
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 12:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCZMcN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 08:32:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229994AbhCZMbt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Mar 2021 08:31:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616761908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uoFm8PFiOFNN12353P3Ed1Q+qFESi+uN0ZPezq27Hjg=;
        b=CjZ4E3Un38/djGDf7FNMY0AS3uv/cPAzYk0e/sArcglErueKFDpfQlqo4XPGqXJ7mw9XpK
        2Sm748tQ+YLWWCbeElrQVw/wBQgXke1cENh2oNVxQA4zyRI5tud5mGEHBjHdxRYeXByF5L
        lOHL9+T0oKc0JSBznBVW0M1tfXwuvuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-Wi_76igrPqCPpF-pCxDJqw-1; Fri, 26 Mar 2021 08:31:44 -0400
X-MC-Unique: Wi_76igrPqCPpF-pCxDJqw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F40C280006E;
        Fri, 26 Mar 2021 12:31:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 200226062F;
        Fri, 26 Mar 2021 12:31:40 +0000 (UTC)
Subject: Re: [PATCH] target: Fix a double put in transport_free_session
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210323025851.11782-1-lyl2019@mail.ustc.edu.cn>
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <f03c8a67-d015-d503-726b-647b4f327b25@redhat.com>
Date:   Fri, 26 Mar 2021 13:31:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323025851.11782-1-lyl2019@mail.ustc.edu.cn>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Dne 23. 03. 21 v 3:58 Lv Yunlong napsal(a):
> In transport_free_session, se_nacl is got from se_sess
> with the initial reference. If se_nacl->acl_sess_list is
> empty, se_nacl->dynamic_stop is set to true. Then the first
> target_put_nacl(se_nacl) will drop the initial reference
> and free se_nacl. Later there is a second target_put_nacl()
> to put se_nacl. It may cause error in race.
> 
> My patch sets se_nacl->dynamic_stop to false to avoid the
> double put.
> 
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
> ---
>  drivers/target/target_core_transport.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 5ecb9f18a53d..c266defe694f 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -584,8 +584,10 @@ void transport_free_session(struct se_session *se_sess)
>  		}
>  		mutex_unlock(&se_tpg->acl_node_mutex);
>  
> -		if (se_nacl->dynamic_stop)
> +		if (se_nacl->dynamic_stop) {
>  			target_put_nacl(se_nacl);
> +			se_nacl->dynamic_stop = false;
> +		}
>  
>  		target_put_nacl(se_nacl);
>  	}
> 

FYI,

I have received a bug report against the 5.8 kernel about task hangs that seems to involve the nacl "dynamic_stop" code

Mar  4 16:49:44 gzboot kernel: [186322.177819] INFO: task targetcli:2359053 blocked for more than 120 seconds.
Mar  4 16:49:44 gzboot kernel: [186322.178862]       Tainted: P           O      5.8.0-44-generic #50-Ubuntu
Mar  4 16:49:44 gzboot kernel: [186322.179746] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 16:49:44 gzboot kernel: [186322.180583] targetcli       D    0 2359053 2359052 0x00000000
Mar  4 16:49:44 gzboot kernel: [186322.180586] Call Trace:
Mar  4 16:49:44 gzboot kernel: [186322.180592]  __schedule+0x212/0x5d0
Mar  4 16:49:44 gzboot kernel: [186322.180595]  ? usleep_range+0x90/0x90
Mar  4 16:49:44 gzboot kernel: [186322.180596]  schedule+0x55/0xc0
Mar  4 16:49:44 gzboot kernel: [186322.180597]  schedule_timeout+0x10f/0x160
Mar  4 16:49:44 gzboot kernel: [186322.180601]  ? evict+0x14c/0x1b0
Mar  4 16:49:44 gzboot kernel: [186322.180602]  __wait_for_common+0xa8/0x150
Mar  4 16:49:44 gzboot kernel: [186322.180603]  wait_for_completion+0x24/0x30
Mar  4 16:49:44 gzboot kernel: [186322.180637]  core_tpg_del_initiator_node_acl+0x8e/0x120 [target_core_mod]
Mar  4 16:49:44 gzboot kernel: [186322.180643]  target_fabric_nacl_base_release+0x26/0x30 [target_core_mod]
Mar  4 16:49:44 gzboot kernel: [186322.180647]  config_item_cleanup+0x5d/0xf0
Mar  4 16:49:44 gzboot kernel: [186322.180649]  config_item_put+0x2d/0x40
Mar  4 16:49:44 gzboot kernel: [186322.180651]  configfs_rmdir+0x1d8/0x350
Mar  4 16:49:44 gzboot kernel: [186322.180653]  vfs_rmdir.part.0+0x66/0x190
Mar  4 16:49:44 gzboot kernel: [186322.180654]  do_rmdir+0x1b4/0x200
Mar  4 16:49:44 gzboot kernel: [186322.180655]  __x64_sys_rmdir+0x17/0x20
Mar  4 16:49:44 gzboot kernel: [186322.180657]  do_syscall_64+0x49/0xc0
Mar  4 16:49:44 gzboot kernel: [186322.180659]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Mar  4 16:49:44 gzboot kernel: [186322.180660] RIP: 0033:0x7f30cf1ca9eb
Mar  4 16:49:44 gzboot kernel: [186322.180661] RSP: 002b:00007ffd72030bd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000054
Mar  4 16:49:44 gzboot kernel: [186322.180662] RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 00007f30cf1ca9eb
Mar  4 16:49:44 gzboot kernel: [186322.180663] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007f30cc1e2a50
Mar  4 16:49:44 gzboot kernel: [186322.180664] RBP: 0000000000a4b7a0 R08: 0000000000000000 R09: 00007ffd72030b7f
Mar  4 16:49:44 gzboot kernel: [186322.180664] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd72030c00
Mar  4 16:49:44 gzboot kernel: [186322.180665] R13: 00007f30cdd706a8 R14: 00007f30ced00cc0 R15: 00007f30cdd70698


Maurizio

