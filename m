From: Vasily Averin <vvs@parallels.com>
Subject: aacraid controller hangs if kernel uses non-default ASPM policy
Date: Fri, 11 Nov 2011 13:42:05 +0400
Message-ID: <4EBCEDED.7030907@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:1977 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab1KKJmj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2011 04:42:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: Matthew Garrett <mjg@redhat.com>, James Bottomley <jbottomley@parallels.com>, Mark Salyzyn <mark_salyzyn@us.xyratex.com>

Aacraid controller can hang on some nodes if kernel uses non-default (powersave) ASPM policy.
Controller hangs shortly after successful load and hardware detection. Scsi error handler detects this hang and tries to restart hardware but it does not help.

Initially it was noticed on RHEL6-based openVZ kernel after backporting aacraid driver from mainline (RHEL6 kernel with original driver works well)
http://bugzilla.openvz.org/show_bug.cgi?id=2043

This issue happens because default ASPM policy was changed in Red Hat kernels. Therefore guys from Red Hat have noticed this problem long time ago:
on Fedora 12
 https://bugzilla.redhat.com/show_bug.cgi?id=540478
on Fedora 14
 https://bugzilla.redhat.com/show_bug.cgi?id=679385

In RHEL6 kernel this issue was fixed, ASPM was disabled in aacraid driver. In kernel changelog I've found that seems it was done by Matthew Garrett: 
- [scsi] aacraid: Disable ASPM by default (Matthew Garrett) [599735]

However seems this patch was not submitted to mainline. I've reproduced this issue on vanilla 3.1.0 kernel booted with "pcie_aspm.policy=powersave" option,
So I believe it makes sense to do it now.

I've reviewed similar issues and found that similar troubles happen with another hardware too. For example similar patch can be found in e1000 driver.

Btw. It's funny that this problem was not fixed even in newly released Fedora 16 kernel: default policy was changed, but driver was not patched.

Thank you,
	Vasily Averin
