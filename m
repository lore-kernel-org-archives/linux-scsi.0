From: Christoph Hellwig <hch@infradead.org>
Subject: Re: lsscsi-0.09
Date: Fri, 4 Apr 2003 14:03:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030404140323.A25057@infradead.org>
References: <3E8D1D76.7050203@torque.net> <20030404124617.A24518@infradead.org> <3E8D80D1.9070902@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:45068 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263772AbTDDMv6 (for <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2003 07:51:58 -0500
Content-Disposition: inline
In-Reply-To: <3E8D80D1.9070902@torque.net>; from dougg@torque.net on Fri, Apr 04, 2003 at 10:55:45PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 04, 2003 at 10:55:45PM +1000, Douglas Gilbert wrote:
> Christoph,
> The scsi mid level is just another driver (singleton device?)
> so it can have driver parameters in sysfs. If sysfs is going to
> displace writes to /proc/scsi/scsi then some of its rules may
> have to bend (if they haven't already been). The "one parameter
> one file node" rule would make for an ugly replacement of:
>    # echo "scsi add-single-device 1 2 3 4" > /proc/scsi/scsi

This isn't exactly pretty either, but yeah, this is what I meant
with doesn't really fir into sysfs's worldview.

> Actually, scsi_debug's sysfs interface is not far away from
> doing something like that (adding hosts rather than individual
> devices) but I'm not sure the syntax is very clear:
>    # echo 3 > num_tgts
>    # echo 64 > max_luns
>    # echo 2 > add_host    # add 2 hosts, each with 3 targets,
>                           #  each with 64 luns
>    # echo -1 > add_hosts  # remove highest numbered host

This sounds doable but really ugly.  If so we'd need some userland
tool to make the interface similar to the old one (and fall back to
/proc/scsi/scsi/ on kernel <= 2.4).  It might really be time
to have a scsi-tools package for all those little scsi helpers.

