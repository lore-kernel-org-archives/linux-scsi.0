Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4C6C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 18:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C793D22CB1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 18:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407712AbhARSwP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 13:52:15 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50856 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407529AbhARSv6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 13:51:58 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IIeloR102230;
        Mon, 18 Jan 2021 18:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8GefXcpZPbzkuLk9I0fDJwYB6Bx6bVC/7hGxIaOiLgU=;
 b=wgmKcvSxLKWr6kgoJdnaLGYQY7CSMtmVJ2vVS1ViztbicyrXf/M54344TkMvz9IEqOAD
 xnRYUiTNxr3b3hrOf2MQ/QHZW+8hON+KoMC9O3zVRAuiifzI4jH/fc20bnoBNbKH9wzr
 A5uX+6LkxMsFSy2vQxCYTn9bXJW/cxqNXSOiqiZC556xDZOQYTKOWdb3SXfFitalm7G5
 CEnXIbd0Tly+JcrvQKEWnD5eeZtr4s4C3pPrHd8ihVgyYxUlxWZayEJmZGO5I8EGyBst
 mnv+QkyXZFEfh4a1KqMgrAZ+pkxBJgSsqVKioR+loKJEoLDK6efxfJOuM0prsCSEZJOi 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 363nnaegpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 18:50:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IIiKMa028695;
        Mon, 18 Jan 2021 18:50:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3649wqbx53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 18:50:51 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10IIoigB018752;
        Mon, 18 Jan 2021 18:50:45 GMT
Received: from [20.15.0.204] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Jan 2021 10:50:43 -0800
Subject: Re: [PATCH] iscsi: Do Not set param when sock is NULL
To:     Gulam Mohamed <gulam.mohamed@oracle.com>
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>
References: <1a8aaa17-b1a3-4d6a-b87a-ff49d61a0d0b@default>
 <9df96d73-015c-4de6-96fa-2f315b066909@default>
 <05277786-2E1F-432D-AE73-F39565C6BEA4@oracle.com>
 <0abfcf5b-5ab8-4968-bf6d-eb4dee32e2f4@default>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <ca8ea0a8-37a5-0ebd-a73e-70edb82ac2b4@oracle.com>
Date:   Mon, 18 Jan 2021 12:50:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0abfcf5b-5ab8-4968-bf6d-eb4dee32e2f4@default>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/7/21 9:48 AM, Gulam Mohamed wrote:
> Hi Michael,
> 
>              As per your suggestions in below mail, I have completed the suggested changes and tested them. Can you please review and let me know your comments? Here is the patch:
> 
> Description
> ===========
> 1. This Kernel panic could be due to a timing issue when there is a race between the sync thread and the initiator was processing of a login response from the target. The session re-open can be invoked from two places
>   a. Sessions sync thread when the iscsid restart
>   b. From iscsid through iscsi error handler 2. The session reopen sequence is as follows in user-space (iscsi-initiator-utils)
>    a. Disconnect the connection
>    b. Then send the stop connection request to the kernel which releases the connection (releases the socket)
>    c. Queues the reopen for 2 seconds delay
>    d. Once the delay expires, create the TCP connection again by calling the connect() call
>    e. Poll for the connection
>    f. When poll is successful i.e when the TCP connection is established, it performs
>       i. Creation of session and connection data structures
>       ii. Bind the connection to the session. This is the place where we assign the sock to tcp_sw_conn->sock
>       iii. Sets the parameters like target name, persistent address etc .
>       iv. Creates the login pdu
>        v. Sends the login pdu to kernel
>       vi. Returns to the main loop to process further events. The kernel then sends the login request over to the target node
>    g. Once login response with success is received, it enters into full feature phase and sets the negotiable parameters like max_recv_data_length, max_transmit_length, data_digest etc .
> 3. While setting the negotiable parameters by calling "iscsi_session_set_neg_params()", kernel panicked as sock was NULL
> 
> What happened here is
> ---------------------
> 1. Before initiator received the login response mentioned in above point 2.f.v, another reopen request was sent from the error handler/sync session for the same session, as the initiator utils was in main loop to process further events (as mentioned in point 2.f.vi above).
> 2. While processing this reopen, it stopped the connection which released the socket and queued this connection and at this point of time the login response was received for the earlier on
> 
> Fix
> ---
> 
> 1. Create a flag "set_param_fail" in iscsi_cls_conn structure 2. On ep_disconnect and stop_conn set this flag to indicate set_param calls for connection level settings should fail 3. This way, scsi_transport_iscsi can set and check this bit for all drivers 2. On bind_conn clear the bit
> 
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 6 ++++++  include/scsi/scsi_transport_iscsi.h | 3 +++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 2e68c0a87698..15c5a7223a40 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2473,6 +2473,8 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
>  	 * it works.
>  	 */
>  	mutex_lock(&conn_mutex);
> +	if (!test_bit(ISCSI_SET_PARAM_FAIL_BIT, &conn->set_param_fail))
> +		set_bit(ISCSI_SET_PARAM_FAIL_BIT, &conn->set_param_fail);

