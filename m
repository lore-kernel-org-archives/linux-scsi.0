From: john smith <whalajam@yahoo.com>
Subject: Re: scsi_host_template.queuecommand() instances
Date: Fri, 4 Mar 2011 12:58:05 -0800 (PST)
Message-ID: <842460.81825.qm@web161919.mail.bf1.yahoo.com>
References: <20110228132402.GI13726@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web161919.mail.bf1.yahoo.com ([98.139.211.227]:20481 "HELO
	web161919.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760065Ab1CDU6H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2011 15:58:07 -0500
In-Reply-To: <20110228132402.GI13726@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

--- On Mon, 2/28/11, Matthew Wilcox <matthew@wil.cx> wrote:
> Before 2.6.37, there's a per-host lock acquired in the scsi
> layer that
> prevents queuecommand being called twice for the same host
> simultaneously.
> If your driver is drivign two cards, then it can still be
> executing
> twice ...  but it's a rare driver that has global
> instead of per-host
> state to protect.

If precautions are taken (to protect shared data), I assume it is safe to spin_unlock(host->host_lock) - at the entry in queuecommand() and spin_lock(host->host_lock) - at the exit, to make it MT?
(I believe I've seen this done)

thanks,
John


      
