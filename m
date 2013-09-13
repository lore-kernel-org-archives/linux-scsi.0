From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/4] Hyper-V TRIM support
Date: Fri, 13 Sep 2013 11:40:47 -0400
Message-ID: <523331FF.40609@interlog.com>
References: <1379077109-29606-1-git-send-email-apw@canonical.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53093 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403Ab3IMPlA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Sep 2013 11:41:00 -0400
In-Reply-To: <1379077109-29606-1-git-send-email-apw@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Ben Howard <ben.howard@canonical.com>, linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org

On 13-09-13 08:58 AM, Andy Whitcroft wrote:
> tl;dr -- enable TRIM support for Hyper-V emulated disks.
>
> The Hyper-V hypervisor can support TRIM for its devices, advertising this
> via the appropriate VPD pages.  However the emulated disks only claim
> to be SPC-2 devices.  According to the specs VPD pages (in general) did
> exist at SPC-2 but the specific pages we interogate for the TRIM support

VPD pages are found in SPC (ANSI INCITS 301-1997) and many of its
drafts. By SPC-2 (ANSI INCITS 351-2001) the "supported VPD pages"
VPD page (0x0) ** and the "device identification" VPD page (0x83)
were mandatory (in SPC those pages were optional). So that is
approaching 20 years for manufacturers to get used to VPD pages.

TRIM is a T13 term (ATA/SATA) that was introduced after 2001
(i.e. after SBC-2). The corresponding SCSI term is now
"Logical Block Provisioning" (LBP). This covers the SCSI
UNMAP command (closest thing to TRIM) and the SCSI WRITE SAME
command which contains LBP options.

LBP capability was originally reported in the SCSI READ
CAPACITY(16) command (but not the more common READ
CAPACITY(10) command); namely the LBPME and LBPRZ bits. Those
bits have been renamed *** during the lifetime of SBC-3 drafts.
Those bits and a lot of additional LBP information are now
found in two VPD pages: "Block Limits" (0xb0) and "Logical
Block Provisioning" (0xb2).


After a 36 byte standard INQUIRY response, unless the
compliance is stone age (e.g. SCSI-2 or earlier) then
a 36 byte INQUIRY with the EVPD bit set and page=0
should be pretty safe. Check the response carefully
as USB devices will often ignore the EVPD bit and respond
with a standard INQUIRY response. Forget any such devices.
Now look for either of those LBP supporting VPD pages.
There should not be too many devices that support neither
and do LBP.

Doug Gilbert


**  some vendors do not include their own vendor specific VPD
     pages in the "Supported VPD pages" VPD page. Grrr

*** those bits were previously named TPE and TPRZ

> did not until SPC-3 therefore the kernel avoids reading the relevant pages
> for SPC-2 devices and prevents TRIM from being offered for these devices.
> Additionally at SPC-2 we prefer ReadCapacity10 over ReadCapacity16 and
> unless we use RC16 we will not identify the device as TRIM capable also
> preventing TRIM being offered.
>
> As the VPD page zero does list which pages are valid for each device, it
> could be argued that we could simply attempt to use these pages for all
> devices which claim to be SPC-2 and above.  While this seems valid the
> code documents a number of devices which take badly to having even VPD
> page 0 interogated even when supposedly supported.  Therefore it seems
> appropriate to add a scsi device flag to allow a device to request SPC-3
> VPD pages be used when only at SPC-2.
>
> Similarly for the ReadCapacity selection it seems dangerous to invert
> the order for all SPC-2 devices.  So it seems appropriate to add a scsi
> device flag to request we try RC16 before RC10 (mirroring the existing
> flag for the opposite).
>
> The following four patches add the two scsi device flags and select those
> flags for the Hyper-V emulated disks.





