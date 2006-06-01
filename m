From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Thu, 01 Jun 2006 19:14:05 +0600
Message-ID: <447EE81D.2050906@ums.usu.ru>
References: <20060511143352.GI12272@parisc-linux.org> <20060518172258.GL1604@parisc-linux.org> <20060529031915.GB23405@parisc-linux.org> <447AB2F5.2000700@s5r6.in-berlin.de> <20060529130515.GE23405@parisc-linux.org> <20060531232139.GA3202@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay4.usu.ru ([194.226.235.39]:35761 "EHLO relay4.usu.ru")
	by vger.kernel.org with ESMTP id S1750943AbWFANOL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2006 09:14:11 -0400
Received: from relay4.usu.ru (localhost [127.0.0.1])
	by relay4.usu.ru (PostSystem) with ESMTP id 3A1013F8C
	for <linux-scsi@vger.kernel.org>; Thu,  1 Jun 2006 19:14:13 +0600 (YEKST)
Received: from usu2.usu.ru (usu2.usu.ru [194.226.237.16])
	by relay4.usu.ru (PostSystem) with ESMTP id BEBF23FE9
	for <linux-scsi@vger.kernel.org>; Thu,  1 Jun 2006 19:14:12 +0600 (YEKST)
Received: from localhost.usu2.usu.ru (localhost.usu2.usu.ru [127.0.0.1])
	by usu2.usu.ru (Postfix) with ESMTP id 79A8FA7EBA
	for <linux-scsi@vger.kernel.org>; Thu,  1 Jun 2006 19:14:06 +0600 (YEKST)
Received: from ums.usu.ru (ums.usu.ru [194.226.236.116])
	by usu2.usu.ru (Postfix) with ESMTP id 0C265A7A35
	for <linux-scsi@vger.kernel.org>; Thu,  1 Jun 2006 19:14:06 +0600 (YEKST)
In-Reply-To: <20060531232139.GA3202@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-hotplug-devel@lists.sourceforge.net, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
>> That's what scsi_complete_async_scans() is for.  If you have a built-in
>> module, it will wait for the async scans to finish before we get as far
>> as trying to mount root.  It does change observable behaviour in that
>> sys_module_init() will return before scans are complete.

What are the expected interactions of this code with early userspace aka "kinit" 
that comes with (soon to be merged) klibc? Does this scsi_complete_async_scans() 
function get called at all if such "default" initramfs with kinit is used?

The problem is that if it doesn't, kinit will not wait.

-- 
Alexander E. Patrakov
