From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: 2.6.23-rc4-mm1
Date: Tue, 11 Sep 2007 04:42:53 +0900
Message-ID: <20070910045503O.tomof@acm.org>
References: <20070910111926.9c942358.akpm@linux-foundation.org>
	<64bb37e0709101159v47f586aby7f078ef1db5cbc39@mail.gmail.com>
	<20070910122038.1f1bb006.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761165AbXIJToH@vger.kernel.org>
In-Reply-To: <20070910122038.1f1bb006.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: just.for.lkml@googlemail.com, apw@shadowen.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Mon, 10 Sep 2007 12:20:38 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 10 Sep 2007 20:59:49 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> 
> > On 9/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Mon, 10 Sep 2007 18:49:26 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> > >
> > > > I have a couple of old NUMA-Q systems which are unable to read their
> > > > boot disks with 2.6.23-rc4-mm1.  The disks appear to be recognised and
> > > > even the partition tables read correctly, and then they go pop:
> > 
> > I reported a similar problem on Sep 1, but until now got no response.
> 
> You still haven't had a response ;)  Let's add a cc.
> 
> Oh, you reported it against 2.6.23-rc4-mm1
> (http://lkml.org/lkml/2007/9/1/92) and I did cc linux-ide in my response.
> 
> I'll continue to point out where this sort of thing occurs because last
> week I was told that a reson why so many bug reports are ignored is because
> "linux-kernel has too much traffic".

many SCSI people don't subscribe to linux-kernel, I think.


> > The system boots, reads the partition tables, starts the RAID and then
> > kicks one drive out because of errors.
> 
> Andy is using qla1280.  You're using sata.  So it's probably a different
> bug, with the same symptoms.

This might be a sg chaining bug too (probabaly sg chaining libata
patch).

Can you try the following patch that I've just sent:

http://lkml.org/lkml/2007/9/10/251

The patch also disables chaining sg list for libata.
