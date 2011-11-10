From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 4/4] ata: add ata port runtime PM callbacks
Date: Thu, 10 Nov 2011 07:45:50 -0800
Message-ID: <20111110154550.GF27258@google.com>
References: <1320906166-15459-5-git-send-email-ming.m.lin@intel.com>
 <Pine.LNX.4.44L0.1111101036160.2338-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64331 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1KJPp6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2011 10:45:58 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1111101036160.2338-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>

On Thu, Nov 10, 2011 at 10:40:21AM -0500, Alan Stern wrote:
> Are you really sure you want to keep this flag set throughout the 
> lifetime of the port?
> 
> What happens if a command fails, then the port suspends, and then the 
> error handler is invoked to take care of the failed command?

Runtime PM doesn't happen if the device is in use in any way, so
there's no request flying in from upper layers.  While the port is
suspended, qc's which which requested EH are short-circuited.  AFAICS,
nothing is really wrong.

Thanks.

-- 
tejun
