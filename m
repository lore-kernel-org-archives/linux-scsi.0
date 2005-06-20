From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] remove scsi_cmnd.eh_state
Date: Mon, 20 Jun 2005 12:33:05 -0400
Message-ID: <42B6EFC1.3080201@adaptec.com>
References: <60807403EABEB443939A5A7AA8A7458B01520CD8@otce2k01.adaptec.com> <20050620123526.GA6222@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:64684 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261379AbVFTQdS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 12:33:18 -0400
In-Reply-To: <20050620123526.GA6222@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 06/20/05 08:35, Christoph Hellwig wrote:
> On Mon, Jun 20, 2005 at 08:28:50AM -0400, Salyzyn, Mark wrote:
> 
>>If the code is not in place, then array devices will go offline.
>>
>>The array needs to have a 5 minute timeout, all other devices can
>>timeout as per the SCSI subsystem.
> 
> 
> The proper API to do that is to set scsi_device.timeout in
> ->slave_configure.

One can also use the

enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);

interface in the scsi_host_template. (If say dynamic
decision is to be made: array or hdd or another kind of device.)

	Luben
