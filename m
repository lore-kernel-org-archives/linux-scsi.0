From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: SCSI synchronization and error handling
Date: 30 Jun 2004 19:49:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088642994.1888.5.camel@mulgrave>
References: <40E317D9.80904@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:34492 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263448AbUGAAuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2004 20:50:12 -0400
In-Reply-To: <40E317D9.80904@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-06-30 at 14:43, Jeff Garzik wrote:
> What's the best way to ensure that the SMART command is only executed 
> after preceding, queued commands are completed?  My guess is to return 
> MLQUEUE_BUSY if (a) ->queuecommand is passed a non-queued command AND 
> (b) there are commands queued to hardware already.

So you have to quiesce the device before issuing the smart command?  In
which case, scsi_quiesce_device() is the API you want.  Or is this some
type of command ordering problem you're trying to solve?

James



