From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules
 automatically inserted
Date: Thu, 18 Jun 2009 17:48:26 -0500
Message-ID: <1245365306.4286.27.camel@mulgrave.site>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
	 <4A369320.2080202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41927 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758510AbZFRXFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2009 19:05:54 -0400
In-Reply-To: <4A369320.2080202@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de

On Mon, 2009-06-15 at 14:29 -0400, Peter Jones wrote:
> On 04/27/2009 02:06 PM, Chandra Seetharaman wrote:
> > Hello,
> > 
> > Currently, SCSI targets doesn't have modalias support. It wasn't an issue
> > until SCSI device handler came along.
> > 
> > We want the SCSI device handler modules to be insmodded automatically
> > when the specific SCSI targets are probed and found.
> > 
> > This set of patches adds the modalias support for SCSI targets and
> > also makes the relevant changes to SCSI device handler modules to 
> > make use of it.
> > 
> > Applies cleanly on 2.6.30-rc3 and is tested on the same.
> > 
> > Please review and consider this for inclusion.
> > 
> > Originally sent on March 17 2009 (http://marc.info/?l=linux-scsi&m=123734001009654&w=2).
> > 
> > Resending after testing on 2.6.30-rc3 and with an ack from Hannes.
> 
> Was there ever any followup to this?

OK, since I've forgotten where we are, let me summarise what I think the
situation is (correct me if I misstate any of the facts):

This code adds no functional value to the kernel because dm already
autoloads the correct handlers based on the inquiry strings

The only value it adds is that by overloading the module table with the
inquiry strings, mkinitrd pulls in the correct dm handlers for the state
the system was in.

the unaddressed problems are:

The kernel now tries to load the dm handler for the device dynamically
whether or not the user is actually deploying multi-path (previously dm
does this and if it's not loaded, that doesn't happen).  It's entirely
unclear whether this would interfere with proprietary multipath handlers
or even cause problems in single path systems which were designed that
way.

So as I see it, the functional benefit to a running kernel is zero and
the functional risk exists but is unquantified, so it seems far better
simply to solve this issue in mkinitrd.

James


