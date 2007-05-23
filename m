From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Stgt-devel] Question for pass-through target design
Date: Wed, 23 May 2007 14:45:42 +0400
Message-ID: <46541B56.7000501@vlnb.net>
References: <463B72F6.3000207@torque.net> <20070506053629P.fujita.tomonori@lab.ntt.co.jp> <463F36AC.3010207@vlnb.net> <20070507182837E.fujita.tomonori@lab.ntt.co.jp> <20070522195656.GD5758@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([85.249.135.242]:34476 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758267AbXEWKpv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 06:45:51 -0400
In-Reply-To: <20070522195656.GD5758@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, santil@us.ibm.com, stgt-devel@lists.berlios.de, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Robert Jennings wrote:
>>>>What I meant that is that the kernel tgt code (scsi_tgt*) receives
>>>>SCSI commands from one lld and send them to another lld instead of
>>>>sending them to user space.
>>>
>>>Although the approach of passing SCSI commands from a target LLD to an
>>>initiator one without any significant interventions from the target
>>>software looks to be nice and simple, you should realize how limited,
>>>unsafe and illegal it is, since it badly violates SCSI specs.
>>
>>I think that 'implemented cleanly' means that one scsi_host is assigned
>>to only one initiator.
> 
> Vladislav listed a number of issues that are inherent in an implementation
> that does not have a 1:1 relationship of initiators to targets.  The vscsi
> architecture defines the 1:1 relationship; it's imposible to have more
> than one initiator per target.

Just few small notes:

1. As I already wrote, complete 1:1 relationship isn't practically 
possible, because there is always a local access on the target (i.e. one 
more initiator) and you can't disable it on practice.

2. 1:1 relationship is a serious limitation for usage cases like an SPI 
tape library serving backup for several servers on an FC net.

Vlad
