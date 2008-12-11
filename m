From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH][RFC 5/23]: SCST /proc interface
Date: Thu, 11 Dec 2008 12:23:07 -0800
Message-ID: <1229026987.4153.555.camel@haakon2.linux-iscsi.org>
References: <494009D7.4020602@vlnb.net>  <49400C81.3010801@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757378AbYLKUX1@vger.kernel.org>
In-Reply-To: <49400C81.3010801@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-12-10 at 21:37 +0300, Vladislav Bolkhovitin wrote:
> This patch contains SCST the /proc interface.
> 
> A description of this interface can be found in the patch with the
> SCST core documentation.
> 
> Since a procfs-based configuration interface is unacceptable for new 
> kernel modules, in the next review iteration SCST's configuration 
> interface will be replaced by a sysfs-based configuration interface. 
> This patch is not intended to be included in the Linux kernel, but is 
> posted here, because as of today this configuration interface is 
> necessary when using SCST.
> 
> Unfortunately, configfs is not (yet) suited for configuring SCST. This 
> is, because configfs is user space driven, so kernel can't create 
> subdirectories on it, and all files on configfs are limited to 4K in 
> size. It makes impossible for kernel to show, e.g., a list of connected 
> initiators. Hence, with configfs it is necessary to have one more 
> interface to show such data, e.g. sysfs-based. 

Btw, please stop spreading FUD about ConfigFS.  ConfigFS works great for
Target_Core_Mod and LIO-Target v3.0, and is what I have found as the
*BEST* foundation for generic target mod moving forward.  This is not
based on a hypothetical discussion or on a long term TODO list, this has
been determined from actually writing the code, which is located at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/lio-core/target_core_configfs.c

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/lio-core/iscsi_target_configfs.c

So please, just because you don't want to acknowledge ConfigFS in your
own work, do not act like there is not already thounsands of lines of
ConfigFS code up and running for the generic target mode and LIO-Target.

--nab

> It would lead to 2 
> interfaces in two different places for configuring SCSI targets: 
> configfs and sysfs based. Definitely, it is better to have only one, 
> sysfs-based interface, than 2 interfaces. From other side, sysfs in what 
> SCST needs provides basically the same possibilities as configfs. And 
> it's widely used in the kernel to configure various its parameters. See, 
> for instance, bonding devices or IO schedulers.
> 
> The proposed /sys interface would be very similar to the current /proc 
> layout intact, except cases, where output >PAGE_SIZE is needed. For such 
> cases each entry, i.e. line, in such files would be presented as a 
> subdirectory with name the first element in that line and each other 
> element in it would be presented as a separate file (attribute). For 
> instance, /proc/scsi_tgt/sessions, which lists connected sessions, would 
> be converted to:
> 
> /sys/scsi_tgt/
>     /sys/scsi_tgt/sessions/
>       /sys/scsi_tgt/sessions/session1_name/
>         /sys/scsi_tgt/sessions/session1_name/target_name
>         /sys/scsi_tgt/sessions/session1_name/initiator_name
>         /sys/scsi_tgt/sessions/session1_name/acl -> ../../acls/aclX
>         /sys/scsi_tgt/sessions/session1_name/commands
>     /sys/scsi_tgt/sessions/session2_name/
>         /sys/scsi_tgt/sessions/session2_name/target_name
>         /sys/scsi_tgt/sessions/session2_name/initiator_name
>         /sys/scsi_tgt/sessions/session2_name/acl -> ../../acls/aclY
>         /sys/scsi_tgt/sessions/session2_name/commands
> .
> .
> .
> 
> Addition of new, e.g. vdisk devices, would be done via echo'ing commands 
> to, in this example, /sys/scsi_tgt/vdisk/mgmt file similarly as it's 
> currently done with /proc/scsi_tgt/vdisk/vdisk (same commands, actually).
> 
> Any comments and suggestions will be greatly appreciated.
> 
> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
> ---
>   drivers/scst/scst_proc.c | 2196 
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 2196 insertions(+)
> 
> The patch is too big to be submitted inline. You can find it in 
> http://scst.sourceforge.net/patches/scst_proc.diff
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
