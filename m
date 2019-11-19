Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA3AC432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 21:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60A1222D3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 21:47:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="A0KlevZ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfKSVrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 16:47:05 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:40054 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727608AbfKSVrE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 16:47:04 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 36BA443B0D;
        Tue, 19 Nov 2019 21:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received;
         s=mta-01; t=1574200017; x=1576014418; bh=twsUITASAab5UXGGc4rFKV
        Ax0pBaX0bJuy3/0+5jeKw=; b=A0KlevZ/Sxm7qDbk9trrY926xrDjYGwm7fd+9t
        nbmZNYz2GYqr3tdFZ2d+VI/ye2vTJQyYv0y4hAQ+FLP7i3VmISWdjPiSybd2BUR/
        EY610I0I5P+rTYJt2oJrRQKA3TCU3JEojdUs1esz6WLvr9yDT4F2DsegCSVAtGGF
        +QnHc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DUuJLt6MjxV4; Wed, 20 Nov 2019 00:46:57 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id CC315438D1;
        Wed, 20 Nov 2019 00:46:56 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 20
 Nov 2019 00:46:56 +0300
Date:   Wed, 20 Nov 2019 00:46:56 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Himanshu Madhani <hmadhani@marvell.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [EXT] [PATCH 0/4] scsi: qla2xxx: Bug fixes
Message-ID: <20191119214656.t2rluirv5kgzl6vg@SPB-NB-133.local>
References: <20190912003919.8488-1-r.bolshakov@yadro.com>
 <8774334a-b1e7-1a5e-0da3-82db68f963b6@acm.org>
 <20190912133605.age2zo7jxdbe4jiq@SPB-NB-133.local>
 <B39B0F4F-3439-4313-A808-578047F1B93A@marvell.com>
 <20191107190032.idvubxehqtzbe3ah@SPB-NB-133.local>
 <20191113185423.ofjxrsxazahy3gbx@SPB-NB-133.local>
 <0B40AFCA-8CB0-4F21-BDD1-DFE7A66DAA07@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0B40AFCA-8CB0-4F21-BDD1-DFE7A66DAA07@marvell.com>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Himanshu,

I've tried the patch and it seems that LOGO doesn't succeed yet:
[ 1079.073246] qla2xxx [0000:00:06.0]-2870:1: Async-logout - hdl=0 loop-id=0 portid=000002 21:00:00:24:ff:7f:35:c6.
[ 1079.073333] qla2xxx [0000:00:06.0]-5837:1: Async-logout failed - 21:00:00:24:ff:7f:35:c6 hdl=12 portid=000002 comp=31 iop0=19 iop1=c.

It means that firmware detected IOCB parameter error at offset 0xc.
I'll examine IOCB parameter dumps tomorrow.

Are you ok if I send the patch (keeping Quinn's authorship) in the my
patch set once I get it fixed?

I also consider to add one more patch to address the issue with BA_RJT.
The idea is to discard a frame that has no session (not logged in) and
send explicit LOGO ELS instead of BA_RJT to follow FCP spec 12.3.3:
   When an ABTS-LS is received at the target FCP_Port, it shall abort
   the designated Exchange and return one of the following responses:

   a) the target FCP_Port shall discard the ABTS-LS and transmit a LOGO
      ELS if the Nx_Port issuing the ABTS-LS is not currently logged in
      (i.e., no N_Port Login exists);

Although, I don't know if firmware can handle that yet. We'll see.

Thank you,
Roman