You can just do a test_and_set_bit.

>  	conn->transport->stop_conn(conn, flag);
>  	mutex_unlock(&conn_mutex);
>  
> @@ -2895,6 +2897,8 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>  			session->recovery_tmo = value;
>  		break;
>  	default:
> +		if (test_bit(ISCSI_SET_PARAM_FAIL_BIT, &conn->set_param_fail))
> +			return -ENOTCONN;
>  		err = transport->set_param(conn, ev->u.set_param.param,
>  					   data, ev->u.set_param.len);
>  	}
> @@ -2956,6 +2960,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
>  		mutex_lock(&conn->ep_mutex);
>  		conn->ep = NULL;
>  		mutex_unlock(&conn->ep_mutex);
> +		set_bit(ISCSI_SET_PARAM_FAIL_BIT, &conn->set_param_fail);
>  	}
>  
>  	transport->ep_disconnect(ep);
> @@ -3716,6 +3721,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  		ev->r.retcode =	transport->bind_conn(session, conn,
>  						ev->u.b_conn.transport_eph,
>  						ev->u.b_conn.is_leading);
> +		clear_bit(ISCSI_SET_PARAM_FAIL_BIT, &conn->set_param_fail);

You should check retcode and only clear if it indicates success.


>  		mutex_unlock(&conn_mutex);
>  
>  		if (ev->r.retcode || !transport->ep_connect) diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 8a26a2ffa952..71b1952b913b 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -29,6 +29,8 @@ struct bsg_job;
>  struct iscsi_bus_flash_session;
>  struct iscsi_bus_flash_conn;
>  
> +#define ISCSI_SET_PARAM_FAIL_BIT	1
> +
>  /**
>   * struct iscsi_transport - iSCSI Transport template
>   *
> @@ -206,6 +208,7 @@ struct iscsi_cls_conn {
>  
>  	struct device dev;		/* sysfs transport/container device */
>  	enum iscsi_connection_state state;
> +	unsigned long set_param_fail; /* set_param for connection should fail 

You don't need a comment since the bit and field name say the same thing.

Th implementation is a little odd, because it's a bitmap with only one bit,
and named specifically for the one bit. It would be best to either do:

1. single bool/bit:

unsigned conn_bound:1;
or
bool conn_bound;

2. generic bitmap:

#define ISCSI_CONN_FLAGS_BOUND 1

unsigned long conn_state_flags;

3. fix up the iscsi_cls_conn->state values so it works in general and also
for your case.

For this conn state one we would fix up the conn state, because it's currently
looks wrong, and when the conn is down it still shows "up", and it doesn't seem
to show "failed".

So add a new state ISCSI_CONN_BOUND in:

static const char *const connection_state_names[] = {
        [ISCSI_CONN_UP] = "up",
        [ISCSI_CONN_DOWN] = "down",
        [ISCSI_CONN_FAILED] = "failed"
};

In iscsi_if_ep_disconnect and iscsi_if_stop_conn set:

conn->state = ISCSI_CONN_DOWN.

In that code where we call transport->bind_conn() do

if (!ev->r.retcode)
	conn->state = ISCSI_CONN_BOUND

and then in iscsi_set_param do

if (conn->state != ISCSI_CONN_BOUND)
	return -ENOTCONN
