From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] Another fix for suspend i/o - validate dev statebefore
	transition
Date: Sat, 11 Dec 2004 07:39:18 -0600
Message-ID: <1102772358.5226.3.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C12E89D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54919 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261935AbULKNjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Dec 2004 08:39:25 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12E89D@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-12-11 at 07:57 -0500, James.Smart@Emulex.Com wrote:
> Upon further reflection... perhaps I was too hasty agreeing with the change.
> 
> It certainly solve my issue. However, what it means is that it may actually hide reports of other invalid state transitions that may be meaningful. Do we want to hide these too ?  If not, than I think the original patch best solves the problem.  Your call...

Well, that's what worried me when I first implemented the state model,
which is why the message is there.  However, there haven't actually been
any bug reports where it did anything other than cause problems.  If
there's really a transition we should be warning about failure on, we
can do it by printing an error on the failure return from
scsi_device_set_state().

James


