From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs
	take 2
Date: 07 Sep 2004 17:33:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094592818.1716.159.camel@mulgrave>
References: <20040907210520.0251476C56@isis.visi.com>
	<413E2440.8080509@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:64180 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268663AbUIGVgX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 17:36:23 -0400
In-Reply-To: <413E2440.8080509@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Scott M. Ferris" <sferris@acm.org>, Mike Christie <mikenc@us.ibm.com>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-09-07 at 17:12, Mike Christie wrote:
> > This is exactly why I ask these questions.  The iSCSI driver
> > developers just implemented this, because they thought this is what
> > you and Christoph were asking for.  Apparently it's not what you
> > wanted.
> 
> Thank you for clarifying this. So we should go back to a single linux host,
> right? The iscsi session is an I_T nexus, so the only way to store the
> session state in the host is to allocate a session per host.

No; for iscsi, the host and target for I_T is the right thing to do.

The reason why doesn't lie in terminology or a specification, it lies in
the code.

When the cisco-iscsi driver was first presented, it had a single host
for everything and a huge connection management resource array hanging
off that.  This was clearly wrong beacuse there was a huge overhead
managing the array.  The correct approach was to make the host
correspond to a single element of that array and use the mid-layer host
management functions instead of home grown resource management
functions.  Doing it this way makes both the management and presentation
of the information more logical and the code cleaner.

James


