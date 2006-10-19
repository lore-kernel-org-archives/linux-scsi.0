From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] AIC94XX: call tasklet_kill while unloading the module
Date: Thu, 19 Oct 2006 18:10:31 -0400
Message-ID: <1161295831.11219.31.camel@mulgrave.il.steeleye.com>
References: <20061019032551.GB19570@us.ibm.com>
	 <1161284239.11219.19.camel@mulgrave.il.steeleye.com>
	 <20061019220228.GA13039@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:57482 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1946566AbWJSWKh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 18:10:37 -0400
In-Reply-To: <20061019220228.GA13039@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-10-19 at 15:02 -0700, malahal@us.ibm.com wrote:
> James, I think we should stop processing the done list before
> we call asd_free_queues() which frees all pending SCB's. So
> asd_destroy_ha_caches() is too late for it. I can put it in
> asd_free_queues() if you agree.

Not really; that won't get it called correctly on the error path of
asd_pci_probe().

On the teardown path, free_irq is called long before asd_free_queues, so
nothing is going to be scheduling the tasklet, so I don't think it
matters where it's called after that.

James


