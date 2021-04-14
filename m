Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34317C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 22:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F39086120E
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 22:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhDNWjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 18:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhDNWjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 18:39:25 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BF28C061574;
        Wed, 14 Apr 2021 15:39:03 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 579A192009C; Thu, 15 Apr 2021 00:38:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 4CD8B92009B;
        Thu, 15 Apr 2021 00:38:59 +0200 (CEST)
Date:   Thu, 15 Apr 2021 00:38:59 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Bring the BusLogic host bus adapter driver up to Y2021
Message-ID: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

 First of all, does anyone have a copy of: "MultiMaster UltraSCSI Host 
Adapters for PCI Systems: Technical Reference Manual" (pub. 3002493-E)?  
It used to live in the "Mylex Manuals and Documentation Archives" section 
of the Mylex web site <http://www.mylex.com/pub/manuals/index.htm>, 
specifically at: <http://www.mylex.com/pub/manuals/mmultra.pdf>.

 Another useful document might be: "Wide SCSI Host Adapters for PCI and 
EISA Systems: Technical Reference Manual" (pub. 3000763-A), which used to 
live at: <http://www.mylex.com/pub/manuals/widescsi.pdf>, linked from the 
same place.

 Sadly I didn't get to these resources while they were still there, and 
neither did archive.org, and now they not appear available from anywhere 
online.  I'm sure Leonard had this all, but, alas, he is long gone too.

 It looks to me like either or both documents would help understanding how 
the BusLogic devices (are supposed to) work and possibly deal with issues 
in a better way.

 So we are here owing to Christoph's recent ISA bounce buffering sweep: 
<https://lore.kernel.org/linux-scsi/20210331073001.46776-1-hch@lst.de/T/#m981284e74e93216626a0728ce1601ca18fca92e8> 
which has prompted me to verify the current version of Linux with my old 
server, which has been long equipped with venerable Linux 2.6.18 and which 
I now have available for general experimenting, and the BusLogic BT-958 
PCI SCSI host bus adapter the server has used for 20-something years now.  
This revealed numerous issues with the BusLogic driver.

 Firstly (1/5) it has suffered from some bitrot and messages produced have 
become messy from the lack of update for proper `pr_cont' support.

 Secondly (2/5) there has been a potential buffer overrun/stack corruption 
security issue from using an unbounded `vsprintf' call.

 Thirdly (3/5) it has become obvious the BusLogic driver would have been 
non-functional, should I have upgraded the kernel, at least with this 
configuration for some 8 years now, and the underlying cause has been a 
long-known issue with the MultiMaster firmware I have dealt with already, 
back in 2003.  To put it short the firmware cannot cope with commands that 
request an allocation length exceeding the length of actual data returned.

 I have originally observed it with a LOG SENSE command in the course of 
investigating why smartmontools bring the system to a death, and worked it 
around: <https://sourceforge.net/p/smartmontools/mailman/message/4993087/> 
by issuing the command twice, first just to obtain the allocation length 
required.  As it turns out we need a similar workaround in the kernel now.

 But in the course of investigating this issue I have discovered there is 
a second bottom to it and hence I have prepared follow-up changes (4-5/5) 
to address problems with our handling of Vital Product Data INQUIRY pages.

 See individual change descriptions for further details.

 Questions, comments, concerns?  Otherwise please apply.

  Maciej
