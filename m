From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
Date: Thu, 19 Jun 2008 20:39:38 +0200
Message-ID: <485AA7EA.6080105@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:51487 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbYFSSkO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2008 14:40:14 -0400
In-Reply-To: <20080619182310.GA30833@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, dsd@gentoo.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

> On Fri, Apr 25, 2008 at 03:11:23AM -0600, Matthew Wilcox wrote:
>> The problem is that USB has one scsi_host per device (rather than, say,
>> having one scsi_host and adding new devices to it as they're found on
>> the USB bus).
>>
>> I'm certainly open to ideas of hooking into the mechanism -- it's just a
>> list of completions after all.  Something like this:
[...]

The problem is AFAIU not exactly how many Scsi_Host instances (initiator 
port representations, or something remotely related to that) are 
instantiated, but rather _when_ they are instantiated.  On multi 
protocol buses or networks like USB and FireWire, it makes sense to 
create the SCSI initiator port representation when we discovered that 
there are actually SCSI targets on the bus or network.

scsi_scan's API is geared towards drivers which create one or more 
initiator port representations right up front before going on target 
discovery, right?
-- 
Stefan Richter
-=====-==--- -==- =--==
http://arcgraph.de/sr/
