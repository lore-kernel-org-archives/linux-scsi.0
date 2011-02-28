From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: scsi_host_template.queuecommand() instances
Date: Mon, 28 Feb 2011 06:24:03 -0700
Message-ID: <20110228132402.GI13726@parisc-linux.org>
References: <20110227222102.GH13726@parisc-linux.org> <439834.81106.qm@web161913.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54793 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1B1NYE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2011 08:24:04 -0500
Content-Disposition: inline
In-Reply-To: <439834.81106.qm@web161913.mail.bf1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: john smith <whalajam@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 27, 2011 at 11:21:20PM -0800, john smith wrote:
> How does the queuecommand get called for concurrent application threads  before 2.6.37?

Before 2.6.37, there's a per-host lock acquired in the scsi layer that
prevents queuecommand being called twice for the same host simultaneously.
If your driver is drivign two cards, then it can still be executing
twice ...  but it's a rare driver that has global instead of per-host
state to protect.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
