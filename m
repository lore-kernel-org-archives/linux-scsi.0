From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd_dif.c use unaligned access helpers
Date: Sat, 26 Jul 2008 08:26:16 -0400
Message-ID: <yq1vdysj0gn.fsf@sermon.lab.mkp.net>
References: <1216854460.30386.32.camel@brick>
	<yq1od4l8eb2.fsf@sermon.lab.mkp.net> <1217049240.5971.51.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:15995 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYGZMcZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2008 08:32:25 -0400
In-Reply-To: <1217049240.5971.51.camel@brick> (Harvey Harrison's message of "Fri\, 25 Jul 2008 22\:14\:00 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

>>>>> "Harvey" == Harvey Harrison <harvey.harrison@gmail.com> writes:

Harvey> So who cares what the spec says, the code is treating it as a
Harvey> host-order u16 everywhere.  Similarly for the ref_tag.

Hold on.  We don't know the personality of the ref_tag.

This is convoluted and I totally agree it's icky.

Each DIF tuple consists of 8 bytes.  The interpretation of those 8
bytes depends on how the disk is formatted.  For Type 1, 2 and 3 the
first two bytes contain the guard_tag, a big endian CRC of the data
portion of the sector.  That part is easy.

The next two bytes are defined to be for use by the application client
(i.e. OS).  The current SCSI spec doesn't say anything about the
contents or how they should be interpreted.

The last four bytes (reference tag) are defined as a big endian entity
for Type 1 and 2.  But with Type 3 the last four bytes become part of
the opaque tag space.  You can view is as they get combined with the
app tag to provide 6 bytes of space.

IOW, for Type 1 + 2 the ref tag is big endian.  For Type 3 it is
undefined.

Also, for DIF Type 4 that's currently being discussed the application
tag will be used for a hash that's defined to be big endian.

So the problem is that the endianness depends on how the attached disk
is formatted.

For now we can switch the app_tag to be host endian.  The only
workaround I can think of for the ref_tag is to introduce struct
sd_dif_tuple_type12 and struct sd_dif_tuple_type3 which use __be32 and
u32 respectively.

I'll muck with that later.  But first I have to finish my OLS
slides...

-- 
Martin K. Petersen	Oracle Linux Engineering

