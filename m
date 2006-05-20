From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/6] mpt fusion - fibre channel target discovery
	prematurely terminates
Date: Sat, 20 May 2006 10:33:36 -0500
Message-ID: <1148139217.3529.19.camel@mulgrave.il.steeleye.com>
References: <446CD224.6060806@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:62375 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964867AbWETPdk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 11:33:40 -0400
In-Reply-To: <446CD224.6060806@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2006-05-18 at 14:59 -0500, Michael Reed wrote:
> mpt_config() can return EAGAIN.  When this happens, fibre channel target
> discovery can prematurely terminate with fewer than the total number of
> targets discovered.  This patch detects EAGAIN and reschedules the scan
> work.
> 
> Generally, this situation only occurs when the lsiutil program is being
> used to reset the board.

mpt_config() only returns EAGAIN when it's out of message frames.  That
should be a very transient condition, so if this rarely occurs anyway,
why not just put an msleep(10) on the condition and then retry?  It
would save all the requeue logic.

James


