From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd_dif.c use unaligned access helpers
Date: Sat, 26 Jul 2008 00:22:41 -0400
Message-ID: <yq1od4l8eb2.fsf@sermon.lab.mkp.net>
References: <1216854460.30386.32.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:20115 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYGZE0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2008 00:26:50 -0400
In-Reply-To: <1216854460.30386.32.camel@brick> (Harvey Harrison's message of "Wed\, 23 Jul 2008 16\:07\:40 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "Harvey" == Harvey Harrison <harvey.harrison@gmail.com> writes:

[Sorry about the delayed response.  I've been traveling for a few
days.]

Harvey> This code should be looked at carefully, while this patch
Harvey> doesn't change any behaviour, the handling of app_tag, ref_tag
Harvey> seems odd.  The struct defines both as __be16/32 but in these
Harvey> locations it is read in/written out as cpu-byteorder.

The opaque tag space (app in Type 1+2, app + ref in Type 3) is
provided for use by filesystems.  The SCSI layer doesn't know anything
about the contents of the tag buffer.  It has no idea whether it
contains bytes, shorts, ints or longs.  So we can't swab on the
assumption that each DIF tuple contains an u16.  Just like we don't
byteswap any other data coming down from above.

Filesystems must prepare tags in an endianness-aware fashion just like
they prepare normal filesystem metadata.  And at the SCSI layer we
treat it as a byte stream.


Harvey> It looks like they should actually be u16/u32.

Guard + ref tags are interpreted by the HBA and storage device and
they are defined to be big endian.

Consequently the DIF tuple tags are defined as __be16 and __be32 to be
in sync with the spec.  But from a protocol perspective the notion of
endianness of the application tag is essentially meaningless.  It is
not interpreted by anybody else than the filesystem.

-- 
Martin K. Petersen	Oracle Linux Engineering
