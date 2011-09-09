From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: NAA breakage
Date: Fri, 09 Sep 2011 14:38:03 -0700
Message-ID: <1315604283.7420.58.camel@haakon2.linux-iscsi.org>
References: <4E494F9F.4000909@zoner.cz>
	 <1313522082.2853.10.camel@haakon2.linux-iscsi.org>
	 <4E4BAB1D.6070104@zoner.cz>
	 <1313618333.9928.61.camel@haakon2.linux-iscsi.org>
	 <4E528F05.9090208@zoner.cz>  <4E6A0618.3040102@zoner.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59408 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938Ab1IIVie (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2011 17:38:34 -0400
In-Reply-To: <4E6A0618.3040102@zoner.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Svec <martin.svec@zoner.cz>
Cc: target-devel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2011-09-09 at 14:27 +0200, Martin Svec wrote:
> Hello folks,
> 
> I'd like to reopen this discussion because there was no conclusion in 
> last three weeks and I still believe that the present implementation 
> of NAA IDs is wrong, regardless of the Andy's Shevchenko patch. Let me 
> explain why:
> 

Hi Martin,

Thanks for your follow-up here Martin.  Getting this resolved for v3.1
is still on my todo list, and the patch I would like to push will be
ready for review in the next days.  My thoughts on your comments are
below.

> (1) According to SCSI SPC-3 (7.6.10), 0x80 VPD unit serial number is a 
> vendor-assigned variable-length string of ASCII data with characters 
> 20h through 7Eh.
> 

Correct

> (2) target_emulate_evpd_83() wrongly assumes that the unit serial 
> number is a hex-encoded string with at least 25 characters and 
> generates NAA ID using hex2bin() from its first 25 chars.
> 

Correct, the fix that I think makes the most sense here is to ensure
that the unit serial number always contains only hex digits (by
stripping out the non hex charactes) when set via configfs in
vpd_unit_serial.

> (3) SCSI SPC-3 (7.6.3.6.4) states that NAA IEEE Registered Extended 
> identifier is a 16-byte fixed-length binary sequence that is 
> _uniquely_ assigned by the organization associated with the IEEE 
> company_id (LIO uses OpenFabrics IEEE ID 00 14 05). That is, NAA ID 
> must be a guaranteed _stable_ worldwide-unique identifier and e.g. 
> VMware strongly relies on this.
> 
>  From (1) and (2) it follows me that LIO does not guarantee the 
> uniqueness and in fact it very easily produces duplicate NAA IDs. For 
> example, unit serial numbers with a common 25-character prefix will 
> necessarily lead to the same NAA ID.

It's the job of userspace to generate a UUID for the unit_serial number,
and to ensure (as much as possible) the UUID is unique.  Taking the
first 25 characters of this value has not created a problem so far.  Can
you give an example of how it's 'very easily' able to produce duplicate
NAA IDs..?

> With Andy's Shevchenko patch, the 
> same also holds for serial numbers that contain only non-hex 
> characters in first 25 bytes, resulting in NAA IDs full of 0xff. And 
> there are other cases where hex2bin() conversion applied to serial 
> numbers leads to duplicates.
> 
> So the way NAA ID is generated from the serial number seems to be 
> broken and does not guarantee NAA ID uniqueness even if the serial 
> numbers are unique and SPC-3 compliant.
> 
> However, I think that the solution is easy:
> 
> (a) Provide a ConfigFS entry for NAA ID to allow userspace to maintain 
> the uniqueness on its own.
> 

I am against exposing the NAA ID as a configfs attribute.  I still think
basing this upon the EVPD 0x80 unit serial still makes the most sense,
and to make userspace ensure (as much as possible) that the UUID -> unit
serial is unique.

> (b) If no ConfigFS NAA ID is specified, target_emulate_evpd_83() 
> should make the best effort to generate unique NAA ID from the unit 
> serial number. An obvious solution is to compute a hash (e.g. SHA1) 
> from the unit serial number and use its 13 most significant bytes to 
> fill vendor-specific NAA ID bytes.
> 

Generating a hash based upon unit serial for the vendor-specific NAA ID
bytes might be useful, but I am still not convinced there is a real
problem of duplicate NAA IDs using UUID based unit seriales for the
vendor specific area..

> Yes, the drawback is that such a change breaks NAA IDs of existing 
> setups. It's a question if it is better to maintain backward 
> compatibility, or fix it while LIO is in mainline for a short time yet.
> 

I think the drawback is worth the extra pain here..  As mentioned, I am
still leaning toward a simple fix to force hex characters for all
vpd_unit_serial values set via configfs.

--nab

