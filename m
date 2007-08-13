From: Jeremy Linton <jli@greshamstorage.com>
Subject: Re: [patch 07/30] Incorrect SCSI transfer length computation from
 odd sized scsi_execute_async() transfers.
Date: Mon, 13 Aug 2007 10:10:13 -0500
Message-ID: <46C07455.7000903@greshamstorage.com>
References: <200708102150.l7ALoaLm011335@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gatekeeper.greshamstorage.com ([216.143.252.225]:21764 "EHLO
	AUSEXCH1.greshamstorage.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S948054AbXHMPKv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 11:10:51 -0400
In-Reply-To: <200708102150.l7ALoaLm011335@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

akpm@linux-foundation.org wrote:
> From: Jeremy Linton <jli@greshamstorage.com>
> 
> Any function which use scsi_execute_async() and transfers "odd" sized data
> that doesn't align correctly with the segment sizes may have its transfer
> length padded out to the closest segment size.
	I would like to strongly suggest that Mike Christie's patch be used instead.
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg06032.html


I finally hit the case he was talking about (the block layer retries 0 length commands caused by a size mismatch) and 
its ugly. I'm not really sure why my initial tests weren't hitting that case, I was trying to understand why some blocks 
were getting an extra command generated while others weren't.  Sufficient to say, his patch fixes both problems, the 
incorrect transfer lengths and the extra 0 length transfer being generated.



