From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Samsung SSD 1.92TB PM863 Enterprise 2.5" SATA3 errors withc
 stable 4.4.34
Date: Wed, 14 Dec 2016 04:48:40 -0800
Message-ID: <20161214124840.GA4759@kroah.com>
References: <CACaajQsKcHJsaUvNo_YTf6UNYR4F2Vi0E6pMUmB1zLpAQg=4ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACaajQsKcHJsaUvNo_YTf6UNYR4F2Vi0E6pMUmB1zLpAQg=4ug@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 14, 2016 at 03:07:48PM +0300, Vasiliy Tolstov wrote:
> Hi! I have stable problems with all Samsung SSD drivers like PM863 and
> EVO 850 Pro.
> 
> Time after time scsi bus reset link with messages:
> [ 2477.973617] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [ 2477.975036] ata1: irq_stat 0x00400040, connection status changed
> [ 2477.976396] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [ 2477.977766] ata1: hard resetting link
> [ 2478.701015] ata1: SATA link down (SStatus 0 SControl 300)
> [ 2483.700924] ata1: hard resetting link
> [ 2484.020924] ata1: SATA link down (SStatus 0 SControl 300)
> [ 2484.022257] ata1: limiting SATA link speed to 1.5 Gbps
> [ 2489.020766] ata1: hard resetting link
> [ 2489.340828] ata1: SATA link down (SStatus 0 SControl 310)
> [ 2489.342158] ata1.00: disabled
> [ 2489.343452] ata1: EH complete
> [ 2489.344806] ata1.00: detaching (SCSI 0:0:0:0)
> [ 2489.347434] sd 0:0:0:0: [sda] Stopping disk
> [ 2489.348605] sd 0:0:0:0: [sda] Start/Stop Unit failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 3457.586929] ata1: exception Emask 0x10 SAct 0x0 SErr 0x4040000
> action 0xe frozen
> [ 3457.588224] ata1: irq_stat 0x00000040, connection status changed
> [ 3457.589453] ata1: SError: { CommWake DevExch }
> [ 3457.590679] ata1: hard resetting link
> [ 3458.312616] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [ 3461.139831] ata1.00: ATA-9: SAMSUNG MZ7LM1T9HCJM-0E003, GXT3003Q,
> max UDMA/133
> [ 3461.141027] ata1.00: 3750748848 sectors, multi 16: LBA48 NCQ (depth
> 31/32), AA
> [ 3461.142882] ata1.00: configured for UDMA/133
> [ 3461.144004] ata1: EH complete
> [ 3461.145545] scsi 0:0:0:0: Direct-Access ATA SAMSUNG MZ7LM1T9 003Q
> PQ: 0 ANSI: 5
> [ 3461.147069] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [ 3461.147082] sd 0:0:0:0: [sda] 3750748848 512-byte logical blocks:
> (1.92 TB/1.75 TiB)
> [ 3461.147649] sd 0:0:0:0: [sda] Write Protect is off
> [ 3461.147652] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 3461.147849] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [ 3461.152457] sd 0:0:0:0: [sda] Attached SCSI removable disk
> 
> I'm try to remove drive and add it again message not appears may be
> one hour or more. I'm try different servers from HP and Supermicro and
> error is present. Also i'm try various disk from this series and
> nothing changed.
> 
> If i have massive workload like writing to ext4 fs on this ssd drivers
> i get corrupted ext4 journal and readonly fs.
> 
> My kernel version is 4.4.34
> May be some Samsung engineers presented in this mailing list and ca
> help to solve this errors? Or for server i need only Intel SSD (yes if
> i use intel ssd this error not happening, this is not intel
> advertising)

Do you also have problems with this on the 4.9 kernel release?  We can't
add any changes to 4.4 that is not already made in 4.9.

thanks,

greg k-h
