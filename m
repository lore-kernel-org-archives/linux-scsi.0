From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what'smissing?
Date: Fri, 27 Jan 2012 09:24:28 +1100
Message-ID: <20120126222428.GX15102@dastard>
References: <1326113987.2580.8.camel@localhost.localdomain>
 <D3F292ADF945FB49B35E96C94C2061B9159134BD@nsmail.netscout.com>
 <4F18429C.3020803@redhat.com>
 <D3F292ADF945FB49B35E96C94C2061B9159134EF@nsmail.netscout.com>
 <4F1844F0.1030406@redhat.com>
 <D3F292ADF945FB49B35E96C94C2061B9159135BF@nsmail.netscout.com>
 <4F18566A.2060107@redhat.com>
 <D3F292ADF945FB49B35E96C94C2061B915913815@nsmail.netscout.com>
 <4F188DA9.3050804@redhat.com>
 <D3F292ADF945FB49B35E96C94C2061B9159D00EC@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B9159D00EC@nsmail.netscout.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Tom Coughlan <coughlan@redhat.com>, Hannes Reinecke <hare@suse.de>, tasleson@redhat.com, Shyam_Iyer@Dell.com, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2012 at 12:05:23PM -0500, Loke, Chetan wrote:
> > > But writes that have to fetch the non-cached data, will
> unnecessarily
> > > issue I/O to the fabric. These orphaned I/O's cause more pain in the
> > > cleanup.
> > > And if caching is enabled on the front-side then it's all the more
> > > painful.
> > >
> > > We can go one extra step and make FS fail read I/O for non-cached
> data
> > > too to avoid more orphan IOs.
> > 
> > I don't really see this as a useful state. Read-only without a real
> > backing file
> > system or LUN is hit or miss, that file system should go offline :)
> > 
> 
> Last year when I checked, I forget but I think xfs(or ext4) was going
> read-only.
> If this is still the case then you are basically asking FS's to modify
> that behavior.

ext4 goes read only on erro by default. I think that behaviour can
be changed by a mount option.

XFS shuts the filesystem down (takes it offline) preventing all
dirty data and metadata from being issued to disk, aborts any
journal IO that might be going on, etc. It the returns fatal errors
(EIO or EUCLEAN "structure needs cleaning" errors) to all callers
that attempt to write or modify the filesystem, and EIO to all
attempts to read from it.

IOWs, the XFS filesystem is *gone* once it shuts down and requires
administrator intervention to get it back to a working state....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
