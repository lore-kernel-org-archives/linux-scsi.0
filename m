Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6992DC54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FFC1206CD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:13:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KVJkexvD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgD0ONK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 10:13:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52726 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgD0ONK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 10:13:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RDx8rA074230;
        Mon, 27 Apr 2020 14:13:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gUpdw/99fJ2TWtChjqJlBcgrMx3YDDqfgekSfJRmQ4g=;
 b=KVJkexvDYF5o2aH31iM4vrz8HljvSBfOuLD8mranTY0LyteFSHz5FeKhHPHn4Tw9lx7n
 hyVjaOKDLipboyXFQOdQxfezZDLebKtq2tT2NoEtXXY6j4gp8ErlODlCy53J+cds+N8h
 tF83Un/vvAfogUhyuTVIr9FNQ+mXVoxi3x+J5NEGBESUQmUuuQf6mMqQ9BQMulThMTjS
 QShgfP+S/dyMLiebji3AzVmesL2w+XNxWrPGddbt3KPI/hIYU5TFcWBEIw3PPoG8lP9P
 ZY9z0/AbCDKm3Blun4us+MwPgu8DF60FfYhNcWZwn0EzX9d1Q8/N3kPDLYrFYrbXrTrt Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30p01ngbcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:13:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RE82vS073329;
        Mon, 27 Apr 2020 14:11:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30mxww95mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:11:00 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03REAxJY010051;
        Mon, 27 Apr 2020 14:10:59 GMT
Received: from [10.154.123.249] (/10.154.123.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 07:10:58 -0700
Subject: Re: [PATCH v4 02/11] qla2xxx: Suppress two recently introduced
 compiler warnings
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-3-bvanassche@acm.org>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <6022b2cb-aa51-cad1-001d-48751bc0dce3@oracle.com>
Date:   Mon, 27 Apr 2020 09:10:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427030310.19687-3-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270119
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/26/20 10:03 PM, Bart Van Assche wrote:
> Suppress the following two compiler warnings because these are not useful:
> 
> In file included from ./include/trace/define_trace.h:102,
>                   from ./include/trace/events/qla.h:39,
>                   from drivers/scsi/qla2xxx/qla_dbg.c:77:
> ./include/trace/events/qla.h: In function 'trace_event_raw_event_qla_log_event':
> ./include/trace/trace_events.h:691:9: warning: function 'trace_event_raw_event_qla_log_event' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
>    691 |  struct trace_event_raw_##call *entry;    \
>        |         ^~~~~~~~~~~~~~~~
> ./include/trace/events/qla.h:12:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>     12 | DECLARE_EVENT_CLASS(qla_log_event,
>        | ^~~~~~~~~~~~~~~~~~~
> In file included from ./include/trace/define_trace.h:103,
>                   from ./include/trace/events/qla.h:39,
>                   from drivers/scsi/qla2xxx/qla_dbg.c:77:
> ./include/trace/events/qla.h: In function 'perf_trace_qla_log_event':
> ./include/trace/perf.h:41:9: warning: function 'perf_trace_qla_log_event' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
>     41 |  struct hlist_head *head;     \
>        |         ^~~~~~~~~~
> ./include/trace/events/qla.h:12:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
> 
> Cc: Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Fixes: 598a90f2002c ("scsi: qla2xxx: add ring buffer for tracing debug logs")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   include/trace/events/qla.h | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/include/trace/events/qla.h b/include/trace/events/qla.h
> index b71f680968eb..737a667ab98f 100644
> --- a/include/trace/events/qla.h
> +++ b/include/trace/events/qla.h
> @@ -9,6 +9,9 @@
>   
>   #define QLA_MSG_MAX 256
>   
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
> +
>   DECLARE_EVENT_CLASS(qla_log_event,
>   	TP_PROTO(const char *buf,
>   		struct va_format *vaf),
> @@ -32,6 +35,8 @@ DEFINE_EVENT(qla_log_event, ql_dbg_log,
>   	TP_ARGS(buf, vaf)
>   );
>   
> +#pragma GCC diagnostic pop
> +
>   #endif /* _TRACE_QLA_H */
>   
>   #define TRACE_INCLUDE_FILE qla
> 

Looks Okay. This is for newly introduced ring buffer tracing.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
