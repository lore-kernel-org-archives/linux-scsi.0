Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C81C47253
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D413E2173E
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgEARpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 13:45:08 -0400
Received: from verein.lst.de ([213.95.11.211]:48085 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729659AbgEARpI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 13:45:08 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 582F768D0F; Fri,  1 May 2020 19:45:06 +0200 (CEST)
Date:   Fri, 1 May 2020 19:45:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN
 reset
Message-ID: <20200501174505.GC23795@lst.de>
References: <20200430131904.5847-1-hare@suse.de> <20200430131904.5847-5-hare@suse.de> <20200430151546.GB1005453@T590> <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de> <20200501150129.GB1012188@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501150129.GB1012188@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 01, 2020 at 11:01:29PM +0800, Ming Lei wrote:
> > We cannot increase MAX_QUEUE arbitrarily as this is a compile time variable,
> > which seems to relate to a hardware setting.
> > 
> > But I can see to update the reserved command functionality for allowing to
> > fetch commands from the normal I/O tag pool; in the case of LUN reset it
> > shouldn't make much of a difference as the all I/O is quiesced anyway.
> 
> It isn't related with reset.
> 
> This patch reduces active IO queue depth by 1 anytime no matter there is reset
> or not, and this way may cause performance regression.

But isn't it the right thing to do?  How else do we guarantee that
there always is a tag available for the LU reset?
