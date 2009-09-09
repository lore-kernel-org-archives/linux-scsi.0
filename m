From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 1/1] be2iscsi: Fixes for powerpc compile
Date: Wed, 09 Sep 2009 12:15:20 -0700
Message-ID: <20090909191520.fb9e5110@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail192.messagelabs.com ([216.82.241.243]:42909 "EHLO
	mail192.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZIITRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2009 15:17:41 -0400
In-Reply-To: 4AA7CC07.20401@cs.wisc.edu
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, sfr@canb.auug.org.au

Implementing pci_pool is not a problem. But, my experience with this chip
(or for that matter any chip that can do huge IOPS ,say, more then 600 -700 KIOPS),
 every line of code on the hot path would have an impact and hence I strive to
move it out of the hot path.

The code is not yet optimized for speed yet but I definitely want to push whatever
 I can to init time from  the IO path.

Thanks
Jay
  _____  
From: Mike Christie [mailto:michaelc@cs.wisc.edu]
To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, sfr@canb.auug.org.au
Sent: Wed, 09 Sep 2009 08:38:47 -0700
Subject: Re: [PATCH 1/1] be2iscsi: Fixes for powerpc compile

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

