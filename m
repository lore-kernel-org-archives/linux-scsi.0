From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iscsi_trx going into D state
Date: Tue, 4 Oct 2016 10:39:27 -0600
Message-ID: <CAANLjFp15z7+3FCzr2fqTf+FC7rboOGNq=DUE59tACaOfeO02g@mail.gmail.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <20161004075545.j52mg3a2jckrchlp@linux-x5ow.site> <5cfc7eb8-c59d-4b7a-3dee-99e17d72f251@suse.de>
 <20161004114642.GA2377@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161004114642.GA2377-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Do you want me to try this patch or wait for some of the suggestions
Christoph brought up to be Incorporated?
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Tue, Oct 4, 2016 at 5:46 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
