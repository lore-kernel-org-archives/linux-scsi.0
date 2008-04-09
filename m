From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: errors from mptsas
Date: Wed, 9 Apr 2008 06:53:43 -0400
Message-ID: <20080409105343.GA19104@animx.eu.org>
References: <200804081820.19607.rick@microway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:48174 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbYDIKxs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2008 06:53:48 -0400
Content-Disposition: inline
In-Reply-To: <200804081820.19607.rick@microway.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rick Warner <rick@microway.com>
Cc: linux-scsi@vger.kernel.org

Rick Warner wrote:
> I am working on 2 dual opteron systems using LSI 3041E SAS cards (1064E(b3)).  
> They each have (1) 73G Seagate SAS drive and (2) 750G Seagate SATA drives 
> hooked up to them.
> 
> One of the stress tests we run on systems is looping through the hard drives 
> running "dd if=/dev/sdX of=/dev/null". With that running, we get a steady 
> stream of these errors in the dmesg-
> 
> mptbase: ioc0: LogInfo(0x31123000): Originator={PL}, Code={Abort}, 
> SubCode(0x3000)
> 
> Any idea what's going on here? I have already updated to the latest firmware 
> for the card.  The system is loaded with FC8 running 2.6.24.4-64.fc8.

Join the club.  I have an LSI SAS with 3x 750gb seagate sata drives in
raid5.  Does this happen only on your SATA drives or all the drives?
Depending on the activity, it would drop one of them out of the
array.  I think the problem has been solved for now by changing the
queue_depth to 1.

echo 1 > /sys/block/sdX/device/queue_depth

Here's the drives in my system:
[0:0:0:0]    disk    ATA      ST3750640AS      E     /dev/sda
[0:0:1:0]    disk    ATA      ST3750640AS      E     /dev/sdb
[0:0:2:0]    disk    ATA      ST3750640AS      E     /dev/sdc

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
