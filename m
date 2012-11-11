From: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Subject: Re: [PATCH] USB enclosures seem to require read(16) with >2TB
 drives
Date: Sun, 11 Nov 2012 12:17:36 +0100
Message-ID: <20121111121736.5672b762@stein>
References: <1352477289-8133-1-git-send-email-hernejj@gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40294C344C61@G1W3652.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40294C344C61-NSOR0jG+XgMSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Elliott, Robert (Server Storage)" <Elliott-VXdhtT5mjnY@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jason J. Herne" <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Nov 09 Elliott, Robert (Server Storage) wrote:
> I recommend broadening this patch.  T10 is discussing making READ (10), WRITE (10), etc. obsolete in SBC-4 in favor of their 16-byte CDB counterparts.  
> 
> The algorithm should be:
> 1. During discovery, determine if 16-byte CDBs are supported.  There are several ways to determine this:
> a) REPORT SUPPORTED OPERATION CODES command succeeds and reports that READ (16) et al are supported.
> b) READ (16) command specifying a Transfer Length of zero succeeds.
> c) READ CAPACITY (16) command succeeds and reports that the capacity is > 2 TiB.
> d) (future) INQUIRY command succeeds fetching the Block Device Characteristics VPD page and notices a new field added by the SBC-4 simplified SCSI feature set proposal.
> 
> Since REPORT SUPPORTED OPERATION CODES is optional, it won't always work. READ CAPACITY (16) used to be optional for < 2 TiB drives, so it won't always work either. READ (16) will always work, but requires the drive to be spun up beforehand (e.g., with START STOP UNIT).

This won't work.  It will crash badly written device firmwares.

Instead, try the (10) commands on the SBC-4 device and let it respond that
it does not implement these commands.  Or have other means to be certain of
SBC-4 compliance without issuing commands that were optional in or not
defined by earlier revisions of the spec.  I wonder whether testing for
INQUIRY_data.VERSION >= something is a sufficiently safe test.

> 2. if 16-byte CDBs are supported, then use them; only drop down to 10-byte CDBs if 16-byte CDBs are unavailable.  Don't make the decision by comparing the LBA on every IO.

-- 
Stefan Richter
-=====-===-- =-== -=-==
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
