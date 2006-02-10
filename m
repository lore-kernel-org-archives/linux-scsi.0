From: Brian King <brking@us.ibm.com>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Fri, 10 Feb 2006 15:28:58 -0600
Message-ID: <43ED059A.1080509@us.ibm.com>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com>	 <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de>	 <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de>	 <1139265890.3022.63.camel@mulgrave.il.steeleye.com>	 <20060209200529.GA8968@suse.de>  <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:17066 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932199AbWBJV3W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 16:29:22 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1ALTKK3003907
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 16:29:20 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1ALTK4C245684
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 16:29:20 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1ALTJFG004725
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 16:29:20 -0500
In-Reply-To: <1139580295.3084.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Olaf Hering <olh@suse.de>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2006-02-10 at 11:11 +0100, Olaf Hering wrote:
>>550 reboots without crash, with this patch reverted.
>>Will try the execute_in_process_context thing now.
> 
> I wouldn't bother ... because of the structure, the
> execute_in_process_context() patch must have the same bug, but the
> context check will make it much more difficult to hit.
> 
> Go back to the original and see if you can diagnose what is NULL and
> why.  The target is supposed to have a reference on the parent, so what
> was the parent in this case?  If it's a host, there's nothing I can
> think of that can produce the behaviour you see; if it's something else,
> like an rport or phy then we may have a transport class issue.

Taking a quick look at the scsi_target_reap_work patch that went in,
one of the things it changed in this regard was the fact that the
caller of scsi_target_reap always has a ref to the starget->dev, which
would have protected scsi_target_reap from ever releasing the
starget->dev. Since the actual remove work was moved to a workqueue,
the get and put that the callers of scsi_target_reap are doing is no longer
adding the same protection it was before.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
