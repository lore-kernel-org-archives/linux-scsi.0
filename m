From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Tue, 29 Jul 2008 13:32:43 +0400
Message-ID: <488EE3BB.1020906@vlnb.net>
References: <488E02DE.5080100@vlnb.net> <1217267776.3503.112.camel@localhost.localdomain> <20080729042701.GA30333@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:37168 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753680AbYG2Jcr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 05:32:47 -0400
In-Reply-To: <20080729042701.GA30333@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

Christoph Hellwig wrote:
> On Mon, Jul 28, 2008 at 12:56:16PM -0500, James Bottomley wrote:
>> On Mon, 2008-07-28 at 21:33 +0400, Vladislav Bolkhovitin wrote:
>>> This patch fixes race on dpc_thread field of struct scsi_qla_host,
>>> which can lead to crash on the module unload.
>>>
>>> This patch is against 2.6.26
>> I'm afraid adding a lock is almost certainly the wrong way to handle
>> this type of failure.  What should be done is to make sure the qla is
>> correctly shut down (i.e. no tasks requiring the dpc_thread can be
>> performed) *before* killing the thread ... it sounds like shutdown is
>> slightly broken in the current driver ... could you post the oops
>> details and we can try to work out what the problem is
> 
> I'm not even sure it's the current driver as he mentions that he using
> some out of tree target driver which might be the problem.
> 
> Can you reproduce it with a stock 2.6.27-rc tree?

The race is still in 2.6.27-rc1.

Vlad


