From: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Tue, 2 Dec 2003 11:22:47 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312021122.47416.krmurthy@cisco.com>
References: <200310231734.10263.krmurthy@cisco.com> <200312011740.09693.krmurthy@cisco.com> <20031201152737.A3853@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:19083 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264284AbTLBFyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2003 00:54:17 -0500
In-Reply-To: <20031201152737.A3853@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

Hi,
	The iSCSI async message does not provide information about which
lun(s) got added or deleted. The iSCSI async message only contains
a  sense data indicating that  "reported luns data" changed.(ASC/ASCQ = 
3F/0E). Upon receiving this we would have to do a report luns/inquiry, 
compare with list of luns which were configured, find out the list of luns 
which got added or deleted and subsequently use scsi_add_device / 
scsi_remove_device.

Doing this in iSCSI driver would duplicated some code from 
scsi_report_lun_scan/scsi_sequential_scan. 

Instead if we can have scsi_report_lun_scan and scsi_sequential_scan return
back a list of luns they configured(includes discovered and already configured 
luns),  scsi_scan_target can traverse the list of devices on this target and 
use scsi_remove_device for devices (provided device access count = 0)
that to do not have an entry in the list. This takes care of both 
added/deleted luns


Please let me know.

Thanx
N.C.Krishna Murthy



On Monday 01 Dec 2003 8:57 pm, Christoph Hellwig wrote:
> On Mon, Dec 01, 2003 at 05:40:09PM +0530, Krishna Murthy wrote:
> > scsi_scan_host_selected is exported.
> >
> > 	iscsi driver does probe for devices at two places
> > a)Once after session establishment.
> > b)Whenever an iSCSI async message indicates a change in
> > "REPORTED LUNS DATA". (addition/deletion of luns on the target)
> >
> > 	There are no issues in calling scsi_scan_host_selected() at a).
> > 	Addition of luns could be handled by calling scsi_scan_host_selected
> > with rescan parameter set to 1.
> > 	Deletion of luns is not handled. scsi_scan_target does not worry about
> > devices which were previously configured, but currently not
> > available.Would you recommend handling this in scsi_scan_target (or a new
> > API) or handle in iSCSI using scsi_request based interfaces?
>
> Case b) could easily use scsi_add_device/scsi_remove_device, couldn't it?
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
