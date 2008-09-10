From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [Open-FCoE] [PATCH 1/3] 24-bit types: typedef and macros for
	accessing 3-byte arrays as integers
Date: Wed, 10 Sep 2008 13:23:51 -0500
Message-ID: <1221071031.27385.21.camel@norville.austin.ibm.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
	 <20080910140712.GA12280@infradead.org>
	 <1221061241.27385.14.camel@norville.austin.ibm.com>
	 <48C7F4EC.1080709@intel.com>  <48C807A9.60509@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754597AbYIJSZn@vger.kernel.org>
In-Reply-To: <48C807A9.60509@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Leech <christopher.leech@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-09-10 at 10:45 -0700, Chris Leech wrote:
> Chris Leech wrote:
> > Dave Kleikamp wrote:
> >> @@ -62,7 +60,7 @@ struct timestruc_t {
> >>   */
> >>  typedef struct {
> >>  	unsigned len:24;
> >> -	unsigned off1:8;
> >> +	u8 off1;
> >>  	u32 off2;
> >>  } lxd_t;
> > 
> > Shouldn't len here be changed to a __le24?  I think this just changed
> > the size of lxd_t by a byte.
> 
> Never mind, I see that it's a host order field.  And presently surprised
> to see that gcc combines the 24-bit bitfield with the following u8.

Right.  I just made a note to throw away this ridiculous structure and
replace it with something sane.  It's only used in-memory and there's no
reason not to have an unsigned long long for offset, and an int for len.
This patch didn't seem to be the right place to fix that though.

-- 
David Kleikamp
IBM Linux Technology Center
