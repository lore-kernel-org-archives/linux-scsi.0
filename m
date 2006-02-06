From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 1/3] SCSI Userspace Target: scsi-ml changes
Date: Mon, 06 Feb 2006 12:02:45 -0600
Message-ID: <1139248965.3022.11.camel@mulgrave.il.steeleye.com>
References: <1138157885.11692.32.camel@max>
	 <1139164228.3017.14.camel@mulgrave.il.steeleye.com>
	 <20060206113356T.fujita.tomonori@lab.ntt.co.jp>
	 <43E78D68.7010301@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:19344 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932195AbWBFSDJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 13:03:09 -0500
In-Reply-To: <43E78D68.7010301@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On Mon, 2006-02-06 at 11:54 -0600, Mike Christie wrote:
> We actually need ths shost pointer becuase we do not represent the LU in 
> the kernel. So we go from:
> 
> scsi_host -> host's uspace request_queue (used to pass commands and 
> messages from the target LLD interrup handler to our netlink 
> code/userspace -> in userspace we represent the target, device/LU, and host.
> 
> Tomo did you add a virtual scsi_device somewhere?

OK, well, the problem is that struct scsi_cmnd is allocated in the
critical I/O path.  The more elements it has, the more time it takes to
set up and tear down.  Kenneth Chen of intel has already produced
figures showing that you can get measurable I/O improvement simply by
dropping fields from it, so I'm very, very reluctant to increase its
size.

James


