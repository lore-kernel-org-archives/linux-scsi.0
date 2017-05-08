From: Richard Weinberger <richard@nod.at>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 14:13:27 +0200
Message-ID: <060a0bf0-cab2-0164-3a57-e8202986d1ac@nod.at>
References: <20170410232118.GA4816@khazad-dum.debian.net>
 <20170410235206.GA28603@wtj.duckdns.org>
 <20170507204007.GA25628@atrey.karlin.mff.cuni.cz>
 <1494228094.6528.14.camel@infradead.org> <20170508092846.GA11029@amd>
 <1494236048.6528.32.camel@infradead.org> <20170508104953.GA17773@amd>
 <CAFLxGvzAmURHU_6K3gmBfOqHKgvQOkkO_+qgMKsmzhWZwwGnqw@mail.gmail.com>
 <20170508134807.498b3ee7@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170508134807.498b3ee7@bbrezillon>
Sender: linux-ide-owner@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Pavel Machek <pavel@ucw.cz>, David Woodhouse <dwmw2@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Boris,

Am 08.05.2017 um 13:48 schrieb Boris Brezillon:
>>> How do you handle the issue during regular write? Always ignore last
>>> successfully written block?  
> 
> I guess UBIFS can know what was written last, because of the log-based
> approach + the seqnum stored along with FS nodes, but I'm pretty sure
> UBIFS does not re-write the last written block in case of an unclean
> mount. Richard, am I wrong?

Yes. UBIFS has the machinery but uses it differently. When it faces ECC
errors while replying the journal it can recover good data from the LEB.
It assumes that an interrupted write leads always to ECC errors.

>>
>> The last page of a block is inspected and allowed to be corrupted.
> 
> Actually, it's not really about corrupted pages, it's about pages that
> might become unreadable after a few reads.

As stated before, it assumes an ECC error from an interrupted read.

We could automatically re-write everything in UBIFS that was written last
but we don't have this information for data UBI itself wrote since UBI has
no journal.

If unstable bit can be triggered with current systems we can think of a clever
trick to deal with that. So far nobody was able to show me the problem.

Thanks,
//richard
