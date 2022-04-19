Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BC6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 08:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350016AbiDSIcr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 04:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350013AbiDSIcq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 04:32:46 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02801D6B;
        Tue, 19 Apr 2022 01:30:02 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 983784598B;
        Tue, 19 Apr 2022 08:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1650357000;
         x=1652171401; bh=XZr1BtkhIFaqmDe6HG1d3R9+PXAyVZArfu1KXlRh8uM=; b=
        Fi190icQoHGKLuFvNPT0137PTh670Rj3e+5tYFMMeLLo487f9RJriAaBpqrx5Sn6
        3s4oMxfZiFepxTzDwUrKN52sQG1RaBciEY3G3E6ZQXV0iJpWcMhGczTo93vtIkKg
        J2zifV5x9Q6PHewJ6HfUC0N1RZ5zhLmVwpGIqRjIZUY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ud1UkOo9gDmW; Tue, 19 Apr 2022 11:30:00 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 970B345985;
        Tue, 19 Apr 2022 11:30:00 +0300 (MSK)
Received: from yadro.com (10.178.113.178) by T-EXCH-01.corp.yadro.com
 (172.17.10.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 19
 Apr 2022 11:29:59 +0300
Date:   Tue, 19 Apr 2022 11:29:57 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH] scsi: target: core: Silence the message about unknown
 VPD pages
Message-ID: <Yl5zBRgS2z4PtbA+@yadro.com>
References: <20220418212622.275516-1-k.shelekhin@yadro.com>
 <yq1r15t93gh.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <yq1r15t93gh.fsf@ca-mkp.ca.oracle.com>
X-Originating-IP: [10.178.113.178]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-01.corp.yadro.com (172.17.10.101)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 18, 2022 at 11:08:12PM -0400, Martin K. Petersen wrote:
> Konstantin,
> 
> > Target does not support some VPD pages and is very verbose about it.
> > Sometimes initiators don't bother and just keep sending the same
> > request from time to time, filling up the logs.
> >
> > This patch lowers the message priority to debug.
> 
> This essentially means the message will never be seen since it is not
> particularly common to twiddle the syslog level. Have you considered
> pr_err_once() or similar?

Hi,

Basically I was going the same route as with this message:

  pr_debug_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n"

IMO it's kinda the same situation. I'm not sure that not implemented VPD
will be of any interest to anyone except for the developers.

Also if I recall correctly pr_err_once() will be triggered once per code
line, not per message, so it's possible to actually lose the info if
more that one page is not implemented.
