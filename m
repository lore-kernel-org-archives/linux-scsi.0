From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] ses: skip error messages for invalid LUNs
Date: Fri, 22 Dec 2017 09:39:11 -0800
Message-ID: <1513964351.3163.14.camel@HansenPartnership.com>
References: <1513855354-86603-1-git-send-email-hare@suse.de>
         <1513855354-86603-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39208 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756218AbdLVRjN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Dec 2017 12:39:13 -0500
In-Reply-To: <1513855354-86603-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, 2017-12-21 at 12:22 +0100, Hannes Reinecke wrote:
> Some storage array set the 'Embedded enclosure' bit even though
> no LUN is present, causing the first RECEIVE DIAGNOSTIC call to
> be returned with sense code 'LOGICAL UNIT NOT SUPPORTED'.
> This patch skips the annoying 'Failed to get diagnostic page 0x1'
> messages for those cases.

What disagnostic pages does this thing support?  Can you do a receive
diagnostic on page 0 to find out?  I suspect a lot of embedded
enclosure services are simple and support page 7 only.  If it really
refuses all diagnostic page requests (which would be a gross standards
violation), then it should probably be blacklisted by inquiry string as
unusable.

James
