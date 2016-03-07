From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 2/2] target/iblock: Use -EAGAIN/-ENOMEM to propigate
 SAM BUSY/TASK_SET_FULL
Date: Mon, 07 Mar 2016 00:03:56 -0800
Message-ID: <1457337836.10643.2.camel@haakon3.risingtidesystems.com>
References: <1457161634-15756-1-git-send-email-nab@daterainc.com>
	 <1457161634-15756-2-git-send-email-nab@daterainc.com>
	 <20160305210108.GA16337@lst.de>
	 <1457218287.28660.70.camel@haakon3.risingtidesystems.com>
	 <20160306061910.GA1116@infradead.org>
	 <1457301315.32532.12.camel@haakon3.risingtidesystems.com>
	 <20160307075548.GB13884@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58422 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbcCGIEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 03:04:07 -0500
In-Reply-To: <20160307075548.GB13884@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>

On Mon, 2016-03-07 at 08:55 +0100, Christoph Hellwig wrote:
> On Sun, Mar 06, 2016 at 01:55:15PM -0800, Nicholas A. Bellinger wrote:
> > The intended use is for any make_request_fn() based driver that invokes
> > bio_endio() completion directly, and sets bi_error != 0 to signal
> > non GOOD status to target/iblock.
> 
> But -EAGAIN and -ENOMEM are not valid drivers for bio_endio,

Why..?

>  and as far as I can tell no driver every returns them.

Correct, it's a new capability for make_request_fn() based drivers using
target/iblock export.

>  So as-is this might be well intended but either useless or broken.
> --

No, it useful for hosts that have an aggressive SCSI timeout, and it
works as expected with Linux/SCSI hosts that either retry on BUSY
status, or retry + reduce queue_depth on TASK_SET_FULL status.

