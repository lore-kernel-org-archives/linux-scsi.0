From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
	slot is freed)
Date: Thu, 13 Aug 2009 13:31:15 -0700
Message-ID: <46b8a8850908131331g5b40a9c8j17bd80c8ba13a55f@mail.gmail.com>
References: <200908122007.43522.ngupta@vflare.org>
	 <Pine.LNX.4.64.0908122312380.25501@sister.anvils>
	 <20090813151312.GA13559@linux.intel.com>
	 <20090813162621.GB1915@phenom2.trippelsdorf.de>
	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>
	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>
	 <1250191095.3901.116.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932437AbZHMUbU@vger.kernel.org>
In-Reply-To: <1250191095.3901.116.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, david@lang.hm, Markus Trippelsdorf <markus@trippelsdorf.de>, Matthew Wilcox <willy@linux.intel.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>, Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 13, 2009 at 12:18 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Actually, I think, if we go in-kernel, the discard might be better ti=
ed
> into the block plugging mechanism. =A0The real test might be no
> outstanding commands and queue plugged, keep plugged and begin
> discarding.

I am very interested in this topic, as I have implemented UNMAP
support in SCST and scst_local.c and ib_srp.c for one SSD vendor, as
well as the block layer changes to have it work correctly (they were
minor changes and based on Matthew's original TRIM or UNMAP patch from
long ago). I believe that the performance was acceptable for them (I
will have to check).

I am also working on other, non-SSD, devices that are in a lower price
range than the large storage arrays where both DISCARD/UNMAP (and
WRITE SAME) would be useful in Linux. It also seems that Microsoft
supports TRIM in Windows 7 if you switch it on, although that really
only implies we should implement UNMAP support in our firmware and
hook it up to existing mechanisms.

I have logged internal enhancement bugs in bugzilla asking for both
TRIM and UNMAP/WRITE SAME support, and although one environment is
iSCSI in userland, and thus can be dealt with without support in the
Linux kernel, there are use cases where DISCARD/UNMAP support in the
Linux kernel would be useful.

I would be very willing to make the firmware changes needed in our
device to support UNMAP/WRITE SAME and to test changes to the Linux
kernel to support same.

I will go through this thread in more detail when I get back from my
trip to Australia, but if there are any GIT trees around with nascent
support in them I would love to know about them, as it will help my
internal efforts to get UNMAP/WRITE SAME support implemented as well.

--
Regards,
Richard Sharpe
