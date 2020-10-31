Return-Path: <SRS0=Icgp=EG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAF3C388F9
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 19:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FBFE205ED
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 19:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N4mmZc5M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgJaTHz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Oct 2020 15:07:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53834 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgJaTHz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Oct 2020 15:07:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09VJ7ZQR115962;
        Sat, 31 Oct 2020 19:07:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xi/CFWuKgz+ABQ83ow+3Sm141qAtmXncHIOTvxTiLVM=;
 b=N4mmZc5MCcEzgW5wdesLs612VWmwwk0u1U5D3MEqrWh9b3lcDDaCEoX8+Yc8soWQk3JN
 pbFIOoZdEZslaAmhHSSTR8hd0bUE/czZxe9gr6GHJOcutc2Vias1lLZ34gWj6995U1i4
 olIjbJzyOj/HHEzbNtDQmIYy0PkwzHmpCJprIgW0w0pjYF+j9Icl9kJtRPsxIhnLWU6L
 AhU2HRnt/nvHHvcZxWfC9kyKV5LZDI1H2aDO8nr+rbn7aqB4co1Z/WUl1bqOTN8/gNgC
 vg9ghRF3Uv4fTHnvYA9h9hDKzcneOHWEH1AZaKEGt1RxSWgFwjVqx0FXhSogHDwDIb8B zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34gyvks4yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 31 Oct 2020 19:07:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09VJ6G99170440;
        Sat, 31 Oct 2020 19:07:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34gyqys3xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Oct 2020 19:07:35 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09VJ7RDe003531;
        Sat, 31 Oct 2020 19:07:31 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 31 Oct 2020 12:07:27 -0700
Subject: Re: [PATCH] scsi: libiscsi: Fix cmds hung when sd_shutdown
To:     Wu Bo <wubo40@huawei.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com
Cc:     lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com,
        lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com
