From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 5/5] target: Fix wrong setting of sense format for PI
 errors
Date: Wed, 8 Jul 2015 15:59:34 +0300
Message-ID: <559D1EB6.3090509@dev.mellanox.co.il>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-6-git-send-email-sagig@mellanox.com>
 <20150708101931.GD14466@infradead.org> <559CFD14.9090803@dev.mellanox.co.il>
 <20150708104955.GA20842@infradead.org> <559D0286.4070202@suse.de>
 <559D0619.9040101@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <559D0619.9040101@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On 7/8/2015 2:14 PM, Sagi Grimberg wrote:
>>
>> And it's actually not true that you'd need descriptor sense to
>> encode the sector information; it'll be stored in the 'information'
>> section (byte 3-6) for fixed format sense.
>
> But when I return the sector info in a fixed size format, the initiator
> is not able to decode the faulty sector:
>
> kernel: DIFv1 Type 1 reference failed on sector: 15 tag: 0xfffffff0
> sector MSB: 0x0000000f
> kernel: sd 10:0:1:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> kernel: sd 10:0:1:0: [sdc] tag#0 Sense Key : Aborted Command [current]
> kernel: sd 10:0:1:0: [sdc] tag#0 Add. Sense: No additional sense
> information
> kernel: sd 10:0:1:0: [sdc] tag#0 CDB: Read(10) 28 20 00 00 00 00 00 00
> 10 00
> kernel: blk_update_request: I/O error, dev sdc, sector 0
>
> Is that a bug?

Bleh, found the bug... It was in scsi_set_sense_information()

For Fixed sized sense the information field is 4 bytes so this fixes it:
diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 41432c1..8cfb7ee 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -270,7 +270,7 @@ void scsi_set_sense_information(u8 *buf, u64 info)
                 put_unaligned_be64(info, &ucp[4]);
         } else if ((buf[0] & 0x7f) == 0x70) {
                 buf[0] |= 0x80;
-           put_unaligned_be64(info, &buf[3]);
+         put_unaligned_be32(info, &buf[3]);
         }
  }
  EXPORT_SYMBOL(scsi_set_sense_information);

I'll send out a separate patch.

Thanks Hannes and Christoph for catching this.

Sagi.
