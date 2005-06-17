From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: SCSI commands order when using scsi_do_req
Date: Fri, 17 Jun 2005 13:08:41 +0400
Message-ID: <42B29319.5050704@vlnb.net>
References: <OFE0914CA0.DA8D0415-ONC2257014.004F2855-C2257014.00603EFB@il.ibm.com> <1117734886.5025.55.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.infobox.ru ([195.208.235.29]:4771 "EHLO
	relay02.infobox.ru") by vger.kernel.org with ESMTP id S261745AbVFQJKZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 05:10:25 -0400
In-Reply-To: <1117734886.5025.55.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Liran Schour <LIRANS@il.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2005-06-02 at 20:31 +0300, Liran Schour wrote:
> 
>>I am developing a new SCSI upper layer driver. (Object based SCSI device)
>>I noticed that scsi_do_req execute commands in LIFO order (add new commands
>>to the head of the Q).
>>This behavior can cause a starvation of commands (or at least long delays).
>>What is the proper solution to this?
> 
> 
> Well, to use the proper interfaces.
> 
> scsi_do_req is deprecated, so don't use it.  scsi_wait_req is its
> replacement.  Note: they're only really intended to allow ULDs to
> execute commands that are necessary for controlling the device (that's
> why they go at the head of the queue).  Block commands are executed in
> order using ULD init_command() (or REQ_BLOCK_PC).

Hm, st/osst/sg use scsi_do_req(), so should we consider those drivers 
broken in async mode? Apparently, a user in this mode could write not 
what he/she intented, the order could be wrong. Or do I miss something?

Vlad
