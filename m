From: Brad Campbell <brad@wasp.net.au>
Subject: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 19:20:09 +0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <412DFFA9.8030504@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
To: linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

G'day all,

Hot on the trail of this libata oddity.

static Scsi_Host_Template svia_sht = {
         .module                 = THIS_MODULE,
         .name                   = DRV_NAME,
         .queuecommand           = ata_scsi_queuecmd,
         .eh_strategy_handler    = ata_scsi_error,
         .can_queue              = ATA_DEF_QUEUE,
         .this_id                = ATA_SHT_THIS_ID,
         .sg_tablesize           = LIBATA_MAX_PRD,
         .max_sectors            = ATA_MAX_SECTORS,

ATA_MAX_SECTORS == 200.

Should then the scsi layer be able to do this and queue 1/2 a Meg in a single request?

sd_rw_intr: sda: res=0x0
1024 sectors total, 524288 bytes done.
use_sg is 128
sd_init_command: disk=sda, block=0, count=1024
sda : block=0
sda : writing 1024/1024 512 byte blocks.
scsi_add_timer: scmd: dfc48a00, time: 30000, (c0283910)
ata_scsi_dump_cdb: CDB (13:0,0,0) 2a 00 00 00 00 00 00 04 00
ata_scsi_translate: ENTER
ata_scsi_rw_xlat: ten-byte command
ata_sg_setup: ENTER, ata13
ata_sg_setup: 128 sg elements mapped

And queue 1024 sectors in one hit?

If I talk to the drive directly with
dd if=/dev/zero of=/dev/sda bs=1024k count=1

The SCSI layer seems to break the request up into nice neat 127 sector chunks and send it on through.

If I talk to it via an md device.

mdadm --create --force --level=0 --raid-devices=1 /dev/md0 /dev/sda
dd if=/dev/zero of=/dev/md0 bs=1024k count=1

Then we get what we see above, and my PATA->SATA adaptor intermittently locks up with transfers that 
long. (It does not appear to if I crank the speed down to UDMA66 from UDMA100 but that is another story)


Am I looking at something completely weird? Is the block layer doing something I should know about? 
Can SATA transfers handle 1024 sectors in one go? Will Batman make it out of the cave alive?

Regards,
Brad
