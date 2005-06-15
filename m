From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] expand information in the scsi_sense_hdr
Date: Wed, 15 Jun 2005 00:25:17 -0400
Message-ID: <42AFADAD.4080307@torque.net>
References: <1118719534.5079.93.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:5307 "EHLO
	tomts36-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S261487AbVFOEYy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 00:24:54 -0400
In-Reply-To: <1118719534.5079.93.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Since the scsi_execute_req() call is trying to make this the standard
> way of passing back sense (mainly because scsi_execute_req() is designed
> for internal consumption, which has more simple sense parsing
> requirements) there needs to be enough information in the header for all
> sense uses within the kernel.
> 
> This patch adds the info field, the flags field, the sense key specific
> field and the command info field to the sense header.  The disadvantage
> is that it adds nineteen bytes to the sense header.

Another disadvantage is that it doesn't cope with
the newer descriptor fields that don't have equivalents
in the older fixed format. OSD and SAT have their own
sense descriptors. Vendors can (and do) have fixed sense
data (defined beyond offset 18 and field replaceable unit)
and can add their own sense descriptors [0x80 to 0xff].
Mapping extensible descriptor format (still limited to 252
bytes overall) back to a (different) fixed format could
be self defeating.

My intention with struct scsi_sense_hdr was to give
a small fixed size view of sense data (from either
fixed or descriptor format) sufficient for drivers
to do error processing. It is sufficient for many but
not all cases in drivers that I converted. I was not
trying to replace the sense data. Is the actual sense
data still going to be available to the SG_IO ioctl
and the sg driver?

BTW If you implement this change, I don't think
field member "u8 byte4;" and friends are any longer
relevant as that was to maintain the mapping between
"struct scsi_sense_data" and the descriptor format
sense data header (i.e. both 8 bytes long).

Doug Gilbert
