From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: 05 Dec 2003 10:33:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070594036.1603.34.camel@mulgrave>
References: <200310231734.10263.krmurthy@cisco.com>
	<200312011740.09693.krmurthy@cisco.com> <1070292174.2007.14.camel@mulgrave>
	<200312041800.55663.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:28422 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264591AbTLEPeC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 10:34:02 -0500
In-Reply-To: <200312041800.55663.krmurthy@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Thu, 2003-12-04 at 07:30, N.C.Krishna Murthy wrote:
> Having user level utility trigger the rescan thru sysfs interfaces will call
> scsi_scan() which will inturn call scsi_scan_host_selected().
> Instead wouldn't it be preferable to call scsi_scan_host_selected()
> from the iSCSI driver itself?

Well, consider all the ramifications: what happens if the
reconfiguration is deleting an existing LUN with a mounted filesystem? 
What happens if the user wants to do something with the new LUN as soon
as it appears (like fold it into a VM volume, or format it).  The
hotplug system is designed to propagate events that others might be
interested in, which it strikes me this is.  So, if you have to trigger
a hotplug event anyway, you may as well go the whole hog and do the
reconfiguration as part of the hotplug subsystem.

> > We could do with a generic infrastructure within SCSI for generating
> > these events, anyway, if you want to go that route...
> >
> I am not much familiar with SCSI hotplug. 
> 
> If the generic infrastructure which you mentioned does not exist now and in 
> case there is a plan to do one such thing is there any framework for that?
> Wouldn't that require a kernel API which is capable of both 
> "adding new luns" and "deleting luns which no longer exist"?

Well, a hotplug event feeds certain information into the environment
when it triggers the call.  All we really need is a wrapper in SCSI to
add the SCSI information to the environment and trigger the event in a
generic fashion.

James



