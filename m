From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: HBAAPI
Date: Thu, 8 Apr 2004 17:57:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF50EFA17B.110888B8-ONC1256E70.0051B96E-C1256E70.005237AD@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:30604 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S261987AbUDHP55
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 11:57:57 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Smart, James" <James.Smart@Emulex.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org





"Smart, James" <James.Smart@Emulex.com> wrote:

> Folks,

Hi,

> We are reviewing ioctls in our driver and would like some input from
> the community :)

> We have a fair number of ioctls which provide the functionality of
> HBAAPI.  HBAAPI is a user-level API for interacting with/configuring
> FC HBAs. There are similar efforts occuring for iSCSI, etc.

I've implemented a first stage of the HBA API for the zfcp lldd on
s390 for kernel 2.4. The kernel-user-space communication is also done
via ioctls.

> The jist of HBAAPI is that each vendor supplies a "provider" module
> that implements the API for the specific hardware. Ours converts
> into a lot of ioctls. We see this as a great opportunity to remove
> the need for a vendor-specific provider module, and simply have a
> standard API, supported by linux FC drivers. There is already a
> sample application and template provider over on SourceForge that
> can be leveraged. We are offering to ante up a proposal for this
> API.

I agree with you.
I think the model described in FC-HBA with a wrapper library and
several vendor libraries maps in Linux to one HBAAPI library, one
"hbaapi"-module (or class) and FC device drivers that register
themselves at the "hbaapi"-module (or class).

I am looking forward to see your proposal. And I offer you to
collaborate in this work.

> Has there been any thoughts/efforts in doing this in the past ? Any
> recommendations for how this should be implemented ?  Any general
> thoughts?

Just some general thoughts about the communication between the kernel
module and the library.

(1) The attributes for adapters, ports etc. could be represented as a
sysfs tree. The library just reads/writes from/to the tree.  Drawbacks
are:

- Performance: too much effort to collect many attributes and convert
the strings into binary data from sysfs if the library handles an HBA
API call

- How to avoid raises if data is (subsequently) collected from
different sysfs attributes for one HBA API call.

- How to implement HBA API calls that send requests into the SAN via
sysfs?

(2) Use binary attributes in sysfs

- up to now not much documented (or lets say: I did not yet feel like
reading the sources;-)

(3) Use ioctl interface

- Seems to me the most obvious way for an implementation

About the kernel module (or device class) and how an lldd has to
register _which_ set of functions ... Hmm, don't know yet.

Of course the kernel module has to care for several things that usually
(up to now) reside in the library. (event handling, tables of available
adapters and ports etc.)

> A couple of additional notes:

> Some of the payload/buffer sizes for the API can exceed 4k in
> size. Thus, moving them to sysfs and potentially converting them to
> multiple operations is problematic.  Right now, the thought is to
> leave them as ioctls.  If you have other ideas, let me know.

I vote for ioctls .

> HBAAPI provides an interface for setting persistent device
> mappings. What are the current thoughts on how driver-level
> persistent data should be maintained/saved/etc ?

> Thanks

> -- James S.

BTW, what/where is the sample application at SoureForge you mentioned
above? (Hope it has nothing to do with hbaverify and the
HBA API Common Library at SourceForge.)


Regards,

Andreas

