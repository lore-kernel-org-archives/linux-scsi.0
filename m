From: Willem Riede <wrlk@riede.org>
Subject: Re: [patches] rq_dev removal
Date: Thu, 31 Oct 2002 18:18:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031231801.GE13860@linnie.riede.org>
References: <Pine.GSO.4.21.0210311715330.16688-100000@weyl.math.psu.edu>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.21.0210311715330.16688-100000@weyl.math.psu.edu>; from viro@math.psu.edu on Thu, Oct 31, 2002 at 17:43:19 -0500
List-Id: linux-scsi@vger.kernel.org
To: Alexander Viro <viro@math.psu.edu>
Cc: linux-scsi@vger.kernel.org

On 2002.10.31 17:43 Alexander Viro wrote:
> 	Folks, ->rq_dev is going away in 2.5 RSN.  The only non-trivial
> remaining uses were in SCSI (scsi_lib.c::scsi_get_request_dev() and
> uses in st.c, osst.c and sg.c to identify a device).
> 
> 	Series of patches on ftp.math.psu.edu/pub/viro/P/P*-C45 deals
> with that stuff and removes most of the uses of minor() in there.  Please,
> review it.

I reviewed the changes to osst (which I maintain).

[snip]
> 	* sd.c and sr.c got a pointer to Scsi_Device_Template in
> scsi_disk and scsi_cd resp.  That pointer is initialized to &s{d,r}_template.
> disk->private_data points to that field (instead of entire scsi_disk/scsi_cd)
> and old uses of disk->private_data are updated to compensate.
> 	* st.c, osst.c and sg.c got gendisks allocated, but not registered.

How appropriate is it, to have something called '*disk' in a tape driver?
I assume that at least the data in it is valid for this type of driver?

> Places that set ->rq_dev set ->rq_disk as well.  Scsi_Tape and friends
> got a pointer to Scsi_Device_Template (similar to sd/sr above) and
> ->private_data is set in similar fashion.  Users of ->rq_dev are using
> ->rq_disk->private_data now.
> 
> 	* Now we can deal with scsi_get_request_dev().  Indeed, all places
> that set ->rq_dev set ->rq_disk, and we are guaranteed that either
> 	+ ->rq_disk is NULL and ->rq_dev is 0
> or
> 	+ ->rq_disk is non-NULL and
>  *(struct Scsi_Device_Template **)rq->rq_disk->private_data
> 	  is the address of template in question.
> 
> In other words, scsi_get_request_dev() is two-liner now:
> 
> 	struct gendisk *p = req->rq_disk;
> 	return p ? *(struct Scsi_Device_Template **)p->private_data : NULL;
> 
> and ->max_major, ->min_major and ->major from Scsi_Device_Template are
> not used anymore (and thus can die).
> 
> 
> 	Please, review.  If somebody has objections - yell, otherwise this
> stuff goes to Linus tomorrow.  Interesting things are in the small patches
> - huge pair in the beginning of series is tape_name() stuff, i.e. purely
> mechanical work.

I don't object (providing it works, which I expect it does). I am working to
adapt osst for 2.5.x to some other changes, and will incorporate your patches
in that WIP too.

Thanks, Willem Riede.
