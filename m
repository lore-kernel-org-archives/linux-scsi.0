Return-Path: <SRS0=Jnta=D7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2CEC4363A
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 12:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722DE2226B
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 12:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="L20rST8i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761237AbgJXMNZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Oct 2020 08:13:25 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:50204 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1761233AbgJXMNY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Oct 2020 08:13:24 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9AC4841315;
        Sat, 24 Oct 2020 12:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1603541597;
         x=1605355998; bh=07uzTTT8NaNO59x5cQLo4UEWwHepvtbpj2lCcR+ID28=; b=
        L20rST8ia6f+QK1tKpWistETQabqMI84D9IGjUMnpmGRoEce19mc+Qs0UNYjCjqN
        3MJzQlU68McZLc96Wpqm8NxSYwhFzj4WrKAbQe7t7PlkhDSlmF+HfrXlRPUvZnD1
        krDlKpjg++0ruOI5k5Dgs8SI9mkAWRTNB6whISqfAY8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WZIKw7Vy2E0P; Sat, 24 Oct 2020 15:13:17 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id F05F4412FC;
        Sat, 24 Oct 2020 15:13:16 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sat, 24
 Oct 2020 15:13:16 +0300
Date:   Sat, 24 Oct 2020 15:13:15 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Message-ID: <20201024121315.GA35317@SPB-NB-133.local>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 23, 2020 at 09:07:38PM -0700, Bart Van Assche wrote:
> On 10/22/20 10:20 AM, Anastasia Kovaleva wrote:
> > According to FCP-4 (9.4.2):
> > 
> >   If the command requested that data beyond the length specified by the
> >   FCP_DL field be transferred, then the device server shall set the
> >   FCP_RESID_OVER bit (see 9.5.8) to one in the FCP_RSP IU and:
> > 
> >   a) process the command normally except that data beyond the FCP_DL
> >   count shall not be requested or transferred;
> > 
> >   b) transfer no data and return CHECK CONDITION status with the sense
> >   key set to ILLEGAL REQUEST and the additional sense code set to INVALID
> >   FIELD IN COMMAND INFORMATION UNIT; or
> > 
> >   c) may transfer data and return CHECK CONDITION status with the sense
> >   key set to ABORTED COMMAND and the additional sense code set to
> >   INVALID FIELD IN COMMAND INFORMATION UNIT.
> > 
> > TCM follows b) and transfers no data for residual writes but returns
> > INVALID FIELD IN CDB instead of INVALID FIELD IN COMMAND INFORMATION
> > UNIT.
> > 
> > Change the ASCQ to INVALID FIELD IN COMMAND INFORMATION UNIT to meet the
> > standart.
> 
> Is FCP the only standard that requires to report INVALID FIELD IN COMMAND
> INFORMATION UNIT for residual overflow? I haven't found any similar
> requirement in the iSCSI RFC nor in the SRP standard.
> 

Hi Bart,

iSCSI doesn't specify a specific code but mentions a possibility of CHECK
CONDITION for residuals (11.4.5.1.  Field Semantics):

  Targets may set the residual count, and initiators may use it when the
  response code is Command Completed at Target (even if the status
  returned is not GOOD).

I have skimmed over SRP and haven't found if it's explicitly disallowed
to send CHECK CONDITION for READ/WRITEs with residuals.

> Additionally, what benefits does it provide to report a CHECK CONDITION
> upon residual overflow?

Typical use case for CHECK CONDITION in case of Underflow/Overflow is
extra robustness against buggy initiators [1][2]. Failing both READ and
WRITE is the most solid approach in that sense [3][4][5] as it prevents
data corruption at all costs.

Suppose an initiator wants to WRITE 8 LBA. For 512-byte formatted LUN,
8 LBAs need a buffer of 4K bytes. For 4096-byte formatted LUN the
command would need 32K data buffer.

An Overflow happens if initiator treats 4Kn device like 512n one but
provides a buffer of 4K. i.e. to complete the WRITE target needs to
consume 28K more data, otherwise only 1 LBA would be written and the
rest 7 LBAs would have indeterminate content.

An Underflow happens if initiator confuses 512n device with 4Kn one and
provides a buffer of 32K, i.e. target doesn't utilize all buffer for the
command.

> The SCST QLogic FC target driver doesn't do this as far as I know, is
> more than ten years old, is widely used and so far nobody complained
> about this.
> 

It might be true but there are no public tests for FC. We're planning to
extend libiscsi using SG_IO v4 to cover more corner cases, like FC
residuals and aborts/error recovery. Also, SLER (Sequence level error
recovery) is comming to FCP-5/FC-NVMe-2, it be useful to test it too.

1. https://www.t10.org/pipermail/t10/2014-June/017369.html
2. https://www.t10.org/pipermail/t10/2014-June/017370.html
3. https://www.t10.org/pipermail/t10/2012-September/016340.html
4. https://www.t10.org/pipermail/t10/2012-September/016350.html
5. https://mailarchive.ietf.org/arch/msg/ips/PpMCMQw-HzKQ5gwteFD54CN_0EY/

Regards,
Roman
