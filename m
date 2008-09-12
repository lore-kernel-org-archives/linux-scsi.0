From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: ConfigFS + Target Mode Engine API discussion
Date: Fri, 12 Sep 2008 13:15:41 -0700
Message-ID: <20080912201541.GA26469@mail.oracle.com>
References: <1221087547.27831.165.camel@haakon2.linux-iscsi.org> <20080910233107.GC23864@mail.oracle.com> <1221097366.27831.216.camel@haakon2.linux-iscsi.org> <20080911021331.GA12902@mail.oracle.com> <1221107358.27831.289.camel@haakon2.linux-iscsi.org> <20080911063846.GB16583@mail.oracle.com> <1221123529.27831.343.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:34967 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbYILURx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 16:17:53 -0400
Content-Disposition: inline
In-Reply-To: <1221123529.27831.343.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, SCST-Devel <scst-devel@lists.sourceforge.net>

On Thu, Sep 11, 2008 at 01:58:49AM -0700, Nicholas A. Bellinger wrote:
> *) $CONFIGFS/target is created with configfs_register_subsystem()
> 
> *) $CONFIGFS/target/core is created as a default group under struct
> configfs_subsystem->su_group to interact with generic target mode
> engine's storage objects (eg: SCSI HCTL referenced devices, LVM UUID, MD
> UUID). 
> 
> ...........
> 
>  # Load LIO-Target using function symbols from target_core_configfs
> modprobe iscsi_target_mod
> 
> module_init() from iscsi_target_mod (eg: the fabric module) calls
> target_fabric_configfs_register() in target_core_configfs.ko, which is a
> small wrapper for calling sys_mkdir($CONFIGFS/target/$FABRIC) to kick
> off the struct config_group_operations->make_group() to create a struct
> config_item for /sys/kernel/config/target/iscsi (or whatever the fabric
> is called).

	No, you don't do this.  Like I said, configfs clients let
userspace create and destroy items.  Not kernelspace.  Do not call
sys_mkdir()/sys_rmdir() from your modules.
	If you don't do this, you also don't need your lookup_hash()
export.  Your code should be behaving as if it didn't know the
filesystem view existed.
	I'm trying to understand what you're actually doing.  Not the
"I want iscsi_target_mod to appear under target/iscsi" part, but why it
needs to be there in the first place.  how it all connects together.

Joel

-- 

"Every new beginning comes from some other beginning's end."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
