From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 08:42:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067355769.1102.17.camel@ronald.kuetemeier.com>
References: <1067313069.1277.17.camel@ronald.kuetemeier.com>
	 <Pine.LNX.4.44L0.0310280959590.793-100000@ida.rowland.org>
	 <20031028071637.B8503@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:30855 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S264025AbTJ1QM4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 11:12:56 -0500
Received: from gw.kuetemeier.com (12-254-105-101.client.attbi.com [12.254.105.101])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id h9SFhfK24576
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2003 07:43:41 -0800
In-Reply-To: <20031028071637.B8503@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, 2003-10-28 at 08:16, Patrick Mansfield wrote:
> On Tue, Oct 28, 2003 at 10:03:06AM -0500, Alan Stern wrote:
> 
> > It's not clear to me what is the best way to take care of the devices that 
> > choke on page 3F.  Should we use a special flag for those devices or 
> > should we disable it entirely?
> 
> I don't know, good question.
> 
> And more generally, should we add devices to the scsi_devinfo.c blacklist,
> and only use the dynamic addition to the black list until the new code is
> available?
> 
> I am still looking at the logs - I don't see any logging of the actual
> failure, and I did not see a failure immediately after the 3f was sent.
> 
As far as I could see the call doesn't fail directly, but as a result
the partition table can not be read. But you have already seen that.

Anyhow, wouldn't it be best to have at least a flag past on from the usb
description of the device about it's capabilities. I.e don't test on 3F
for this device when it connects, instead of having descriptions of the
device in two places. Which are already slightly out of sync,
ie. usb unusual devices reads:
    "Sony",
    "DSC-S30/S70/S75/505V/F505/F707/F717/P8",

while I use "Sony:Sony DSC:" for scsi.
What does black listing mean in this context anyhow? Or I don't want to
patch my kernel all the time.
Thanks for you help,
Ronald

  
> We should first try and get his device working without black listing it.
> 
> -- Patrick Mansfield
> 

