From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/3] zfcp: Don't report device as LUN 0 to SCSI stack
Date: Mon, 18 Jun 2007 09:25:24 -0500
Message-ID: <1182176724.3464.30.camel@mulgrave.il.steeleye.com>
References: <200705291529.54785.swen@vnet.ibm.com>
	 <1182113412.19498.7.camel@mulgrave.il.steeleye.com>
	 <467646A0.3070105@suse.de>
	 <20070618135614.GD3580@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36231 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758722AbXFROZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2007 10:25:26 -0400
In-Reply-To: <20070618135614.GD3580@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schmichr@de.ibm.com

On Mon, 2007-06-18 at 15:56 +0200, Heiko Carstens wrote:
> One of my current disks has an FCP LUN of 0x401040ba00000000... That's just

That's correct and coped with ... SCSI LUNs are BE ... this is still
only a four byte lun ... it actually says Flat Space addressing, 2 level
LUN: 16-168

> the limit that scsilun_to_int() (four bytes that is) still works with.
> Just wondering if there are patches around that make the SCSI stack work
> with eight byte LUNs?

We've been around this several times, but no-one's ever seen a LUN that
goes beyond 2 levels (and our current scheme correctly copes with all 2
level LUNs)... to go beyond 2 level, it's a simple case of converting
the LUN to u64 and updating the accessors, but we still haven't found a
reason to do it yet.

> Otherwise this looks like replacing a broken approach with a different but
> at least incomplete approach. The above LUN would be translated to a SCSI
> stack internal LUN of 1085947920. Hmm... 

The only broken bit about our approach is the fact that we print the
translated value (as you show) which doesn't correspond to the actual
hierarchy.  We could quietly update to use the correct number, but we'd
probably have to change our device ID. For only single level LUs, it's
easy, we still use

H:C:I:L

for flat space, I could see something like

H:C:I:L4-L3-L2-L1

Or we could just combine them into a single enumerated LUN.

For peripheral Encoding, perhaps something like:

H:C:I:B4,L4-B3,L3-B2,L2-B1,L1

Logical Unit addressing is starting to look really horrible: something
like:

H:C:I:T4,B4,L4-T3,B3,L3...

And obviously, there's no translation for the extended address method.

James


