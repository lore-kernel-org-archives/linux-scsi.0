From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Tue, 2 Dec 2003 08:59:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031202085933.A3814@beaverton.ibm.com>
References: <200310231734.10263.krmurthy@cisco.com> <200312011740.09693.krmurthy@cisco.com> <20031201152737.A3853@infradead.org> <200312021122.47416.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:23494 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262425AbTLBRCb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 12:02:31 -0500
Content-Disposition: inline
In-Reply-To: <200312021122.47416.krmurthy@cisco.com>; from krmurthy@cisco.com on Tue, Dec 02, 2003 at 11:22:47AM +0530
List-Id: linux-scsi@vger.kernel.org
To: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Tue, Dec 02, 2003 at 11:22:47AM +0530, N.C.Krishna Murthy wrote:
> Hi,
> 	The iSCSI async message does not provide information about which
> lun(s) got added or deleted. The iSCSI async message only contains
> a  sense data indicating that  "reported luns data" changed.(ASC/ASCQ = 
> 3F/0E). Upon receiving this we would have to do a report luns/inquiry, 
> compare with list of luns which were configured, find out the list of luns 
> which got added or deleted and subsequently use scsi_add_device / 
> scsi_remove_device.
> 
> Doing this in iSCSI driver would duplicated some code from 
> scsi_report_lun_scan/scsi_sequential_scan. 
> 
> Instead if we can have scsi_report_lun_scan and scsi_sequential_scan return
> back a list of luns they configured(includes discovered and already configured 
> luns),  scsi_scan_target can traverse the list of devices on this target and 
> use scsi_remove_device for devices (provided device access count = 0)
> that to do not have an entry in the list. This takes care of both 
> added/deleted luns

That sounds like a good idea, but do not bother with scsi_sequential_scan,
since sparse LUNs usage could cause problems - removing a LUN that still
exists and is in use.

So, the calls to scsi_remove_device would only be triggered via report lun
scanning. 

Their should probably be a different code path and flags/arguments to
conditionally trigger the check and possible removal of LUNs.

And the caller needs to have process context, so we can't just call the
into the code from the mid-layer.

It would be best to trigger a hotplug callout for the event, and let user
land trigger the scan/delete. But, we need early boot time handling or
something else (always rescan with removal via startup scripts?) to handle
LUNs changing while booting.

Code would also need fixing so we always try a report lun scan if the
target exists (code snippet mentioned by James in another post). So if LUN
0 goes away, we still remove devices.

-- Patrick Mansfield
