From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx intothe
 kernel
Date: Mon, 03 Oct 2005 11:19:34 -0400
Message-ID: <43414C06.2030501@adaptec.com>
References: dlang@dlang.diginsite.com <Pine.LNX.4.62.0510030721540.11541@qynat.qvtvafvgr.pbz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:5079 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751101AbVJCPTl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 11:19:41 -0400
In-Reply-To: <Pine.LNX.4.62.0510030721540.11541@qynat.qvtvafvgr.pbz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Lang <david.lang@digitalinsight.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Kyle Moffett <mrmacman_g4@mac.com>, Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On 10/03/05 10:26, David Lang wrote:
> in this case wouldn't it be trivial to write a 'null transport' driver 
> that just passed things down to the card to let the firmware deal with it?
> (reformatting the data if needed)

Hi David,

I think it is trivial.

Your LLDD would define the host template and register it
with SCSI Core.  This way you _bypass_ the Transport Layer.
(This is what you call null driver -- as is traditionally done
in SCSI Core due to the legacy LLDDs (to which MPT caters
for 100% backward software compatibility))

Else if your LLDD is just an inteface to the interconnect:
i.e. it only implements Execute SCSI RPC and TMFs, then
you'd register with the Transport Layer (SBP or USB or SAS)
which will do all Transport related tasks, and then that
Transport Layer (USB, SBP or SAS) would register a scsi host
with SCSI Core.

	Luben

> having a null driver for a layer for some hardware, and a much more 
> complex driver for the same layer for other hardware is fairly common in 
> Linux. I believe ti was Linus that said in an interview that Linux is now 
> largely designed for an ideal abstracted CPU, with code put in on the 
> architectures that don't have a feature to simulate that feature in 
> software.
> 
> David Lang
> 

