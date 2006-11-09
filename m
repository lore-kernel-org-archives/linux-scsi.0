From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 18/26] drivers/scsi/megaraid.c: Replacing yield() with a
 better alternative
Date: Thu, 9 Nov 2006 09:21:09 -0800
Message-ID: <20061109092109.3fa8e532.akpm@osdl.org>
References: <890BF3111FB9484E9526987D912B2619F9798D@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:37857 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S966040AbWKIRVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2006 12:21:17 -0500
In-Reply-To: <890BF3111FB9484E9526987D912B2619F9798D@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsi.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, amol@verismonetworks.com

On Thu, 9 Nov 2006 07:44:34 -0700
"Ju, Seokmann" <Seokmann.Ju@lsi.com> wrote:

> On Wednesday, November 08, 2006 10:56 PM, 
> > For this driver cond_resched() seems to be a better alternative
> Can you add some details on why cond_resched() better than yield()?

Since 2.5.early, yield() can cause very very long pauses if there are
busy processes in the machine.  Many seconds.

Quite a lot of yield()-using code broke when we made that CPU scheduler
change.
