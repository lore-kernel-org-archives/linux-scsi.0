From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Full hostlock pushdown available
Date: Mon, 01 Nov 2010 11:56:47 -0400
Message-ID: <4CCEE33F.5030300@garzik.org>
References: <20101028150508.GA2385@basil.fritz.box> <4CCD5F7F.8020808@panasas.com> <tkrat.c4793af298337eff@s5r6.in-berlin.de> <4CCE271D.7040400@garzik.org> <20101101135338.GA25817@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64472 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab0KAP4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 11:56:51 -0400
Received: by ywc21 with SMTP id 21so897354ywc.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2010 08:56:51 -0700 (PDT)
In-Reply-To: <20101101135338.GA25817@basil.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On 11/01/2010 09:53 AM, Andi Kleen wrote:
>> > Missing drivers/ata/libata-scsi.c modification?

> Ah thanks for noticing. I missed that because it defined queuecommand
> in a header plus a macro. Fixed in the tree. I also did another grep to make
> sure there a no other occurrences. And fixed some documentation.
>
> Updated tree

You have just recreated the same bug Nicholas did:  you incorrectly 
removed the required _irqsave and _irqrestore from ap->lock.

Please check your changes closely to make sure you haven't duplicated 
this bug in other drivers.

This is _precisely_ why I like Boaz' suggestion:  it better guarantees 
the locking remains unchanged.  Apparently your change, like Nicholas's, 
is not so mechanical after all.

	Jeff


