From: Luben Tuikov <luben@splentec.com>
Subject: Re: status as in SAM2
Date: Sun, 26 May 2002 18:33:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CF162CF.9D137E50@splentec.com>
References: <3CEE5837.CECADF71@splentec.com> <3CF01627.3C6866C@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Thanks Douglas,

I looked in the low-level scsi device drivers (LLDD)
and it seems to me that not all bother to set
the status byte right (even more so for emulated
scsi like the 3ware).

For compatibility I use something like this:

status = (uint8_t) ((status_byte(SCpnt->result) << 1) & 0xFF);

but I'd _much_ rather use the form you suggested:

status = SCpnt->result & 0xFF;

but am not sure if the position of the status byte
will change within the 32 bit result.

It would even be better if the device server status
byte has it's own byte variable in SCpnt, so that
LLDD writers feel ``encouraged'' to set it explicitly,
rather than the mid-level try and guess its value
using scsi_sense_valid(), and the driver byte...

> Perhaps it is time (in lk 2.5) to get rid of the current
> status_byte macro "cleverness", change it to:
>    #define status_byte(result) ((result) & 0xff)

I'm all for it!

Thanks,
-- 
Luben
P.S. A new breed of SCSI HBA heavily rely
on the device server status byte being reported right,
and I'm kind of set back to see that the LLDD don't
report it always... But I guess that depends on
the underlying hardware (device server)...
