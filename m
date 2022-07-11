Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F3E4C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 10:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiGKKqu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 06:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiGKKqh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 06:46:37 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855A53AB09;
        Mon, 11 Jul 2022 02:53:09 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 8A71D40886;
        Mon, 11 Jul 2022 09:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657533186; x=1659347587; bh=mhoAHoOLCT3G3RavKheA7N+rjGYT+gFIzmj
        ZOmqgJhk=; b=DHlnx97IubAYFZaA1K43HQMyCtYnXYNxENS5bl/PhqTATVQFjGL
        6wtyHIPZSWtPQuxg1Qge2ZH3ga8s23UAFq+sOW+P0cMDRctalb8QZsdl9ckMsgSe
        rwp4gtne1vvfL3iGxwkilKJgCyvdnwBYNLaljheJjV8zND6ci+rveOKI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QqDSxMKEuLZO; Mon, 11 Jul 2022 12:53:06 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3E9A4404CD;
        Mon, 11 Jul 2022 12:53:05 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 11 Jul 2022 12:53:05 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Mon, 11 Jul
 2022 12:53:03 +0300
Date:   Mon, 11 Jul 2022 12:53:08 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        "Felipe Balbi" <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/36] target: Return Function Complete
Message-ID: <20220711095308.GB32568@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <d25dbd79f4234f5b0d7574cc1ba02e42e3537d81.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707133428.GD23838@yadro.com>
 <a20da7c6-3903-c193-2eac-41d9cf053f60@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a20da7c6-3903-c193-2eac-41d9cf053f60@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 08, 2022 at 11:51:38PM +0000, Thinh Nguyen wrote:
> 
> On 7/7/2022, Dmitry Bogdanov wrote:
> > Hi Thinh,
> >
> > On Wed, Jul 06, 2022 at 04:35:01PM -0700, Thinh Nguyen wrote:
> >> According to SAM-4 r14 section 7.2, for ABORT TASK function, a response
> >> of FUNCTION COMPLETE shall indicate that the command was aborted or was
> >> not in the task set. Currently we respond with TASK DOES NOT EXIST when
> >> there's no command in the task set. Fix the response to FUNCTION
> >> COMPLETE instead.
> > SAM does not describe a response status encoding. But other specs
> > do describe. For example, iSCSI RFC7143 11.6.1.  Response
> >         0 - Function complete
> >         1 - Task does not exist
> >     The mapping of the response code into a SCSI service response code
> >     value, if needed, is outside the scope of this document.  However, in
> >     symbolic terms, Response values 0 and 1 map to the SCSI service
> >     response of FUNCTION COMPLETE.
> >
> > So, the current code is according to specs.
> > Moreover, TMR_TASK_DOES_NOT_EXIST is used in several fabric drivers to
> > handle some corner cases.
> 
> Ok, it's a bit confusing. So, the SCSI service response needs to reflect
> FUNCTION COMPLETE, but the FUNCTION COMPLETE can be different for other
> specs?
Yes, SCSI service response code may have a different values to differentiate
a level of "success" :) or a reason of failure.
> 
> Thanks,
> Thinh
> 
> >> Fixes: 3d28934aaae5 ("target: Add TMR_ABORT_TASK task management support")
> >> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> >> ---
> >>   drivers/target/target_core_tmr.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> >> index 2af80d0998bf..724ddabda488 100644
> >> --- a/drivers/target/target_core_tmr.c
> >> +++ b/drivers/target/target_core_tmr.c
> >> @@ -170,9 +170,9 @@ void core_tmr_abort_task(
> >>      if (dev->transport->tmr_notify)
> >>              dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);
> >>
> >> -    printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
> >> +    printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %lld\n",
> >>                      tmr->ref_task_tag);
> >> -    tmr->response = TMR_TASK_DOES_NOT_EXIST;
> >> +    tmr->response = TMR_FUNCTION_COMPLETE;
> >>      atomic_long_inc(&dev->aborts_no_task);
> >>   }
> >>
> 
