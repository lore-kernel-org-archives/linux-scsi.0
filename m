Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86804C00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 08:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiHLIDZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 04:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiHLIDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 04:03:24 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AEC9C2FA;
        Fri, 12 Aug 2022 01:03:23 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 54B6C41242;
        Fri, 12 Aug 2022 08:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received
        :received; s=mta-01; t=1660291400; x=1662105801; bh=gM3xqwycVx6f
        d8QpBl8Se03RISF8OOLrmfL75nBVpnU=; b=FXvxl5dE0UvWpJV7xuqZS7B0du5u
        UB3oIvaTi+u2Ki0hG7lg5vDU6DZ+08WMWJFVwRCS0TR4LCjgsWJdG5is+M1z9wMn
        e4vrp9k6slpbu/HTDKkjHbP3cx7WJSY5H64Pa9iUJc4M4HDz/ET50U8cmAS+aM45
        dIXnjMGxV5lzGUU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FPjeQs0V6vw2; Fri, 12 Aug 2022 11:03:20 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8E4E64138F;
        Fri, 12 Aug 2022 11:03:07 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 12 Aug 2022 11:03:07 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 12 Aug
 2022 11:03:06 +0300
Date:   Fri, 12 Aug 2022 11:03:07 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 2/6] scsi: target: core: add list of opcodes for RSOC
Message-ID: <20220812080307.GA29582@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
 <20220718120117.4435-3-d.bogdanov@yadro.com>
 <99508f9b-46cb-b696-a5c4-3874b4d08355@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <99508f9b-46cb-b696-a5c4-3874b4d08355@oracle.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2022 at 10:38:29PM -0500, Mike Christie wrote:
> «Внимание! Данное письмо от внешнего адресата!»
> 
> On 7/18/22 7:01 AM, Dmitry Bogdanov wrote:
> > Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> > Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> > ---
> >  drivers/target/target_core_spc.c | 595 +++++++++++++++++++++++++++++++
> >  include/scsi/scsi_proto.h        |   3 +
> >  2 files changed, 598 insertions(+)
> >
> > diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> > index 4157f73977cf..506e28b14e5a 100644
> > --- a/drivers/target/target_core_spc.c
> > +++ b/drivers/target/target_core_spc.c
> 
> 
> > +static struct target_opcode_descriptor tcm_opcode_xdwriteread10 = {
> > +     .support = SCSI_SUPPORT_FULL,
> > +     .opcode = XDWRITEREAD_10,
> > +     .cdb_size = 10,
> > +     .usage_bits = {XDWRITEREAD_10, 0x18, 0xff, 0xff,
> > +                    0xff, 0xff, SCSI_GROUP_NUMBER_MASK, 0xff,
> > +                    0xff, SCSI_CONTROL_MASK},
> > +};
> > +
> > +static struct target_opcode_descriptor tcm_opcode_xdwriteread32 = {
> > +     .support = SCSI_SUPPORT_FULL,
> > +     .serv_action_valid = 1,
> > +     .opcode = VARIABLE_LENGTH_CMD,
> > +     .service_action = XDWRITEREAD_32,
> > +     .cdb_size = 32,
> > +     .usage_bits = {VARIABLE_LENGTH_CMD, SCSI_CONTROL_MASK, 0x00, 0x00,
> > +                    0x00, 0x00, SCSI_GROUP_NUMBER_MASK, 0x18,
> > +                    0x00, XDWRITEREAD_32, 0x18, 0x00,
> > +                    0xff, 0xff, 0xff, 0xff,
> > +                    0xff, 0xff, 0xff, 0xff,
> > +                    0x00, 0x00, 0x00, 0x00,
> > +                    0x00, 0x00, 0x00, 0x00,
> > +                    0xff, 0xff, 0xff, 0xff},
> > +};
> > +
> 
> I just removed these because they didn't work. I think the patch was added to
> one of Martin's tree after you made this patch.
Yes, I saw,  Iwill remove XDWRITEREAD_* in the next revision.
