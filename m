From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules
 automatically inserted
Date: Tue, 07 Jul 2009 17:12:03 +0000
Message-ID: <1246986723.6277.63.camel@mulgrave.site>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
	 <4A369320.2080202@redhat.com> <1245365306.4286.27.camel@mulgrave.site>
	 <4A3BDFE8.3090003@redhat.com>  <4A44D37A.10903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58437 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754596AbZGGRMH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2009 13:12:07 -0400
In-Reply-To: <4A44D37A.10903@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de

On Fri, 2009-06-26 at 09:56 -0400, Peter Jones wrote:
> James, I think Chandra and I have responded to most if not all of your points, 
> and would appreciate your thoughts on what we've said.

Well, you didn't respond to the important one:

You're seeking to change the binding of these helpers from manual to
automatic.  This would mean that the modules are loaded in the single
controller case, for which they may not be wanted and also when some
multi path tool other than dm-mp is managing the device, in which case
they may actively interfere with operations.  Your basic contention is
that you "don't see any concern here".  When I ask what testing you've
done for either of these, the studied silence eloquently illustrates
"none".  A policy change like this can't be made without being
incredibly sure we're not going to screw up existing installations.

The second point I made speaks to the technical ugliness of this: what
you're basically doing is open coding multiple binding for a device
handler specific case.  If you can persuade me the policy above is
correct, then technically all this should be done correctly via multiple
binding in the generic device core ... before this interface nastiness
you're constructing propagates outwards and becomes part of the user
ABI.

James


