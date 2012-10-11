From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
Date: Thu, 11 Oct 2012 14:34:00 +0100
Message-ID: <20121011143400.49f79a7f@pyramind.ukuu.org.uk>
References: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com>
	<1349951069.2425.44.camel@dabdike.int.hansenpartnership.com>
	<5076AE3B.5040509@imgtec.com>
	<1349960296.2425.53.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349960296.2425.53.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> > The alignment is fine (the offset of the u16 is 8 bytes), but
> > unfortunately with the metag port of gcc, sizeof(struct
> > scsi_varlen_cdb_hdr) is rounded up to a 4 byte boundary (even though the
> > largest data member alignment is only 2 bytes), which is 12 bytes
> > instead of 10.
> 
> That sounds to be a bug in your compiler ... it shouldn't be rounding up
> structure sizes if the structure can fit in 10 bytes.  This isn't
> happening in any other architecture that I know of (otherwise we'd have
> had a reported build break).

It's not a bug for the alignment rules of the processor as far as I can
see. The architectural definition is perfectly entitled to have tail
padding in this case.

The x86 equivalent would be

struct foo {
	double x;
	int a;
};


which is *NOT* 12 bytes long.

It is indeed a portability bug in the scsi layer.

Alan
