From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
Date: Tue, 5 Apr 2011 09:14:54 -0700
Message-ID: <20110405161454.GB885@kroah.com>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@suse.de>, Jon Masters <jcm@redhat.com>, 2nddept-manager@sdl.hitachi.co.jp
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 05, 2011 at 09:49:46PM +0900, Nao Nishijima wrote:
> This patch series provides a SCSI option for persistent device
> names in kernel. With this option, user can always assign a
> same device name (e.g. sda) to a specific device according to
> udev rules and device id.
> 
> Issue:
> Recently, kernel registers block devices in parallel. As a result,
> different device names will be assigned at each boot time. This
> will confuse file-system mounter, thus we usually use persistent
> symbolic links provided by udev. However, dmesg and procfs outputs
> show device names instead of the symbolic link names. This causes
> a serious problem when managing multiple devices (e.g. on a
> large-scale storage), because usually, device errors are output
> with device names on dmesg. We also concern about some commands
> which output device names, as well as kernel messages.
> 
> Solution:
> To assign a persistent device name, I create unnamed devices (not
> a block device, but an intermediate device. users cannot read/write
> this device). When scsi device driver finds a LU, the LU is registered
> as an unnamed device and inform to udev. After udev finds the unnamed
> device, udev assigns a persistent device name to a specific device
> according to udev rules and registers it as a block device. Hence,
> this is just a naming, not a renaming.
> 
> Some users are satisfied with current udev solution. Therefore, my
> proposal is implemented as an option.
> 
> If using this option, add the following kernel parameter.
> 
> 	scsi_mod.persistent_name=1
> 
> Also, if you want to assign a device name with sda, add the
> following udev rules.
> 
> SUBSYSTEM=="scsi_unnamed", ATTR{disk_id}=="xxx", PROGRAM="/bin/sh
> -c 'echo -n sda > /sys/%p/disk_name'"

Also, where is the "real" program you have created to properly name
devices from userspace?  You need that to properly test this patch,
right?

thanks,

greg k-h
