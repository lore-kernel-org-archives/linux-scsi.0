From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: atomic write & T10 standards
Date: Wed, 03 Jul 2013 08:37:09 -0700
Message-ID: <1372865829.3601.41.camel@dabdike>
References: <51D4365C.1030008@redhat.com>
	   <20130703143844.14981.69152@localhost.localdomain>
	   <51D43B87.5090005@redhat.com> <1372863655.3601.19.camel@dabdike>
	  <51D43D6C.6050505@redhat.com> <1372864959.3601.37.camel@dabdike>
	 <51D442DD.8000001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39190 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514Ab3GCPhM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 11:37:12 -0400
In-Reply-To: <51D442DD.8000001@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Mason <clmason@fusionio.com>, "Martin K. Petersen" <mkp@mkp.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2013-07-03 at 11:27 -0400, Ric Wheeler wrote:
> On 07/03/2013 11:22 AM, James Bottomley wrote:
> > On Wed, 2013-07-03 at 11:04 -0400, Ric Wheeler wrote:
> >> Why not have the atomic write actually imply that it is atomic and durable for
> >> just that command?
> > I don't understand why you think you need guaranteed durability for
> > every journal transaction?  That's what causes us performance problems
> > because we have to pause on every transaction commit.
> >
> > We require durability for explicit flushes, obviously, but we could
> > achieve far better performance if we could just let the filesystem
> > updates stream to the disk and rely on atomic writes making sure the
> > journal entries were all correct.  The reason we require durability for
> > journal entries today is to ensure caching effects don't cause the
> > journal to lie or be corrupt.
> 
> Why would we use atomic writes for things that don't need to be
> durable?
> 
> Avoid a torn page write seems to be the only real difference here if
> you use the atomic operations and don't have durability...

It's not just about torn pages: Journal entries are big complex beasts.
They can be megabytes big (at least on xfs).  If we can guarantee all or
nothing atomicity in the entire journal entry write it permits a more
streaming design of the filesystem writeout path.

James
 

