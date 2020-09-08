Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75659C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 245E421897
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="E69661ws"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgIHGlv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:41:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46882 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728759AbgIHGlu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:41:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0886f5Rn009656;
        Mon, 7 Sep 2020 23:41:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=3P+b5DAtUyAJOjDDAer4aU9l5JZPTV5HDqbmbz05Tz0=;
 b=E69661wsx+IXZSrIfdQnqtjxkdrqttjj7ZBhj53381LyeW3PTm93uoygxiK3qJBXXz7O
 ocnstlUmsnPGxu2bX09YfqGDgChieXPVDCR453Pw1AEehjl+T+GMnBzMpwiGfwL1X2dN
 l2bNrFr7AB9IyLElSbVSutZ0s3e140wRydiGJq5KSCAddHGTBOYiF4m0hh+XpjqAaX2H
 4lInd79fD/cEjlA+clOV0zGYfGl0FHoJL955WFb9zuRdBt/g4BFm56nE/zRKuwWpqsvg
 INN5CvLPEaNGFZZr5btp/nCPJvkQ7OSnB1eNEZJ59kh+5PWNHvjqfaAwZdf7w5Obltpt Dg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81ptfv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 23:41:44 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 23:41:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 23:41:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 23:41:43 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id E24D33F703F;
        Mon,  7 Sep 2020 23:41:42 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 0886fgu2019828;
        Mon, 7 Sep 2020 23:41:42 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 7 Sep 2020 23:41:42 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Nilesh Javali" <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 0/4] qla2xxx: A couple crash fixes
In-Reply-To: <20200831161854.70879-1-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2009072340490.28578@irv1user01.caveonetworks.com>
References: <20200831161854.70879-1-dwagner@suse.de>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_02:2020-09-08,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,

On Mon, 31 Aug 2020, 9:18am, Daniel Wagner wrote:

> changes since v1:
> 
>  - added dummy warn function to patch#1
>  - added log entry to patch#4
> 
> as suggested by Martin
> 
> 
> 
> Initial cover letter:
> 
> The first crash we observed is due memory corruption in the srb memory
> pool. Unforuntatly, I couldn't find the source of the problem but the
> workaround by resetting the cleanup callbacks 'fixes' this problem
> (patch #1). I think as intermeditate step this should be merged until
> the real cause can be identified.
> 
> The second crash is due a race condition(?) in the firmware. The sts
> entries are not updated in time which leads to this crash pattern
> which several customers have reported:
> 
>  #0 [c00000ffffd1bb80] scsi_dma_unmap at d00000001e4904d4 [scsi_mod]
>  #1 [c00000ffffd1bbe0] qla2x00_sp_compl at d0000000204803cc [qla2xxx]
>  #2 [c00000ffffd1bc20] qla24xx_process_response_queue at d0000000204c5810 [qla2xxx]
>  #3 [c00000ffffd1bd50] qla24xx_msix_rsp_q at d0000000204c8fd8 [qla2xxx]
>  #4 [c00000ffffd1bde0] __handle_irq_event_percpu at c000000000189510
>  #5 [c00000ffffd1bea0] handle_irq_event_percpu at c00000000018978c
>  #6 [c00000ffffd1bee0] handle_irq_event at c00000000018984c
>  #7 [c00000ffffd1bf10] handle_fasteoi_irq at c00000000018efc0
>  #8 [c00000ffffd1bf40] generic_handle_irq at c000000000187f10
>  #9 [c00000ffffd1bf60] __do_irq at c000000000018784
>  #10 [c00000ffffd1bf90] call_do_irq at c00000000002caa4
>  #11 [c00000ecca417a00] do_IRQ at c000000000018970
>  #12 [c00000ecca417a50] restore_check_irq_replay at c00000000000de98
> 
> From analyzing the crash dump it was clear that
> qla24xx_mbx_iocb_entry() calls sp->done (qla2x00_sp_compl) which
> crashes because the response is not a mailbox entry, it is a status
> entry. Patch #4 changes the process logic for mailbox commands so that
> the sp is parsed before calling the correct proccess function.
> 
> Thanks,
> Daniel
> 
> Daniel Wagner (4):
>   qla2xxx: Warn if done() or free() are called on an already freed srb
>   qla2xxx: Simplify return value logic in qla2x00_get_sp_from_handle()
>   qla2xxx: Drop unused function argument from
>     qla2x00_get_sp_from_handle()
>   qla2xxx: Handle incorrect entry_type entries
> 
>  drivers/scsi/qla2xxx/qla_gbl.h    |  3 +-
>  drivers/scsi/qla2xxx/qla_init.c   | 10 ++++++
>  drivers/scsi/qla2xxx/qla_inline.h |  5 +++
>  drivers/scsi/qla2xxx/qla_isr.c    | 74 +++++++++++++++++++++++----------------
>  drivers/scsi/qla2xxx/qla_mr.c     |  9 ++---
>  5 files changed, 62 insertions(+), 39 deletions(-)
> 
> 

Thanks for the patches, my comments in the respective patches.

Regards,
-Arun
