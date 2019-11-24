Return-Path: <SRS0=aE2e=ZQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E3BC43215
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Nov 2019 18:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66085207FC
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Nov 2019 18:31:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="WdF5q4l4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfKXSbI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Nov 2019 13:31:08 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:35018 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726833AbfKXSbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 Nov 2019 13:31:08 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9F05043D12;
        Sun, 24 Nov 2019 18:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1574620265;
         x=1576434666; bh=IBoJjYQPCNxLu3SR1IcVDBO8FAOPRF6HJJDI9hzTB30=; b=
        WdF5q4l4Q6Qy38Cb7O0/0+fVIfCdZ34vfxrCLjsiy+XamhsGVBFzUkptTmXiuTjG
        FZo+oIENGpz4zaxm+ccWqFhheNv2E/vof+KYbSnSR0qZbehcefaFlmcCQvSfXbcy
        5iM/VUWcgCw2Oj24xb57OhhBfMmrC0FUfrMpaLCHTUk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9eQG2q7G4o6e; Sun, 24 Nov 2019 21:31:05 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A847A41240;
        Sun, 24 Nov 2019 21:31:05 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sun, 24
 Nov 2019 21:31:05 +0300
Date:   Sun, 24 Nov 2019 21:31:04 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Martin Wilck <mwilck@suse.de>
CC:     Hannes Reinecke <hare@suse.de>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH v2 00/15] scsi: qla2xxx: Bug fixes
Message-ID: <20191124183104.fg364dol5rol3xfh@SPB-NB-133.local>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <b84e274f-c20e-9351-27de-4cf1b34916d9@suse.de>
 <139c4a1040a9077fff39486f47134960d543ca53.camel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <139c4a1040a9077fff39486f47134960d543ca53.camel@suse.de>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 22, 2019 at 10:36:06PM +0100, Martin Wilck wrote:
> On Fri, 2019-11-22 at 10:14 +0100, Hannes Reinecke wrote:
> > This patchset has the nice benefit that it has fixed the crashes on
> > rmmod we had been seeing.
> 
> Well, I investigated two distinct crash-at-rmmod cases, and one was
> already fixed by the earlier commit f45bca8c5052 ("scsi: qla2xxx: Fix
> double scsi_done for abort path"), whereas the other is still present,
> even after applying this series.
> 
> Not to say the series is bad - we just shouldn't raise expectations
> too high.
> 

Hi Martin,

This patch series only fixes a crash when there's active I/O and ACL of
the initiator is getting deleted. The issue can be reproduced quite
easily:

  1. Configure a target with 1 LUN and 1 ACL (and 1 Mapped LUN inside)
  2. Run I/O from initiator
  3. Delete ACL while running the I/O

The crash happens ~30s after the ACL is deleted when the initiator
starts sending ABORT TASK TMF to abort timed out I/O. It might happen at
rmmod time but that's just coincidence of ABORT TASK being processed. It
might not happen if a rig shuts off in less than 30 seconds.

Thanks,
Roman
