From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: 2.4.20: possibly wrong handling of removeable scsi disks
Date: Tue, 25 Feb 2003 00:10:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030224231055.GA14101@win.tue.nl>
References: <3E58BBC3.7020507@domdv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E58BBC3.7020507@domdv.de>
List-Id: linux-scsi@vger.kernel.org
To: Andreas Steinmetz <ast@domdv.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 23, 2003 at 01:17:07PM +0100, Andreas Steinmetz wrote:

> There is possibly a wrong handling of removable disks with no medium 
> inserted in the sd driver. From 2.4.20 drivers/scsi/sd.c (...=snip):
> 
>             /*
>              * If the drive has indicated to us that it doesn't have
>              * any media in it, don't bother with any of the rest of
>              * this crap.
>              */
>             if( the_result != 0
>                 && ((driver_byte(the_result) & DRIVER_SENSE) != 0)
> ===>            && SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION
>                 && SRpnt->sr_sense_buffer[12] == 0x3A ) {
>                     rscsi_disks[i].capacity = 0x1fffff;
>                     sector_size = 512;
>                     rscsi_disks[i].device->changed = 1;
>                     rscsi_disks[i].ready = 0;
> ===>                break;
>             }
>            ...
>     } while (the_result && spintime &&
>              time_after(spintime_value + 100 * HZ, jiffies));
>    ...
> 
> Now look at the marked (===>) lines above. I dont believe the test for 
> UNIT_ATTENTION is correct. As far as I could find out the sense 
> information from TEST_UNIT_READY should be either NO_SENSE, 
> ILLEGAL_REQUEST or NOT_READY. As there is a check for 'medium not 
> present' (0x3A) the test should be for NOT_READY instead of 
> UNIT_ATTENTION.

I wrote in 2.5:

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

> Furthermore the 'break;' statement seems wrong to me as 
> the function lateron does e.g. things like READ_CAPACITY which doesn't 
> make any sense if no medium is present.

I wrote in 2.5:

        if (sdkp->media_present)
                sd_read_capacity(sdkp, disk->disk_name, SRpnt, buffer);

That code can be backported.

Andries
