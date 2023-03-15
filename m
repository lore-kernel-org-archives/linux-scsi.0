Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC51C7618B
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 07:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbjCOH7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 03:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjCOH7J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 03:59:09 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24D834038;
        Wed, 15 Mar 2023 00:59:06 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 967CB341DF9;
        Wed, 15 Mar 2023 10:59:04 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=SYHt2RiwOOFnYnUtSK+XR/+XEjQbm1wWqqHi1WdGY6Y=; b=
        ZQ2z0b28wPTqU6m0t41eUGs0My+Rn1WplUG1edq6kWZYx1XDmPy5lMrZcmwz7yJE
        EuTn+H78Ax8PsrBc+2U7/0DOkpWfrGDIqsUTUpy8TT00xSPBEYdH/X/e6gIt7uH+
        S4wycmUq3VOxTidRqi487IW9CnmewbrZjDspN6pUC48=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 886AE341CBA;
        Wed, 15 Mar 2023 10:59:04 +0300 (MSK)
Received: from yadro.com (10.199.20.11) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 15 Mar
 2023 10:59:03 +0300
Date:   Wed, 15 Mar 2023 10:59:04 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: Re: [PATCH v3 12/12] target: add virtual remote target
Message-ID: <20230315075904.GC1031@yadro.com>
References: <20230313181110.20566-1-d.bogdanov@yadro.com>
 <20230313181110.20566-13-d.bogdanov@yadro.com>
 <c004e7a8-8478-cc75-e174-5c0bbd22f4fc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c004e7a8-8478-cc75-e174-5c0bbd22f4fc@oracle.com>
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 14, 2023 at 12:09:31PM -0500, Mike Christie wrote:
> 
> On 3/13/23 1:11 PM, Dmitry Bogdanov wrote:
> > +
> > +static int tcm_remote_port_link(
> > +     struct se_portal_group *se_tpg,
> > +     struct se_lun *lun)
> > +{
i> 
> Oh no, what happened. Something probably got messed up in your patch
> management because I saw the 0/12 patch said the coding style was
> fixed up.
> 
> If Martin will take a follow up patch or it's not a big deal to him,
> I'm ok.
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> 

Mike, the code style is the same as in v2. AFAIR you said not to mix
the first function argument in the same line with the first argument in
the next line. In my patch there is no such mix anymore. Either all
arguments are inline or all arguments in the next lines.

