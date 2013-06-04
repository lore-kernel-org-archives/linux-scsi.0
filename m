From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] make dev_loss_tmo checks uniform across drivers
Date: Tue, 04 Jun 2013 08:54:02 +0200
Message-ID: <51AD8F0A.9050007@acm.org>
References: <1370283919-11884-1-git-send-email-gurinder.shergill@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:33011 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3FDGyH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jun 2013 02:54:07 -0400
In-Reply-To: <1370283919-11884-1-git-send-email-gurinder.shergill@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gurinder.shergill@hp.com
Cc: linux-scsi@vger.kernel.org

On 06/03/13 20:25, gurinder.shergill@hp.com wrote:
> The dev_loss_tmo parameter controls how long the FC transport layer
> insulates a loss of a remote port. It is defined to be between 1 and
> SCSI_DEVICE_BLOCK_MAX_TIMEOUT (600). Different drivers do slightly different
> checks when passed this parameter. This patch makes the dev_loss_tmo setting
> uniform across all the drivers by pulling the common logic into the
> transport layer function which is responsible for invoking the driver
> provided callouts.
>
> In addition, this patch also fixes a issue (see below), where dev_loss_tmo
> could end up with a value more than SCSI_DEVICE_BLOCK_MAX_TIMEOUT when
> fast_io_fail_tmo is enabled and then disabled.  The change is to never
> allow dev_loss_tmo to be out of its defined range. And, once that is a
> given, then fast_io_fail_tmo can be capped by dev_loss_tmo.

Hello Sunny,

As far as I know some users set fast_io_fail_tmo such that dev_loss_tmo 
can be set to a very large value in order to prevent that the SCSI host 
number changes. Sorry but I'm not sure it's a good idea to remove that 
functionality.

Bart.

