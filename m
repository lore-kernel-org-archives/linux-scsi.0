From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 07/18] osd_ktests: Add basic OSD tests
Date: Wed, 7 Jan 2009 00:12:10 +0900
Message-ID: <20090107001206N.fujita.tomonori@lab.ntt.co.jp>
References: <1231251436-9777-1-git-send-email-bharrosh@panasas.com>
	<20090106234303H.fujita.tomonori@lab.ntt.co.jp>
	<49637117.50108@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41854 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZAFPNF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2009 10:13:05 -0500
In-Reply-To: <49637117.50108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, osd-dev@open-osd.org, akpm@linux-foundation.org

On Tue, 06 Jan 2009 16:56:23 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> FUJITA Tomonori wrote:
> > On Tue,  6 Jan 2009 16:17:16 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> Currently testing what is implemented in the osd_initiator library.
> >> That is - format, create/remove partition, create/remove object,
> >> read and write to objects.
> >>
> >> This test passes against the IBM-OSD-SIM OSDv1 target.
> >>
> >> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> >> Reviewed-by: Benny Halevy <bhalevy@panasas.com>
> >> ---
> >>  drivers/scsi/osd/Kbuild       |    2 +-
> >>  drivers/scsi/osd/osd_ktests.c |  331 +++++++++++++++++++++++++++++++++++++++++
> >>  drivers/scsi/osd/osd_ktests.h |    4 +
> >>  drivers/scsi/osd/osd_uld.c    |    2 +-
> >>  4 files changed, 337 insertions(+), 2 deletions(-)
> >>  create mode 100644 drivers/scsi/osd/osd_ktests.c
> >>
> >> diff --git a/drivers/scsi/osd/Kbuild b/drivers/scsi/osd/Kbuild
> >> index 4730cdc..6fb823f 100644
> >> --- a/drivers/scsi/osd/Kbuild
> >> +++ b/drivers/scsi/osd/Kbuild
> >> @@ -35,5 +35,5 @@ libosd-y := osd_initiator.o
> >>  obj-$(CONFIG_SCSI_OSD_INITIATOR) += libosd.o
> >>  
> >>  # osd.ko - SCSI ULD and char-device
> >> -osd-y := osd_uld.o
> >> +osd-y := osd_uld.o osd_ktests.o
> >>  obj-$(CONFIG_SCSI_OSD_ULD) += osd.o
> >> diff --git a/drivers/scsi/osd/osd_ktests.c b/drivers/scsi/osd/osd_ktests.c
> >> new file mode 100644
> >> index 0000000..fba4934
> >> --- /dev/null
> >> +++ b/drivers/scsi/osd/osd_ktests.c
> >> @@ -0,0 +1,331 @@
> >> +/*
> >> + * osd_ktests.c - An osd_initiator library in-kernel test suite
> >> + *              called by the osd_uld module
> > 
> > Why do we need in-kernel test suite?
> 
> It must be in kernel, because it tests the in-kernel library.
> However it could be in it's own Module, which makes it more
> complicated, but doable.

Why do we need the code to tests the in-kernel library?

I expect that you guys have tested the osd in-kernel library heavily
and will. I don't think people want to do the same. Then why do we
need to have the test suite in mainline?


> Please note that the submitted tests are the bare minimum and
> will be enhanced in the future. Perhaps later when the test grow
> I will put them in their own module.

If you can have it as a module, it's very easy for you guys to keep it
out-of-mainline.
