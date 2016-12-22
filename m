From: Christoph Hellwig <hch@lst.de>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
        iscsi_tcp_segment_done+0x20d/0x2e0
Date: Thu, 22 Dec 2016 07:18:27 +0100
Message-ID: <20161222061827.GA31630@lst.de>
References: <20161214222411.GH4326@dastard> <20161214222953.GI4326@dastard> <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org> <20161221221638.GD4758@dastard> <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Chris Leech <cleech@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 21, 2016 at 03:19:15PM -0800, Linus Torvalds wrote:
> Looking around a bit, the only even halfway suspicious scatterlist
> initialization thing I see is commit f9d03f96b988 ("block: improve
> handling of the magic discard payload") which used to have a magic
> hack wrt !bio->bi_vcnt, and that got removed. See __blk_bios_map_sg(),
> now it does __blk_bvec_map_sg() instead.

But that check was only for discard (and discard-like) bios which
had the maic single page that sometimes was unused attached.

For "normal" bios the for_each_segment loop iterates over bi_vcnt,
so it will be ignored anyway.  That being said both I and the lists
got CCed halfway through the thread and I haven't seen the original
report, so I'm not really sure what's going on here anyway.
