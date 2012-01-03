From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [LSF/MM TOPIC][ATTEND] linux servers as a storage server -
 what's missing?
Date: Tue, 3 Jan 2012 14:26:09 -0500
Message-ID: <20120103142609.2b4d06cb@tlielax.poochiereds.net>
References: <4EF2026F.2090506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EF2026F.2090506@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 21 Dec 2011 10:59:43 -0500
Ric Wheeler <rwheeler@redhat.com> wrote:

> 
> One common thing that I see a lot of these days is an increasing number of 
> platforms that are built on our stack as storage servers. Ranging from the 
> common linux based storage/NAS devices up to various distributed systems.  
> Almost all of them use our common stack - software RAID, LVM, XFS/ext4 and samba.
> 
> At last year's SNIA developers conference, it was clear that Microsoft is 
> putting a lot of effort into enhancing windows 8 server as a storage server with 
> both support for a pNFS server and of course SMB. I think that linux (+samba) is 
> ahead of the windows based storage appliances today, but they are putting 
> together a very aggressive list of features.
> 
> I think that it would be useful and interesting to take a slot at this year's 
> LSF to see how we are doing in this space. How large do we need to scale for an 
> appliance?  What kind of work is needed (support for the copy offload system 
> call? better support for out of band notifications like those used in "thinly 
> provisioned" SCSI devices? management API's? Ease of use CLI work? SMB2.2 support?).
> 
> The goal would be to see what technical gaps we have that need more active 
> development in, not just a wish list :)
> 
> Ric

Unfortunately, w/o a wishlist of sorts, it's hard to know what needs
more active development ;).

While HCH will probably disagree, being able to support more
NFSv4/Windows API features at the VFS layer would make it a lot easier
to do a more unified serving appliance. Right now, both knfsd and samba
track too much info internally, and that makes it very difficult to
serve the same data via multiple protocols.

Off the top of my head, my "wishlist" for better NFSv4 serving would be:

- RichACLs
- Share/Deny mode support on open
- mandatory locking that doesn't rely on weirdo file modes

It's always going to be hard for us to compete with dedicated
appliances. Where Linux can shine though is in allowing for more
innovative combinations.

Being able to do active/active NFS serving from clustered filesystems,
for instance is something that we can eventually attain but that would
be harder to do in an appliance. This sort of discussion might also
dovetail with Benny's proposal about pNFS serving.

-- 
Jeff Layton <jlayton@redhat.com>
