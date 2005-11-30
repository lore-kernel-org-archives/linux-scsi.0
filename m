From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: Optimize scsi_cmnd initialization and bug fix
Date: Tue, 29 Nov 2005 18:06:45 -0800
Message-ID: <200511300206.jAU26tg05889@unix-os.sc.intel.com>
References: <1133249853.2804.9.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr22.intel.com ([143.183.121.14]:2234 "EHLO
	scsfmr002.sc.intel.com") by vger.kernel.org with ESMTP
	id S1750812AbVK3CH3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 21:07:29 -0500
In-Reply-To: <1133249853.2804.9.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Arjan van de Ven' <arjan@infradead.org>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Arjan van de Ven wrote on Thursday, November 24, 2005 12:06 AM
> actually I question this optimisation. memset uses the rep stosl code
> sequence, which mean that the cpu can avoid write-allocate on the
> cachelines in question, and just plain zero them in cache. If you
> initialize the parts one by one, the cpu will need to do write-allocate
> on the cachelines, and thus has double the memory bandwidth needed than
> the existing case.
> 
> (not sure if all cpus are smart enough to avoid write allocate for rep
> stosl, but most of the newer ones are)

Your earlier email prompt me to double check with hardware architects
whether "rep stosl" has any special cache behavior.  The answer is NO
(at least on all Intel Pentium 4 processors).  It behaves just like
stosl as far as the cache behavior is concerned. On write cache misses,
processor performs a cache line fill, write allocation. Then it writes
the operand into the cache line.


Arjan van de Ven wrote on Monday, November 28, 2005 11:38 PM
> > 30 out of 38 member variables are initialized to non-zero value, about 4
> > are initialized by the LLDD.  Another 4 got written in the I/O return
> > path, though these 4 are sprinkled in the structure.  Even though memset
> > doesn't write-allocate, there are enough code which will bring the cache
> > line into the cpu anyway.  
> 
> but.. it's ALREADY in cache after the memset.... That's the entire point
> of that. You put zeros in the cache without needing to get the
> overwritten-in-a-few-cycles data from ram, but make sure the data is in
> cache so that the next uses of it are really cheap. Eg the only cache
> traffic is writing the data back to ram eventually, which is
> asynchronous. By avoiding the write allocate altogether you avoid 1)
> having to wait for the ram and 2) the memory bandwidth needed for it.
> Both are important, and both are avoided by a memset..

The behavior you described here is not what Intel pentium 4 processor
would do.  So the assumption doesn't apply here.  By removing the memset,
we don't have to execute extra CPU cycles because at later point, a store
will effectively does the same thing.  Why spend the extra cycle to store
two values into the same location?

- Ken

