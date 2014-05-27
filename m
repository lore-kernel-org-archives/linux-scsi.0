From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Tue, 27 May 2014 12:47:26 +0200
Message-ID: <53846D3E.6050901@redhat.com>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>			 <53835A77.1090708@acm.org> <1401118025.3303.5.camel@dabdike>		 <5384439C.1040604@acm.org> <1401179019.14454.18.camel@dabdike>	 <5384541B.1010400@acm.org> <1401186086.14454.43.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaE0KsE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 06:48:04 -0400
In-Reply-To: <1401186086.14454.43.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, "bvanassche@acm.org" <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

Il 27/05/2014 12:21, James Bottomley ha scritto:
> I could also see us one day extending the TMF capability to abort any
> running command, which would make even an assertion of block timed out
> or completed invalid.

Actually the assertion would remain valid, and that's exactly what Bart 
wants to document with this assertion.

"Completed" from the point of view of the block layer really means "do 
not run the softirq".  If you wanted to abort any running command, you 
still would mark the request as completed for the block layer before 
issuing the TMF.

Paolo
