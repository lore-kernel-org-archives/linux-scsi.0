From: "Scott M. Ferris" <sferris@acm.org>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs take
 2
Date: Tue, 7 Sep 2004 16:24:29 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907212429.7BDDF76C56@isis.visi.com>
References: <413E2440.8080509@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from conn.mc.mpls.visi.com ([208.42.156.2]:35827 "EHLO
	conn.mc.mpls.visi.com") by vger.kernel.org with ESMTP
	id S268669AbUIGVYa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 17:24:30 -0400
In-Reply-To: <413E2440.8080509@cs.wisc.edu> from Mike Christie at "Sep 7, 2004
 02:12:32 pm"
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Scott M. Ferris" <sferris@acm.org>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <mikenc@us.ibm.com>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> > 
> > This is exactly why I ask these questions.  The iSCSI driver
> > developers just implemented this, because they thought this is what
> > you and Christoph were asking for.  Apparently it's not what you
> > wanted.
> 
> Thank you for clarifying this. So we should go back to a single linux host,
> right? The iscsi session is an I_T nexus, so the only way to store the
> session state in the host is to allocate a session per host.

Sometimes, but not always.  I believe the goal is now one host for
each initiator port (with iSCSI, combination of InitiatorName and
ISID).

If you're trying to create multiple iSCSI sessions to different target
portals within the same SCSI target port (i.e. to TargetAddresses of
the same TargetName with the same TargetPortalGroupTag), you'd need to
use a different SCSI initiator port (typically by using a different
ISID), which means you'd need to allocate multiple hosts.

-- 
Scott M. Ferris,
sferris@acm.org 
