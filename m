Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DAAC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 02:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 551AB2227F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 02:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l4zHS5hW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895183AbgJVCm3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 22:42:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38608 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895180AbgJVCm3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 22:42:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M2g2NC116641;
        Thu, 22 Oct 2020 02:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ID+MWcpfAgL/BolgPTt1XuoANirkm9tVdASOsjVwdnk=;
 b=l4zHS5hWlnz4251npLbeaT7PaynC/DV3pr7Pkyuwuwr22W1y6dtdUAA7ErpLwDEws3xz
 S+Hc1sX0/Ncm5g6LqO14OpWc2cn1XhJ6BcS3ozvQ5NYRxqcOI3eMEfmDO9+deE9EDfGH
 EgYLgzw6ol5dA5XXVUpiBMr2yYy5EymGMZ9R3JLMa9VVDtyapFGKhR298+byd7WJmuiW
 1LOW9ZVr+DyLR9jWzdP7ASvP/nbDflpHv7TusIIxExHNIsXnD9n/8J05poulQO8yZ8JV
 HOK5HqTZFnSbEREoPkywab5Zy+BbKZ2aXOAt3cKi4scCXcEhVQDa9JFfZjgfhwYvioQy MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 349jrpuph8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 02:42:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09M2TiTo029925;
        Thu, 22 Oct 2020 02:42:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 348ah0b62e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Oct 2020 02:42:25 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09M2gOqi004468;
        Thu, 22 Oct 2020 02:42:24 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 19:42:24 -0700
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a
 task
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
Date:   Wed, 21 Oct 2020 21:42:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201007145326.56850-3-mlombard@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=2 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9781 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=2 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/7/20 9:53 AM, Maurizio Lombardi wrote:
> The iscsit_release_commands_from_conn() function does the following
> operations:
> 
> 1) locks the cmd_lock spinlock
> 2) Scans the list of commands and sets the CMD_T_FABRIC_STOP flag
> 3) Releases the cmd_lock spinlock
> 4) Rescans the list again and clears the i_conn_node link of each command
> 
> If an abort task timer is fired between 3) and 4), it will find
> the CMD_T_FABRIC_STOP flag set and won't call list_del_init();
> therefore it may end up calling __iscsit_free_cmd() with a
> non-empty i_conn_node list, thus triggering the warning.
> 
> Considering that:
> 
> - we expect list_del_init() to be executed by
>   iscsit_release_commands_from_conn() when the CMD_T_FABRIC_STOP is set.
> - iscsit_aborted_task() is the only function that calls __iscsit_free_cmd()
>   directly, while all the other functions call iscsit_free_cmd().
> - the warning in __iscsit_free_cmd() is a duplicate (the same warning
>   can be found in iscsit_free_cmd().
> 

For iscsi, what does the last put on the cmd for a successful abort. Ignore this conn stop case.

If we abort a command successfully, the abort path does:

target_handle_abort -> transport_cmd_check_stop_to_fabric -> lio_check_stop_free -> target_put_sess_cmd

When we create the cmd we do transport_init_se_cmd and that sets the refcount=1. We do target_get_sess_cmd with ack_kref=true so that sets refcount=2.

On the abort completion path, target_handle_abort does target_put_sess_cmd (refcount=1 after), check_stop_free ends up doing a put (refcount=0 after).

If we free the cmd from the abort path, then for your conn stop plus abort race case, could we do:

1. thread1 runs iscsit_release_commands_from_conn and sets CMD_T_FABRIC_STOP.
2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It then returns from the aborted_task callout and we finish target_handle_abort and do:

target_handle_abort -> transport_cmd_check_stop_to_fabric -> lio_check_stop_free -> target_put_sess_cmd

The cmd is now freed.
3. thread1 now finishes iscsit_release_commands_from_conn and runs iscsit_free_cmd while accessing a command we just released.


