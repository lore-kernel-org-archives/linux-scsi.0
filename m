From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] scsi_transport_fc: LUN masking
Date: Thu, 12 Nov 2015 14:33:26 +0100
Message-ID: <56449526.5090405@linux.vnet.ibm.com>
References: <1447238080-109942-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:58946 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbbKLNdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2015 08:33:32 -0500
Received: from localhost
	by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Thu, 12 Nov 2015 13:33:30 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 852AE17D8062
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2015 13:33:46 +0000 (GMT)
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tACDXRZR53870818
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2015 13:33:27 GMT
Received: from d06av02.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tACDXQdM005933
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2015 06:33:27 -0700
In-Reply-To: <1447238080-109942-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@odin.com>

Hi Hannes,

On 11/11/2015 11:34 AM, Hannes Reinecke wrote:
> having been subjected to the pain of trying to bootstrap a really
> large machine with systemd I decided to implement LUN masking in

This is very interesting.

I also thought about initiator-based LUN masking a while ago.
While scsi_transport_fc would be sufficient to allow zfcp to get rid of=
=20
its own implementation, I wonder why we wouldn't do it in the midlayer'=
s=20
scsi_scan.c. This would provide initiator-based LUN masking for any and=
=20
all transports and LLDDs?

(I also thought about initiator-based zoning, and that would indeed be=20
something for scsi_transport_fc because it is inherently transport=20
specific.)

> scsi_transport_fc.
> The principle is simple: disallow the automated LUN scanning when
> discovering a rport, and create udev rules which selectively
> enable individual LUNs by echoing the relevant values in the 'scan'
> attribute of the SCSI host.

I imagined exactly the same existing user space interface.

Now we "only" need some user-friendly user space tooling, which provide=
s=20
transport specific user arguments automatically translated into the=20
midlayer naming scheme, such as converting FC SAN addressing (HBA devic=
e=20
bus-ID,WWPN,FCPLUN) into scsi_device names (Scsi_Host,0,scsi_id,scsi_lu=
n),
and some persistency mechanism (such as managing udev rules).

> With that I'm able to boot an arbitrary large machine without
> running into any udev or systemd imposed timeout.
> To _disable_ LUN masking and restoring the original behaviour
> I've noticed that the 'scan' sysfs attribute is actually synchronous,
> ie the calling process will be blocked until the entire LUN scan
> is completed.
> So I've added another module parameter 'async_user_scan' to
> move the scanning onto the existing scan workqueue, and unblock
> the calling process.

Just curious: Which means would a user of async_user_scan have to sync=20
against the completion?
Or is this only meant for user space--I currently cannot imagine--which=
=20
does not care about the appearance of what was (newly) discovered?

>
> As usual, comments and reviews are welcome.
>
> Hannes Reinecke (2):
>    scsi_transport_fc: implement 'disable_target_scan' module paramete=
r
>    scsi_transport_fc: Implement 'async_user_scan' module parameter
>
>   drivers/scsi/scsi_transport_fc.c | 47 +++++++++++++++++++++++++++++=
++++++++---
>   1 file changed, 44 insertions(+), 3 deletions(-)
>

--=20
Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
