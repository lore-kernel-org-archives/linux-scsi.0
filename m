From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.2, Partition support for SCSI CDROM...
Date: Tue, 24 Feb 2004 17:06:26 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040224170626.A25066@infradead.org>
References: <40396134.6030906@realitydiluted.com> <20040222190047.01f6f024.akpm@osdl.org> <40396E8F.4050307@realitydiluted.com> <20040224061130.GC503530@sgi.com> <403B8108.6080606@realitydiluted.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:48648 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262306AbUBXRGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 12:06:31 -0500
Content-Disposition: inline
In-Reply-To: <403B8108.6080606@realitydiluted.com>; from sjhill@realitydiluted.com on Tue, Feb 24, 2004 at 11:51:20AM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Steven J. Hill" <sjhill@realitydiluted.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Feb 24, 2004 at 11:51:20AM -0500, Steven J. Hill wrote:
> Here is the second try at the patch.
> 
> -Steve


+static int partitions = 16;

This is changes what sr1 is mapped to without specicying any option.
The default _must_ be 0 partitions or existing setups will break.

+MODULE_PARM(partitions, "i");

please make this module_param so it works at boot-time aswell.

+MODULE_PARM_DESC(partitions, "number of SCSI CDROM partitions to support");
 
+	/* Check number of partitions specified. */
+	if (partitions < 0)
+		partitions = 0;

now if you made the variable 'unsigned' you wouldn't have that problem..

While you're at it please also cook up an ide-cd variant, having partitions
only supported on scsi cdroms is more than confusing.
