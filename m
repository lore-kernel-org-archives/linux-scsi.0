From: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 4 Dec 2003 18:00:55 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312041800.55663.krmurthy@cisco.com>
References: <200310231734.10263.krmurthy@cisco.com> <200312011740.09693.krmurthy@cisco.com> <1070292174.2007.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:2567 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S261733AbTLDMc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2003 07:32:29 -0500
In-Reply-To: <1070292174.2007.14.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

Hi,
	Please find my replies/quieries interspersed in your reply.
On Monday 01 Dec 2003 8:52 pm, James Bottomley wrote:
> On Mon, 2003-12-01 at 06:10, Krishna Murthy wrote:
> > Hi,
> > 	We could use probing code from mid layer provided
> > scsi_scan_host_selected is exported.
> >
> > 	iscsi driver does probe for devices at two places
> > a)Once after session establishment.
> > b)Whenever an iSCSI async message indicates a change in
> > "REPORTED LUNS DATA". (addition/deletion of luns on the target)
>
> This sounds like an async event which could be handled by the hotplug
> system.  Would there be a problem with simply transmitting this to a
> user level utility and having it trigger the rescan through the exported
> sysfs interfaces?
Having user level utility trigger the rescan thru sysfs interfaces will call
scsi_scan() which will inturn call scsi_scan_host_selected().
Instead wouldn't it be preferable to call scsi_scan_host_selected()
from the iSCSI driver itself?


>
> We could do with a generic infrastructure within SCSI for generating
> these events, anyway, if you want to go that route...
>
I am not much familiar with SCSI hotplug. 

If the generic infrastructure which you mentioned does not exist now and in 
case there is a plan to do one such thing is there any framework for that?
Wouldn't that require a kernel API which is capable of both 
"adding new luns" and "deleting luns which no longer exist"?

Please let us know
Thanx
N.C.Krishna Murthy
