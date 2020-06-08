Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD01C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 06:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C18082076C
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 06:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgFHGUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 02:20:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:34088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHGUW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jun 2020 02:20:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A78E9ACAE;
        Mon,  8 Jun 2020 06:20:24 +0000 (UTC)
Subject: Re: [PATCH 15/17] iscsi target: hook iscsi target into sysfs API
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-16-git-send-email-michael.christie@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <5922c71f-3fd9-69f3-b39a-0ef28554dc4c@suse.de>
Date:   Mon, 8 Jun 2020 08:20:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591562164-9766-16-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/20 10:36 PM, Mike Christie wrote:
> Have the iscsi target export it's sessions in sysfs.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/iscsi/iscsi_target.c      | 2 ++
>   drivers/target/iscsi/iscsi_target_nego.c | 9 +++++++++
>   2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 4c73374..f26d364 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4383,6 +4383,8 @@ int iscsit_close_session(struct iscsi_session *sess)
>   		}
>   	}
>   
> +	target_sysfs_remove_session(sess->se_sess);
> +
>   	if (sess->sess_ops->ErrorRecoveryLevel == 2)
>   		iscsit_free_connection_recovery_entries(sess);
>   
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index c44613a2..6dcb8ff 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -359,6 +359,13 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
>   					    ISCSI_LOGIN_STATUS_NO_RESOURCES);
>   			return -1;
>   		}
> +
> +		if (target_sysfs_add_session(&conn->tpg->tpg_se_tpg,
> +					     conn->sess->se_sess)) {
> +			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
> +					    ISCSI_LOGIN_STATUS_NO_RESOURCES);
> +			return -1;
> +		}
>   	}
>   
>   	if (conn->conn_transport->iscsit_put_login_tx(conn, login,
> @@ -371,6 +378,8 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
>   
>   err:
>   	if (login->login_complete) {
> +		target_sysfs_remove_session(conn->sess->se_sess);
> +
>   		if (conn->rx_thread && conn->rx_thread_active) {
>   			send_sig(SIGINT, conn->rx_thread, 1);
>   			complete(&conn->rx_login_comp);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
