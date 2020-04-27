Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8390DC54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 08:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60CDF206D4
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 08:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgD0IPw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 04:15:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:53602 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbgD0IPv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 04:15:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0F4C0AE39;
        Mon, 27 Apr 2020 08:15:49 +0000 (UTC)
Date:   Mon, 27 Apr 2020 10:15:48 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 02/11] qla2xxx: Suppress two recently introduced
 compiler warnings
Message-ID: <20200427081548.skbi7pqysknamfv5@beryllium.lan>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427030310.19687-3-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

[Cc: added Steven]

On Sun, Apr 26, 2020 at 08:03:01PM -0700, Bart Van Assche wrote:
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

I would be really surprised if this is needed for every single
DECLARE_EVENT_CLASS declaration. 

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

Thanks,
Daniel
