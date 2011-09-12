From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: NAA breakage
Date: Mon, 12 Sep 2011 00:35:36 -0700
Message-ID: <1315812936.12904.144.camel@haakon2.linux-iscsi.org>
References: <4E494F9F.4000909@zoner.cz>
	 <1313522082.2853.10.camel@haakon2.linux-iscsi.org>
	 <4E4BAB1D.6070104@zoner.cz>
	 <1313618333.9928.61.camel@haakon2.linux-iscsi.org>
	 <4E528F05.9090208@zoner.cz>  <4E6A0618.3040102@zoner.cz>
	 <1315604283.7420.58.camel@haakon2.linux-iscsi.org>
	 <4E6B7B76.4090805@zoner.cz>
	 <1315687061.12709.52.camel@haakon2.linux-iscsi.org>
	 <4E6CA0E6.8080300@zoner.cz>  <4E6CBEED.1090507@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53849 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1ILHfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2011 03:35:45 -0400
In-Reply-To: <4E6CBEED.1090507@bootc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Cc: Martin Svec <martin.svec@zoner.cz>, target-devel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2011-09-11 at 15:00 +0100, Chris Boot wrote:
> On 11/09/2011 12:52, Martin Svec wrote:
> > thanks a lot for your comments. Clearly there was a misunderstanding 
> > of who is the vendor that defines what is "vendor-specific" in case of 
> > LIO. Of course, it is easy for me to fix my userspace code to generate 
> > serial numbers without these issues. But I suggest to enforce 
> > vpd_unit_serial restrictions in configfs code because rtslib/lio-utils 
> > is just a referential userspace implementation, not a kernel ABI.
> 
> I feel it's time to add my 2 cents to this discussion. A vendor-specific 
> identifier in my mind could very well be what Martin uses it for, in my 
> opinion - at least according to SPC-3.

To clarify a point wrt to the per device EVPD 0x80 vpd_unit_serial
configfs attribute.  SPC-4 recommends using vpd_unit_serial as part of
the vendor specific identifier for T10 vendor ID based DESIGNATOR in
EVPD 0x83.  This is described in 7.8.5.4 as:

"The organization associated with the T10 vendor identification is
responsible for ensuring that the VENDOR SPECIFIC DESIGNATOR field is
unique in a way that makes the entire DESIGNATOR field unique.
A recommended method of constructing a unique DESIGNATOR field is to
concatenate the PRODUCT IDENTIFICATION field from the standard
INQUIRY data and the PRODUCT SERIAL NUMBER field from the Unit Serial
Number VPD page."

This is what target does for EVPD 0x83 using the T10 vendor designator
variable length method, and as well for modern NAA IEEE Registered
Extended designator using a fixed byte length.

> If the LIO stack cannot handle 
> such use of identifiers the configfs code should refuse to accept such 
> an identifier. If for example the LIO code only creates a valid NAA/WWN 
> from a hex string of a certain length, it should only accept a hex 
> string of that length. It should not be a requirement to exactly follow 
> what rtslib does in every case.
> 
> Of course the way I see it the vendor specific identifier doesn't 
> necessarily have anything to do with the NAA/WWN, so it would be nice if 
> one could set both a WWN as a hex string of the correct length and 
> format, and a vendor-specific string in a mostly freeform manner as long 
> as it abides by SPC-3. The WWN shouldn't necessarily be generated from 
> the vendor identifier.
> 

As target emulation for 0x83 designators are both based on
vpd_unit_serial attribute to provide uniqueness, the current code allows
up 254 bytes supporting variable length designators exceeding what is
defined for individual NAA IEEE Registered fixed lengths and striping
off the remaining bytes.

The intention here is for the two EVPD 0x83 to contain similar enough
values based on vpd_unit_serial so they can be recognized as the same
LUN from both designators.  So the question is how should the kernel be
formatting input from a configfs attribute who's value is used to
produce freeform ASCII uniqueness for one case, and hex2bin safe
formatted uniqueness for another..?

So sing vpd_unit_serial for the vendor specific identifier area to
ensure uniqueness for the two EVPD 0x83 cases still makes sense to me,
but failing on non hex specific vpd_unit_serial input is likely too
restrictive for all cases.  Stripping of the hex characters from the NAA
IEEE registered vendor specific identifier area is an option for
userspace already using a properly formatted uuid, but this obviously
still requires filesytems who are aware of NAAs designators to update
their on-disk metadata when the '-' is stripped from the uuid ->
vpd_unit_serial input.

--nab


