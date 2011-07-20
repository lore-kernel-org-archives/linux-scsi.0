From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH SCSI] sr: check_events() ignore GET_EVENT when TUR says
 otherwise
Date: Wed, 20 Jul 2011 18:33:08 +0200
Message-ID: <20110720163308.GC9924@mtj.dyndns.org>
References: <20110630130348.GQ3386@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110630130348.GQ3386@htj.dyndns.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, maggu2810@googlemail.com, linux-hotplug@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 30, 2011 at 03:03:48PM +0200, Tejun Heo wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> Some broken devices indicates that media has changed on every
> GET_EVENT_STATUS_NOTIFICATION.  This translates into MEDIA_CHANGE
> uevent on every open() which lets udev run into a loop.
> 
> Verify GET_EVENT result against TUR and if it generates spurious
> events for several times in a row, ignore the GET_EVENT events, and
> trust only the TUR status.
> 
> This is the log of a USB stick with a (broken) fake CDROM drive:
> 
>  scsi 5:0:0:0: Direct-Access     SanDisk  U3 Cruzer Micro  8.02 PQ: 0 ANSI: 0 CCS
>  sd 5:0:0:0: Attached scsi generic sg3 type 0
>  scsi 5:0:0:1: CD-ROM            SanDisk  U3 Cruzer Micro  8.02 PQ: 0 ANSI: 0
>  sd 5:0:0:0: [sdb] Attached SCSI removable disk
>  sr2: scsi3-mmc drive: 48x/48x tray
>  sr 5:0:0:1: Attached scsi CD-ROM sr2
>  sr 5:0:0:1: Attached scsi generic sg4 type 5
>  sr2: GET_EVENT and TUR disagree continuously, suppress GET_EVENT events
>  sd 5:0:0:0: [sdb] 31777279 512-byte logical blocks: (16.2 GB/15.1 GiB)
>  sd 5:0:0:0: [sdb] No Caching mode page present
>  sd 5:0:0:0: [sdb] Assuming drive cache: write through
>  sd 5:0:0:0: [sdb] No Caching mode page present
>  sd 5:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: sdb1
> 
> -tj: Updated to consider only spurious GET_EVENT events among
>      different types of disagreement and allow using TUR for kernel
>      event polling after GET_EVENT is ignored.
> 
> Reported-By: Markus Rathgeb maggu2810@googlemail.com
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: stable@kernel.org	# >= v2.6.38, fixes udev busy looping w/ certain devices

James, ping.

-- 
tejun
