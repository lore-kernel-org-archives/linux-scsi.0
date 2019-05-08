From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mptsas: fix undefined behaviour of a shift of an int by
 more than 31 places
Date: Wed, 08 May 2019 07:24:28 -0700
Message-ID: <1557325468.3196.2.camel@HansenPartnership.com>
References: <20190504164010.24937-1-colin.king@canonical.com>
         <1557027274.2821.2.camel@HansenPartnership.com>
         <de7e3aaf-0155-5007-c228-510f0d0de428@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <de7e3aaf-0155-5007-c228-510f0d0de428@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-05-08 at 14:07 +0100, Colin Ian King wrote:
> On 05/05/2019 04:34, James Bottomley wrote:
> > On Sat, 2019-05-04 at 17:40 +0100, Colin King wrote:
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > Currently the shift of int value 1 by more than 31 places can
> > > result in undefined behaviour. Fix this by making the 1 a ULL
> > > value before the shift operation.
> > 
> > Fusion SAS is pretty ancient.  I thought the largest one ever
> > produced had four phys, so how did you produce the overflow?
> 
> This was an issue found by static analysis with Coverity; so I guess
> won't happen in the wild, in which case the patch could be ignored.

The point I was more making is that if we thought this could ever
happen in practice, we'd need more error handling than simply this:
we'd be setting the phy_bitmap to zero which would be every bit as bad
as some random illegal value.

James
