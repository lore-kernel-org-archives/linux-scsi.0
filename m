Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F435C3A589
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 17:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF8F4214DA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 17:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbfHTRNc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Aug 2019 13:13:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36512 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725971AbfHTRNb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2019 13:13:31 -0400
Received: (qmail 5200 invoked by uid 2102); 20 Aug 2019 13:13:30 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 20 Aug 2019 13:13:30 -0400
Date:   Tue, 20 Aug 2019 13:13:30 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Andrea Vai <andrea.vai@unipv.it>
cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Slow I/O on USB media after commit f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
In-Reply-To: <307581a490b610c3025ee80f79a465a89d68ed19.camel@unipv.it>
Message-ID: <Pine.LNX.4.44L0.1908201307540.1573-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 19 Aug 2019, Andrea Vai wrote:

> Hi Alan,
>   I attach the two traces, collected as follows:
> 
> - start the trace;
> - wait 10 seconds;
> - plug the drive;
> - wait 5 seconds;
> - mount the drive;
> - wait 5 seconds;
> - copy a 500 byte file;
> - wait 5 seconds;
> - unmount the drive;
> - wait 5 seconds;
> - stop the trace.

Still no noticeable differences between the two traces.  They both 
include a 1.2 second delay shortly after the writing starts, and the 
initialization sequences are the same.

I really don't know where to look for this.  The only thing I can think
of at this point is to repeat this test, but using a file large enough
for the difference in writing speed to show up plainly.

By the way, it would be best to run the tests with the smallest
possible number of other USB devices plugged in.  None at all, if you
can arrange it.

Alan Stern

