From: scameron@beardog.cce.hp.com
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Thu, 1 Sep 2011 15:44:19 -0500
Message-ID: <20110901204419.GY8422@beardog.cce.hp.com>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com> <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110901160724.GN9189@beardog.cce.hp.com> <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com> <1314903038.3067.27.camel@dabdike> <20110901125938.7cb1da85@jbarnes-desktop> <20110901200349.GO9189@beardog.cce.hp.com> <20110901130930.5caec2d4@jbarnes-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110901130930.5caec2d4@jbarnes-desktop>
Sender: linux-pci-owner@vger.kernel.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jon Mason <mason@myri.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, linux-pci@vger.kernel.org, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 01, 2011 at 01:09:30PM -0700, Jesse Barnes wrote:
> On Thu, 1 Sep 2011 15:03:49 -0500
> scameron@beardog.cce.hp.com wrote:
> 
> > On Thu, Sep 01, 2011 at 12:59:38PM -0700, Jesse Barnes wrote:
> > > On Thu, 01 Sep 2011 11:50:38 -0700
> > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > 
> > > > On Thu, 2011-09-01 at 10:58 -0700, Roland Dreier wrote:
> > > > > > OK I found the bad commit,I got lucky... I lost some files but my
> > > > > > machine was able to complete the bisection. CC involved people
> > > > > 
> > > > > > # bad: [b03e7495a862b028294f59fc87286d6d78ee7fa1] PCI: Set PCI-E Max Payload Size on fabric
> > > > > 
> > > > > Hi Eric,
> > > > > 
> > > > > I guess it would be useful to see "lspci -vv" output with a "good" kernel
> > > > > and with that bad patch applied.  Most likely we should see some difference
> > > > > somewhere in the MaxPayload fields in the PCI Express capability of
> > > > > some device.
> > > > > 
> > > > > Either the RAID controller or something else lies, and puts a value
> > > > > in the DevCap that it can't actually support, or else the patch is
> > > > > buggy and puts something out of range in a DevCtl somewhere.
> > > > 
> > > > 
> > > > While we investigate, I think the problems produced by the patch (data
> > > > corruption) are serious enough to warrant reverting it, please Jesse.
> > > 
> > > Hm I haven't been paying attention to the compromise thread; how should
> > > I share these changes?  Is master.kernel.org down indefinitely?  Is
> > > there a new server at kernel.org I can use?
> > 
> > I can't answer that question, but I would like a copy of your revert
> > patch(es) to test (as a simple patch --reverse of the original commit on the 3.1-rc4
> > tree didn't go in cleanly).
> 
> Attached is the series.  Applies on top of my for-linus branch.

Thanks.  I tried them out vs. 3.1-rc4, and they applied cleanly and
make things work on my BL460g7.

-- steve
