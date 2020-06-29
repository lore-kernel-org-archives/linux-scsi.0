Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=DATE_IN_PAST_12_24,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363A7C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15B5820672
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389002AbgF2Ueu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:34:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:59504 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732209AbgF2TVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 15:21:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CFDB4AC5E;
        Mon, 29 Jun 2020 07:01:43 +0000 (UTC)
Date:   Mon, 29 Jun 2020 09:01:43 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 7/9] qla2xxx: Fix a Coverity complaint in
 qla2100_fw_dump()
Message-ID: <20200629070143.n6gzn5yymeq2tfmt@beryllium.lan>
References: <20200614223921.5851-1-bvanassche@acm.org>
 <20200614223921.5851-8-bvanassche@acm.org>
 <20200623083354.2fldcoancxym6s6n@beryllium.lan>
 <c0b9309f-0da6-f5f5-d1c3-4b01986d9e72@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0b9309f-0da6-f5f5-d1c3-4b01986d9e72@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Sun, Jun 28, 2020 at 03:31:37PM -0700, Bart Van Assche wrote:
> On 2020-06-23 01:33, Daniel Wagner wrote:
> > On Sun, Jun 14, 2020 at 03:39:19PM -0700, Bart Van Assche wrote:
> >> @@ -1063,7 +1063,8 @@ qla2100_fw_dump(scsi_qla_host_t *vha)
> >>  	}
> >>  
> >>  	if (rval == QLA_SUCCESS)
> >> -		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
> >> +		qla2xxx_copy_queues(ha, (char *)fw +
> >> +				    offsetof(typeof(*fw), risc_ram) + cnt);
> > 
> > This looks pretty ugly to me. Any chance to write this in a way it's
> > understandable by humans and coverity is not annoyed?
> > 
> > Do I understand it correctly, it's valid to read after the end of risc_ram?
> 
> Doesn't the function qla2xxx_copy_queues() write to the pointer passed
> as the second argument instead of reading?

Yes, it seems to copy the request queue and the response queue
to the pointer. Funny, it returns a pointer offset which only uses
the size of the response queue which is used py qla2xxx_copy_eft.
Looking at I would swear qla2xxx_copy_eft overwrites data from
qla2xxx_copy_queues.

> A possible alternative can be found below. The only reason I can think
> of why this works is because the qla2100_fw_dump structure is occurs in
> a union and because there is probably a larger structure present in the
> same union. I would like to specify a size for the queue_dump[] array
> but I am not sure where to get that information from.

Yes, this would be indeed a good thing.

> Subject: [PATCH] qla2xxx: Fix a Coverity complaint in qla2100_fw_dump()
> 
> 'cnt' can exceed the size of the risc_ram[] array. Prevent that Coverity
> complains by rewriting an address calculation expression. This patch
> fixes the following Coverity complaint:
> 
> CID 337803 (#1 of 1): Out-of-bounds read (OVERRUN)
> 109. overrun-local: Overrunning array of 122880 bytes at byte offset
> 122880 by dereferencing pointer &fw->risc_ram[cnt].

Much better, now I get it :)

Reviewed-by: Daniel Wagner <dwagner@suse.de>

Thanks,
Daniel
