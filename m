Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3619C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 07:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjFAHYQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jun 2023 03:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbjFAHYK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2023 03:24:10 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3829F;
        Thu,  1 Jun 2023 00:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1685604239; x=1717140239;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7mqdnmsXuIWuWi1J0aDxuFjgfrWdJ16+HRGU+cCI0WA=;
  b=TWzxsI8Djd0Ldpwc3ol0GTtpLvMG3Zpmle2ekxWhD6Iun1IDGraACbqy
   Fd0n550hq7CwQVnarUCpZlwM6Bi6DL/fU/AiwpbKVkqbmzC0Mzt5d8Mus
   AslaPkCbTz7M5SjPZiwFjjV9Vpy92XrPHtC6a+zbTUjp69iZKovsANu4f
   g=;
X-IronPort-AV: E=Sophos;i="6.00,209,1681171200"; 
   d="scan'208";a="217885865"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 07:23:57 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id D5BD040E57;
        Thu,  1 Jun 2023 07:23:56 +0000 (UTC)
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 1 Jun 2023 07:23:53 +0000
Received: from dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (10.15.57.183)
 by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 1 Jun 2023 07:23:53 +0000
Received: by dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (Postfix, from userid 5466572)
        id AF3A0970; Thu,  1 Jun 2023 07:23:52 +0000 (UTC)
Date:   Thu, 1 Jun 2023 07:23:52 +0000
From:   Maximilian Heyne <mheyne@amazon.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Adam Radford <aradford@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: megaraid: Fix uninitialized mbox in mega_cmd_done
Message-ID: <20230601072352.GA123625@dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com>
References: <20230531133259.55619-1-mheyne@amazon.de>
 <yq1v8g8b0e8.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <yq1v8g8b0e8.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 31, 2023 at 06:38:12PM -0400, Martin K. Petersen wrote:
> Hi Maximilian!

Hi Martin,

thanks for your response.

> 
> > This is similar to commit 7a2ae008a53c ("scsi: megaraid: Fix
> > mega_cmd_done() CMDID_INT_CMDS").
> 
> That's supposed to be commit 75cb113cd43f, right?

Sorry, yes I meant this commit. I accidentally got the commit id form the 5.4
backport.

> 
> > When cmdid == CMDID_INT_CMDS and status != 0 then mbox is still NULL
> > but is dereferenced below.
> 
> Is this actually a valid scenario, though? The mbox is only dereferenced
> if there is status returned from an attached device. And I am guessing
> that a controller-internal command does not talk to any attached device.
> Thus status should always be 0 for CMDID_INT_CMDS. I don't have the
> megaraid firmware manual so this is pure guesswork on my part. But you
> would think we would have come across an invalid deref since the
> original 2014 commit made the offending change.
> 

This could indeed be the case. I only found this because it was reported by
static code analysis. However, by reading the code it's not obvious that this is
how it works. Should we therefore skip the whole status checking switch for
internal commands to make it more clear? For example, by a goto to the end of
the loop when the scb gets freed or just adding the scb free, list removal
and a continue?




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



