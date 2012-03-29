From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result
 correctly when SRB status is INVALID
Date: Thu, 29 Mar 2012 09:02:14 +0100
Message-ID: <1333008134.2823.15.camel@dabdike>
References: <1332115915-26805-1-git-send-email-kys@microsoft.com>
	 <1332115963-26855-1-git-send-email-kys@microsoft.com>
	 <1332173560.3152.65.camel@dabdike>
	 <6E21E5352C11B742B20C142EB499E0481B769E88@TK5EX14MBXC126.redmond.corp.microsoft.com>
	 <1332196819.3152.77.camel@dabdike>
	 <6E21E5352C11B742B20C142EB499E0481B76A16D@TK5EX14MBXC126.redmond.corp.microsoft.com>
	 <1332233502.14019.14.camel@dabdike.int.hansenpartnership.com>
	 <6E21E5352C11B742B20C142EB499E0481B76AF70@TK5EX14MBXC126.redmond.corp.microsoft.com>
	 <1332749776.2836.15.camel@dabdike>
	 <6E21E5352C11B742B20C142EB499E0481B775A8A@TK5EX14MBXC124.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44189 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066Ab2C2ICS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Mar 2012 04:02:18 -0400
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481B775A8A@TK5EX14MBXC124.redmond.corp.microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2012-03-27 at 15:32 +0000, KY Srinivasan wrote:
> > > > James, unfortunately based on the current SRB codes I get back from the
> > > > host, I don't know which commands that failed ought to be retried and which
> > > > ones should not be; I simply get a single SRB error code for cases where the
> > > > host filtered the unsupported commands as well as the case where the host
> > > > supported the command and something failed in the command execution.
> > > > If there is something I can try in this driver to fix this problem, I am more than
> > > > happy to try it. If it involves getting changes into  the host (win8, win2k8 etc.),
> > > > I am willing to start a conversation with the relevant teams, but I cannot
> > > > obviously determine when such changes will ship. However, I do need
> > > > solution for the problem now.
> > > >
> > > > I appreciate your taking the time to help me gravitate towards the
> > > > correct solution here. Given my constraints, let me know what is the
> > > > best way forward here.
> > >
> > > Ping.
> > 
> > On what? What don't you understand about the above?
> > 
> > The failure path needs to look like the following metacode
> > 
> > case SRB_whatever
> > 
> > if (retryable command)
> > 	return DID_TARGET_FAILURE
> > else
> > 	setup sense and error
> > 	return DID_PASSTHROUGH
> > 
> 
> Thanks James and I am sorry for taking so much of your time. I suspect the check for
> retryable commands is to be based on the sense data that might be available. Assuming 
> this is what you had in mind, as I look the  scsi_error.c, scsi_check_sense() appears to
> do what I would need here. Would you be willing to take patch that exports this function.
> Or, is there a better way to identify commands that would be re-tried.

Erm, no, I was thinking of something much more simple.  Right at the
moment if (retryable_command) is if (scmnd->cmnd[0] != ATA_16)

Although I'm sure there are other commands that are not retryable ... I
don't really know since I'm not sure what else your hypervisor will
choke on.  It might be simpler to have a list of known good retryable
commands (READ_ WRITE_ GET_CAPACITY_ INQUIRY etc. i.e. the commands sd
normally uses) and assume anything outside that range isn't retryable
but someone who knows what's going on in the hypervisor needs to decide
this.

The point is that you don't pre-filter.  You send the command and then
try and work out from the generic error and the type of command you sent
what happened.  That way, if the hypervisor ever works properly (or
simply passes commands through to real devices) it will "just work"
rather than failing because of the pre-filter.

We should only use the pre-filter if the effects of the command are
fatal (like we have to a lot in USB because the firmware crashes and
hangs).

James


