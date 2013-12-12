From: Wakko Warner <wakko@animx.eu.org>
Subject: Help with mpt2sas kernel message
Date: Thu, 12 Dec 2013 12:04:59 -0500
Message-ID: <20131212170459.GD13674@animx.eu.org>
Reply-To: Wakko Warner <wakko@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:45399 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab3LLRZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Dec 2013 12:25:19 -0500
Received: from wakko by animx.eu.org with local
	(Exim 4.69 #3 (Debian Bug?  What bug /\oo/\))
	id 1Vr9h5-000114-JY
	for linux-scsi@vger.kernel.org; Thu, 12 Dec 2013 12:04:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Kernel: vanilla 3.7.2.

I have 2 mpt2sas controllers.  I'm running a md check on the 2 arrays that I
have (one per card).  I'm seeing this in my kernel log (last 4 lines):
2013-12-10 19:52:10 kame kernel:[1558186.193904] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2013-12-10 19:52:35 kame kernel:[1558211.606908] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2013-12-10 19:53:02 kame kernel:[1558237.954502] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
2013-12-10 19:53:50 kame kernel:[1558286.227318] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)

Can someone tell me if there is a problem here?

I'd also like to know which card mpt2sas0 is.  Is it the one that has the
lower numbered pci bus?  I was unable to figure that out from
/sys/bus/pci/drivers/mpt2sas.

The contents are:
lrwxrwxrwx 1 root root    0 Dec 10 19:49 0000:03:00.0 -> ../../../../devices/pci0000:00/0000:00:05.0/0000:03:00.0/
lrwxrwxrwx 1 root root    0 Dec 10 19:49 0000:04:00.0 -> ../../../../devices/pci0000:00/0000:00:07.0/0000:04:00.0/

lspci for those:
03:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
04:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 02)

I am able to figure out which drives are on which of these controllers from
/sys/block

So far, I'm not seeing any data errors.  Although drives on 03:00.0 appear
to be running slower than the ones on 04:00.0 according to /proc/mdstat.  No
drives are actually in use other than the check that is running.

I posted to linux-kernel@ but I didn't receive a reply and thought this list
would be better suited.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
