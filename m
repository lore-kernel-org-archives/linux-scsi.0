From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] sd: disk offlined prematurely from media access timeout
Date: Wed, 23 Oct 2013 04:36:11 -0400
Message-ID: <yq1vc0ofkp0.fsf@sermon.lab.mkp.net>
References: <20130924194244.GA26428@fury.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27717 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3JWIgZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 04:36:25 -0400
In-Reply-To: <20130924194244.GA26428@fury.redhat.com> (David Jeffery's message
	of "Tue, 24 Sep 2013 15:42:44 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "David" == David Jeffery <djeffery@redhat.com> writes:

David> There is an error with the medium access timeout feature of the
David> sd driver. The sdkp->medium_access_timed_out value is set to zero
David> in sd_done() in the wrong place.  It is set to zero only if a
David> command returns sense data.  If an I/O command times out, error
David> handling succeeds, and the I/O commands complete, the value won't
David> be reset if nothing responds with a sense buffer.  Then, another
David> timeout (no matter how far in the future) can increment it again,
David> causing the device to be errantly set offline.

David> The resetting of sdkp->medium_access_timed_out should occur
David> before the check for sense data.

David> Signed-off-by: David Jeffery <djeffery@redhat.com>

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
