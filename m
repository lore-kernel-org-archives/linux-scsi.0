From: Willem Riede <wrlk@riede.org>
Subject: Re: 2.4.20: possibly wrong handling of removeable scsi disks
Date: Sun, 23 Feb 2003 08:20:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030223132009.GA2155@linnie.riede.org>
References: <3E58BBC3.7020507@domdv.de>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E58BBC3.7020507@domdv.de>; from ast@domdv.de on Sun, Feb 23, 2003 at 07:17:07 -0500
List-Id: linux-scsi@vger.kernel.org
To: Andreas Steinmetz <ast@domdv.de>
Cc: linux-scsi@vger.kernel.org

On 2003.02.23 07:17 Andreas Steinmetz wrote:
>              if( the_result != 0
>                  && ((driver_byte(the_result) & DRIVER_SENSE) != 0)
> ===>            && SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION
>                  && SRpnt->sr_sense_buffer[12] == 0x3A ) {
>                      rscsi_disks[i].capacity = 0x1fffff;
>                      sector_size = 512;
>                      rscsi_disks[i].device->changed = 1;
>                      rscsi_disks[i].ready = 0;
>     ...
> 
> Now look at the marked (===>) lines above. I dont believe the test for 
> UNIT_ATTENTION is correct. As far as I could find out the sense 
> information from TEST_UNIT_READY should be either NO_SENSE, 
> ILLEGAL_REQUEST or NOT_READY. As there is a check for 'medium not 
> present' (0x3A) the test should be for NOT_READY instead of 
> UNIT_ATTENTION. ger.kernel.org/majordomo-info.html

You are right about this one. It should be NOT_READY, value 0x02.
As a matter of fact, ASQ 0x3A is unique, so you could just delete the
test of sr_sense_buffer[2] and it would work as expected.

Success, Willem Riede.
