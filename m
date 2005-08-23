From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] libata: error processing + rw 6 byte fix
Date: Tue, 23 Aug 2005 22:33:29 +1000
Message-ID: <430B1799.1060800@torque.net>
References: <430994BC.4060102@torque.net> <20050823071338.GA11233@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050823071338.GA11233@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Mon, Aug 22 2005, Douglas Gilbert wrote:
> 
>> 	if (scsicmd[0] == READ_6 || scsicmd[0] == WRITE_6) {
>>-		qc->nsect = tf->nsect = scsicmd[4];
>>+		if (scsicmd[4] == 0) {
>>+			/*
>>+			 * For READ_6 and WRITE_6 (only)
>>+			 * transfer_len==0 -> 256 blocks !!
>>+			 */
>>+			if (lba48) {
>>+				tf->hob_nsect = 1;
>>+				qc->nsect = 256;
>>+			} else
>>+				return 1;
> 
> 
> This isn't quite right, for 28-bit lba a 0 sector value means 256
> sectors to transfer as well. So just make that:
> 
>         if (lba48) {
>                 tf->hob_nsect = 1;
>                 qc->nsect = 256;
>         }
> 
>         /* continue */
> 
> and it should work fine. Similarly for 48-bit lba, 0 means 16^2 sectors.

Jens,
Since for 28-bit lba a 0 sector value means 256 sectors
do I need to check for the lba48 case at all? As proposed
to Jeff is this ok (for READ_6 and WRITE_6):

       if (scsicmd[4] == 0) {
           /*
            * For READ_6 and WRITE_6 (only)
            * transfer_len==0 -> 256 blocks !!
            */
           qc->nsect = 256;
       } else
           qc->nsect = scsicmd[4];
       tf->nsect = scsicmd[4];

Also I noticed while testing the original code with READ_6
(sectors=0) that the device locked up (power cycle required).
So given the point you make for 48-bit lba, 0 means 16^2
sectors, then the READ_10 (sectors=0) and READ_16 (sectors=0)
which are valid nops according to SBC-2 may also lock up
in libata.

Doug Gilbert

