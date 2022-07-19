Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00619C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 21:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbiGSVGl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240548AbiGSVG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 17:06:29 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F1061D40
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 14:06:19 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JGoArP014154;
        Tue, 19 Jul 2022 14:06:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=yef932Ra0866vSLpasDIXLoty8/3vQwO6MoE2NnWRHk=;
 b=HwZD4ExqGJ+aWlWesFPigJq8Zixf3ym4OFJwOxAd9r9+BIg08MBJc16LTG4IlSNrPZ2u
 0bO7TEb8oX2rVgFFzVwyy5IBYoqv+Sy8S5e4k2//9ikrAPdNRmWmiKQU+k9dcwc8CNJq
 oPu/PEE0fb4JP7NMlU8cnWxeB0zPRmzNA7KpYooathmMxHxfSxU+mlmHZ9qifqwu54kQ
 BLB5NMgK+CddHZDizIgpogUHRhft4E+5PN8fLH6dNOJwIpik/Rrjbiheg7KNYcTgZ4pt
 uFwrT2oOVJASiGRwPH+KWc7aLF+tCKiirIrgSAwF+xiV+dYjFg7e5CYDfinmL9rTV/Od Xg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hdqw1awpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 14:06:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 Jul
 2022 14:06:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Jul 2022 14:06:13 -0700
Received: from mvluser05.qlc.com (unknown [10.112.10.135])
        by maili.marvell.com (Postfix) with ESMTP id 4FAE03F7090;
        Tue, 19 Jul 2022 14:06:13 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by mvluser05.qlc.com (8.14.4/8.14.4/Submit) with ESMTP id 26JL6B67028985;
        Tue, 19 Jul 2022 14:06:12 -0700
X-Authentication-Warning: mvluser05.qlc.com: aeasi owned process doing -bs
Date:   Tue, 19 Jul 2022 14:06:11 -0700
From:   Arun Easi <aeasi@marvell.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: Re: [EXT] Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
In-Reply-To: <20220718152243.21ad13e7@gandalf.local.home>
Message-ID: <259d53a5-958e-6508-4e45-74dba2821242@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
 <20220715060227.23923-3-njavali@marvell.com>
 <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
 <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
 <20220718152243.21ad13e7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="1879738122-1939649863-1658264773=:3483"
X-Proofpoint-ORIG-GUID: Z7u43gLfTf9WZQfrOaanoCiFNbW5ZNrs
X-Proofpoint-GUID: Z7u43gLfTf9WZQfrOaanoCiFNbW5ZNrs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_08,2022-07-19_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--1879738122-1939649863-1658264773=:3483
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT

On Mon, 18 Jul 2022, 12:22pm, Steven Rostedt wrote:

> External Email
> 
> ----------------------------------------------------------------------
> On Mon, 18 Jul 2022 12:02:26 -0700
> Arun Easi <aeasi@marvell.com> wrote:
> 
> > Many times when a problem was reported on the driver, we had to request 
> > for a repro with extended error logging (via driver module parameter) 
> > turned on. With this internal tracing in place, log messages that appear 
> > only with extended error logging are captured by default in the internal 
> > trace buffer.
> > 
> > AFAIK, kernel tracing requires a user initiated action to be turned on, 
> > like enabling individual tracepoints. Though a script (either startup or 
> > udev) can do this job, enabling tracepoints by default for a single 
> > driver, I think, may not be a preferred choice -- particularly when the 
> > trace buffer is shared across the kernel. That also brings the extra 
> > overhead of finding how this could be done across various distros.
> > 
> > For cases where the memory/driver size matters, there is an option to 
> > compile out this feature, plus choosing a lower default trace buffer size.
> 
> You can enable an ftrace instance from inside the kernel, and make it a
> compile time option.
> 
> 	#include <linux/trace_events.h>
> 	#include <linux/trace.h>
> 
> 	struct trace_array *tr;
> 
> 	tr = trace_array_get_by_name("qla2xxx");
> 	trace_array_set_clr_event(tr, "qla", NULL, true);
> 
> And now you have trace events running:
> 
>  # cat /sys/kernel/tracing/instances/qla/trace
> 

Thanks Steve. I was not aware of this relatively newer interface. This 
looks promising.

I have a question on the behavior of this interface.

It appears by calling the above two interfaces, I get a separate instance 
of "qla" only traces, but with only the "qla"-only instance being enabled, 
leaving the main (/sys/kernel/tracing/events/qla/enable) one disabled. No 
issues there, but when I enable both of them, I get garbage values on one.

/sys/kernel/tracing/instances/qla2xxx/trace:
             cat-56106   [012] ..... 2419873.470098: ql_dbg_log: qla2xxx [0000:05:00.0]-1054:14:  Entered (null).
             cat-56106   [012] ..... 2419873.470101: ql_dbg_log: qla2xxx [0000:05:00.0]-1000:14:  Entered ×+<96>²Ü<98>^H.
             cat-56106   [012] ..... 2419873.470102: ql_dbg_log: qla2xxx [0000:05:00.0]-1006:14:  Prepare to issue mbox cmd=0xde589000.

/sys/kernel/tracing/trace:
             cat-56106   [012] ..... 2419873.470097: ql_dbg_log: qla2xxx [0000:05:00.0]-1054:14:  Entered qla2x00_get_firmware_state.
             cat-56106   [012] ..... 2419873.470100: ql_dbg_log: qla2xxx [0000:05:00.0]-1000:14:  Entered qla2x00_mailbox_command.
             cat-56106   [012] ..... 2419873.470102: ql_dbg_log: qla2xxx [0000:05:00.0]-1006:14:  Prepare to issue mbox cmd=0x69.

It appears that only one should be enabled at a time. Per my read of 
Documentation/trace/ftrace.rst, the main directory and instances have 
separate trace buffers, so I am a bit confused with the above output.

Regards,
-Arun
--1879738122-1939649863-1658264773=:3483--