References: <1604132622-497115-1-git-send-email-wubo40@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <15627360-dd21-074c-868b-88d641372594@oracle.com>
Date:   Sat, 31 Oct 2020 14:07:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1604132622-497115-1-git-send-email-wubo40@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9791 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010310158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9791 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 clxscore=1011
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010310158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/31/20 3:23 AM, Wu Bo wrote:
> For some reason, during reboot the system, iscsi.service failed to
> logout all sessions. kernel will hang forever on its
> sd_sync_cache() logic, after issuing the SYNCHRONIZE_CACHE cmd to all
> still existent paths.
> 
> [ 1044.098991] reboot: Mddev shutdown finished.
> [ 1044.099311] reboot: Usermodehelper disable finished.
> [ 1050.611244]  connection2:0: ping timeout of 5 secs expired, recv timeout 5, last rx 4295152378, last ping 4295153633, now 4295154944
> [ 1348.599676] Call trace:
> [ 1348.599887]  __switch_to+0xe8/0x150
> [ 1348.600113]  __schedule+0x33c/0xa08
> [ 1348.600372]  schedule+0x2c/0x88
> [ 1348.600567]  schedule_timeout+0x184/0x3a8
> [ 1348.600820]  io_schedule_timeout+0x28/0x48
> [ 1348.601089]  wait_for_common_io.constprop.2+0x168/0x258
> [ 1348.601425]  wait_for_completion_io_timeout+0x28/0x38
> [ 1348.601762]  blk_execute_rq+0x98/0xd8
> [ 1348.602006]  __scsi_execute+0xe0/0x1e8
> [ 1348.602262]  sd_sync_cache+0xd0/0x220 [sd_mod]
> [ 1348.602551]  sd_shutdown+0x6c/0xf8 [sd_mod]
> [ 1348.602826]  device_shutdown+0x13c/0x250
> [ 1348.603078]  kernel_restart_prepare+0x5c/0x68
> [ 1348.603400]  kernel_restart+0x20/0x98
> [ 1348.603683]  __se_sys_reboot+0x214/0x260
> [ 1348.603987]  __arm64_sys_reboot+0x24/0x30
> [ 1348.604300]  el0_svc_common+0x80/0x1b8
> [ 1348.604590]  el0_svc_handler+0x78/0xe0
> [ 1348.604877]  el0_svc+0x10/0x260
> 
> d754941225 (scsi: libiscsi: Allow sd_shutdown on bad transport) Once
> solved this problem. The iscsi_eh_cmd_timed_out() function add system_state
> judgment, and will return BLK_EH_DONE and mark the result as
> DID_NO_CONNECT when system_state is not SYSTEM_RUNNING,
> To tell upper layers that the command was handled during
> the transport layer error handler helper.
> 
> The scsi Mid Layer timeout handler function(scsi_times_out) will be
> abort the cmd if the scsi LLD timeout handler return BLK_EH_DONE.
> if abort cmd failed, will enter scsi EH logic.
> 
> Scsi EH will do reset target logic, if reset target failed, Will
> call iscsi_eh_session_reset() function to drop the session.
> 
> The iscsi_eh_session_reset function will wait for a relogin,
> session termination from userspace, or a recovery/replacement timeout.
> But at this time, the app iscsid has exited, and the session was marked as
> ISCSI_STATE_FAILED, So the SCSI EH process will never be
> scheduled back again.
> 
> PID: 9123   TASK: ffff80020c1b4d80  CPU: 3   COMMAND: "scsi_eh_2"
>   #0 [ffff00008632bb70] __switch_to at ffff000080088738
>   #1 [ffff00008632bb90] __schedule at ffff000080a00480
>   #2 [ffff00008632bc20] schedule at ffff000080a00b58
>   #3 [ffff00008632bc30] iscsi_eh_session_reset at ffff000000d1ab9c [libiscsi]
>   #4 [ffff00008632bcb0] iscsi_eh_recover_target at ffff000000d1d1fc [libiscsi]
>   #5 [ffff00008632bd00] scsi_try_target_reset at ffff0000806f0bac
>   #6 [ffff00008632bd30] scsi_eh_ready_devs at ffff0000806f2724
>   #7 [ffff00008632bde0] scsi_error_handler at ffff0000806f41d4
>   #8 [ffff00008632be70] kthread at ffff000080119ae0
> 
> Reported-by: Tianxiong Lu <lutianxiong@huawei.com>
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>   drivers/scsi/libiscsi.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 1e9c317..2570768 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2380,7 +2380,17 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
>   
>   	mutex_lock(&session->eh_mutex);
>   	spin_lock_bh(&session->frwd_lock);
> -	if (session->state == ISCSI_STATE_TERMINATE) {
> +
> +	/*
> +	 * During shutdown, if session is prematurely disconnected
> +	 * recovery won't happen and there will be hung cmds.
> +	 * To solve this case, all cmds would be enter scsi EH.
> +	 * But the EH path will wait for wait_event_interruptible() completed,
> +	 * when the session state machine is not ISCSI_STATE_TERMINATE,
> +	 * ISCSI_STATE_LOGGED_IN and ISCSI_STATE_RECOVERY_FAILED.
> +	 */
> +	if (session->state == ISCSI_STATE_TERMINATE ||
> +		unlikely(system_state != SYSTEM_RUNNING)) {
>   failed:
>   		ISCSI_DBG_EH(session,
>   			     "failing session reset: Could not log back into "

Do you need this with the current code? If the system_state is not 
SYSTEM_RUNNING above, shouldn't we call

iscsi_conn_failure -> iscsi_conn_error_event ->
stop_conn_work_fn -> iscsi_if_stop_conn(STOP_CONN_TERM) -> iscsi_conn_stop.

iscsi_conn_stop will set session->state to ISCSI_STATE_TERMINATE, so 
when iscsi_eh_session_reset does:

wait_event_interruptible(conn->ehwait,
                          session->state == ISCSI_STATE_TERMINATE ||

....

that will fail immediately right?
