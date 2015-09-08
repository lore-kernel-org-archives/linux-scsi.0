From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: randconfig build error with next-20150908, in
 drivers/md/dm-mpath.c
Date: Tue, 8 Sep 2015 14:30:22 -0400
Message-ID: <20150908183021.GA3019@redhat.com>
References: <CA+r1ZhgR=dO0ezk0Nm0JuAb1D0AU7K2Am=Pyy9aPqCMsLW9Y0w@mail.gmail.com>
 <20150908172356.GA1584@redhat.com>
 <1441733672.5932.1.camel@Odin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbbIHSaY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2015 14:30:24 -0400
Content-Disposition: inline
In-Reply-To: <1441733672.5932.1.camel@Odin.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>, hare@suse.de
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "agk@redhat.com" <agk@redhat.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "jim.epost@gmail.com" <jim.epost@gmail.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Tue, Sep 08 2015 at  1:34pm -0400,
James Bottomley <jbottomley@odin.com> wrote:

> On Tue, 2015-09-08 at 13:23 -0400, Mike Snitzer wrote:
> > On Tue, Sep 08 2015 at  1:10pm -0400,
> > Jim Davis <jim.epost@gmail.com> wrote:
> > 
> > > Building with the attached random configuration file,
> > > 
> > > drivers/built-in.o: In function `activate_path':
> > > /home/jim/linux-next/drivers/md/dm-mpath.c:1225: undefined reference
> > > to `scsi_dh_activate'
> > > drivers/built-in.o: In function `parse_path':
> > > /home/jim/linux-next/drivers/md/dm-mpath.c:581: undefined reference to
> > > `scsi_dh_attached_handler_name'
> > > /home/jim/linux-next/drivers/md/dm-mpath.c:600: undefined reference to
> > > `scsi_dh_attach'
> > > /home/jim/linux-next/drivers/md/dm-mpath.c:615: undefined reference to
> > > `scsi_dh_set_params'
> > 
> > These DM-mpath changes were staged via linux-scsi.  Cc'ing James and Christoph.
> 
> [adding linux-scsi]
> 
> It must be Hannes' dm changes ... you acked them.  I take it the problem
> is now dm-mpath won't build without CONFIG_SCSI?  How do you want it
> fixed?  We can either add a Kconfig dependency or try to disentangle
> them again.

OK (Hannes' changes).  I'm fine with seeing DM_MULTIPATH depend on
CONFIG_SCSI.

The Kconfig for DM_MULTIPATH is clearly stale:

        # nasty syntax but means make DM_MULTIPATH independent
        # of SCSI_DH if the latter isn't defined but if
        # it is, DM_MULTIPATH must depend on it.  We get a build
        # error if SCSI_DH=m and DM_MULTIPATH=y
        depends on SCSI_DH || !SCSI_DH

James, if you have a vision for how to fix this please feel free.
Otherwise, Hannes, care to send a patch to fix this?

Thanks,
Mike
