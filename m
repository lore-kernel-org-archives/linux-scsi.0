From: "Scott M. Ferris" <sferris@acm.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 8 Dec 2003 09:46:18 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031208154618.1AFB45DC7E@bambi.visi.com>
References: <200312082036.41027.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from conn.mc.mpls.visi.com ([208.42.156.2]:36494 "EHLO
	conn.mc.mpls.visi.com") by vger.kernel.org with ESMTP
	id S265468AbTLHPq3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2003 10:46:29 -0500
In-Reply-To: <200312082036.41027.krmurthy@cisco.com> from "N.C.Krishna Murthy"
 at "Dec 8, 2003 09:16:19 am"
List-Id: linux-scsi@vger.kernel.org
To: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

N.C.Krishna Murthy wrote:
> Hi,
> 	We agree to using the wrapper when we are notified about 
> "reported lun data change". 
> 
> 	However when a session is initially established to an iSCSI target,
> luns on the target need to be configured. As mentioned in one of my previous
> mails , we need to use scsi_scan_host_selected(). 
> Will the function be exported in the next release of 2.6 or do I need to 
> generate a patch for the same?

You'd be better off letting the OS decide which LUNs to use, and not
masking anything in the low-level driver. If LUN masking is needed,
adding a general mechanism to the kernel to provide LUN masking for
any particular target would be a better approach than having each
low-level driver implement its own way of masking LUNs.

The main motivation for LUN masking is the limited number of SCSI disk
devices Linux can support.  Now that Linux has 32-bit device numbers,
the SCSI disk driver could be changed to support many more LUNs per
target, and the need for LUN masking would be greatly reduced.  This
would probably be less work than adding a general LUN masking
mechanism, and would be useful to a larger number of users than LUN
masking would.

-- 
Scott M. Ferris,
sferris@acm.org 
