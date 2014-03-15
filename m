From: Christoph Hellwig <hch@infradead.org>
Subject: scsi_debug and mutipath, was Re: [PATCH 1/1] block: rework flush
 sequencing for blk-mq
Date: Sat, 15 Mar 2014 06:28:26 -0700
Message-ID: <20140315132826.GA17752@infradead.org>
References: <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <20140312102849.GA26509@infradead.org>
 <20140313161347.GA6598@redhat.com>
 <20140314092519.GA10139@infradead.org>
 <20140314130021.GA12589@redhat.com>
 <20140314132323.GA14606@infradead.org>
 <20140314141301.GA13112@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140314141301.GA13112@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 14, 2014 at 10:13:01AM -0400, Mike Snitzer wrote:
> I was more reacting to the assertion you made like multipath regresses
> all the time.  I'm not faulting you at all for not having tested
> multipath.  Hell, I even forget to test multipath more than I should.
> /me says with shame

And I didn't assert that, I just asserted that it gets little testing.

> Yeah, not sure why single path scsi_debug "just works", maybe it is a
> "feature" of the older multipathd I have kicking around?, but for basic
> data path testing scsi_debug is a quick means to an end.  I can look
> closer at _why_ it gets multipathd in a bit.  But maybe Ben or Hannes
> will have quicker insight?
> 
> For me, if multipathd is running, if I issue the following a multipath
> device gets layered ontop of the associated scsi_debug created sd
> device: modprobe scsi_debug dev_size_mb=1024
> 
> I think it useful to have scsi_debug work with multipath.  I know people
> in Red Hat's QE organization have even simulated multiple paths with
> it.. but I don't recall if they had to hack scsi_debug to do that.  I'll
> try to find out.

Looks like it really shouldn't attach as-is.  But scsi_debug should be
easily extendable to export two LUNs for the same backing store to help
multipath testing.
