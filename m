From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Mon, 12 Jan 2009 22:48:06 +0000
Message-ID: <20090112224806.GB26430@shareable.org>
References: <4947BFAA.4030208@panasas.com> <4947CA5C.50104@panasas.com> <20081229121423.efde9d06.akpm@linux-foundation.org> <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain> <4960D3CA.2000202@panasas.com> <1231783926.3256.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1231783926.3256.29.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>, Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>, open-osd development <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Um, your submission path is character.  You pick up block again because
> SCSI uses it for queues, but it's not really part of your paradigm.

> I think your choice of using a character device will turn out to be a
> design mistake because the migration path of existing filesystems is
> bound to be a block device with extra features (which they may or may
> not make use of) but only if there's a way to make ODS relevant to
> users.

We mount character devices already when it's appropriate.

Look at JFFS, JFFS2, UBIFS and LOGFS.  All of them operate on MTD
devices, which are character device interfaces to flash storage, using
the common MTD interface instead of the block layer.

This is quite correct, because block devices have specific
characteristics (generic block caching and ability to read/write each
block independently) which neither flash nor OSDs have.

Imho, OSDs are similar to flash in this respected.  There is no
fixed-size block/sector indexed storage device, therefore a block
device would be wrong.

Admittedly lumping everything else under "character" is daft, when you
can't read and write character streams to the device, but that's unix
for you.  Character device used to mean serial ports etc. until it
become "any old crap that's not a block device". :-)

-- Jamie
