From: "Scott M. Ferris" <sferris@acm.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 10 Dec 2003 10:50:42 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031210165042.ABC605DC7E@bambi.visi.com>
References: <200312102031.04680.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from conn.mc.mpls.visi.com ([208.42.156.2]:22686 "EHLO
	conn.mc.mpls.visi.com") by vger.kernel.org with ESMTP
	id S263758AbTLJQuo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2003 11:50:44 -0500
In-Reply-To: <200312102031.04680.krmurthy@cisco.com> from "N.C.Krishna Murthy"
 at "Dec 10, 2003 08:31:04 pm"
List-Id: linux-scsi@vger.kernel.org
To: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Cc: "Scott M. Ferris" <sferris@acm.org>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

N.C.Krishna Murthy wrote:
>
> Hi,
> 	We do not need scsi_scan_host_selected()  for lun masking.
> 
> In the current code, after establishing a session with an iSCSI target we 
> a)issue report luns to find out what luns exist on the target.
> b)Configure each lun using scsi_add_device.
> To accomplish a),  we use iscsi_do_cmnd(). 
> Linux scsi folks had suggested that we could use the "report lun based"
> probing infrastructure that exists in the 2.6 kernel instead of duplicating 
> the same in our driver. We need scsi_scan_host_selected() function to utilize 
> the same. As of now (2.6.0-test11) the function is not exported.
> 

The point people are trying to make is that the low-level driver
should not be doing either a or b.  When an iSCSI target is added,
tell hotplug, and let it initiate a scan of that target through sysfs.

-- 
Scott M. Ferris,
sferris@acm.org 
