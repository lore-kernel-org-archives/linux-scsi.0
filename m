From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Retry scsi_mode_sense if UNIT ATTENTION occurs
Date: Tue, 29 Jul 2003 23:28:19 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0307292319140.3939@kai.makisara.local>
References: <Pine.LNX.4.44L0.0307281005590.797-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:53653 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S272059AbTG2U2V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 16:28:21 -0400
In-Reply-To: <Pine.LNX.4.44L0.0307281005590.797-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 28 Jul 2003, Alan Stern wrote:

> Jens:
>
> This patch changes the scsi_mode_sense() routine to retry up to a total of
> 3 times if a command fails with a UNIT ATTENTION sense key value.
>
This is dangerous or makes __scsi_mode_sense usable only in special cases.
Some high-level drivers need to process the UNIT ATTENTION sense data.

> Without this change, sr.c does not properly read the capabilities mode
> page for a just-powered-up cdrom drive -- it gives up upon receiving a
> Device Reset Occurred code.
>
One alternative is to move the retry code upwards to scsi_mode_sense and
document that it may discard UNIT ATTENTION. Those drivers that can't
tolerate this can then use __scsi_mode_sense. This would solve the sr
problem.

-- 
Kai
