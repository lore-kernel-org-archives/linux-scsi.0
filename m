From: "Steven Nash" <Steven_Nash@compuserve.com>
Subject: RE: [Bugme-new] [Bug 4201] New: megaraid crashes at random with CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
Date: Mon, 14 Feb 2005 15:19:07 -0000
Message-ID: <20050214151710.650AB7EC0E9@mailgate.sgnash.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E57036626A7@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Received: from mailgate.sgnash.co.uk ([80.176.179.82]:16260 "EHLO
	mailgate.sgnash.co.uk") by vger.kernel.org with ESMTP
	id S261444AbVBNPTR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 10:19:17 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57036626A7@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sju@lsil.com, 'Andrew Morton' <akpm@osdl.org>, linux-scsi@vger.kernel.org

1. The memory of the server is 2GB, see output from free for full details:
             total       used       free     shared    buffers     cached
Mem:       2075128    1617708     457420          0     331344    1026896
-/+ buffers/cache:     259468    1815660
Swap:      2031608          0    2031608 

2. Config data:
cat /proc/megaraid/hba0/config
v2.00.3 (Release Date: Wed Feb 19 08:51:30 EST 2003)
CERC ATA100/4ch
Controller Type: 438/466/467/471/493/518/520/531/532
Controller Supports 40 Logical Drives
Controller capable of 64-bit memory addressing
Controller using 64-bit memory addressing
Base = f8816000, Irq = 201, Logical Drives = 1, Channels = 4
Version =6.62:1.03, DRAM = 16Mb
Controller Queue Depth = 254, Driver Queue Depth = 126
support_ext_cdb    = 1
support_random_del = 1
boot_ldrv_enabled  = 1
boot_ldrv          = 0
boot_pdrv_enabled  = 0
boot_pdrv_ch       = 0
boot_pdrv_tgt      = 0
quiescent          = 0
has_cluster        = 0

Module Parameters:
max_cmd_per_lun    = 63
max_sectors_per_io = 128

3a. Legacy drive info (from kernel source 2.6.10):
* Version : v2.00.3 (Feb 19, 2003) - Atul Mukker <Atul.Mukker@lsil.com>
*
* Description: Linux device driver for LSI Logic MegaRAID controller
*
* Supported controllers: MegaRAID 418, 428, 438, 466, 762, 467, 471, 490,
493
*                                      518, 520, 531, 532
*

3b. New driver (from kernel source 2.6.10):
 *
 * FILE         : megaraid_mbox.c
 * Version      : v2.20.4.1 (Nov 04 2004)

 *
 * FILE         : megaraid_mm.c
 * Version      : v2.20.2.3 (Dec 09 2004)
 *
 * Common management module

4. As for loads the system does not get that busy, most of the crashes seem
to occure around 3am when I backup some WinXP shares to tar files and after
that the DLT backup job runs, where my script creates a list of files to
backup before running tar with the bzip compression.

At the moment kernel 2.6.9 (FC3 build) seems to be ok.

Steve
> -----Original Message-----
> From: sju@lsil.com [mailto:sju@lsil.com] 
> Sent: 14 February 2005 13:30
> To: 'Andrew Morton'; linux-scsi@vger.kernel.org
> Cc: Steven_Nash@compuserve.com; Ju, Seokmann
> Subject: RE: [Bugme-new] [Bug 4201] New: megaraid crashes at 
> random with CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
> 
>  
> On Friday, February 11, 2005 7:29 PM, Andrew wrote:
> > megaraid driver crashing.  I have tried forcing the old megaraid 
> > driver in the kernel config and rebuilding but this has no effect.
> 
> Can you provide details on following,please?
> - The megaraid driver version?
> - Device configuration information on the CERC ATA100/4ch 
> with options (cached, WT/WB, or read-ahead?)
> - Size of main memory on PowerEdge 600SC?
> - What are the typical I/O loads has been applied to reach crash?
> 
> Thanks,
> 
> Seokmann
> LSI Logic Corporation.
> 
> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@osdl.org]
> > Sent: Friday, February 11, 2005 7:29 PM
> > To: linux-scsi@vger.kernel.org
> > Cc: Steven_Nash@compuserve.com
> > Subject: Fw: [Bugme-new] [Bug 4201] New: megaraid crashes at random 
> > with CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
> > 
> > 
> > 
> > Begin forwarded message:
> > 
> > Date: Fri, 11 Feb 2005 16:08:26 -0800
> > From: bugme-daemon@osdl.org
> > To: bugme-new@lists.osdl.org
> > Subject: [Bugme-new] [Bug 4201] New: megaraid crashes at 
> random with 
> > CERC ATA100/4ch (DELL Controller) on PowerEdge 600SC
> > 
> > 
> > http://bugme.osdl.org/show_bug.cgi?id=4201
> > 
> >            Summary: megaraid crashes at random with CERC  
> ATA100/4ch (DELL
> >                     Controller) on PowerEdge 600SC
> >     Kernel Version: 2.6.10
> >             Status: NEW
> >           Severity: high
> >              Owner: andmike@us.ibm.com
> >          Submitter: Steven_Nash@compuserve.com
> > 
> > 
> > Distribution: Fedora Core 3
> > Hardware Environment: x86 (32 bit)
> > Software Environment: Vanilla Kernel & Fedora Build Kernel Problem 
> > Description: After a day or two (varies) the system hangs 
> and the only 
> > option is to hit the reset button.  Sometimes sda errors 
> appear on the 
> > current active VT but nothing appears in the logs after 
> reboot (which 
> > is due to the megaraid driver crashing.  I have tried 
> forcing the old 
> > megaraid driver in the kernel config and rebuilding but this has no 
> > effect.
> > 
> > Steps to reproduce:
> > Run a system for a few days, crashes seem to occure around 
> 3 am approx.
> > The
> > only other SCSI device on the system is a Dell DLT Drive.
> > 
> > This is a serious bug!
> > 
> > ------- You are receiving this mail because: ------- You 
> are on the CC 
> > list for the bug, or are watching someone who is.
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" 
> > in the body of a message to majordomo@vger.kernel.org More 
> majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html
> 

