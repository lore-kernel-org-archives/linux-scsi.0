From: Andreas Steinmetz <ast@domdv.de>
Subject: 2.4.20: possibly wrong handling of removeable scsi disks
Date: Sun, 23 Feb 2003 13:17:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E58BBC3.7020507@domdv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[Please CC me on replies, I'm not subscribed to the list]

There is possibly a wrong handling of removable disks with no medium 
inserted in the sd driver. From 2.4.20 drivers/scsi/sd.c (...=snip):

static int sd_init_onedisk(int i)
{
    ...
     do {
             retries = 0;

             while (retries < 3) {
                     cmd[0] = TEST_UNIT_READY;
                    ...
                    if (the_result == 0
                         || SRpnt->sr_sense_buffer[2] != UNIT_ATTENTION)
                             break;
             }

             /*
              * If the drive has indicated to us that it doesn't have
              * any media in it, don't bother with any of the rest of
              * this crap.
              */
             if( the_result != 0
                 && ((driver_byte(the_result) & DRIVER_SENSE) != 0)
===>            && SRpnt->sr_sense_buffer[2] == UNIT_ATTENTION
                 && SRpnt->sr_sense_buffer[12] == 0x3A ) {
                     rscsi_disks[i].capacity = 0x1fffff;
                     sector_size = 512;
                     rscsi_disks[i].device->changed = 1;
                     rscsi_disks[i].ready = 0;
===>                break;
             }
            ...
     } while (the_result && spintime &&
              time_after(spintime_value + 100 * HZ, jiffies));
    ...

Now look at the marked (===>) lines above. I dont believe the test for 
UNIT_ATTENTION is correct. As far as I could find out the sense 
information from TEST_UNIT_READY should be either NO_SENSE, 
ILLEGAL_REQUEST or NOT_READY. As there is a check for 'medium not 
present' (0x3A) the test should be for NOT_READY instead of 
UNIT_ATTENTION. Furthermore the 'break;' statement seems wrong to me as 
the function lateron does e.g. things like READ_CAPACITY which doesn't 
make any sense if no medium is present. The correct statement seems to 
me 'return i;'.

As a sidenote sd_init_onedisk() should be changed to return void. It is 
static and the return value is nowhere used.

If my above assumptions are right please let me know, I'll submit 
patches in this case.

