From: Doug Ledford <dledford@redhat.com>
Subject: Re: Problems with DLT tape drive.
Date: Tue, 28 May 2002 15:37:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ad0m8n$hi1$2@main.gmane.org>
References: <Pine.LNX.4.21.0205271140010.5429-100000@cpserver>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.21.0205271140010.5429-100000@cpserver>; from andrew@cpplating.com.au on Mon, May 27, 2002 at 12:11:59PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Andrew R Reid <andrew@cpplating.com.au>
Cc: linux-tape@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, May 27, 2002 at 12:11:59PM +1000, Andrew R Reid wrote:
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

[ snip ]
 
> As you can see I have a iomega zip and a Agfa snapscan connected to the
> same scsi bus.  I have a micro 50 to centronics 50 pin cable from the
> host adaptor to the DLT drive.  I have a 50 pin centronics to DB25 cable
> from the DLT drive to the zip drive and a db25-db25 cable from there to
> the scanner.  The scanner is terminated with a db25 passive terminator.
> 
> After reading a SCSI FAQ, I have a feeling that mixing 25 pin devices with
> 50 pin devices may not be a good idea, but this is the only option I have
> at present without playing around a good deal to use the second host
> adaptor on the mainboard.

For testing purposes you could install a terminator on the tape drive, 
leaving the scanner and zip drive disconnected long enough to reboot the 
machine and try a backup.  The SCSI bus layout you list is somewhat 
questionable as far as reliability is concerned, and this test should 
eliminate a lot of the possible variances that could result in bus errors.  
Another option is to configure the BIOS on the 2930 card to only allow 
async transfers to the tape drive.  That can help with bus errors on 
questionable busses.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
