From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Date: Fri, 18 Nov 2011 11:00:31 -0600
Message-ID: <1321635631.3022.44.camel@dabdike.int.hansenpartnership.com>
References: <1320776028-29568-1-git-send-email-kys@microsoft.com>
	 <1321554393.3041.77.camel@dabdike.int.hansenpartnership.com>
	 <6E21E5352C11B742B20C142EB499E0481AA6D232@TK5EX14MBXC128.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA6D232@TK5EX14MBXC128.redmond.corp.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-11-18 at 04:53 +0000, KY Srinivasan wrote:
> > I still think you need to disable clustering and junk the bvec merge
> > function.  Your object seems to be to accumulate in page size multiples
> > (and not aggregate over this) ... that's what clustering is designed to
> > do.
> 
> As part of addressing your first round of comments, I experimented with your
> suggestions and I could not get rid of the code that does the bounce buffer handling.
> I could generate I/O patterns that would require bounce buffer handling with your
> suggestions in place.

There are two separate things here.  One is the scatter gather list
bounce buffer processing, which is a bit nasty, but if you want to use <
4kb block size filesystems, I suppose I have to accept that you need it
(although since it's a global fault of the hypervisor, perhaps it should
sit in the hypervisor interface layer, so that every SG based transport
can use it).  The other is the biovec merge function addition.  The
purpose of this function seems to be to ensure you get one SG entry for
every page (if I read it right)?  In that case, you don't need any of
this special casing.  The flag DISABLE_CLUSTERING achieves the same
thing.

James
