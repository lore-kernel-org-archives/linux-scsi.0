Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEFDC6FA8B
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 23:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiISXPe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 19:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiISXPc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 19:15:32 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8D549B7A
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 16:15:31 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28JG4xnM010918;
        Mon, 19 Sep 2022 16:15:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=VtxQQO78bSnmvcvs2YuHHFQT/3/aayrYTsmQ2RTicvA=;
 b=gpYcQeRHf3iDeeWPGCt2otyU/TejDYH6pRQwSAM3iiygJ/x1frLfYnjLlaOuGp5evmSO
 G5iyT4oc45MmVpuvYEXWaSNKFSc5732sT6hleVyFp2L/RbVe+E7GjxYq56+watg1qWtT
 4gX7Uv4lGC8M90sa5/1D/fiOCA1CCKh9xroyoTzM6TSgWOHKLfOFH5D4gGK80AA3r9ju
 ZM7RuZmUzqYhVR1zB6FH7bEH1vw+D9ChAzMMhoJpbOEqTSIxe/S4wQSCVsiioaAzzh9S
 hTeGyd0ZoqsPPNCsPpNcsp+99b71wToZVwVMA/Y8Xth+DY3/4UiHKKBcARg2p197Dbvo 0g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jndrmrcsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 16:15:18 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 19 Sep
 2022 16:15:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 19 Sep 2022 16:15:16 -0700
Received: from mvluser05.qlc.com (unknown [10.112.10.135])
        by maili.marvell.com (Postfix) with ESMTP id 53F213F70C6;
        Mon, 19 Sep 2022 16:15:16 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by mvluser05.qlc.com (8.14.4/8.14.4/Submit) with ESMTP id 28JNFDOY031515;
        Mon, 19 Sep 2022 16:15:14 -0700
X-Authentication-Warning: mvluser05.qlc.com: aeasi owned process doing -bs
Date:   Mon, 19 Sep 2022 16:15:13 -0700
From:   Arun Easi <aeasi@marvell.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>
Subject: Re: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate
 tunable and more
In-Reply-To: <20220919220110.GA352230@roeck-us.net>
Message-ID: <99caf0ec-c4c5-4333-bcec-1f2ffa5a7e94@marvell.com>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-6-njavali@marvell.com>
 <20220919220110.GA352230@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: 9bLbao6NHtmW3MEa59BqiKOKNk4lRepJ
X-Proofpoint-ORIG-GUID: 9bLbao6NHtmW3MEa59BqiKOKNk4lRepJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_05,2022-09-16_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Guenter,

On Mon, 19 Sep 2022, 3:01pm, Guenter Roeck wrote:

> On Fri, Aug 26, 2022 at 03:25:57AM -0700, Nilesh Javali wrote:
> > From: Arun Easi <aeasi@marvell.com>
> > 
> > Older tracing of driver messages was to:
> >     - log only debug messages to kernel main trace buffer AND
> >     - log only if extended logging bits corresponding to this
> >       message is off
> > 
> > This has been modified and extended as follows:
> >     - Tracing is now controlled via ql2xextended_error_logging_ktrace
> >       module parameter. Bit usages same as ql2xextended_error_logging.
> >     - Tracing uses "qla2xxx" trace instance, unless instance creation
> >       have issues.
> >     - Tracing is enabled (compile time tunable).
> >     - All driver messages, include debug and log messages are now traced
> >       in kernel trace buffer.
> > 
> > Trace messages can be viewed by looking at the qla2xxx instance at:
> >     /sys/kernel/tracing/instances/qla2xxx/trace
> > 
> > Trace tunable that takes the same bit mask as ql2xextended_error_logging
> > is:
> >     ql2xextended_error_logging_ktrace (default=1)
> > 
> > Suggested-by: Daniel Wagner <dwagner@suse.de>
> > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Arun Easi <aeasi@marvell.com>
> > Signed-off-by: Nilesh Javali <njavali@marvell.com>
> 
> I understand this has already been reported early September, but then
> the problem disapppeared in next-20220912 and reappeared in next-20220919.
> 
> This patch results in various test build failures. Example:
> 
> Building powerpc:skiroot_defconfig ... failed
> --------------
> Error log:
> drivers/scsi/qla2xxx/qla_os.c: In function 'qla_trace_init':
> drivers/scsi/qla2xxx/qla_os.c:2854:25: error:
> 	implicit declaration of function 'trace_array_get_by_name'; did you mean 'trace_array_set_clr_event'?
> 
> Guenter
> 

Apologies for the troubles this patch has caused.

A fix for this is already posted (in trace.h), but is awaiting a final 
approval from the maintainer:

https://lore.kernel.org/linux-scsi/20220907233308.4153-2-aeasi@marvell.com/

Martin,

In the interest of time, and with more people running into the build 
failures, if you want to pick up "Ren Zhijie"'s fix posted earlier today 
with the fix all contained within the qla2xxx driver, feel free to go 
ahead (I will NAK my NAK in that case :o )

Regards,
-Arun
