From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: copy offload support in Linux - new system call needed?
Date: Wed, 14 Dec 2011 17:27:23 -0500
Message-ID: <20111214222723.GD7623@fieldses.org>
References: <4EE8F75F.6070800@gmail.com>
 <20111214192739.GN2203@ZenIV.linux.org.uk>
 <4EE8FC2E.3010207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4EE8FC2E.3010207-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 14, 2011 at 02:42:38PM -0500, Ric Wheeler wrote:
> On 12/14/2011 02:27 PM, Al Viro wrote:
> >On Wed, Dec 14, 2011 at 02:22:07PM -0500, Ric Wheeler wrote:
> >
> >>We had an active thread a couple of years back that came out of the
> >>reflink work and, at the time, there seemed to be moderately
> >>positive support for adding a new system call that would fit this
> >>use case (Joel Becker's copyfile()).
> >>
> >>Can we resurrect this effort? Is copyfile() still a good way to go,
> >>or should we look at other hooks?
> >copyfile(2) is probably a good way to go, provided that we do _not_
> >go baroque as it had happened the last time syscall had been discussed.
> >
> >IOW, to hell with progress reports, etc. - just a fastpath kind of
> >thing, in the same kind of relationship to cp(1) as rename(2) is to mv(1).
> >If it works - fine, if not - caller has to be ready to deal with handling
> >cross-device case anyway.
> 
> I think that this approach makes a lot of sense. Most of the
> devices/targets that support the copy offload, will do it in very
> reasonable amounts of time.

The current NFSv4.2 draft rolls both the "fast" and "slow" cases into
one operation:

	http://tools.ietf.org/html/draft-ietf-nfsv4-minorversion2-06#section-2
 
Perhaps we should ask for separate operations for the two cases.  (Or at
least a "please don't bother if this is going to take 8 hours" flag....)

--b.

> 
> Let me see if I can dig up some of the presentations from the NetApp
> guys who presented overviews or the specifications from the IETF and
> T10....
> 
> Ric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
