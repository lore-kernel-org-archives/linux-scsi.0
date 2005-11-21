From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 1/3] cciss: bug fix for hpacucli
Date: Mon, 21 Nov 2005 18:23:28 +0100
Message-ID: <20051121172328.GH15804@suse.de>
References: <20051118163357.GA10928@beardog.cca.cpqcorp.net> <20051118204946.GB25454@suse.de> <20051121082810.GV25454@suse.de> <20051121164648.GA7714@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932370AbVKURZl@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051121164648.GA7714@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hpa@zytor.com, sitniko@infonet.ee
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 21 2005, mikem wrote:
> On Mon, Nov 21, 2005 at 09:28:10AM +0100, Jens Axboe wrote:
> > On Fri, Nov 18 2005, Jens Axboe wrote:
> > > On Fri, Nov 18 2005, mikem wrote:
> > > > Patch 1 of 3
> > > > 
> > > > This patch fixes a bug that breaks hpacucli, a command line interface
> > > > for the HP Array Config Utility. Without this fix the utility will
> > > > not detect any controllers in the system. I thought I had already fixed
> > > > this, but I guess not.
> > > > 
> > > > Thanks to all who reported the issue. Please consider this this inclusion.
> > > 
> > > Lovely, hope this makes it able to configure my drives on the tiger now
> > > :).
> > 
> > This sort-of makes it work. I get some complaints about unaligned access
> > when setting up a test array:
> > 
> > => controller slot=0 create type=logicaldrive drives=all raid=1 drivetype=sas
> > .hpacucli(12458): unaligned access to 0x60000fffffcb370e, ip=0x40000000003c8550
> > => controller slot=0 create type=logicaldrive drives=all raid=1 drivetype=sata
> > .hpacucli(12458): unaligned access to 0x60000fffffcb4aee, ip=0x40000000003c8550
> > .hpacucli(12458): unaligned access to 0x60000fffffcb370e, ip=0x40000000003c8550
> > .hpacucli(12458): unaligned access to 0x60000fffffcb370e, ip=0x40000000003c8550
> 
> This seems to be coming out of user space. We'll work with the application
> folks to investigate. There is a library called infomanager that's used
> by the app. There may be an issue there. Call you strace the program and
> send me the results? I haven't seen this in my lab with a vendor kernel.

Sure I'll try, I'll boot the box again tomorrow.

> > Invoking hpacucli again later on makes it trigger a kobj warning:
> > 
> > Badness in kref_get at lib/kref.c:32
> 
> Hmmm, is this with my put_disk patch installed?

Yep, it's with current git HEAD (so all 3 patches you sent).

-- 
Jens Axboe
