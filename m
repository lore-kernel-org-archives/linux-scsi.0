From: Jens Axboe <axboe@suse.de>
Subject: Re: sg driver and Fedora Core 2
Date: Fri, 28 May 2004 16:18:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040528141854.GJ20657@suse.de>
References: <40B74725.90403@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:61896 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263182AbUE1OTD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 10:19:03 -0400
Content-Disposition: inline
In-Reply-To: <40B74725.90403@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, alan@redhat.com

On Sat, May 29 2004, Douglas Gilbert wrote:
> Recently I have had a query about how a specialist application
> (that worked in the lk 2.4 series) sends 16 MB data through a
> single SCSI command in Fedora Core 2. The simple answer to that
> one is the block layer imposes a 128 KB limit on single
> transfers and that's it. [Counter-intuitively that limit also
> applies to st and osst when they use the SG_IO ioctl.] Around a
> year ago I tried to move Jens Axboe on this issue and failed.
> Evidentally there are good reasons why the block layer imposes
> that limit. There are other issues with this change.

The block layer does not impose any 128KB limitation. In fact there
should be no real limitations (*). The block layer honors whatever
restrictions that the drivers sets, 128KB is the maximum transfer size
for an ATAPI drive for instance.

You could flag queue capability to handle requests > max_sectors like
SCSI has always been able to. Then you could change this check

        if (hdr->dxfer_len > (q->max_sectors << 9))
                return -EIO;

to only fail for drivers that can't partially complete requests
correctly. This would allow such applications to continue working.

(*) Not quite true, since the max size of a bio is 1MB on 4KB page sized
    hardware. You can string them for bigger total size, though.
> 
> There seems to be mixed signals coming from the Fedora camp
> on this change. A "policy" change was one response and this
> url ( http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=123876 )
> has Alan Cox stating that this change is a bug.

That's not the identical issue, it's due to usb storage setting 120KB as
the max size causing sg_set_reserved_size() to fail.

-- 
Jens Axboe

