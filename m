From: Oliver Xymoron <oxymoron@waste.org>
Subject: Re: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 23:09:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118050939.GC20171@waste.org>
References: <200211172237.gAHMbF99022232@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211172237.gAHMbF99022232@leviathan.ele.uri.edu>
List-Id: linux-scsi@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Doug Ledford <dledford@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 05:35:52PM -0500, Ming Zhang wrote:
> For example, like the iSCSI target code, when it start, it should
> find all SCSI disks or tapes link in order to export to client side.

No it shouldn't! What if one of them happens to be your boot device?
You'll want to be able to configure from userspace exactly which
devices are available, as well as what authentication they require,
etc.

In fact, I'd recommend running all of the iSCSI target negotiation in
userspace and only push down sockets that have established sessions to the
kernel if you find that you need to for performance. You probably
don't need to.

Further, I'd recommend supporting block devices other than SCSI and
files (similar to the loopback block device) otherwise you're missing
most of the point of using Linux as an iSCSI target. I want to serve
my diskless Beowulf nodes via iSCSI with LVM over RAID5 on IDE disks
and have web manageable storage at a tenth of the cost of SCSI/FC.
Building a cheaper SCSI JBOD is boring.

-- 
 "Love the dolphins," she advised him. "Write by W.A.S.T.E.." 
