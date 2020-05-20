Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FB5C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 08:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 973D52075F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 08:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgETI4z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 04:56:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:44624 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgETI4z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 May 2020 04:56:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8938BAA4F;
        Wed, 20 May 2020 08:56:56 +0000 (UTC)
Date:   Wed, 20 May 2020 10:56:52 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v7 15/15] qla2xxx: Fix endianness annotations in source
 files
Message-ID: <20200520085652.ps64ccmgjefc46cc@beryllium.lan>
References: <20200518211712.11395-1-bvanassche@acm.org>
 <20200518211712.11395-16-bvanassche@acm.org>
 <20200519152401.oh6cewdru3fu7ogd@beryllium.lan>
 <alpine.LNX.2.22.394.2005201726250.8@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.22.394.2005201726250.8@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

On Wed, May 20, 2020 at 05:39:55PM +1000, Finn Thain wrote:
> I agree. qla2xxx-endianness-annotations.diff seems to be noise.
> 
> The differences in the __bug_table sections and ql_dbg() call sites are
> presumably caused by line break changes. Perhaps they can be squelched by
> inserting blank lines at the appropriate places (for either build). That
> could probably be automated.

Yes most of the noise is due to the ql_dbg() statemenents. I supppose the
simplest way would to undefine it so no code is generated.

> It would be nice to know how these symbols end up with different numbering
> between builds because it makes a real mess of the diff.

I am not sure what triggers the compiler to have different numberings. Mabye a
newer gcc would behave better, no idea. I used the on shipped on SLE15-SP1,
which means a bit older :)

> I wonder whether the Reproducible Builds project has developed any
> techniques that could be applied here.
> https://reproducible-builds.org/

Maybe, I don't know if they tools from this project help for such an analysis.

Well, I ended up going through the filtered diff. Obviously, with such a big
diff it's easy to miss something but I don't think it's a problem. The patch
got reviewes and the tools do also help to find bugs.

Thanks,
Daniel
