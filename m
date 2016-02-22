From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv8 20/23] scsi: Add 'access_state' attribute
Date: Mon, 22 Feb 2016 07:34:58 -0800
Message-ID: <56CB2AA2.9090505@sandisk.com>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
 <1455869840-122786-21-git-send-email-hare@suse.de>
 <56C7688A.2050608@sandisk.com> <56C81DB5.7070102@suse.de>
 <56C8834F.50304@sandisk.com> <56C9750B.9010200@suse.de>
 <56CA9252.8030007@sandisk.com> <56CAB1E4.9060809@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0090.outbound.protection.outlook.com ([157.56.110.90]:12306
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753489AbcBVPfE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2016 10:35:04 -0500
In-Reply-To: <56CAB1E4.9060809@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/21/16 22:59, Hannes Reinecke wrote:
> The main reason why I need the 'access_state' attribute is to decouple
> the multipath daemon; at the moment the multipath daemon has to issue
> REPORT TARGET PORT GROUPS frequently to figure out the status, which is
> causing quite some load on the target. When using the 'access_state'
> attribute we would avoid doing I/O for that and have a consistent view,
> both on the kernel and the multipath daemon side.
>
> But it's actually a good thing to have the 'access_state' patch in a
> different series; I've got some more patches converting the remaining
> device_handler to also supply the 'access_state' values.

Hello Hannes,

The above sounds very interesting to me. Will multipathd recognize at 
run-time whether or not the kernel supports the sysfs ALUA state 
attribute ? Will ALUA state changes be reported through udev or will 
multipathd poll the sysfs ALUA state attributes ? And if the netlink 
buffer that is used in multipathd to receive udev events overflows 
(ENOBUFS), will multipathd resynchronize its state ? As far as I can see 
in source file libmultipath/uevent.c today multipathd ignores netlink 
buffer overflows.

Thanks,

Bart.
