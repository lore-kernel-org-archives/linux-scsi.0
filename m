From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [0/3] Last 3 patches for bidi support
Date: Tue, 06 Nov 2007 12:25:16 -0600
Message-ID: <4730B18C.20505@cs.wisc.edu>
References: <4730ACAA.2060007@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43947 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbXKFS1E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Nov 2007 13:27:04 -0500
In-Reply-To: <4730ACAA.2060007@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>

Boaz Harrosh wrote:
> [1]
> I propose a small change to scsi_tgt_lib.c that will make
> tgt completely neutral to the scsi_data_buffer patch. And will
> make it all that more ready for bidi, too. TOMO is this OK?
> 
> (Can you do without the GFP_KERNEL allocation flag? It could
> make the code a bit more simple)
> 

GFP_KERNEL is nice for the target layer because it can sleep in that 
path you changed and it and does not have the "cannot write out pages 
because it may come back to the same device issues" like an initiator does.

If we ever changed to a softirq instead of the work queue then we would 
not need the flag since it would have to GFP_ATOMIC, but I am not sure 
if we have plans to do that anytime soon.
