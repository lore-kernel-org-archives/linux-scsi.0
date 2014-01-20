From: CrashPlan Pro <linux-scsi@crashplan.pro>
Subject: Re: Disk spin-up optimization during system resume
Date: Mon, 20 Jan 2014 13:38:15 +0100
Message-ID: <52DD18B7.7030303@crashplan.pro>
References: <20140116220409.GA1183@linux.intel.com>	<Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org>	<CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>	<52D9976C.2010009@ubuntu.com>	<CAPcyv4iJScXxpAzH99m6VNHv=vM+96KWgfmv-FH+McnCMb5Vfg@mail.gmail.com>	<52D9F27F.8060705@ubuntu.com> <CAPcyv4i2+GAEV7NNx6MkOOcZSCxhOWB3sCO1eCuH40Z2fhpw3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:57500 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaATM4m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2014 07:56:42 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id 74D3947AFC6
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2014 13:38:25 +0100 (CET)
In-Reply-To: <CAPcyv4i2+GAEV7NNx6MkOOcZSCxhOWB3sCO1eCuH40Z2fhpw3g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Phillip Susi <psusi@ubuntu.com>, SCSI development list <linux-scsi@vger.kernel.org>

Dan Williams wrote at 18-01-14 05:09:
> Larger systems are less likely to ever sleep.

I have to agree with this. There is almost no storage server that will 
be suspended to sleep.

Users of storage servers rather see an improvement at reboot time.

For example by not re-enumerating all 40 / 80 / 100 attached PuiS ATA 
drives or not spinning the drive while enumerating. Only the boot drive 
needs to be spin up. Currently the reboot proces does wake each drive 
that was previously spun down. At a rate of 1 concurrent drive that 
takes approximately 6 seconds to spin up, the re-enumeration part takes 
around 8 minutes during reboot.
