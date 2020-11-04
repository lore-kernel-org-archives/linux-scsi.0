Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1058C2D0A3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 21:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EF5120867
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 21:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DRONj/Ts"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgKDVeB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 16:34:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33224 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727098AbgKDVeA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 16:34:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4L9cpl087353;
        Wed, 4 Nov 2020 21:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JYHHlZoYUpmuu1gjzTNnNvfQg6haTYhkH7OnQGcSmGM=;
 b=DRONj/TsCPWOBBqH5ott/wDy1zrzx02Um8/eG9LBbc41eZA398OqgCqvdsl8sjfbG6d6
 bb1kkuZST0WVcIYa7T0dFEJKjEE491qJzGCZFoioR5bbCp8FgqcEmgU6qKQFcl1IesHP
 7027xHg6O9SeHmLNihDEXqYKDnd2bD2rQZo7E/AUSbIEfqw3Rm8dqT0naR+oIyn5dhL8
 aJOTvJMlpC49DNXc+rGmuFPklI8YiU52F//o9U3XHqBzgg6xpLeuBeQgLWDlISeOtjMr
 0qSjnI6q1CE9SVGfGFtLn/u+3/MBwwlyf//7it9rpKA+LOUTYKR6ysStsMLZP/41X/va qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34hhb290hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 04 Nov 2020 21:33:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A4LAWZ4091802;
        Wed, 4 Nov 2020 21:33:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34hw0kj4vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Nov 2020 21:33:54 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A4LXrAW001243;
        Wed, 4 Nov 2020 21:33:53 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 13:33:52 -0800
Subject: Re: [PATCH] scsi: libiscsi: fix NOP race condition
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org
Cc:     open-iscsi@googlegroups.com, Lee Duncan <lduncan@suse.com>
References: <20200918210947.23800-1-leeman.duncan@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <f0c9b3ff-7d93-9c2b-d405-e52fb4aa8c37@oracle.com>
Date:   Wed, 4 Nov 2020 15:33:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200918210947.23800-1-leeman.duncan@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=2 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=2
 clxscore=1011 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011040154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/18/20 4:09 PM, Lee Duncan wrote:
> From: Lee Duncan <lduncan@suse.com>
> 
> iSCSI NOPs are sometimes "lost", mistakenly sent to the
> user-land iscsid daemon instead of handled in the kernel,
> as they should be, resulting in a message from the daemon like:
> 
>> iscsid: Got nop in, but kernel supports nop handling.
> 
> This can occur because of the new forward- and back-locks,
> and the fact that an iSCSI NOP response can occur before
> processing of the NOP send is complete. This can result
> in "conn->ping_task" being NULL in iscsi_nop_out_rsp(),
> when the pointer is actually in the process of being set.
> 
> To work around this, we add a new state to the "ping_task"
> pointer. In addition to NULL (not assigned) and a pointer
> (assigned), we add the state "being set", which is signaled
> with an INVALID pointer (using "-1").
> 
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/scsi/libiscsi.c | 11 ++++++++++-
>   include/scsi/libiscsi.h |  3 +++
>   2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 1e9c3171fa9f..5eb064787ee2 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -738,6 +738,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>   						   task->conn->session->age);
>   	}
>   
> +	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
> +		WRITE_ONCE(conn->ping_task, task);
> +
>   	if (!ihost->workq) {
>   		if (iscsi_prep_mgmt_task(conn, task))
>   			goto free_task;
> @@ -941,6 +944,11 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>           struct iscsi_nopout hdr;
>   	struct iscsi_task *task;
>   
> +	if (!rhdr) {
> +		if (READ_ONCE(conn->ping_task))
> +			return -EINVAL;
> +		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
> +	}
>   	if (!rhdr && conn->ping_task)
>   		return -EINVAL;
>   
> @@ -957,11 +965,12 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>   
>   	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
>   	if (!task) {
> +		if (!rhdr)
> +			WRITE_ONCE(conn->ping_task, NULL);

I don't think you need this. If __iscsi_conn_send_pdu returns NULL, it 
will have done __iscsi_put_task and done this already.

>   		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
>   		return -EIO;
>   	} else if (!rhdr) {
>   		/* only track our nops */
> -		conn->ping_task = task;
>   		conn->last_ping = jiffies;
>   	}

Why in the send path do we always use the READ_ONCE/WRITE_ONCE, but in 
the completion path like in iscsi_complete_task we don't.
