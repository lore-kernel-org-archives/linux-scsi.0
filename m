From: Alexander Viro <viro@math.psu.edu>
Subject: Re: Several Misc SCSI updates...
Date: Sun, 17 Nov 2002 16:55:26 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0211171653391.23400-100000@steklov.math.psu.edu>
References: <Pine.LNX.4.44.0211171338570.12975-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0211171338570.12975-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Doug Ledford <dledford@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Scsi Mailing List <linux-scsi@vger.kernel.org>



On Sun, 17 Nov 2002, Linus Torvalds wrote:

> 
> On Sun, 17 Nov 2002, Doug Ledford wrote:
> > 
> > Won't work.  module->live is what Rusty uses to indicate that the module 
> > is in the process of unloading, which is when we *do* want the attempt to 
> > module_get() to fail.
> 
> That's fine, as long as "module_get()" is the only thing that cares. Just 
> make it go "live" early as you indicate, and everybody should be happy. I 
> certainly agree that it should be illegal to do more module_get()'s once 
> we've already started unloading..

On the unload side it's OK.  module_get() also breaks during _init_ and that's
the problem.  IOW, you'll need to make every block device driver to set ->live
manually.  Smells like a wrong API...

