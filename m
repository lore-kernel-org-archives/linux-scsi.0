Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B061AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 19:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbiGRTCg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 15:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbiGRTCf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 15:02:35 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B212B278
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 12:02:34 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IGKh5q020580;
        Mon, 18 Jul 2022 12:02:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=f4rl721HIcVRQPDWwVMhF4DwsnMP9xrwXJQ4rXc8Z2o=;
 b=hr+aXs3yLPlHmisSCVSDSOrwdqCDFwzi2Bi/hCazmFJEImwQ5FbfQg1fb8Ud8WmoRrgO
 WSNQNTiovt6XLIVWpxAhsIoB/EiHN3ZxOLrZ5dQHL0n5HUU/ZswKF5GdVqtX5Ft2grin
 xP24nMII1mxpzFbkznn6VyBnq3xJEm8OkFpIcr1xiq3b6flkajbWLVEvK1zz4e8wp/p5
 tBT8vEkM0CxAC8RnCZDJfNDHD0fn6qHkzOlCfShiCUsfwMozSY97yTeNDsU7tFNeGe9e
 WRbKlE1Af5lzRpWVkxllqH+9NP5VDhE0mJxT6dlziA9yVYzItMBTqWnOOTdEWQCOAgtX Kg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hday0hkk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 12:02:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 18 Jul
 2022 12:02:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 18 Jul 2022 12:02:28 -0700
Received: from mvluser05.qlc.com (unknown [10.112.10.135])
        by maili.marvell.com (Postfix) with ESMTP id 43A953F7052;
        Mon, 18 Jul 2022 12:02:28 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by mvluser05.qlc.com (8.14.4/8.14.4/Submit) with ESMTP id 26IJ2Q6r026138;
        Mon, 18 Jul 2022 12:02:27 -0700
X-Authentication-Warning: mvluser05.qlc.com: aeasi owned process doing -bs
Date:   Mon, 18 Jul 2022 12:02:26 -0700
From:   Arun Easi <aeasi@marvell.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     Nilesh Javali <njavali@marvell.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
In-Reply-To: <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
Message-ID: <f49cd5a0-93b8-48a2-5a3a-a4554ef660ac@marvell.com>
References: <20220715060227.23923-1-njavali@marvell.com>
 <20220715060227.23923-3-njavali@marvell.com>
 <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: 5p_ymGOBjtMNPJpM7wgCy4x3zWwhZdn1
X-Proofpoint-ORIG-GUID: 5p_ymGOBjtMNPJpM7wgCy4x3zWwhZdn1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_18,2022-07-18_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Jul 2022, 1:54am, Daniel Wagner wrote:

> Hi
> 
> [adding Steven Rostedt]
> 
> On Thu, Jul 14, 2022 at 11:02:23PM -0700, Nilesh Javali wrote:
> > From: Arun Easi <aeasi@marvell.com>
> > 
> > Adding a message based tracing mechanism where
> > a rotating number of messages are captured in
> > a trace structure. Disable/enable/resize
> > operations are allowed via debugfs interfaces.
> 
> I really wonder why you need to this kind of infrastructure to your
> driver? As far I know the qla2xxx is already able to log into
> ftrace. Why can't we just use this infrastructure?
> 

Many times when a problem was reported on the driver, we had to request 
for a repro with extended error logging (via driver module parameter) 
turned on. With this internal tracing in place, log messages that appear 
only with extended error logging are captured by default in the internal 
trace buffer.

AFAIK, kernel tracing requires a user initiated action to be turned on, 
like enabling individual tracepoints. Though a script (either startup or 
udev) can do this job, enabling tracepoints by default for a single 
driver, I think, may not be a preferred choice -- particularly when the 
trace buffer is shared across the kernel. That also brings the extra 
overhead of finding how this could be done across various distros.

For cases where the memory/driver size matters, there is an option to 
compile out this feature, plus choosing a lower default trace buffer size.

Regards,
-Arun
