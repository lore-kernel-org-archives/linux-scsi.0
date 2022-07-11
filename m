Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A13CCA47B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 10:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiGKKek (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 06:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiGKKeV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 06:34:21 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35303E74A;
        Mon, 11 Jul 2022 02:45:00 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B66DD411D9;
        Mon, 11 Jul 2022 09:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received
        :received; s=mta-01; t=1657532695; x=1659347096; bh=YOOUHYKWEWHP
        eNoSCtxE+Fla8fMfuPc4+iON0lM6PM0=; b=W9jU9Onj5U9ybX15N6F+d/vk5yJq
        JIE4QkVGz+jToVuUW2t1wl+uY7Xl4J/aTg++wD1FX9lItNehXFFBiSJg5OyIr93u
        I5yeTPRJ1o1f/LqVaNleOWEojwzxLPTwhigBVULAnnQHP+Ns18fBEFkWlp33bM9g
        stA+LUYUtKI89ho=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K3kgeZTLLsdB; Mon, 11 Jul 2022 12:44:55 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 40C9A40886;
        Mon, 11 Jul 2022 12:44:54 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 11 Jul 2022 12:44:54 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Mon, 11 Jul
 2022 12:44:53 +0300
Date:   Mon, 11 Jul 2022 12:44:57 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 04/36] target: Does tmr notify on aborted command
Message-ID: <20220711094457.GA32568@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <a15b6eb1fd62e7e8bc7ad65f77cd327a2afde07e.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707125657.GB23838@yadro.com>
 <154d432d-b91d-d16f-d5d4-89fd8eb7eb7b@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <154d432d-b91d-d16f-d5d4-89fd8eb7eb7b@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 08, 2022 at 11:11:37PM +0000, Thinh Nguyen wrote:
> «Внимание! Данное письмо от внешнего адресата!»
> 
> On 7/7/2022, Dmitry Bogdanov wrote:
> > Hi Thinh,
> >
> > On Wed, Jul 06, 2022 at 04:34:49PM -0700, Thinh Nguyen wrote:
> >> If the tmr_notify is not implemented, simply execute a generic command
> >> completion to notify the command abort.
> > Why? What are you trying to fix?
> 
> If tmr_notify() is not implemented (which most don't), then the user
> won't get notified of the command completion.
tmr_notify is for transport drivers (iblock/pscsi/user) - transport of
IOs to the real storage device. Not for trasport of incoming SCSI
messages - that is a frontend driver in TCM terms.
So, USB frontend driver has nothing to do with transport->tmr_notify().
> 
> I was trying to directly notify the user via target_complete_cmd(). It
> may not be the right way to handle this, any advise?
Frontend drivers are notified of the aborted task twice:
1. The incoming TMF in frontend driver; usually a frontend driver do not
 do anything here, just pass TMF to TCM Core.
2. TCM Core makrs the command as "to be aborted". 
  cmd->transport_state |= CMD_T_ABORTED;
2. TCM Core checks that command is to be aborted when IO is not started
yet or IO is completed:
 * target_execute_cmd(start of handling SCSI cmd),
 * target_compete_cmd (backend device completes IO), 
 * transport_generic_request_failure  (some generic request to send a
   failure response)
  And calls target_handle_abort() which calls
cmd->se_tfo->aborted_task(cmd) to notify frontend driver that it will
not be asked to send response to the command and it may do some cleanup
if needed.

There are two possible continuous processes in a cmd lifecycle:
1. Data IN (several responses to initiator)
 TCM Core receives a data from transport (backstore device) and passes
it to frontend driver. Frontend driver is responsible to send it to the
initiator. Probably, it may check that cmd is aborted to break sending,
but nobody do that.
2. Data OUT (several requests from initiators)
 Data from DataOUT is collected by frontend driver to pass it to TCM
Core in target_submit_cmd. TCM Core will abort the cmd at that moment.

There is no interface in TCM Core to notify Frontend driver to stop
those continuous processes. Probably, because of differences in fronted
protocol standards.
For example, iSCSI tunes that behaviour by some negotiatable session
parameter. Current kernel iSCSI driver does not support that parameter.

> 
> Thanks,
> Thinh
> 
> >> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> >> ---
> >>   drivers/target/target_core_tmr.c | 4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> >> index 7a7e24069ba7..2af80d0998bf 100644
> >> --- a/drivers/target/target_core_tmr.c
> >> +++ b/drivers/target/target_core_tmr.c
> >> @@ -14,6 +14,7 @@
> >>   #include <linux/spinlock.h>
> >>   #include <linux/list.h>
> >>   #include <linux/export.h>
> >> +#include <scsi/scsi_proto.h>
> >>
> >>   #include <target/target_core_base.h>
> >>   #include <target/target_core_backend.h>
> >> @@ -150,6 +151,9 @@ void core_tmr_abort_task(
> >>                      if (dev->transport->tmr_notify)
> >>                              dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
> >>                                                         &aborted_list);
> >> +                    else
> >> +                            target_complete_cmd(se_cmd,
> >> +                                                SAM_STAT_TASK_ABORTED);
> > That is wrong and breaks a command lifecycle and command kref counting.
> > target_complete_cmd is used to be called by a backend driver.
> >>
> >>                      list_del_init(&se_cmd->state_list);
> >>                      target_put_cmd_and_wait(se_cmd);
> 
