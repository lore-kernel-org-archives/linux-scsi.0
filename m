From: Scott Merritt <Scsi@PragmaSoft.com>
Subject: Re: 2.4.20: possibly wrong handling of removeable scsi disks
Date: Sun, 23 Feb 2003 11:14:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030223111427.7573a717.Scsi@PragmaSoft.com>
References: <3E58BBC3.7020507@domdv.de>
	<20030223132009.GA2155@linnie.riede.org>
	<3E58CF6C.2020601@domdv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E58CF6C.2020601@domdv.de>
List-Id: linux-scsi@vger.kernel.org
To: Andreas Steinmetz <ast@domdv.de>
Cc: wrlk@riede.org, linux-scsi@vger.kernel.org

On Sun, 23 Feb 2003 14:41:00 +0100
Andreas Steinmetz <ast@domdv.de> wrote:

> Willem Riede wrote:
> > On 2003.02.23 07:17 Andreas Steinmetz wrote:
> > 
> >>             if( the_result != 0
> >>                 && ((driver_byte(the_result) & DRIVER_SENSE) != 0)
> >>===>            && SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION
> >>                 && SRpnt->sr_sense_buffer[12] == 0x3A ) {
> >>                     rscsi_disks[i].capacity = 0x1fffff;
> >>                     sector_size = 512;
> >>                     rscsi_disks[i].device->changed = 1;
> >>                     rscsi_disks[i].ready = 0;
> >>    ...
> >>
> >>Now look at the marked (===>) lines above. I dont believe the test for 
> >>UNIT_ATTENTION is correct. As far as I could find out the sense 
> >>information from TEST_UNIT_READY should be either NO_SENSE, 
> >>ILLEGAL_REQUEST or NOT_READY. As there is a check for 'medium not 
> >>present' (0x3A) the test should be for NOT_READY instead of 
> >>UNIT_ATTENTION. ger.kernel.org/majordomo-info.html
> > 
> > 
> > You are right about this one. It should be NOT_READY, value 0x02.
> > As a matter of fact, ASQ 0x3A is unique, so you could just delete the
> > test of sr_sense_buffer[2] and it would work as expected.
> > 
> 
> OK,
> this still leaves the question why, if a device reports 'no medium 
> found', the code still tries to do a READ_CAPACITY (multiple times). 
> Capacity reporting depends on available medium, isn't possible when 
> there's no medium found and causes unneeded communication and cpu 
> overhead as well as syslog spamming.
> 
Andreas,

Yes, I was/am also annoyed by the syslog spamming.  In my case, it was with a "permanently" connected USB compact flash reader that was typically empty while booting. I posted a patch (available on request) for this in 2.4.19, but it did not get "resolved" into a form suitable for incorporation.  I would have to go back and refresh my memory, but as I recall this test needs to be for "NOT READY" and "UNIT ATTENTION", as the later will occur if the media was removed just prior to the test being performed.

After later reflection, I realized that my patch might have caused problems with some seriously "non-conforming" disk drives and thus I never "pushed" it.  To truly solve this problem, I believe we would need to add a status flag to the scsi structure indicating that the last examination of the device determined that there was no media present.  This status flag would then be used to bypass the subsequent Read Capacity (and partition table reading) commands.

Regards, Scott.


