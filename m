From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Fri, 13 Dec 2002 14:37:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1018380000.1039815430@aslan.btc.adaptec.com>
References: <hch@infradead.org>
 <200212101602.gBAG2Hi02930@localhost.localdomain>
 <20021211135855.A19325@infradead.org>
 <1266570000.1039619906@aslan.scsiguy.com>
 <20021211153935.A23704@infradead.org>
 <1221760000.1039627865@aslan.btc.adaptec.com>
 <20021211181745.A30253@infradead.org> <20021212202052.GC8842@redhat.com>
 <20021213210215.A15074@infradead.org> <20021213212352.GA10883@redhat.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021213212352.GA10883@redhat.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

> On Fri, Dec 13, 2002 at 09:02:15PM +0000, Christoph Hellwig wrote:
>> On Thu, Dec 12, 2002 at 03:20:52PM -0500, Doug Ledford wrote:
>> > On Wed, Dec 11, 2002 at 06:17:46PM +0000, Christoph Hellwig wrote:
>> > > 
>> > > Yupp, it currently crashes when I have both compiled in.  Dough, any
>> > > chance you could fix that?  A PCI driver is not supposed to stop
>> > > over already claimed device.
>> > 
>> > If you've got a test machine, the attached patch would I think fix the 
>> > problem.  Let me know if it does in fact work for you and I'll commit
>> > it  to the tree.
>> 
>> Still doesn't work.  I think you really need to set and check the driver
>> field like justin suggested.
> 
> Hmmm...what's the failure mode here?

I haven't tested it locally yet, so I'm not sure.  My concern was that
the PCI subsystem would simply not know that your driver had attached
which could lead to a second attach playing with BARs or other configuration
space stuff before the aic7xxx driver even tries to map registers.
This doesn't occur in the non-PCI case, so the request region stuff is
probably sufficient there.

--
Justin
