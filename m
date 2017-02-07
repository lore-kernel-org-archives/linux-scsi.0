From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 3.10 141/319] scsi: mpt3sas: Fix secure erase premature
 termination
Date: Tue, 7 Feb 2017 18:12:34 +0100
Message-ID: <20170207171234.GB4041@1wt.eu>
References: <1486322541-8206-1-git-send-email-w@1wt.eu>
 <1486322541-8206-42-git-send-email-w@1wt.eu>
 <ae8ffc4f86c5af1caf97dfa9a6493443@mail.gmail.com>
 <20170206222623.GA4769@1wt.eu>
 <1486449528.2474.125.camel@HansenPartnership.com>
 <20170207065946.GC4850@1wt.eu>
 <1486486971.2488.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486486971.2488.19.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux@roeck-us.net, Andrey Grodzovsky <andrey2805@gmail.com>, linux-scsi@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 07, 2017 at 09:02:51AM -0800, James Bottomley wrote:
> On Tue, 2017-02-07 at 07:59 +0100, Willy Tarreau wrote:
> > Hi James,
> > 
> > On Mon, Feb 06, 2017 at 10:38:48PM -0800, James Bottomley wrote:
> > > On Mon, 2017-02-06 at 23:26 +0100, Willy Tarreau wrote:
> > (...)
> > > > We don't have the referenced commit above in 3.10 so we should be
> > > > safe. Additionally I checked that neither 4.4 nor 3.12 have them 
> > > > either, so that makes me feel confident that we can skip it in 
> > > > 3.10 as well.
> > > 
> > > The original was also racy with respect to multiple commands, so 
> > > the above fixed the race as well.
> > 
> > OK so I tried to backport it to 3.10. I dropped a few parts which 
> > were addressing this one marked for stable 4.4+ :
> >     7ff723a ("scsi: mpt3sas: Unblock device after controller reset")
> > 
> > And I got the attached patch. All I know is that it builds. I'd 
> > appreciate it if someone could confirm its validity, in which case
> > I'll add it.
> 
> The two patches apply without fuzz to your tree and the combination is
> a far better bug fix than the original regardless of whether 7ff723a
> exists in your tree or not.  By messing with the patches all you do is
> add the potential for introducing new bugs for no benefit, so why take
> risk for no upside?

Just because I'm suggested to apply this fix which is supposed to fix
a regression brought by 7ff723a which itself is marked to fix 4.4+ only
and which doesn't apply to 3.10. So now I'm getting confused because
you say that these patches apply without fuzz but one part definitely
is rejected and the other one has to be applied by hand. I want not
to take a risk but I'm faced with these options :
  - drop all these patches and stay as 3.10.104 is
  - merge the "secure erase premature" + the the part of the patch
    that supposedly fixes the regression it introduced
  - merge this fix + 7ff723a + whatever it depends on (not fond of
    it)

In all cases I don't even have the hardware to validate anything. I'd
be more tempted with the first two options. If you think I'm taking
risks by backporting the relevant part of the fix, I'll simply drop
them all and leave the code as it is now.

Thanks,
Willy
