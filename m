From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Fri, 29 Oct 2004 17:41:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041030004131.GA29908@beaverton.ibm.com>
References: <1098833278.4914.24.camel@zezette> <20041027081713.GC32712@marowsky-bree.de> <1098903759.12464.32.camel@zezette> <1098914250.1588.1.camel@mulgrave> <20041028113728.GT32712@marowsky-bree.de> <20041028181436.GA18874@beaverton.ibm.com> <20041028182154.GY32712@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:24993 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263641AbUJ3AmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 20:42:11 -0400
Content-Disposition: inline
In-Reply-To: <20041028182154.GY32712@marowsky-bree.de>
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Oct 28, 2004 at 08:21:54PM +0200, Lars Marowsky-Bree wrote:
> On 2004-10-28T11:14:36, Patrick Mansfield <patmans@us.ibm.com> wrote:
> 
> > > Can't we do a test-unit-ready before trying to read and then just not
> > > read the partition table w/o so much noise?
> > We already issue a TUR in sd_spinup_disk() prior to the READ CAPACITY and
> > partition reads.
> 
> I'm just saying we should stop on the first failed command (TUR) and not
> retry to read all 64 sectors regardless. I can live with one error per
> passive path, but 64 really kills the logs.

That makes sense.

What is the result of the TUR? I did not see any information about it in other posts in this thread.

We should only send the READ CAPACTIY if the TUR says the device is
ready. Maybe the code in media_not_present() is wrong and causing a
problem.

This code in sd.c:

static int media_not_present(struct scsi_disk *sdkp, struct scsi_request *srp)
{
        if (!srp->sr_result)
                return 0;
        if (!(driver_byte(srp->sr_result) & DRIVER_SENSE))
                return 0;
        if (srp->sr_sense_buffer[2] != NOT_READY &&
            srp->sr_sense_buffer[2] != UNIT_ATTENTION)
                return 0;
        if (srp->sr_sense_buffer[12] != 0x3A) /* medium not present */
                return 0;

        set_media_not_present(sdkp);
        return 1;
}

For example if we got sr_result of a DID_NO_CONNECT or other error that
does not end up setting DRIVER_SENSE, driver_byte(sr_result) could be
0, and then we would return 0. 

Agree?

And then we allow a READ CAPACITY later on if media is present.

Maybe we have a similiar problem with the TUR to this device.

We should change state somehow if the TUR failed or was not ready, maybe
call set_media_not_present(), or maybe change the sdev state to
SDEV_OFFLINE - though that might cause extra logging.

We might not normally every hit this since the scan (INQUIRY failure)
would likely prevent the device from showing up at all. 

Plus, we only call sd_spinup_disk() during discovery and not on open,
unlike the calls to sd_media_changed().

-- Patrick Mansfield
