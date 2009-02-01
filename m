From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Sat, 31 Jan 2009 22:20:39 -0500
Message-ID: <49851507.5040905@garzik.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1233456951-992-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com, dm-devel@RedHat.com
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> This patchset implements alt_size, which is a size hint to the users
> of a block device.  It's primarily to communicate the BIOS (HPA) size
> on ATA devices to userland, so that dmraid can consider it when trying
> to figure out BIOS raid layout.  This is critical as dmraid can be
> tricked into assemblying the wrong raid when fed with the unlocked
> size and if the disk content is right (or, rather, wrong) and good
> number of distros are shipping with ignore_hpa=1 as default.
> 
> This patch contains the following three patches.
> 
>   0001-block-add-alt_size.patch
>   0002-scsi-add-scsi_device-alt_capacity.patch
>   0003-libata-export-HPA-size-as-alt_size.patch
> 
> Without the above three patches, I get the following on my nv RAID-0
> if HPA unlocking is turned on.
> 
>   # ~/work/dmraid/tools/dmraid -a y
>   RAID set "nvidia_djgdjigi" was activated
>   # mount /dev/dm-0 /mnt/tmp
>   mount: wrong fs type, bad option, bad superblock on /dev/dm-0,
> 	 missing codepage or helper program, or other error
> 	 In some cases useful info is found in syslog - try
> 	 dmesg | tail  or so
> 
> With the above three patches and modified dmraid,
> 
>   ck804:~/os/work/build # ~/work/dmraid/tools/dmraid -a y -v -v -v
>   ...
>   NOTICE: /dev/sdb: using BIOS sectors 234439535
>   RAID set "nvidia_djgdjigi" was activated
>   ...
>   ck804:~/os/work/build # mount /dev/dm-0 /mnt/tmp
>   ck804:~/os/work/build # umount /dev/dm-0

But the net result is that you are telling dmraid that it is OK to 
proceed, even though part of the disk it wants is really missing.  That 
seems unwise, because are you not basically proceeding with a known 
corrupt dataset at that point?

	Jeff




