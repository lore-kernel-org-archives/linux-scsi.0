Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1FCC636D4
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 08:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjBAItJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 03:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjBAItH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 03:49:07 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF53E61845;
        Wed,  1 Feb 2023 00:48:54 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 59D8B341AC1;
        Wed,  1 Feb 2023 11:48:52 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=IRFeII1GBdglgzusTJ8qXO4lGGvHA3PC2a32LjsKdNE=; b=
        qdg2+O/D8mNAZdhTNUMvsYhjePkHsPe6T4rV/J2HBnsVoQEO9Xi4eGlJ/H0MLzhz
        NnVxCueNvYCUMwul52wIScpL3/hyNt1nf7RMW0E3W2k1ydKln8QB9zleR6QyrQcF
        8j+poju43e4IHj1qEkogO2sR2wX8378uuh1RdFcs/ew=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 5098A341A6B;
        Wed,  1 Feb 2023 11:48:52 +0300 (MSK)
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 1 Feb 2023
 11:48:51 +0300
Date:   Wed, 1 Feb 2023 11:48:52 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: Re: [RESEND] target: add virtual remote target
Message-ID: <20230201084852.GK31614@yadro.com>
References: <20221202122319.28508-1-d.bogdanov@yadro.com>
 <4c3e72fb-a61e-2cf4-31fd-51ccb8104792@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4c3e72fb-a61e-2cf4-31fd-51ccb8104792@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 31, 2023 at 01:09:57PM -0600, Mike Christie wrote:
> 
> On 12/2/22 06:23, Dmitry Bogdanov wrote:
> > +
> > +static void tcm_remote_port_unlink(
> > +     struct se_portal_group *se_tpg,
> > +     struct se_lun *lun)
> > +{
> > +     pr_debug("TCM_Remote_ConfigFS: Port Unlink LUN %lld Successful\n",
> > +               lun->unpacked_lun);
> > +}
> > +
> > +/* End items for tcm_remote_port_cit */
> > +
> > +/* Start items for tcm_remote_naa_cit */
> > +
> > +static struct se_portal_group *tcm_remote_make_tpg(struct se_wwn *wwn,
> > +                                                  const char *name)
> > +{
> 
> The patch seems ok.
> 
> My only comments are on coding style:
> 
> 1. I know we have a mismatch in other lio code like above where sometimes we
> don't put any args on the first line after the "(" in tcm_remote_port_unlink
> and sometimes we do the above. Since this is new code, could you do the more
> standard style?

Yes, I will do it.

> 2. Maybe for some of these callouts where most drivers are returning the same
> hard coded value we shouldn't make them mandatory. target_fabric_tf_ops_check
> should just set a default callout.

I see that those hardcoded values are different (0 or 1) in the drivers :)
Most likely they can be the same, but those values are exported to sysfs
and potentially it could break some userspace. That would add a much of
questions.
I would like to keep this patch as much as simple.

BR,
 Dmitry

