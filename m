From: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 10 Dec 2003 20:31:04 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312102031.04680.krmurthy@cisco.com>
References: <20031208154618.1AFB45DC7E@bambi.visi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:7252 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S261411AbTLJPBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2003 10:01:17 -0500
In-Reply-To: <20031208154618.1AFB45DC7E@bambi.visi.com>
List-Id: linux-scsi@vger.kernel.org
To: "Scott M. Ferris" <sferris@acm.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

Hi,
	We do not need scsi_scan_host_selected()  for lun masking.

In the current code, after establishing a session with an iSCSI target we 
a)issue report luns to find out what luns exist on the target.
b)Configure each lun using scsi_add_device.
To accomplish a),  we use iscsi_do_cmnd(). 
Linux scsi folks had suggested that we could use the "report lun based"
probing infrastructure that exists in the 2.6 kernel instead of duplicating 
the same in our driver. We need scsi_scan_host_selected() function to utilize 
the same. As of now (2.6.0-test11) the function is not exported.

Thanx
N.C.Krishna Murthy




On Monday 08 Dec 2003 9:16 pm, Scott M. Ferris wrote:
> N.C.Krishna Murthy wrote:
> > Hi,
> > 	We agree to using the wrapper when we are notified about
> > "reported lun data change".
> >
> > 	However when a session is initially established to an iSCSI target,
> > luns on the target need to be configured. As mentioned in one of my
> > previous mails , we need to use scsi_scan_host_selected().
> > Will the function be exported in the next release of 2.6 or do I need to
> > generate a patch for the same?
>
> You'd be better off letting the OS decide which LUNs to use, and not
> masking anything in the low-level driver. If LUN masking is needed,
> adding a general mechanism to the kernel to provide LUN masking for
> any particular target would be a better approach than having each
> low-level driver implement its own way of masking LUNs.
>
> The main motivation for LUN masking is the limited number of SCSI disk
> devices Linux can support.  Now that Linux has 32-bit device numbers,
> the SCSI disk driver could be changed to support many more LUNs per
> target, and the need for LUN masking would be greatly reduced.  This
> would probably be less work than adding a general LUN masking
> mechanism, and would be useful to a larger number of users than LUN
> masking would.
