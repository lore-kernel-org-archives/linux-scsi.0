From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Fri, 10 Feb 2006 09:04:55 -0500
Message-ID: <1139580295.3084.3.camel@mulgrave.il.steeleye.com>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com>
	 <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de>
	 <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de>
	 <1139265890.3022.63.camel@mulgrave.il.steeleye.com>
	 <20060209200529.GA8968@suse.de>  <20060210101124.GA6253@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61882 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932090AbWBJOFH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 09:05:07 -0500
In-Reply-To: <20060210101124.GA6253@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-02-10 at 11:11 +0100, Olaf Hering wrote:
> 550 reboots without crash, with this patch reverted.
> Will try the execute_in_process_context thing now.

I wouldn't bother ... because of the structure, the
execute_in_process_context() patch must have the same bug, but the
context check will make it much more difficult to hit.

Go back to the original and see if you can diagnose what is NULL and
why.  The target is supposed to have a reference on the parent, so what
was the parent in this case?  If it's a host, there's nothing I can
think of that can produce the behaviour you see; if it's something else,
like an rport or phy then we may have a transport class issue.

James


