From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: Blk-mq/scsi-mq Tuning
Date: Thu, 29 Oct 2015 11:04:47 -0700
Message-ID: <56325FBF.8010306@sandisk.com>
References: <D256A425.229C0%chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0079.outbound.protection.outlook.com ([207.46.100.79]:38322
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751055AbbJ2SEu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2015 14:04:50 -0400
In-Reply-To: <D256A425.229C0%chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, "hch@lst.de" <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>, Jens Axboe <axboe@fb.com>

On 10/28/2015 01:11 PM, Chad Dupuis wrote:
> We=B9ve begun to explore blk-mq and scsi-mq and wanted to know if the=
re were
> any best practices in terms of block layer settings.  We=B9re looking
> specifically at the FCoE and iSCSI protocols.
>
> A little background on the queues in our hardware first: we have a pe=
r
> connection transmit queue and multiple, global receive queues.  The
> transmit queues are not pegged to a particular CPU.  The receive queu=
es
> are pegged to the first N CPUs where N is the number of receive queue=
s.
> We set the nr_hw_queues in the scsi_host_template to N as well.
>
> In our initial testing we=B9re not seeing the performance scale as we=
 would
> expect so we wanted to see if there some =8Cknobs=B9 if you will that=
 we could
> try tuning to try to increase the performance.  Also, one question we=
 did
> have is there an official API to be able to set the CPU affinity of t=
he
> hw_ctx_queues?

(added Jens to CC-list)

Hello Chad,

It's great news that you are looking into adding scsi-mq support for=20
=46CoE and iSCSI initiator HBA's. If you do not see the performance sca=
le=20
as expected that probably means that lock contention occurs in the code=
=20
that submits requests to the SCSI request queues. Have you already trie=
d=20
to measure L3 cache misses with perf (e.g. perf record -ag -e=20
LLC-store-misses sleep 10 && perf report) ? If a single function is=20
responsible for more than 10% of the L3 cache misses usually that means=
=20
that that function is causing a bottleneck.

As far as I know an official API for setting the CPU affinity of the=20
hw_ctx queues is not yet available. The approach of the SRP initiator=20
driver (ib_srp) is that it assumes that the HCA supports MSI-X and that=
=20
MSI-X interrupts have been spread evenly over processors. The ib_srp=20
driver selects an MSI-X interrupt for each hw_ctx queue via the=20
comp_vector member of struct ib_cq_init_attr. The script I am using=20
myself is available at=20
http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/21312/fo=
cus=3D98409.=20
I hope one day that script will be superfluous :-)

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
