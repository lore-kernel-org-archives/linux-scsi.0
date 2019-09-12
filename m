Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B500C4CEC6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 13:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DCAB2075C
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 13:49:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="FY8kGL9z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732084AbfILNtf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 09:49:35 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:48564 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731791AbfILNte (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 09:49:34 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0030C435D6;
        Thu, 12 Sep 2019 13:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        user-agent:in-reply-to:content-disposition:content-type
        :content-type:mime-version:references:message-id:subject:subject
        :from:from:date:date:received:received:received; s=mta-01; t=
        1568296172; x=1570110573; bh=W4GGB2bc1IYsC2LTssEtP/jT9RBiRZUPcZZ
        pMHSk/qg=; b=FY8kGL9z2gWLBxN/CN0oJRxsSil8J2E2WYME7R5KA1+I9vT/9WG
        REo5tpAFa6Qlj83SVFjVq5XbF4hlU29cXYvMGCsxShrpMeVcSdACJ/x2exkToOID
        wFmXpQhMkARjV8VBxakn/3yzDXKnpZObeH3/K5LWaJhsBycwTrIyukzo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hHmW4X1HThIZ; Thu, 12 Sep 2019 16:49:32 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 48A0241203;
        Thu, 12 Sep 2019 16:49:31 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 12
 Sep 2019 16:49:30 +0300
Date:   Thu, 12 Sep 2019 16:49:30 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, Quinn Tran <qtran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: Re: [PATCH 0/4] scsi: qla2xxx: Bug fixes
Message-ID: <20190912133605.age2zo7jxdbe4jiq@SPB-NB-133.local>
References: <20190912003919.8488-1-r.bolshakov@yadro.com>
 <8774334a-b1e7-1a5e-0da3-82db68f963b6@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8774334a-b1e7-1a5e-0da3-82db68f963b6@acm.org>
User-Agent: NeoMutt/20180716
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 12, 2019 at 06:37:22AM +0100, Bart Van Assche wrote:
> On 9/12/19 1:39 AM, Roman Bolshakov wrote:
> > This series has a few bug fixes for the driver.
> > 
> > Note, #1 only fixes the crash in the kernel. The complete fix for clean
> > ACL deletion from initiator side is in works and requires a discussion.
> > 
> > As of now initiator is not aware that target no longer wants talking to
> > it, that implies unneeded timeout. It might be fixed by making LOGO
> > explicit on session deletion but it's an issue I want to raise first
> > before making the change. Whether we need implicit LOGO in qla2xxx,
> > explicit or use both.
> > 
> > Also, an unsolicited ABTS from a port without session would still result
> > in BA_RJT response instead of frame discard and LOGO ELS, as specified
> > in FCP (12.3.3 Target FCP_Port response to Exchange termination):
> > 
> >    When an ABTS-LS is received at the target FCP_Port, it shall abort
> >    the designated Exchange and return one of the following responses:
> > 
> >    a) the target FCP_Port shall discard the ABTS-LS and transmit a LOGO
> >       ELS if the Nx_Port issuing the ABTS-LS is not currently logged in
> >       (i.e., no N_Port Login exists);
> > 
> > FWIW, the target driver can receive ABTS as part of ABORT TASK/LUN
> > RESET/CLEAR TASK SET TMFs and in case of failed sequence retransmission
> > requests, exchange or sequence errors. IIRC, some initiators requeue
> > SCSI commands if BA_RJT is received. Therefore, a timely LOGO will
> > prevent a perceived session freeze on the initiators.
> 
> Hi Roman,
> 
> Has this patch series been prepared against Linus' master branch,
> against Martin's 5.3/scsi-fixes or against Martin's 5.4/scsi-queue
> branch? I'm asking this because some patches in this series look similar
> to patches that are already present in the 5.4/scsi-queue branch.
> 
> Thanks,
> 
> Bart.
> 

Hi Bart,

To be honest it was prepared against next-20190904 but it applies to
5.4/scsi-queue cleanly. The fixes made two weeks ago look promising but
are related to stuck PRLI and unhandled RSCN while #4 is related to
stuck PLOGI after qla_post_els_plogi_work.

Thank you,
Roman
