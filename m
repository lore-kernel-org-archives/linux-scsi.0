Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9BAC433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 13:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B4E2072A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 13:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgICNhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 09:37:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:41420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728981AbgICNB5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Sep 2020 09:01:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AD318ABED;
        Thu,  3 Sep 2020 13:01:00 +0000 (UTC)
Message-ID: <f1e02a57e5d42c492d89acc2f82809e91e42d2aa.camel@suse.com>
Subject: Re: [PATCH v4 2/4] target: initialize LUN in
 transport_init_se_cmd().
From:   Martin Wilck <mwilck@suse.com>
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Michael Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shirley Ma <shirley.ma@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Arun Easi <aeasi@marvell.com>
Date:   Thu, 03 Sep 2020 15:00:58 +0200
In-Reply-To: <dcc05e5d-5b8f-4ae1-991d-b8d454eff3f0@default>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
         <1591559913-8388-3-git-send-email-sudhakar.panneerselvam@oracle.com>
         <cbbd368e6e33af6e22c850192e69b27edd043efd.camel@suse.com>
         <dcc05e5d-5b8f-4ae1-991d-b8d454eff3f0@default>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.36.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-09-02 at 08:14 -0700, Sudhakar Panneerselvam wrote:
> Hi Martin,
> 
> > 
> > AFAICS, your patch breaks the case where the above code is executed
> > to
> > derive unpacked_lun from the tag. The updated value of unpacked_lun
> > is
> > never used. That would break aborts for the qla2xxx target.
> > 
> > Am I overlooking something? Can you please explain?
> > 
> 
> You are right. This change breaks the qlogic abort task code path,
> since it is the only transport that sets the
> TARGET_SCF_LOOKUP_LUN_FROM_TAG flag making that condition true. My
> apologies. I can send out a patch if you have not written one
> already. Please let me know.

Please go ahead. I haven't written a patch - I'm not experienced enough
with the target code to quickly grok whether simply moving the
target_lookup_lun_from_tag() code upward would work, in particular wrt
handling failures and cleaning up.

Regards,
Martin



