From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH [3/5]  qla2xxx: TCQ fixes
Date: 12 Jul 2004 16:41:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089668486.1799.62.camel@mulgrave>
References: <20040712140558.GA6961@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:31398 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263735AbUGLVll (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 17:41:41 -0400
In-Reply-To: <20040712140558.GA6961@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-07-12 at 09:05, Andrew Vasquez wrote:
> ChangeSet
>   1.1867 04/07/12 09:38:28 andrew.vasquez@apc.qlogic.com +2 -0
>   Correct usage of tag-command-queueing methods:

I really don't think it is.

For the way the qla2xxx works, the correct tag usage would be to use per
HBA tags (which were introduced for aic7xxx but never used by them, so I
haven't actually created the mid-layer API), to populate your queue
handle field with the tag and to dispense with your outstanding_cmnds[]
array and use scsi_find_tag() to get back the command from the handle.

Since you'd be the first user of this API, I'd be happy to come up with
it for a willing victim^Wvolunteer.

James

