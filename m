Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE747C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99F212082E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:32:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="VBeToWEJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgEKHck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 03:32:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38064 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728014AbgEKHcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 03:32:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04B7V03i008680;
        Mon, 11 May 2020 00:32:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=OpuO8ERrQ4Y3E/rMh84ntwk8oSBu1+smbvrlLQ1O+rk=;
 b=VBeToWEJkR/S9iy61c803aCW5exUX17453PZNVI/6Wqhb/4tJhhE1tgBBeBMapi3UYfJ
 qQelJr7ih2zrmiIfCZ1EdEuJseDxH03WqobTHHs0rLBWqXdbbrNDpRf2WUQDPEq+JPfI
 JI5G/qabvLVgV30E8daMkYKaC9RBYttH8yH7TbwqoHkqKHgEd7AXNzcvt7DVTRz7MZob
 lVopTN/q9UyAli0iJl+wB810xMr5ln5xABzLLlLD2iSxppCoRsgfIVkzZPipF9OsKVVJ
 AL5yhUw6aNNio0efDrZrDiuAd6xke3Yh2b01upLyPC7T54ZVSsqoZ+XyA7WkajawOwHH ng== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30wsvqdw7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 00:32:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 May
 2020 00:32:19 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 May
 2020 00:32:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 May 2020 00:32:19 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id C23A23F7041;
        Mon, 11 May 2020 00:32:18 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 04B7WIhQ022293;
        Mon, 11 May 2020 00:32:18 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 11 May 2020 00:32:18 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>,
        "Rajan Shanmugavelu" <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH v4 02/11] qla2xxx: Suppress two recently introduced
 compiler warnings
In-Reply-To: <20200427030310.19687-3-bvanassche@acm.org>
Message-ID: <alpine.LRH.2.21.9999.2005110031410.23618@irv1user01.caveonetworks.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-3-bvanassche@acm.org>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_02:2020-05-11,2020-05-11 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 26 Apr 2020, 8:03pm, Bart Van Assche wrote:

> Suppress the following two compiler warnings because these are not useful:
> 
> In file included from ./include/trace/define_trace.h:102,
>                  from ./include/trace/events/qla.h:39,
>                  from drivers/scsi/qla2xxx/qla_dbg.c:77:
> ./include/trace/events/qla.h: In function 'trace_event_raw_event_qla_log_event':
> ./include/trace/trace_events.h:691:9: warning: function 'trace_event_raw_event_qla_log_event' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
>   691 |  struct trace_event_raw_##call *entry;    \
>       |         ^~~~~~~~~~~~~~~~
> ./include/trace/events/qla.h:12:1: note: in expansion of macro 'DECLARE_EVENT_CLASS'
>    12 | DECLARE_EVENT_CLASS(qla_log_event,
>       | ^~~~~~~~~~~~~~~~~~~
> In file included from ./include/trace/define_trace.h:103,
>                  from ./include/trace/events/qla.h:39,
>                  from drivers/scsi/qla2xxx/qla_dbg.c:77:
> ./include/trace/events/qla.h: In function 'perf_trace_qla_log_event':
> ./include/trace/perf.h:41:9: warning: function 'perf_trace_qla_log_event' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
>    41 |  struct hlist_head *head;     \
>       |         ^~~~~~~~~~
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
>  include/trace/events/qla.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/trace/events/qla.h b/include/trace/events/qla.h
> index b71f680968eb..737a667ab98f 100644
> --- a/include/trace/events/qla.h
> +++ b/include/trace/events/qla.h
> @@ -9,6 +9,9 @@
>  
>  #define QLA_MSG_MAX 256
>  
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
> +
>  DECLARE_EVENT_CLASS(qla_log_event,
>  	TP_PROTO(const char *buf,
>  		struct va_format *vaf),
> @@ -32,6 +35,8 @@ DEFINE_EVENT(qla_log_event, ql_dbg_log,
>  	TP_ARGS(buf, vaf)
>  );
>  
> +#pragma GCC diagnostic pop
> +
>  #endif /* _TRACE_QLA_H */
>  
>  #define TRACE_INCLUDE_FILE qla
> 

Thank you for the patch. Looks ok.


