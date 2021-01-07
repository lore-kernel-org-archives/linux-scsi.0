Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,URIBL_RED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B116C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63782233F6
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbhAGXoY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:44:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:43368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbhAGXoY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 18:44:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610063017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JghvF3bijIzseKZmfeivZsS28rPF33JX8/B/IJ9Pznw=;
        b=Frhf/gFdFfy1UiuceMqvlRISchbNlxCT6YE3OT/P8OwXAOh3ccd2yPGiiFR/PQysDPk2a7
        rP5RwyYFUbV3CQGu4oJNeMXtdUMDCUx2jSYaggeYPO4Tg0QwdxjIwyKRf7n+pxzRCYV174
        uVV0tyWsCdz1iamAJvSgWDKNz4OLWgc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 75CF0ABC4;
        Thu,  7 Jan 2021 23:43:37 +0000 (UTC)
Message-ID: <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
From:   Martin Wilck <mwilck@suse.com>
To:     Don.Brace@microchip.com, pmenzel@molgen.mpg.de,
        Kevin.Barnett@microchip.com, Scott.Teel@microchip.com,
        Justin.Lindley@microchip.com, Scott.Benesh@microchip.com,
        Gerry.Morong@microchip.com, Mahesh.Rajashekhara@microchip.com,
        hch@infradead.org, joseph.szczypek@hpe.com, POSWALD@suse.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, it+linux-scsi@molgen.mpg.de,
        buczek@molgen.mpg.de, gregkh@linuxfoundation.org
Date:   Fri, 08 Jan 2021 00:43:36 +0100
In-Reply-To: <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763254769.26927.9249430312259308888.stgit@brunhilda>
         <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
         <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-15 at 20:23 +0000, Don.Brace@microchip.com wrote:
> Please see answers below. Hope this helps.
> 
> -----Original Message-----
> From: Paul Menzel [mailto:pmenzel@molgen.mpg.de] 
> Sent: Monday, December 14, 2020 11:54 AM
> To: Don Brace - C33706 <Don.Brace@microchip.com>; Kevin Barnett -
> C33748 <Kevin.Barnett@microchip.com>; Scott Teel - C33730 <
> Scott.Teel@microchip.com>; Justin Lindley - C33718 <
> Justin.Lindley@microchip.com>; Scott Benesh - C33703 <
> Scott.Benesh@microchip.com>; Gerry Morong - C33720 <
> Gerry.Morong@microchip.com>; Mahesh Rajashekhara - I30583 <
> Mahesh.Rajashekhara@microchip.com>; hch@infradead.org; 
> joseph.szczypek@hpe.com; POSWALD@suse.com; James E. J. Bottomley <
> jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; it+linux-scsi@molgen.mpg.de; Donald
> Buczek <buczek@molgen.mpg.de>; Greg KH <gregkh@linuxfoundation.org>
> Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
> 
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> Dear Don, dear Mahesh,
> 
> 
> Am 10.12.20 um 21:35 schrieb Don Brace:
> > From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> > 
> > * Correct scsi-mid-layer sending more requests than
> >    exposed host Q depth causing firmware ASSERT issue.
> >    * Add host Qdepth counter.
> 
> This supposedly fixes the regression between Linux 5.4 and 5.9, which
> we reported in [1].
> 
>      kernel: smartpqi 0000:89:00.0: controller is offline: status
> code 0x6100c
>      kernel: smartpqi 0000:89:00.0: controller offline
> 
> Thank you for looking into this issue and fixing it. We are going to
> test this.
> 
> For easily finding these things in the git history or the WWW, it
> would be great if these log messages could be included (in the
> future).
> DON> Thanks for your suggestion. Well add them in the next time.
> 
> Also, that means, that the regression is still present in Linux 5.10,
> released yesterday, and this commit does not apply to these versions.
> 
> DON> They have started 5.10-RC7 now. So possibly 5.11 or 5.12
> depending when all of the patches are applied. The patch in question
> is among 28 other patches.
> 
> Mahesh, do you have any idea, what commit caused the regression and
> why the issue started to show up?
> DON> The smartpqi driver sets two scsi_host_template member fields:
> .can_queue and .nr_hw_queues. But we have not yet converted to
> host_tagset. So the queue_depth becomes nr_hw_queues * can_queue,
> which is more than the hw can support. That can be verified by
> looking at scsi_host.h.
>         /*
>          * In scsi-mq mode, the number of hardware queues supported
> by the LLD.
>          *
>          * Note: it is assumed that each hardware queue has a queue
> depth of
>          * can_queue. In other words, the total queue depth per host
>          * is nr_hw_queues * can_queue. However, for when host_tagset
> is set,
>          * the total queue depth is can_queue.
>          */
> 
> So, until we make this change, the queue_depth change prevents the
> above issue from happening.

can_queue and nr_hw_queues have been set like this as long as the
driver existed. Why did Paul observe a regression with 5.9?

And why can't you simply set can_queue to 
(ctrl_info->scsi_ml_can_queue / nr_hw_queues)?

Regards,
Martin


