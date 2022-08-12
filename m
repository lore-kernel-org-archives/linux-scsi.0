Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23959C00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 11:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiHLLbN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 07:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiHLLbM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 07:31:12 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6DDADCCE;
        Fri, 12 Aug 2022 04:31:10 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id AFE4141399;
        Fri, 12 Aug 2022 11:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received
        :received; s=mta-01; t=1660303867; x=1662118268; bh=YROq5AD6XA+G
        3xOZ51mMOlYP1/LF/t6LqTV9Jm331xY=; b=mbPZmP1JgLoGvvi8TN49/hFUOYWA
        ICPT0pda+XsQB6+mOihxH9t/ZqBmS4PVFSmiWs5mLuHafUG7Q/mmPrOt2Iw9k3l6
        jIf+wrCjZdLLYSFMp/e6j6UWRcAdN+j5TN5EJVQvQMvQtp6Dyl8CQmZf3GOD6rj0
        C24sIEIHI83y1fM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5JRZ64mOZG8R; Fri, 12 Aug 2022 14:31:07 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 06D2041395;
        Fri, 12 Aug 2022 14:30:44 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 12 Aug 2022 14:30:44 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 12 Aug
 2022 14:30:43 +0300
Date:   Fri, 12 Aug 2022 14:30:42 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 3/6] scsi: target: core: dynamic opcode support in RSOC
Message-ID: <20220812113042.GA32459@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
 <20220718120117.4435-4-d.bogdanov@yadro.com>
 <1f72d08c-10e3-e625-0c19-e666fb70e5bb@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f72d08c-10e3-e625-0c19-e666fb70e5bb@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2022 at 10:43:05PM -0500, Mike Christie wrote:
> «Внимание! Данное письмо от внешнего адресата!»
> 
> On 7/18/22 7:01 AM, Dmitry Bogdanov wrote:
> > Report supported opcodes depending on a dynamic device configuration
> >
> > Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> > Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> > ---
> >  drivers/target/target_core_spc.c  | 118 ++++++++++++++++++++++++++++--
> >  include/target/target_core_base.h |   1 +
> >  2 files changed, 114 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> > index 506e28b14e5a..cf516136b933 100644
> > --- a/drivers/target/target_core_spc.c
> > +++ b/drivers/target/target_core_spc.c
> > @@ -1424,6 +1424,13 @@ static struct target_opcode_descriptor tcm_opcode_xdwriteread32 = {
> >                      0xff, 0xff, 0xff, 0xff},
> >  };
> >
> > +static bool tcm_is_ws_enabled(struct se_cmd *cmd)
> > +{
> > +     struct se_device *dev = cmd->se_dev;
> > +
> > +     return dev->dev_attrib.emulate_tpws;
> > +}
> > +
> >  static struct target_opcode_descriptor tcm_opcode_write_same32 = {
> >       .support = SCSI_SUPPORT_FULL,
> >       .serv_action_valid = 1,
> > @@ -1438,8 +1445,16 @@ static struct target_opcode_descriptor tcm_opcode_write_same32 = {
> >                      0x00, 0x00, 0x00, 0x00,
> >                      0x00, 0x00, 0x00, 0x00,
> >                      0xff, 0xff, 0xff, 0xff},
> > +     .enabled = tcm_is_ws_enabled,
> >  };
> 
> I'm not sure what's incorrect. I think your patch is correct but the write
> same code is wrong.
> 
> If emulate_tpws is 0, we will still execute the command. We actually only fail
> with TCM_UNSUPPORTED_SCSI_OPCODE if it's a WRITE_SAME with the UNMAP bit = 1
> and emulate_tpws=0.
> 
> If it's just a normal WRITE_SAME we maybe go by if by max_write_same_len is
> greater than zero? Maybe that was a mistake and sbc_setup_write_same needs
> a emulate_tpws check.
Looks like emulate_tpws was introduced exaclty for WS+UNMAP bit case
and it can not be used in tcm_is_ws_enabled as only check. Because of
WS is actually two different commands selected by UNMAP bit it is
unable somehow to differentiate them in RSOC. So I will reformulate
the check in tcm_is_ws_enabled to be true if some of cases is
supported by the backstore device.
+	return (dev->dev_attrib.emulate_tpws && !!ops->execute_unmap) ||
+	       !!ops->execute_write_same;

> 
> >  static struct target_opcode_descriptor tcm_opcode_sync_cache = {
> > @@ -1502,6 +1533,14 @@ static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
> >                      0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
> >  };
> >
> > +static bool tcm_is_unmap_enabled(struct se_cmd *cmd)
> > +{
> > +     struct sbc_ops *ops = cmd->protocol_data;
> > +     struct se_device *dev = cmd->se_dev;
> > +
> > +     return ops->execute_unmap  && dev->dev_attrib.emulate_tpu;
> > +}
> 
> Just a trivial nit. You had an extra space there.
yep, will fix 

