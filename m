Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07845C54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4C0A2072D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 21:25:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="F7nCzuZJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgDUVZK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:25:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52490 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726055AbgDUVZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 17:25:10 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LL9Yxr011008;
        Tue, 21 Apr 2020 14:25:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=6lvHo5FZQ/ndm14tZcqho4Jc4MdhHH5/Er3MEN9UP84=;
 b=F7nCzuZJRqw1aqcxfbKwNLkqQaN/+ZwzOkDthH5vRqNKBWVNJxXnpPVnbv74XgHGnW5x
 eWgmHImfJo23B/fWe89QML/tARpN66LSQnlU6dE/VzXbbr0S20x2ScrUIC1lmRbLJnEq
 Ch+XKmlcbvCVIHdQwOrG621tqfOR9W885w7IXfwuB/gXt08c1gwd8Q6ihb1OrJ9piTNa
 tlJD0Hi10ncFhjSG9K7bzv4KEKOBhpXTwSLEz5oUw+ohWHObutSYj1ShscX2uEo22cFT
 Yg8JkOdRjyEubjva8U7hT/gFgEVu+ei+6QGu3gsvpM/s7tw9xg01DexRS9tKPRMIvcuI WA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 30fxwpe92s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 14:25:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Apr
 2020 14:25:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Apr 2020 14:25:01 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 991583F7041;
        Tue, 21 Apr 2020 14:25:01 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 03LLP03V031534;
        Tue, 21 Apr 2020 14:25:00 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Tue, 21 Apr 2020 14:25:00 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Martin Wilck <mwilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Roman Bolshakov" <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        "Bart Van Assche" <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] [PATCH v4 0/2] scsi: qla2xxx: fixes for driver unloading
In-Reply-To: <20200421204621.19228-1-mwilck@suse.com>
Message-ID: <alpine.LRH.2.21.9999.2004211424090.23618@irv1user01.caveonetworks.com>
References: <20200421204621.19228-1-mwilck@suse.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_09:2020-04-21,2020-04-21 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Series look good.

Thank you for the patches and testing, Martin.

Regards,
-Arun

On Tue, 21 Apr 2020, 1:46pm, mwilck@suse.com wrote:

> External Email
> 
> ----------------------------------------------------------------------
> From: Martin Wilck <mwilck@suse.com>
> 
> Hello Martin, Arun, Himanshu, all,
> 
> here is v4 of the little series I first submitted on Nov 29, 2019.
> I dropped the more controversial part, hoping to get the actual fix
> for the issue merged.
> 
> Reviews welcome.
> Martin
> 
> Changes since v3:
>  - In patch 2, moved check from qla2x00_post_async_XYZ_work() to
>    qla2x00_alloc_work() as suggested by Arun
>  - Dropped patch 3-5. With 1 and 2 applied, I haven't been able to reproduce
>    shutdown hangs any more.
> 
> Changes since v2:
>  - Removed "scsi: qla2xxx: avoid sending mailbox commands if firmware is
>    stopped", because the first hunk is obsoleted by the (new) 1/3, and Arun
>    suggested to use a different approach (which is now in 4/3) for the second
>    hunk.
>  - Removed "scsi: qla2xxx: don't shut down firmware before closing sessions"
>    (nak'd by Arun).
>  - Former 3/3 is now 1/5
>  - Added "scsi: qla2xxx: check UNLOADING before posting async work". This one
>    is key for avoiding lags when qla2xxx is unloaded.
>  - Added revert of "scsi: qla2xxx: Fix unbound sleep in fcport delete path.",
>    as I believe it's now obsolete.
>    If we ever encounter unbound sleep there again, we should rather figure
>    out the reason than simply abort waiting.
>  - Added patch 4 and 5, a new attempt at avoiding mailbox and HW request queue
>    access at low level. 4/5 was motivated by Arun's comments on my v2 series.
>    5/5 is obviously similar in spirit to 77ddb94a4853 ("scsi: qla2xxx: Only
>    allow operational MBX to proceed during RESET."), but I found that the
>    rom_cmds list contains commands that would hang when the FW is stopped,
>    so I created a new list. Perhaps some day the two can be consolidated.
> 
> Changes since v1:
>  - Added patch 3 to set the UNLOADING flag before waiting for sessions
>    to end (Roman)
>  - Use test_and_set_bit() for UNLOADING (Hannes)
> 
> Martin Wilck (2):
>   scsi: qla2xxx: set UNLOADING before waiting for session deletion
>   scsi: qla2xxx: check UNLOADING before posting async work
> 
>  drivers/scsi/qla2xxx/qla_os.c | 35 +++++++++++++++++------------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
> 
> 
