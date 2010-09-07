From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: Cache synchonization timeouts after drive hot-unplug
Date: Tue, 7 Sep 2010 13:35:01 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040805DBCBF94@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8697 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab0IGMfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 08:35:05 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello folks,

I have encountered the following problem while running our SAS driver 
with libsas:
If we hot-unplug a drive that was attached via an expander, libsas starts
sas_revalidate_domain() and discovers that the expander phy is empty.
Then libsas starts to remove the device, eventually calls the sd layer
that tries to synchronize cache.
Synchronization retries cause a significant delay before libsas
finally call SAS driver with sas_notify_lldd_dev_gone().

Some time ago there was a fix proposal for libsas:
"Don't issue commands to devices that have been hot-removed"
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12110.html
but as I understand it was not accepted...

Isn't it a bug?
Should libsas forward commands to devices that are known to be missing?

I'll appreciate any feedback.
Thanks,
Maciek Trela.


