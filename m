From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH scsi-misc-2.6] sd: implement sd_check_events()
Date: Tue, 21 Dec 2010 12:09:13 -0600
Message-ID: <1292954953.3034.15.camel@mulgrave.site>
References: <20101217122831.39300d94.sfr@canb.auug.org.au>
	 <1292597607.2820.17.camel@mulgrave.site>  <4D0CF27F.1080601@kernel.org>
	 <1292862013.3034.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1292862013.3034.7.camel@mulgrave.site>
Sender: linux-next-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-12-20 at 10:20 -0600, James Bottomley wrote:
> Added cc: linux-scsi
> 
> On Sat, 2010-12-18 at 18:42 +0100, Tejun Heo wrote:
> > Replace sd_media_change() with sd_check_events().
> > 
> > * Move media removed logic into set_media_not_present() and
> >   media_not_present() and set sdev->changed iff an existing media is
> >   removed or the device indicates UNIT_ATTENTION.
> > 
> > * Make sd_check_events() sets sdev->changed if previously missing
> >   media becomes present.
> > 
> > * Event is reported only if sdev->changed is set.
> > 
> > This makes media presence event reported if scsi_disk->media_present
> > actually changed or the device indicated UNIT_ATTENTION.  For backward
> > compatibility, SDEV_EVT_MEDIA_CHANGE is generated each time
> > sd_check_events() detects media change event.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Kay Sievers <kay.sievers@vrfy.org>
> > ---
> > Here it is.  The conflicts were due to Alan's recent patch, which was
> > in the similar direction anyway.
> 
> This looks fine to me.  Jens can you strip the SCSI patches out of your
> tree and I'll run them through a postmerge tree to get the fix up?

Ping on this, please: I can't build a postmerge tree until block is
sorted out.  I need these four removing:

commit 638428ece619495edc9579b1e21493eb00f9687c
Author: Tejun Heo <tj@kernel.org>
Date:   Thu Dec 9 11:18:42 2010 +0100

    scsi: fix TUR error handling in sr_media_change()
  
commit 9f8a2c23c6c1140f515f601265c4dff7522110b7
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Dec 8 20:57:40 2010 +0100

    scsi: replace sr_test_unit_ready() with scsi_test_unit_ready()
 
commit 93aae17af1172c40c6f74b7294e93a90c3cfaa5d
Author: Tejun Heo <tj@kernel.org>
Date:   Thu Dec 16 17:52:17 2010 +0100

    sr: implement sr_check_events()

commit c8d2e937355d02db3055c2fc203e5f017297ee1f
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Dec 8 20:57:42 2010 +0100

    sd: implement sd_check_events()

Thanks,

James
