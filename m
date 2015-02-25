From: brace <brace@pmcs.com>
Subject: RE: [PATCH 06/43] hpsa: hpsa decode sense data for io and tmf
Date: Wed, 25 Feb 2015 18:06:25 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB38D5D65C@BBYEXM01.pmc-sierra.internal>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221221803.21954.76453.stgit@brunhilda>
 <20150223201802.GC11037@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:49628 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbbBYSGh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2015 13:06:37 -0500
In-Reply-To: <20150223201802.GC11037@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Scott Teel <Scott.Teel@pmcs.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, Justin Lindley <Justin.Lindley@pmcs.com>, brace <brace@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is intriguing. And you found a bug in our version of the decode_sense_data function, the ASC/ASCQ bytes are reversed for the descriptor formatted sense data.

Cool.

I'll try to work this in...

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, February 23, 2015 2:18 PM
> To: Don Brace
> Cc: Scott Teel; Kevin Barnett; james.bottomley@parallels.com;
> hch@infradead.org; Justin Lindley; brace; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 06/43] hpsa: hpsa decode sense data for io and tmf
> 
> On Sat, Feb 21, 2015 at 04:18:03PM -0600, Don Brace wrote:
> > +/* extract sense key, asc, and ascq from sense data.  -1 means invalid. */
> > +static void decode_sense_data(const u8 *sense_data, int sense_data_len,
> > +			int *sense_key, int *asc, int *ascq)
> > +{
> 
> Can't you just use scsi_normalize_sense()?
