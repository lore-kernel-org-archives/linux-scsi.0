From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: MPT fusion SAS target numbering...
Date: Sat, 2 May 2009 16:44:54 -0600
Message-ID: <660360F4F2570145BD872F298951B17A80F01F53@cosmail03.lsi.com>
References: <20090502.151510.127219702.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og60.obsmtp.com ([64.18.14.185]:46953 "EHLO
	chip3og60.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZEBWqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2009 18:46:06 -0400
In-Reply-To: <20090502.151510.127219702.davem@davemloft.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tayfun.kocaoglu@sun.com" <tayfun.kocaoglu@sun.com>, "Greg.Onufer@sun.com" <Greg.Onufer@sun.com>

the sas transport layer is assigning the target id's
________________________________________
From: David Miller [davem@davemloft.net]
Sent: Saturday, May 02, 2009 4:15 PM
To: Moore, Eric
Cc: linux-scsi@vger.kernel.org; tayfun.kocaoglu@sun.com; Greg.Onufer@sun.com
Subject: MPT fusion SAS target numbering...

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
