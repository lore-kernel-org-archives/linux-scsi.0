From: Jens Axboe <axboe@suse.de>
Subject: Re: memory leak in scsi_cmd_cache 2.6.15
Date: Sat, 28 Jan 2006 20:27:14 +0100
Message-ID: <20060128192714.GI9750@suse.de>
References: <Pine.LNX.4.62.0601212105590.22868@pureeloreel.qftzy.pbz> <Pine.LNX.4.62.0601222045180.12815@pureeloreel.qftzy.pbz> <1137997104.2977.7.camel@laptopd505.fenrus.org> <200601230029.12674.chase.venters@clientec.com> <Pine.LNX.4.62.0601230136080.22979@pureeloreel.qftzy.pbz> <20060123072556.GC15490@fifty-fifty.audible.transient.net> <Pine.LNX.4.62.0601261312160.1174@pureeloreel.qftzy.pbz> <87ek2td4i9.fsf@amaterasu.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87ek2td4i9.fsf@amaterasu.srvr.nix>
Sender: linux-ide-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Ariel <askernel2615@dsgml.com>, Jamie Heilman <jamie@audible.transient.net>, Chase Venters <chase.venters@clientec.com>, Arjan van de Ven <arjan@infradead.org>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 27 2006, Nix wrote:
> On 26 Jan 2006, Ariel noted:
> > Is this good or bad? I'm guessing it means it's still leaking. So it's
> > really starting to look like ata_piix is the problem. But we need someone
> > who has the leak to remove that and see if it helps. I can't, since my
> > drives are connected to it.
> 
> FWIW, a bit of negative-confirmatory evidence: I have a sym53c875
> and non-SATA IDE drive on this 2.6.15.1, and there is no leak,
> nor was there in 2.6.15:
> 
>     11     11 100%    0.34K      1       11         4K scsi_cmd_cache

It's not a bad data point, it just confirms that setting ->ordered_flush
to 0 in the SATA drivers will fix the leak. So really, it's as expected.
So far apparently nobody tried it, suggested it twice.

-- 
Jens Axboe

