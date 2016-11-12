From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: regression: scsi: megaraid_sas: Fix data integrity failure for
 JBOD (passthrough) devices
Date: Sat, 12 Nov 2016 13:16:38 +0100
Message-ID: <de99d003-c8cf-6ceb-bc52-3d688cc96914@profihost.ag>
References: <8870e289-d199-d41e-7ba8-5d463f3c4418@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <8870e289-d199-d41e-7ba8-5d463f3c4418@profihost.ag>
Sender: stable-owner@vger.kernel.org
To: kashyap.desai@broadcom.com
Cc: Greg KH <gregkh@linuxfoundation.org>, thenzl@redhat.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org, hare@suse.com, emilne@redhat.com
List-Id: linux-scsi@vger.kernel.org

seems stable kernel line misses this one:
http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?id=5e5ec1759dd663a1d5a2f10930224dd009e500e8


Am 12.11.2016 um 12:47 schrieb Stefan Priebe:
> Hello,
>
> the mentioned commit introduces a regression to me into v4.4.31. After
> upgrading from 4.4.30 to 4.4.31 my megasas controller no longer exports
> any drives to the os.
>
> dmesg:
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.381898] scsi 0:2:13:0:
> Direct-Access                                    PQ: 0 ANSI: 0
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.381991] sd 0:2:13:0: Attached
> scsi generic sg23 type 0
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.382051] sd 0:2:13:0: [sdx]
> Sector size 0 reported, assuming 512.
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.382055] sd 0:2:13:0: [sdx] 1
> 512-byte logical blocks: (512 B/512 B)
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.382056] sd 0:2:13:0: [sdx]
> 0-byte physical blocks
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.382088] sd 0:2:13:0: [sdx]
> Write Protect is off
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.382091] sd 0:2:13:0: [sdx]
> Mode Sense: 00 00 00 00
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.382109] sd 0:2:13:0: [sdx]
> Asking for cache data failed
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.382111] sd 0:2:13:0: [sdx]
> Assuming drive cache: write through
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.382237] sd 0:2:13:0: [sdx]
> Sector size 0 reported, assuming 512.
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.382450] sd 0:2:13:0: [sdx]
> Sector size 0 reported, assuming 512.
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.382484] sd 0:2:13:0: [sdx]
> Attached SCSI disk
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.443552] scsi 0:2:14:0:
> Direct-Access                                    PQ: 0 ANSI: 0
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.443654] sd 0:2:14:0: [sdy]
> Sector size 0 reported, assuming 512.
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.443655] sd 0:2:14:0: Attached
> scsi generic sg24 type 0
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.443659] sd 0:2:14:0: [sdy] 1
> 512-byte logical blocks: (512 B/512 B)
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.443661] sd 0:2:14:0: [sdy]
> 0-byte physical blocks
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.443680] sd 0:2:14:0: [sdy]
> Write Protect is off
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.443683] sd 0:2:14:0: [sdy]
> Mode Sense: 00 00 00 00
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.443702] sd 0:2:14:0: [sdy]
> Asking for cache data failed
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.443707] sd 0:2:14:0: [sdy]
> Assuming drive cache: write through
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.443834] sd 0:2:14:0: [sdy]
> Sector size 0 reported, assuming 512.
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.444038] sd 0:2:14:0: [sdy]
> Sector size 0 reported, assuming 512.
> Nov 12 11:09:54 cloud2-1394 kernel: [   17.444083] sd 0:2:14:0: [sdy]
> Attached SCSI disk
>
> Greets,
> Stefan
