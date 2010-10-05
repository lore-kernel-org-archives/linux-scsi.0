From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH]SCSI: don't return errors for failures in sd_suspend()
Date: Tue, 05 Oct 2010 09:38:17 -0500
Message-ID: <1286289497.6661.8.camel@mulgrave.site>
References: <201010051628.21414.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab0JEOiV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2010 10:38:21 -0400
In-Reply-To: <201010051628.21414.oneukum@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, hare@suse.de

On Tue, 2010-10-05 at 16:28 +0200, Oliver Neukum wrote:
> From f4eee84ae76a303f8ceca761f0d9e3813b4d45cb Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Tue, 5 Oct 2010 16:10:30 +0200
> Subject: [PATCH] SCSI: don't return errors for failures in sd_suspend()
> 
> If an uncoorectable error happens during the suspension
> of an sd device, the device is unsalvageable. The error
> can be ignored, as offlined devices will be ignored in
> the future anyway.

More justification please ...

Lying to upper layers about errors (or just ignoring them) has been a
huge problem with our stack error handling which we are trying to
correct.

The most likely cause of error is cache sync failure so at the point of
power off for suspend, we'll lose data.  This might not be an
uncorrectable error either; it could be memory allocation failure or a
host of other transient reasons.

James


