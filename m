From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: PATCH [3/5]  qla2xxx: TCQ fixes
Date: Mon, 12 Jul 2004 17:19:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F32AAE.5070508@us.ibm.com>
References: <20040712140558.GA6961@praka.san.rr.com> <1089668486.1799.62.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:21936 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S264519AbUGMAWe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 20:22:34 -0400
In-Reply-To: <1089668486.1799.62.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net, Krishna Murthy <krmurthy@cisco.com>

James Bottomley wrote:
> On Mon, 2004-07-12 at 09:05, Andrew Vasquez wrote:
> 
>>ChangeSet
>>  1.1867 04/07/12 09:38:28 andrew.vasquez@apc.qlogic.com +2 -0
>>  Correct usage of tag-command-queueing methods:
> 
> 
> I really don't think it is.
> 
> For the way the qla2xxx works, the correct tag usage would be to use per
> HBA tags (which were introduced for aic7xxx but never used by them, so I
> haven't actually created the mid-layer API), to populate your queue
> handle field with the tag and to dispense with your outstanding_cmnds[]
> array and use scsi_find_tag() to get back the command from the handle.
> 
> Since you'd be the first user of this API, I'd be happy to come up with
> it for a willing victim^Wvolunteer.

Depending on the API, we might be able to use it for the linux-iscsi 
driver. Today the driver uses scsi_activate_tcq(), but does not uses the 
tag numbers. Instead it uses its own initiator task tags values for 
session wide identifiers, becuase we need tag values for iscsi ops. For 
example if we need to send a ping how should we get a tag from the mid 
layer? Or maybe becuase there are some transport specific tag values 
should we use someting else or keep it in the driver?

Mike
