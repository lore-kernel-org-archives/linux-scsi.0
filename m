From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [ANNOUNCE] iscsi-initiator-core 1.6.2.0-rc1 for 2.6.12-rc1
Date: Sat, 23 Apr 2005 21:49:15 -0500
Message-ID: <1114310956.4805.9.camel@mulgrave>
References: <1112385701.3008.18.camel@haakon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:37855 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262158AbVDXEZO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Apr 2005 00:25:14 -0400
In-Reply-To: <1112385701.3008.18.camel@haakon>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Cc: iscsi-initiator-core-announce@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <mikenc@us.ibm.com>

On Fri, 2005-04-01 at 12:01 -0800, Nicholas A. Bellinger wrote:
> A few minor fixes in this release, with the main feature addition being
> support for persistent connection/session parameters as defined within 
> /etc/sysconfig/initiator.  For example, it is now possible to define
> specific connection/session parameters and have those values remain
> throughout connection/session failures.  Also, the first run of tests
> with dm-multipath have been compelted successful.  I am working on a
> section within the documentation to describe how these two pieces work
> together within linux 2.6.
> 
> Also an important milestone has been reached with v1.0 of the
> iscsi-initiator-core.org howto located at:
> 
> http://iscsi-initiator-core.org/mediawiki/index.php/Howto
> 
> This is a work in progress as data is imported from the ASCII version
> from iscsi-initiator-core-tools v2.3.
> 
> This release is now considered stable and no new features will be added
> until 1.6.2.0-final is released.

OK, I assessed this for inclusion.

The feedback I had based on my last review was

1) Use the iscsi transport class
2) get rid of MC/S in favour of dm-multipath
3) Don't try to subvert the SCSI error handler

Point 3) is much better, but still present in this:

+	/*
+	 * This is completion of a given struct scsi_cmnd after an
+	 * iSCSI exception occured.  Based upon iSCSI exceptions and/or
+	 * passed action parameter, struct scsi_cmnd->eh_timeout may have
+	 * been stopped, and needs to be rstarted before completion to
+	 * the SCSI stack.
+	 */
+	if (!(timer_pending(&sc->eh_timeout))) {
+		sc->eh_timeout.data = (unsigned long) sc;
+		sc->eh_timeout.expires = (jiffies + sc->timeout_per_command);
+		sc->eh_timeout.function = scsi_timeout_function;
+		add_timer(&sc->eh_timeout);

However the other two still have not been addressed, so this patch is
not suitable for inclusion.

James


