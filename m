From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with
	udev
Date: Tue, 01 Apr 2008 15:19:29 -0500
Message-ID: <1207081169.3100.20.camel@localhost.localdomain>
References: <bug-10374-10286@http.bugzilla.kernel.org/>
	 <20080401011518.eb683cff.akpm@linux-foundation.org>
	 <1207059115.3100.9.camel@localhost.localdomain>
	 <20080401210521.abbb443c.seraph@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43650 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209AbYDAUTd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 16:19:33 -0400
In-Reply-To: <20080401210521.abbb443c.seraph@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jos van der Ende <seraph@xs4all.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org

On Tue, 2008-04-01 at 21:05 +0200, Jos van der Ende wrote:
> Hello all,
> 
> 
> I did a bit more testing, and I think this may be related to the order in which modules are loaded.
> 
> If I let udev load sungem, and load sym53c8xx manually, everything works.
> 
> If I let udev load sym53c8xx, and load sungem manually, I get the non-functional network.
> 
> If I let udev load both modules, I also get the non-functional network. While udev loads sungem first and sym53c8xx later, I don't suppose it waits for one module to 'settle' before loading the next. :-)

That's odd ... it's behaving like a resource conflict.  However, the
ports and interrupt trace didn't betray anything.  What does lspci -vv
say for each of the devices?  Also, if you remove the sym2 module in the
problem case, does the sungem come back to life?

I'm afraid I can't see anything relevant looking over the sym2 changes,
so you might need to bisect this to identify the culprit.

James


