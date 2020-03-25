Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417D2C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 23:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 126E42073E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 23:35:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="krV/xpfP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbgCYXf1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 19:35:27 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43986 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726970AbgCYXf1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 19:35:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PNUGOe021630;
        Wed, 25 Mar 2020 16:35:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=vKIrRuyDs1pF5iwAHpO9yAFTHZUL0PMbI004wPrDAhc=;
 b=krV/xpfPTHzGsq6uduoOzYPYGePqnLmbB+oRe8tLV6zdCzNRJJPf0e2g64X+XGvY7fse
 ByLA/JCkyAj/PwQhRn9WTkzHKMXAFQkEEGcRHqnGqtcnaSDlrGdO13hhz11QgdwhPyQ8
 3ukD6n5eLb5ijJPx853tfrASD3OmkHEpaN0cQgHAA/FE9zccaTbQnfEXGU4oAJ3vo8aT
 RgGwvL6zFkmNl+hmLiwJ0NGKthc6xHILYwBO0hpDoWWzW3Gq6qQl5VUxGjnUG0XXxTaQ
 zEUUkCufinKTXAkpsfP1XiIh5H69yWLwDyYfaELQWJwBHf6uLTvQnsL64cfAguqeyoSU jg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9ntvt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 16:35:17 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 16:35:15 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 16:35:15 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 07B653F7041;
        Wed, 25 Mar 2020 16:35:16 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 02PNZFq3029820;
        Wed, 25 Mar 2020 16:35:15 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 25 Mar 2020 16:35:15 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Martin Wilck <mwilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Daniel Wagner <dwagner@suse.de>,
        "James Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v2 1/3] scsi: qla2xxx: avoid sending mailbox
 commands if firmware is stopped
In-Reply-To: <86e85687933f6875ab75f927981fc43a9a257b74.camel@suse.com>
Message-ID: <alpine.LRH.2.21.9999.2003251615200.12727@irv1user01.caveonetworks.com>
References: <20200205214422.3657-1-mwilck@suse.com>
  <20200205214422.3657-2-mwilck@suse.com>
  <alpine.LRH.2.21.9999.2003241648560.12727@irv1user01.caveonetworks.com>
  <dfbd88461ef4b5f56a83db7095c6e3f36b5a485e.camel@suse.com>
  <4fb2d29be88dbef2050cf51210d8e4e14a4b8ac2.camel@suse.com>
  <940e20ba5d117b6fd181e0acdac14b7682ff2d64.camel@suse.com>
  <alpine.LRH.2.21.9999.2003251506260.12727@irv1user01.caveonetworks.com>
 <86e85687933f6875ab75f927981fc43a9a257b74.camel@suse.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_13:2020-03-24,2020-03-25 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 25 Mar 2020, 3:41pm, Martin Wilck wrote:

>
> ----------------------------------------------------------------------
> On Wed, 2020-03-25 at 15:13 -0700, Arun Easi wrote:
> > On Wed, 25 Mar 2020, 11:21am, Martin Wilck wrote:
> > 
> > > On Wed, 2020-03-25 at 18:20 +0100, Martin Wilck wrote:
> > > > Perhaps the (!fw_started) condition should be treated like
> > > > ABORT_ISP_ACTIVE in qla2x00_mailbox_command, i.e. execute only if
> > > > is_rom_cmd() returns true?
> > > 
> > > No, this won't be sufficient, as e.g. MBC_IOCB_COMMAND_A64 is in
> > > rom_cmds[], but has been found to hang (this is why I had the hunk
> > > in
> > > qla24xx_fabric_logout()). The list of mailbox commands
> > > that must be passed on when the FW is stopped has to be shorter
> > > than
> > > rom_cmds[].
> > > 
> > 
> > With your patch 2/3, where UNLOADING is set prior to the reset of 
> > chip, in place this issue should be largely addressed. Basically, 
> > paths that send out request to wire check UNLOADING bit (if any path 
> > is missing that, should add the check) before sending it out.
> > 
> > Now with UNLOADING set (with your patch 2/3), chip reset, and all 
> > outstanding command's completion called (qla2x00_abort_isp_cleanup) I 
> > see less chance of anything being sent out. If you see any issue with 
> > your patches 1 & 2 (addressing my comments) applied, let me know and 
> > we can tackle then. How about that?
> 
> It sounds like a plan. Although it means that I just wasted time trying
> to figure out which mailbox commands need to be processed even if the
> firmware is down :-)
> 

I hope it was not too much time. On the plus side, you know the mailbox 
path very well now. :)

Regards,
-Arun
