From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: Problems with DLT tape drive.
Date: Mon, 27 May 2002 10:55:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <acssb7$8kc$2@main.gmane.org>
References: <Pine.LNX.4.21.0205271140010.5429-100000@cpserver>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew R Reid <andrew@cpplating.com.au>
Cc: linux-tape@vger.kernel.org, linux-scsi@vger.kernel.org

Andrew R Reid wrote:
> Hi,
> 
> I hope that I have come to the right place.  I have spent the whole
> weekend trying to fix a problem with a DLT Tape drive that I have bought
> second hand.
> 
> I keep on getting the following message when I try to back up to it.
> 
> tar: Removing leading `/' from member names
> tar: /dev/st0: Cannot write: Input/output error
> tar: Error is not recoverable: exiting now
> 
> This error occurs at a random time into the backup.  It ssems not to
> matter if I have compression turned on or off on the tape drive and
> doesn't seem to matter if the data is easily compressible or not.
> 
> The kernel reports the following.
> 
> May 27 11:44:42 cpserver kernel: (scsi2:0:4:0) Data overrun detected in Data-Out phase, tag 0;
> May 27 11:44:42 cpserver kernel:   Have seen Data Phase. Length=10240, NumSGs=1.
> May 27 11:44:42 cpserver kernel:   Raw SCSI Command: 0x0a 00 00 28 00 00 
> May 27 11:44:42 cpserver kernel: st0: Error 27070000 (sugg. bt 0x20, driver bt 0x27, host bt 0x7).
> 


I'm having this problem too, but with a brand new HP LTO drive.

May 25 02:39:31 backup kernel: (scsi1:A:3:0): Unexpected busfree in Message-out phase
May 25 02:39:31 backup kernel: SEQADDR == 0x168
May 25 02:39:31 backup kernel: st0: Error 70000 (sugg. bt 0x0, driver bt 0x0, host bt 0x7).
May 25 02:39:31 backup kernel: st0: Error with sense data: Current st09:00: sns = 70  5
May 25 02:39:31 backup kernel: ASC=20 ASCQ= 0
May 25 02:39:31 backup kernel: Raw sense data:0x70 0x00 0x05 0x00 0x00 0x00 0x00 0x0e 0x00 0x00 0x00 0x00 0x20 0x00 0x00 0x00 0x2c 0x01 0x00 0x00 0x00 0x00

# uname -a
Linux backup 2.4.16-4GB #1 Fri Mar 22 15:38:04 GMT 2002 i686 unknown

# lspci | grep SCSI
00:09.0 SCSI storage controller: Adaptec 7892A (rev 02)

# cat /proc/scsi/aic7xxx/1
Adaptec AIC7xxx driver version: 6.2.4
aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Channel A Target 3 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 255, 16bit)
         Goal: 80.000MB/s transfers (40.000MHz, offset 15, 16bit)
         Curr: 80.000MB/s transfers (40.000MHz, offset 15, 16bit)
         Channel A Target 3 Lun 0 Settings
                 Commands Queued 1875861
                 Commands Active 0
                 Command Openings 1
                 Max Tagged Openings 0
                 Device Queue Frozen Count 0

(there are no other drives connected to this controller)

PS: On linux-scsi please CC me because I'm not on the list.

-- 
MfG / Regards
Friedrich Lobenstock

