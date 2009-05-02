From: David Miller <davem@davemloft.net>
Subject: MPT fusion SAS target numbering...
Date: Sat, 02 May 2009 15:15:10 -0700 (PDT)
Message-ID: <20090502.151510.127219702.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59537
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754101AbZEBWPQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2009 18:15:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: linux-scsi@vger.kernel.org, tayfun.kocaoglu@sun.com, Greg.Onufer@sun.com


Hello Eric, I have a question about the behavior of the Linux MPT
Fusion SAS driver, and I hope you can clue me in.

The microcode of these cards tracks physical devices and once seen
makes sure the device shows up with the same physical target number
even if you hotplug the SAS disk into a different slot or similar.

But it seems that the Linux driver is totally ignoring the topology
target numbering provided by the SAS topology scan and simply
assigning consequetive indexes, starting at 0, for the target numbers
presented to the Linux SCSI layer.

It puts a virtual target shim in between these two things so that the
mptsas driver can convert the "virtual target" IDs presented to the
Linux SCSI layer into the ones indicated by the SAS topology
information.

Why does it do this?  This breaks a lot of things for me on Sparc, for
example.  There, the device target numbers used by the firmware use
the SAS toplogy provided target numbering, whereas the Linux driver
uses this (seemingly arbitrary) linear assignment.
