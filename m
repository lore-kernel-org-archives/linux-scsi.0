From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Adaptec 39160 / Yamaha CRW8424S CD burning
Date: Mon, 13 Jan 2003 19:06:37 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E22738D.3020000@torque.net>
References: <20030113071543.GA9558@holomorphy.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

William Lee Irwin III wrote:
> SCSI CD burning appears to fail, causing audio CD's burned with
> bash-2.05# cdrecord -v -pad speed=1 dev=0,3,0 -audio `cat tracks`
> (where the tracks are wav files) to have massive numbers of skips.
> 
> $ cat /proc/scsi/scsi 
> Attached devices: 
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: WDIGTL   Model: WDE18310 ULTRA2  Rev: 1.30
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 03 Lun: 00
>   Vendor: YAMAHA   Model: CRW8424S         Rev: 1.0j
>   Type:   CD-ROM                           ANSI SCSI revision: 02
> Host: scsi1 Channel: 00 Id: 06 Lun: 00
>   Vendor: IBM      Model: DDYS-T36950N     Rev: S93E
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> 
> The adapter is an Adaptec 39160, kernel is 2.5.49-mm2.
> 
> It works in 2.4, of course.

Bill,
Depending on which version of cdrecord you are using,
cdrecord will get to the SCSI Yamaha burner via:
   - scsi generic (sg) device (probably /dev/sg1)
   - or directly to /dev/scd0 (via the SG_IO ioctl in
     the block layer)
   - or via /dev/scd0 using the CDROM_PACKET_COMMAND
     ioctl

Could you determine which one is happening? If the
sg route is being used then the individual SCSI
commands can be seen by observing 'cat /proc/scsi/sg/debug'
while the burn is in progress. What version of cdrecord
are you using and what does its output look like?

Doug Gilbert


