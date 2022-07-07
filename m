Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C07C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 12:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiGGMhv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 08:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiGGMhu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 08:37:50 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A98286E7;
        Thu,  7 Jul 2022 05:37:47 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2AE3B412C5;
        Thu,  7 Jul 2022 12:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657197464; x=1659011865; bh=lu4kapZbV+PypZ0lwlA8CoN3Uon/UMJwpde
        AuGqUHUA=; b=bDXApxrKyYHyCS3ywRcM5N1IKfzv8esh65y1vgANHfD6HiWrL7p
        oJMqkgh2Lpjc/f4Hoe49dfMPmnVVeBCfxo5CDeebuMmYl+gxKGhNI+R1+MNXPojL
        ag4NyLQ5Vl1IwNYK3thWDAql3FjrEFsRXYjMlcaAbf2FKeG1dFwnu3Y0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1J2qkNpyC4pg; Thu,  7 Jul 2022 15:37:44 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D9BB741277;
        Thu,  7 Jul 2022 15:37:43 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 15:37:43 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 15:37:42 +0300
Date:   Thu, 7 Jul 2022 15:37:43 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Subject: Re: [PATCH 34/36] usb: gadget: f_tcm: Free tags earlier
Message-ID: <20220707123743.GA23621@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <6a5487365f0804447d4cbb8911d0719d8b21b601.1657149962.git.Thinh.Nguyen@synopsys.com>
 <17d93b498de04ee5b550ff0fe8b91847@yadro.com>
 <e9e153a4-66c4-ca08-98b6-3849646b9bdb@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e9e153a4-66c4-ca08-98b6-3849646b9bdb@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 07, 2022 at 10:11:49AM +0000, Thinh Nguyen wrote:
> On 7/7/2022, Dmitriy Bogdanov wrote:
> > Hi Thinh,
> >
> >> Free up sbitmap index immediately once the command is completed rather
> >> than waiting for kref to call freeing tag. This keeps the sbitmap queue
> >> free quicker.
> >>
> > That is completely wrong. Sbitmap index is a place of usbg_cmd* in
> > a pre-allocated memory pool. It must not be freed until usbg_cmd*
> > is not used.
> 
> As noted in the commit message and as you can see in the code change, I
> only free it when the command is completed or no longer in used.

It IS used in the next line.
This patch is wrong.
NACK
> 
> > Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> > ---
> >   drivers/usb/gadget/function/f_tcm.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
> > index c13aa61d82aa..fa09999adda7 100644
> > --- a/drivers/usb/gadget/function/f_tcm.c
> > +++ b/drivers/usb/gadget/function/f_tcm.c
> > @@ -570,6 +570,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
> >          struct usbg_cmd *cmd = req->context;
> >          struct uas_stream *stream = cmd->stream;
> >          struct f_uas *fu = cmd->fu;
> > +       struct se_session *se_sess = cmd->se_cmd.se_sess;
> >          int ret;
> >
> >          if (req->status == -ESHUTDOWN)
> > @@ -603,6 +604,8 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
> >                  break;
> >
> >          case UASP_QUEUE_COMMAND:
> > +
> > +               target_free_tag(se_sess, &cmd->se_cmd);
> >                  transport_generic_free_cmd(&cmd->se_cmd, 0);
> >                  usb_ep_queue(fu->ep_cmd, cmd->req, GFP_ATOMIC);
> >
> > @@ -614,6 +617,7 @@ static void uasp_status_data_cmpl(struct usb_ep *ep, struct usb_request *req)
> >          return;
> >
> >   cleanup:
> > +       target_free_tag(se_sess, &cmd->se_cmd);
> >          transport_generic_free_cmd(&cmd->se_cmd, 0);
> >   }
> >
> > @@ -941,6 +945,7 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
> >          struct se_cmd *se_cmd = &cmd->se_cmd;
> >
> >          if (req->status == -ESHUTDOWN) {
> > +               target_free_tag(se_cmd->se_sess, se_cmd);
> >                  transport_generic_free_cmd(&cmd->se_cmd, 0);
> >                  return;
> >          }
> > @@ -963,6 +968,7 @@ static void usbg_data_write_cmpl(struct usb_ep *ep, struct usb_request *req)
> >   cleanup:
> >          /* Command was aborted */
> >          if (cmd->state == UASP_QUEUE_COMMAND) {
> > +               target_free_tag(se_cmd->se_sess, se_cmd);
> >                  transport_generic_free_cmd(se_cmd, 0);
> >                  return;
> >          }
> 
