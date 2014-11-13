From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Thu, 13 Nov 2014 09:54:02 -0800
Message-ID: <20141113175402.GA27327@infradead.org>
References: <54629CAE.2000207@laposte.net>
 <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com>
 <5462CB90.1080303@roeck-us.net>
 <54642541.9080302@laposte.net>
 <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net>
 <54647C10.4070506@laposte.net>
 <20141113142907.GB29354@infradead.org>
 <5464E6E6.3090606@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5464E6E6.3090606@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Barto <mister.freeman@laposte.net>
Cc: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, Bjorn Helgaas <bhelgaas@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 13, 2014 at 06:14:14PM +0100, Barto wrote:
> Hello Christoph,
> 
> I tested this commit :
> 
> 7ae65c0f9646c29432b69580b80e08632e6cd813 scsi: convert target_busy to an
> atomic_t
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=7ae65c0f9646c29432b69580b80e08632e6cd813
> 
> there is no bug, boot process is ok whit this commit,
> 
> when I did the "git bisect" the first bad commit was Guenters' commit (
> 045065d8a300a37218c548e9aa7becd581c6a0e8 ), it seems that all commits
> before 045065d8a300a37218c548e9aa7becd581c6a0e8 are ok,

The bisect isn't quite interesting here as we're trying to find the real
root ause.

045065d8a300a37218c548e9aa7becd581c6a0e8 reverts the polarity of the
check that 71e75c97f97a9645d25fbf3d8e4165a558f18747 incorrectly
chaged.

The behavior you see doesn't make a lot of sense from a high level view,
so we need to find out what's going on.

When you say all commits before 045065d8a300a37218c548e9aa7becd581c6a0e8
I wonder if the bisect simply skiped to many revisions.

Please explicitly test commits:

71e75c97f97a9645d25fbf3d8e4165a558f18747

and

74665016086615bbaa3fa6f83af410a0a4e029ee

Thanks!
