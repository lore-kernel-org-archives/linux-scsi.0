From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [RESEND] aic7xxx: replace kmalloc/memset by kzalloc
Date: Tue, 24 Mar 2015 13:57:02 -0700
Message-ID: <1427230622.12126.13.camel@perches.com>
References: <94D0CD8314A33A4D9D801C0FE68B40295930E577@G4W3296.americas.hpqcorp.net>
	 <1427041891-2694-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <550FB9BE.5010801@suse.de> <5511CD10.6040709@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5511CD10.6040709@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Hannes Reinecke <hare@suse.de>, JBottomley@parallels.com, Elliott@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-03-24 at 13:46 -0700, Michael Opdenacker wrote:
> Hi,
> 
> On 03/22/2015 11:59 PM, Hannes Reinecke wrote:
> > On 03/22/2015 05:31 PM, Michael Opdenacker wrote:
> >> This replaces kmalloc + memset by a call to kzalloc
> >> (or kcalloc when appropriate, which zeroes memory too)
> >>
> >> This also fixes one checkpatch.pl issue in the process.
> >>
> >> This improvement was suggested by "make coccicheck"
> >>
> >> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> 
> I'm sending a version that reverts the use of kcalloc() instead of
> kzalloc(). For reasons I don't understand, I didn't see the end of
> Robert Elliott's comment that the use of kcalloc() could prevent the
> compiler from detecting an overflow.

I'm confused.  I don't see that comment either, but
the entire point of kcalloc is to prevent overflows
by returning NULL when an overflow might occur.

from include/linux/slab.h:

/**
 * kmalloc_array - allocate memory for an array.
 * @n: number of elements.
 * @size: element size.
 * @flags: the type of memory to allocate (see kmalloc).
 */
static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
{
	if (size != 0 && n > SIZE_MAX / size)
		return NULL;
	return __kmalloc(n * size, flags);
}

/**
 * kcalloc - allocate memory for an array. The memory is set to zero.
 * @n: number of elements.
 * @size: element size.
 * @flags: the type of memory to allocate (see kmalloc).
 */
static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
{
	return kmalloc_array(n, size, flags | __GFP_ZERO);
}
