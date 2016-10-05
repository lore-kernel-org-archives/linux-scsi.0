From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: iscsi_trx going into D state
Date: Wed, 5 Oct 2016 11:40:42 -0600
Message-ID: <CAANLjFrNz45nizmPa7XH4Hpw7e-KScGCsaMpXWG0BCNhuXxOCg@mail.gmail.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <20161004075545.j52mg3a2jckrchlp@linux-x5ow.site> <5cfc7eb8-c59d-4b7a-3dee-99e17d72f251@suse.de>
 <20161004114642.GA2377@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35529 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933423AbcJERko (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2016 13:40:44 -0400
Received: by mail-oi0-f67.google.com with SMTP id d132so2841295oib.2
        for <linux-scsi@vger.kernel.org>; Wed, 05 Oct 2016 10:40:44 -0700 (PDT)
In-Reply-To: <20161004114642.GA2377@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

We are not able to identify the patch that you mentioned from Lee, can
you give us a commit or a link to the patch?

Thanks,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Tue, Oct 4, 2016 at 5:46 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Oct 04, 2016 at 11:11:18AM +0200, Hannes Reinecke wrote:
>> Hmm. Looking at the code it looks as we might miss some calls to
>> 'complete'. Can you try with the attached patch?
>
> That only looks slightly better than the original.  What this really
> needs is a waitqueue and and waitevent on sess->ncon.  Although
> that will need a bit more refactoring around that code.  There also
> are a few more ovbious issues around it, e.g. iscsit_close_connection
> needs to use atomic_dec_and_test on sess->nconn instead of having
> separate atomic_dec and atomic_read calls, and a lot of the 0 or 1
> atomic_ts in this code should be replaced with atomic bitops.
>
> Btw, there also was a fix from Lee in this area that added a missing
> wakeup, make sure your tree already has that.
