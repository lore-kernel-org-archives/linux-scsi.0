From: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and
	macros	for	accessing	3-byte arrays as integers
Date: Wed, 10 Sep 2008 14:20:09 -0500
Message-ID: <1221074409.27385.39.camel@norville.austin.ibm.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
	<20080910140712.GA12280@infradead.org>
	<1221061241.27385.14.camel@norville.austin.ibm.com>
	<48C7F19D.3080507@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <48C7F19D.3080507-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-09-10 at 19:11 +0300, Boaz Harrosh wrote:
> Dave Kleikamp wrote:

> > @@ -62,7 +60,7 @@ struct timestruc_t {
> >   */
> >  typedef struct {
> >  	unsigned len:24;
> > -	unsigned off1:8;
> > +	u8 off1;
> >  	u32 off2;
> >  } lxd_t;
> >  
> 
> Why is the difference from below definition. That is the
> use/not of __le24? 

Answered elsewhere, but this is host-endian.  I plan to kill this
structure soon.

> > @@ -90,8 +88,8 @@ struct lxdlist {
> >   *	physical xd (pxd)
> >   */
> >  typedef struct {
> > -	unsigned len:24;
> > -	unsigned addr1:8;
> > +	__le24 len;
> 
> Is this stuff on-the-wire?

Written to disk, so basically, yeah.

> Do you need a:
> +	__le24 len __packed;
> 
> > +	u8 addr1;
> >  	__le32 addr2;
> >  } pxd_t;
> and:
>   } pxd_t __packed ;

I'm not convinced that this is needed.  Does the compiler do any padding
for alignment when it only contains char types (or structs of chars)?

> 
> Note that before the :24 bit-field was kept packed but now
> with the use of struct at the __le24 definition it might
> choose to pad them.

Maybe, but I can't get the compiler to add any padding playing around
with variants of these structures.  I've tested a simple program on both
x86 and ppc64, but I'm not sure what would happen on, say, arm.

> Chris you might want to change the definitions at linux/types.h
> to:
> 
> typedef struct { __u8 b[3]; } __be24, __le24 __packed;
> 
> With gcc it will not help with the proceeding fields, and the
> containing struct will need it's own "__packed" declaration
> but it will keep it packed with previous fields.
>
> Just my $0.017
> Boaz

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
