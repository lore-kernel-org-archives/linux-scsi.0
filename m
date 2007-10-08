From: Stefan Rutzinger <rutzi@fs.tum.de>
Subject: Re: /dev/sda with 8 byte offset
Date: Mon, 8 Oct 2007 21:07:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710082045060.26022@valhalla.fs.tum.de>
References: <Pine.LNX.4.64.0709262121040.17048@valhalla.fs.tum.de>
 <46FAC72F.5020304@s5r6.in-berlin.de> <Pine.LNX.4.64.0709271916470.23129@valhalla.fs.tum.de>
 <tkrat.2208603358dde0a4@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlas.fs.tum.de ([129.187.202.11]:36721 "EHLO atlas.fs.tum.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXJHTH5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Oct 2007 15:07:57 -0400
In-Reply-To: <tkrat.2208603358dde0a4@s5r6.in-berlin.de>
Content-ID: <Pine.LNX.4.64.0710082059261.26022@valhalla.fs.tum.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

Hi,

thanks to my stupidity I found out only last weekend that `scsiinfo -i` in 
fact does create the fifo offset behaviour. However, `scsiinfo -a` as 
stefan described does not (this is why I haven't tried `-i` up to now).

Well, the good news is that almost any other queries of scsiinfo instead 
of INQUIRY resets the device to its normal behaviour.

And there's another workaround: Stop udevd before connecting the device 
and manually create the node /dev/sda. udevd is the bad guy who does the 
INQUIRY to detect the connected hardware.

And yes, the firmware is crap. At USB, scsiinfo is only useful as a very 
poor random generator. The output is only garbage from each command to the 
next. However, I won't risk a firmware update up to now.

Many thanks to Stefan Richter and Al Viro.

Stefan

