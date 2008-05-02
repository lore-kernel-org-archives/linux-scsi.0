From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [2.6.25] lpfc driver problem
Date: Fri, 02 May 2008 11:31:21 -0400
Message-ID: <481B33C9.5070500@emulex.com>
References: <alpine.DEB.1.10.0804291625330.31652@mtl.rackplans.net> <20080501211659.8a2e0686.akpm@linux-foundation.org> <alpine.DEB.1.10.0805020714500.21142@mtl.rackplans.net>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:62444 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760500AbYEBPbe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 11:31:34 -0400
In-Reply-To: <alpine.DEB.1.10.0805020714500.21142@mtl.rackplans.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Mack <gmack@innerfire.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


Gerhard Mack wrote:
> 
>> On Tue, 29 Apr 2008 16:28:03 -0400 (EDT) Gerhard Mack <gmack@innerfire.net> wrote:
>>
>>> hello
>>>
>>> I'm getting the following error when trying to load the lpfc driver.  This 
>>> is a new install so I have no idea if this is a regression or not.
>>>
>>> dmesg output:
>>> Emulex LightPulse Fibre Channel SCSI driver 8.2.5
>>> Copyright(c) 2004-2008 Emulex.  All rights reserved.
>>> scsi2 :  on PCI bus 02 device 50 irq 24
>>> lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg 
>>> x400000, FW Data: A8 x0 AC x0
>>> lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg 
>>> x400000, FW Data: A8 x0 AC x0
>>>
>>> Card is:
>>> 02:0a.0 Fibre Channel: Emulex Corporation LP8000 Fibre Channel Host 
>>> Adapter (rev 02)
>>> 02:0a.0 0c04: 10df:f800 (rev 02)
>> (Cc's added)

The error indicates that the adapter did not respond to a basic port reset,
which we do before we try to bring up it's messaging interface, etc.
This likely means it failed POST or some other hardware error. The LED's on
the backpanel would have indicated the condition. The LP8000 is a pretty old
board and was EOL'd years ago, so it doesn't surprise me that something like
this could pop up.

> 
> I am no longer able to debug this.  My client took the card back and 
> traded it for a Qlogic.

As much as any vendor hates to see a customer switch :( I understand expediency...

As an fyi - to help the debug, whether it be Emulex or Qlogic, or someone else,
I recommend that you cat the various /sys/class/scsi_host/hostX/* and
/sys/class/fc_host/hostX/* attributes (where hostX corresponds to the scsi? bus\
number assigned to the adapter).  Assuming the adapter attaches enough for these
things to exist, it will give us a lot more information about the adapter for debug.

-- james s

> 
> 	Gerhard
>  
> 
> --
> Gerhard Mack
> 
> gmack@innerfire.net
> 
> <>< As a computer I find your faith in technology amusing.
> 
