From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] 2.6 aacraid: endian cleanup
Date: Mon, 28 Mar 2005 15:36:23 -0800
Message-ID: <424894F7.5090103@osdl.org>
References: <1111430484.9918.9.camel@markh1.pdx.osdl.net>	 <20050328215931.GB14148@infradead.org> <1112052522.5560.34.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:23787 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262120AbVC1Xgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 18:36:35 -0500
In-Reply-To: <1112052522.5560.34.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Mark Haverkamp wrote:
> On Mon, 2005-03-28 at 22:59 +0100, Christoph Hellwig wrote:
> 
>>On Mon, Mar 21, 2005 at 10:41:23AM -0800, Mark Haverkamp wrote:
>>
>>>A patch from Adaptec with byte order changes:
>>> - drop byte swapping on all 0's and all 1's content
>>> - fix up missing swapping directives
>>> - ensure swapping on 16 bit values does not use 32 bit swap
>>> - reconcile the readl/writel auto-swapping in only most of the
>>>configurations.
>>
>>that last bit is bogus.  readl/writel are defined to swap bytes on
>>big endian systems.  Whatever broken Mvista/Windriver or whatever port
>>doesn't do that should be fixed.
>>
>>Also please remove unrelated changes like the new cardtypes from the patch,
>>follow normal kernel codingstyle (e.g. ||, && at the end of the line) and
>>switch to __le* types for harware structures and make sure it's passing
>>sparse -Wbitwise.
> 
> 
> Sorry if this is a dumb question, but I haven't used sparse before.  If
> I do a make C=1, will that run sparse with the appropriate options?

sparse doesn't do bitwise by default, so you need to do

make C=1 CHECK="sparse -Wbitwise" drivers/scsi/filename.o  (e.g.)

-- 
~Randy
