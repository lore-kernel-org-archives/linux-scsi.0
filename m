From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BusLogic driver reports non-existent disks since VMware 1.0.4
Date: Sun, 16 Mar 2008 16:56:18 -0500
Message-ID: <1205704578.6767.113.camel@localhost.localdomain>
References: <47DD834B.9050807@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51480 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbYCPV4W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Mar 2008 17:56:22 -0400
In-Reply-To: <47DD834B.9050807@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-scsi@vger.kernel.org, lnz@dandelion.com

On Sun, 2008-03-16 at 20:30 +0000, Daniel Drake wrote:
> There's no evidence that this is a BusLogic driver bug (as opposed to 
> being a VMware bug), but as I couldn't find any mention on this list I 
> thought I'd bring it to peoples attention:
> 
> If you upgrade from vmware 1.0.3 to 1.0.4, when using the BusLogic 
> emulation (as opposed to LSI logic), the kernel reports existence of 
> many disks that do not actually exist. Accessing those disks obviously 
> causes hangs and error messages.
> 
> http://communities.vmware.com/thread/103939?tstart=0&start=0
> https://bugs.gentoo.org/show_bug.cgi?id=198296
> 
> dmesg output from such a system:
> https://bugs.gentoo.org/attachment.cgi?id=135371&action=view
> 
> This is similar but not the same as another vmware vs scsi driver problem:
> http://marc.info/?l=linux-scsi&m=118590789115292&w=2
> (that one is different and has been fixed in vmware)
> 
> If anyone is interested in investigating, I can pass on patches to 
> people who can test them.

It does rather look like a vmware emulation problem.  The Short INQUIRY
read:

scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
scsi scan: INQUIRY result too short (5), using 36
scsi 0:0:1:0: Direct-Access                                    PQ: 0 ANSI: 0

Implies the inquiry returned all zeros (length of 5 is because that's
the offset into the INQUIRY of the additional length), which is also a
strong indicator of a vmware issue.

There have been reports of BusLogic Flashpoint working, but that's
practically a separate driver.  The only real way to be sure is for
someone to try it out with a real BT-958 and see.

James


