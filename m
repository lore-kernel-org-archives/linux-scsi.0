Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38138C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 12:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiHKM2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 08:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbiHKM2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 08:28:43 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD8E94ED7
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 05:28:42 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id F215D68AA6; Thu, 11 Aug 2022 14:28:39 +0200 (CEST)
Date:   Thu, 11 Aug 2022 14:28:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Martin Wilck <mwilck@suse.com>, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com,
        Hannes Reinecke <Hannes.Reinecke@suse.com>
Subject: Re: [PATCH 3/4] scsi: Internally retry scsi_execute commands
Message-ID: <20220811122839.GD1742@lst.de>
References: <20220810034155.20744-1-michael.christie@oracle.com> <20220810034155.20744-4-michael.christie@oracle.com> <6149f7bdfa013e0352e59dee2669298b2c080a03.camel@suse.com> <2b1943b2-466f-5674-1c8c-7db7b2dc4738@oracle.com> <2b33796a-b504-f0b0-85cf-09383543fbcc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b33796a-b504-f0b0-85cf-09383543fbcc@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 10, 2022 at 12:38:08PM -0500, Mike Christie wrote:
> It sounded really nice at first, but to do that I would have a bunch of
> cases that might be specific to pr_ops, alua or scanning, etc. Then I
> also had cases where user1 does not want to retry but user2 did, so I
> have to add more SCMD bits. So, in the end it will get messier than
> you initially think.

Do you have an overview of the different cases you've spot so far?
