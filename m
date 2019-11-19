Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DEBC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 11:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E69F222F2
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 11:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfKSLCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 06:02:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:50656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbfKSLCk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 06:02:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4FEFEB380;
        Tue, 19 Nov 2019 11:02:39 +0000 (UTC)
Message-ID: <d206cd30258703d88b53c65db071d60cabb33263.camel@suse.de>
Subject: Re: [PATCH 52/52] scsi: Drop the now obsolete driver_byte
 definitions
From:   Martin Wilck <mwilck@suse.de>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
Date:   Tue, 19 Nov 2019 12:03:17 +0100
In-Reply-To: <4164a4a2-d206-b4de-367b-6c94f0bbbf99@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
         <20191104090151.129140-53-hare@suse.de>
         <4b19bf3fdb242f166b203c456243553c09a22c92.camel@suse.de>
         <4164a4a2-d206-b4de-367b-6c94f0bbbf99@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-11-19 at 10:31 +0100, Hannes Reinecke wrote:
> On 11/19/19 10:02 AM, Martin Wilck wrote:
> > 
> > While I generally like this change, the driver byte is part of the
> > sg_io user space API, and used in sg3_utils and multipath-tools (in
> > particular, DRIVER_SENSE), and likely in other user space tools as
> > well. Can we simply ditch it without adding some compatibility code
> > to
> > sg and bsg?
> > 
> Why, but I did...
> sg and bsg should report to userland exactly the same values as
> before;
> or at least that was the plan.

I am sorry, I overlooked that part in sg.c where you set DRIVER_SENSE. 
It's the only DRIVER_xyz code that you set though. Is that sufficient? 

In bsg.c, I just see 

@@ -96,7 +96,7 @@ static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
         */
        hdr->device_status = sreq->result & 0xff;
        hdr->transport_status = host_byte(sreq->result);
-       hdr->driver_status = driver_byte(sreq->result);
+       hdr->driver_status = 0;
        hdr->info = 0;
        if (hdr->device_status || hdr->transport_status || hdr->driver_status)
                hdr->info |= SG_INFO_CHECK;
	hdr->driver_status = 0;

To me that looks as if userspace might get a different result as
before. Similar in bsg_lib.c. I may be overlooking something again, but
not being familiar with the bsg driver, I thought I'd better ask.

(Nitpick: your change obsoletes the check for hdr->driver_status two
lines below).

Thanks
Martin


