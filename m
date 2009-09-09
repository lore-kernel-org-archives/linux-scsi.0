From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: Fixes for powerpc compile
Date: Wed, 09 Sep 2009 10:38:47 -0500
Message-ID: <4AA7CC07.20401@cs.wisc.edu>
References: <20090908223437.cc0c0f82@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55647 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZIIPi5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Sep 2009 11:38:57 -0400
In-Reply-To: <20090908223437.cc0c0f82@mailhost.serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, sfr@canb.auug.org.au

On 09/08/2009 05:34 PM, Jayamohan Kalickal wrote:
>    >  + max_size = ALIGN(sizeof(struct be_cmd_bhs), 64) * sess->cmds_max;
>    >  + vaddr = pci_alloc_consistent(phba->pcidev,
>
>
>    Do you just want a dma/pci pool? It will align structs for you too, I think.
>      I didn't want to do it because we do not really alloc/free once a connection is established.
> Yes, it can be done that way but certainly would not wan to do that in the IO hot path (even
> if it picking from pool).
>

I was just going by some other drivers like lpfc where they create the 
pool at pci probe time, then also preallocate from the pool at some 
setup/init time. In the case of lpfc it allocates scsi bufs for each 
command in its slave_alloc when new devices are added.

It is not a big deal. If people are ok with it as is, I am fine.
