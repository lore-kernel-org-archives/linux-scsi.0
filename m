From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Fri, 14 Feb 2003 08:38:57 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030214083857.A25020@beaverton.ibm.com>
References: <3E495862.3050709@splentec.com> <20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com> <20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com> <20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com> <20030213154748.A1965@infradead.org> <3E4BEA13.50402@splentec.com> <20030213192440.A6660@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030213192440.A6660@redhat.com>; from dledford@redhat.com on Thu, Feb 13, 2003 at 07:24:40PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>, Christoph Hellwig <hch@infradead.org>, Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

On Thu, Feb 13, 2003 at 07:24:40PM -0500, Doug Ledford wrote:
> On Thu, Feb 13, 2003 at 01:55:15PM -0500, Luben Tuikov wrote:
> > 	::same_target_siblings -- this shouldn't exist by design.
> 
> Yes!  That one most certainly should exist!  There are lots of operations 
> in the scsi protocol that are target specific instead of lun specific and 

And it would be nice if each scsi_device pointed to a parent struct
scsi_target that grouped all per-target information - like (as you
mentioned) active_cmd_count_target, *lld_target_data, and other target
specific data that is now stored in scsi_device.

This might aid in probe/scanning for transports (like FCP) that can figure
out a target is there without scanning: a representation of the target can
show up without any scsi_device, and then we scan those targets.

It also gives a better representation (under sysfs) of the physical layout
of the devices.

-- Patrick Mansfield
