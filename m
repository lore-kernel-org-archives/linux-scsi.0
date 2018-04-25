From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: simplify procfs code for seq_file instances
Date: Thu, 26 Apr 2018 00:24:11 +0300
Message-ID: <20180425212411.GB9020@avx2>
References: <20180419124140.9309-1-hch@lst.de> <20180419185750.GD2066@avx2>
 <20180424142304.GE26136@lst.de>
 <20180424081916.e94ca8463fb3c39ebc082bdd@linux-foundation.org>
 <20180424160652.GA28483@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20180424160652.GA28483@lst.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rtc@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Corey Minyard <minyard@acm.org>, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, megaraidlinux.pdl@broadcom.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 24, 2018 at 06:06:53PM +0200, Christoph Hellwig wrote:
> On Tue, Apr 24, 2018 at 08:19:16AM -0700, Andrew Morton wrote:
> > > > I want to ask if it is time to start using poorman function overloading
> > > > with _b_c_e(). There are millions of allocation functions for example,
> > > > all slightly difference, and people will add more. Seeing /proc interfaces
> > > > doubled like this is painful.
> > > 
> > > Function overloading is totally unacceptable.
> > > 
> > > And I very much disagree with a tradeoff that keeps 5000 lines of 
> > > code vs a few new helpers.
> > 
> > OK, the curiosity and suspense are killing me.  What the heck is
> > "function overloading with _b_c_e()"?
> 
> The way I understood Alexey was to use have a proc_create macro
> that can take different ops types.  Although the short cut for
> __builtin_types_compatible_p would be _b_t_c or similar, so maybe
> I misunderstood him.

That's correct.

I also think that several dozens kmalloc signatures are a problem.

And there will be more with pmalloc* stuff and more 2D/3D array
checked allocations and who knows what.
And I want to add typed kmalloc!
