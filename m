From: Chris Mason <chris.mason@fusionio.com>
Subject: Re: New Defects based on recent changes in Kernel code found by
 Coverity Scan
Date: Thu, 5 Jul 2012 11:33:16 -0400
Message-ID: <20120705153316.GN14928@shiny>
References: <829BE905228AE14A9AE1A46E6F2E371605538D039D@VA3DIAXVS891.RED001.local>
 <20120703152739.ea7df9e6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Scan Subscription <scan-subscription@coverity.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Chris L. Mason" <clmason@fusionio.com>, Bing Zhao <bzhao@marvell.com>, Robert Love <robert.w.love@intel.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 03, 2012 at 04:27:39PM -0600, Andrew Morton wrote:
> On Thu, 28 Jun 2012 11:32:09 -0700
> Scan Subscription <scan-subscription@coverity.com> wrote:
> 
> > 
> > Hi,
> > 
> > Based on several requests to test the recent changes to the Linux Kernel for any new defects, that may have been introduced, using Coverity SCAN, we have the results and we would share them with the larger community. To date we have found a total of 27 new defects based on changes made in the last THREE weeks. Below you can find the full summary and details of defects found including the source code snippet.
> > 
> > We will share this information weekly and include the list of new defects found by Coverity SCAN. You can also view the details of the defects by logging into SCAN http://scan5.coverity.com:8080   
> > 
> > ____________________________________________________________________________________________________________
> > Summary of Defects:  
> > * CID 703583: Out-of-bounds access (OVERRUN_STATIC) - Array of  uint16_t mb[4], is being accessed as mb[1],mb[2],mb[3],mb[4], instead of index from 0 to 3
> > drivers/scsi/qla2xxx/qla_isr.c:92
> > drivers/scsi/qla2xxx/qla_target.c:4045
> 
> cc Andrew and linux-scsi
> 
> > * CID 709112: Dereference after null check - fs/btrfs/ioctl.c, line: 1309 Comparing "device->fs_devices" to null implies that "device->fs_devices" might be null, and then it is deference
> > fs/btrfs/ioctl.c:1309
> 
> Chris.

Thanks for forwarding this.  But I'm a little confused, our line 1309 is
this:

        if (device->fs_devices && device->fs_devices->seeding) {

Is coverity telling me that I'm using fs_devices later on in the
function without extra checks?  Some functions we call do assume it
isn't null, but the seeding devices are special snowflakes. 

Mostly wondering how smart the scan is.

-chris
