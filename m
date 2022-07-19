Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491B4C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 22:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240675AbiGSWKI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiGSWKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 18:10:08 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F49E19
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 15:10:06 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JJf6lu009918;
        Tue, 19 Jul 2022 15:10:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=LaQvx7iyjk4qQxUWBlP4ftZzbqtBCd8XrA3/YQzYpDg=;
 b=F7QvdTzTIU0xNtt8PJ/Mny4NwGUHGkCQwBD/G8hVuRa33eMxn3cE37Z88WFpeoAzCcFn
 Aq6J4U2HhOG4G8ySKz63OWAKIY2eIPqb1o5AbCUSmZDaDvappw9FEdoh6Aj7BhLGcVLA
 Jo4F7DQFMCgM1xzdbSnZYKRX/oEsHmTcOtlDzKMvK+jGTSkKHlQUYTWYS0J8REu/sbzJ
 HQJqUYyxYdrb4bokF787xx3uqPh1oXZplZ3SSZa2aSC51qtg4xXgS9EqekPW3rRsm3Fy
 RepvnIyaeWRJ4ScKJF372PEQ02caodz5W/ocfq9GQHmHyPPs15l25eKL5Siaoqdj0r3Q ow== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hbvumvk04-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 15:10:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 Jul
 2022 15:10:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 19 Jul 2022 15:10:00 -0700
Received: from mvluser05.qlc.com (unknown [10.112.10.135])
        by maili.marvell.com (Postfix) with ESMTP id 8E3283F707E;
        Tue, 19 Jul 2022 15:09:59 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by mvluser05.qlc.com (8.14.4/8.14.4/Submit) with ESMTP id 26JM9xYB030398;
        Tue, 19 Jul 2022 15:09:59 -0700
X-Authentication-Warning: mvluser05.qlc.com: aeasi owned process doing -bs
Date:   Tue, 19 Jul 2022 15:09:59 -0700
From:   Arun Easi <aeasi@marvell.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        Nilesh Javali <njavali@marvell.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: Re: [EXT] Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
In-Reply-To: <20220719082514.egsqevbaxl7a4prx@carbon.lan>
Message-ID: <65df89cd-0f86-9d11-2f31-da6b6e4a1de2@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
 <20220715060227.23923-3-njavali@marvell.com>
 <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
 <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
 <20220718152243.21ad13e7@gandalf.local.home>
 <20220719082514.egsqevbaxl7a4prx@carbon.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: BpKqqgBZaNyal6xSP-8VYpxLtPFa5bYQ
X-Proofpoint-ORIG-GUID: BpKqqgBZaNyal6xSP-8VYpxLtPFa5bYQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_08,2022-07-19_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,

On Tue, 19 Jul 2022, 1:25am, Daniel Wagner wrote:

> External Email
> 
> ----------------------------------------------------------------------
> Hi Arun,
> 
> On Mon, Jul 18, 2022 at 03:22:43PM -0400, Steven Rostedt wrote:
> > On Mon, 18 Jul 2022 12:02:26 -0700
> > Arun Easi <aeasi@marvell.com> wrote:
> > 
> > > Many times when a problem was reported on the driver, we had to request 
> > > for a repro with extended error logging (via driver module parameter) 
> > > turned on. With this internal tracing in place, log messages that appear 
> > > only with extended error logging are captured by default in the internal 
> > > trace buffer.
> > > 
> > > AFAIK, kernel tracing requires a user initiated action to be turned on, 
> > > like enabling individual tracepoints. Though a script (either startup or 
> > > udev) can do this job, enabling tracepoints by default for a single 
> > > driver, I think, may not be a preferred choice -- particularly when the 
> > > trace buffer is shared across the kernel. That also brings the extra 
> > > overhead of finding how this could be done across various distros.
> > > 
> > > For cases where the memory/driver size matters, there is an option to 
> > > compile out this feature, plus choosing a lower default trace buffer size.
> 
> I am really asking the question why do we need to add special debugging
> code to every single driver? Can't we try to make more use of generic
> code and extend it if necessary?
> 
> Both FC drivers qla2xxx and lpfc are doing their own thing for
> debugging/logging and I really fail to see why we can't not move towards
> a more generic way. Dumping logs to the kernel log was the simplest way
> but as this series shows, this is not something you can do in production
> systems.

No contention here on a generic way. The per instance trace creation and 
enabling from within the kernel looks like such a one. Let me revisit the 
trace patches with this new info.

Regards,
-Arun

> 
> > You can enable an ftrace instance from inside the kernel, and make it a
> > compile time option.
> >
> > 	#include <linux/trace_events.h>
> > 	#include <linux/trace.h>
> > 
> > 	struct trace_array *tr;
> > 
> > 	tr = trace_array_get_by_name("qla2xxx");
> > 	trace_array_set_clr_event(tr, "qla", NULL, true);
> > 
> > And now you have trace events running:
> > 
> >  # cat /sys/kernel/tracing/instances/qla/trace
> 
> Thanks Steve for the tip!
> 
> Daniel
> 