On Wed, Nov 13, 2019 at 10:33:35PM +0000, Himanshu Madhani wrote:
> Hi Roman,
> 
> 
> > On Nov 13, 2019, at 12:54 PM, Roman Bolshakov <r.bolshakov@yadro.com> wrote:
> >
> > External Email
> >
> > ----------------------------------------------------------------------
> > Hi Himanshu,
> >
> > Could you please answer the questions below?
> > And if we should start doing explicit LOGO on session shutdown?
> >
> 
> You are correct in target mode driver should do explicit logo if target does not want to talk to initiator anymore.
> 
> We had patch for the explicit_logo in our internal code base, but did not sent it upstream. I’ve attached it here for you to try it out and see if it helps in your env.
> 
> Thanks,
> Himanshu
> 
> 
> 
> > Thank you,
> > Roman
> >
> > On Thu, Nov 07, 2019 at 10:00:32PM +0300, Roman Bolshakov wrote:
> >> Hi Himanshu,
> >>
> >> Could you please take a look at the series and anwser if we should stop
> >> doing BA_RJT as a response on ABTS when there's no session?
> >>
> >> Thank you,
> >> Roman
> >>
> >> On Thu, Sep 12, 2019 at 01:53:03PM +0000, Himanshu Madhani wrote:
> >>> Adding Correct Quinn. Please use "qutran@mavell.com"
> >>>
> >>> We'll take a look at the series
> >>>
> >>> ﻿On 9/12/19, 8:49 AM, "linux-scsi-owner@vger.kernel.org on behalf of Roman Bolshakov" <linux-scsi-owner@vger.kernel.org on behalf of r.bolshakov@yadro.com> wrote:
> >>>
> >>>    On Thu, Sep 12, 2019 at 06:37:22AM +0100, Bart Van Assche wrote:
> >>>> On 9/12/19 1:39 AM, Roman Bolshakov wrote:
> >>>>> This series has a few bug fixes for the driver.
> >>>>>
> >>>>> Note, #1 only fixes the crash in the kernel. The complete fix for clean
> >>>>> ACL deletion from initiator side is in works and requires a discussion.
> >>>>>
> >>>>> As of now initiator is not aware that target no longer wants talking to
> >>>>> it, that implies unneeded timeout. It might be fixed by making LOGO
> >>>>> explicit on session deletion but it's an issue I want to raise first
> >>>>> before making the change. Whether we need implicit LOGO in qla2xxx,
> >>>>> explicit or use both.
> >>>>>
> >>>>> Also, an unsolicited ABTS from a port without session would still result
> >>>>> in BA_RJT response instead of frame discard and LOGO ELS, as specified
> >>>>> in FCP (12.3.3 Target FCP_Port response to Exchange termination):
> >>>>>
> >>>>>   When an ABTS-LS is received at the target FCP_Port, it shall abort
> >>>>>   the designated Exchange and return one of the following responses:
> >>>>>
> >>>>>   a) the target FCP_Port shall discard the ABTS-LS and transmit a LOGO
> >>>>>      ELS if the Nx_Port issuing the ABTS-LS is not currently logged in
> >>>>>      (i.e., no N_Port Login exists);
> >>>>>
> >>>>> FWIW, the target driver can receive ABTS as part of ABORT TASK/LUN
> >>>>> RESET/CLEAR TASK SET TMFs and in case of failed sequence retransmission
> >>>>> requests, exchange or sequence errors. IIRC, some initiators requeue
> >>>>> SCSI commands if BA_RJT is received. Therefore, a timely LOGO will
> >>>>> prevent a perceived session freeze on the initiators.
> >>>>
> >>>> Hi Roman,
> >>>>
> >>>> Has this patch series been prepared against Linus' master branch,
> >>>> against Martin's 5.3/scsi-fixes or against Martin's 5.4/scsi-queue
> >>>> branch? I'm asking this because some patches in this series look similar
> >>>> to patches that are already present in the 5.4/scsi-queue branch.
> >>>>
> >>>> Thanks,
> >>>>
> >>>> Bart.
> >>>>
> >>>
> >>>    Hi Bart,
> >>>
> >>>    To be honest it was prepared against next-20190904 but it applies to
> >>>    5.4/scsi-queue cleanly. The fixes made two weeks ago look promising but
> >>>    are related to stuck PRLI and unhandled RSCN while #4 is related to
> >>>    stuck PLOGI after qla_post_els_plogi_work.
> >>>
> >>>    Thank you,
> >>>    Roman
> >>>
> >>>
> 
