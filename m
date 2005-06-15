From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] expand information in the scsi_sense_hdr
Date: Wed, 15 Jun 2005 09:04:44 -0500
Message-ID: <1118844284.5045.9.camel@mulgrave>
References: <1118719534.5079.93.camel@mulgrave>
	 <42AFADAD.4080307@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:51878 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261445AbVFOOEr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 10:04:47 -0400
In-Reply-To: <42AFADAD.4080307@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-06-15 at 00:25 -0400, Douglas Gilbert wrote:
> Another disadvantage is that it doesn't cope with
> the newer descriptor fields that don't have equivalents
> in the older fixed format. OSD and SAT have their own
> sense descriptors. Vendors can (and do) have fixed sense
> data (defined beyond offset 18 and field replaceable unit)
> and can add their own sense descriptors [0x80 to 0xff].
> Mapping extensible descriptor format (still limited to 252
> bytes overall) back to a (different) fixed format could
> be self defeating.

Remember that the only use is for internal, so if no-one's interested in
the information it doesn't matter if we don't use it.  If someone
becomes interested in OSD or SAT descriptors, they can add them
(currently OSD is rather expensive and rare and SAT is the province of
SAS which is still under discussion).  However, the only use currently
is Filemark, ILI and EOM which are really only a property of SSC and
SBC.

> My intention with struct scsi_sense_hdr was to give
> a small fixed size view of sense data (from either
> fixed or descriptor format) sufficient for drivers
> to do error processing. It is sufficient for many but
> not all cases in drivers that I converted. I was not
> trying to replace the sense data. Is the actual sense
> data still going to be available to the SG_IO ioctl
> and the sg driver?

All commands that report sense data back to the user still send the raw
sense data.  Like I said, the sense header is for internal kernel use.

> BTW If you implement this change, I don't think
> field member "u8 byte4;" and friends are any longer
> relevant as that was to maintain the mapping between
> "struct scsi_sense_data" and the descriptor format
> sense data header (i.e. both 8 bytes long).

OK, I'll junk those, thanks.

James


