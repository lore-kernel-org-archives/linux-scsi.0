From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/3] [SCSI] scst: Move SCST device documentation to
 Documentation/ABI
Date: Wed, 22 Dec 2010 16:20:53 -0800
Message-ID: <20101223002053.GA7475@suse.de>
References: <201012222144.47522.bvanassche@acm.org>
 <201012222146.28782.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0LWAVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Dec 2010 19:21:38 -0500
Content-Disposition: inline
In-Reply-To: <201012222146.28782.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, vst@vlnb.net, realrichardsharpe@gmail.com, scst-devel@lists.sourceforge.net

On Wed, Dec 22, 2010 at 09:46:28PM +0100, Bart Van Assche wrote:
> Move the documentation about the sysfs attributes of the SCST
> virtual device to Documentation/ABI/stable.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Vladislav Bolkhovitin <vst@vlnb.net>
> ---
>  Documentation/ABI/stable/sysfs-devices-scst |  150 +++++++++++++++++++++++++++
>  Documentation/scst/README.scst              |   71 -------------
>  2 files changed, 150 insertions(+), 71 deletions(-)
>  create mode 100644 Documentation/ABI/stable/sysfs-devices-scst
> 
> diff --git a/Documentation/ABI/stable/sysfs-devices-scst b/Documentation/ABI/stable/sysfs-devices-scst
> new file mode 100644
> index 0000000..80bc258
> --- /dev/null
> +++ b/Documentation/ABI/stable/sysfs-devices-scst
> @@ -0,0 +1,150 @@
> +What:           /sys/devices/scst/mgmt

How did you get a file into this directory?  Are you sure that's
acceptable?  Same for the other files you added here.

> +Date:           December 2010
> +KernelVersion:  2.6.38

Really?  That's pretty presumptious, isn't it?

> +Contact:        linux-scsi@vger.kernel.org

Why not the "owner" of this code, not the scsi mailing list.

> +Description:
> +		Interface through which SCST management commands can be issued.

You mix tabs and spaces above and in all of your other files.  Please
make them only tabs.
> +		The documentation of the syntax of these commands can be
> +		obtained by reading this file:
> +
> +		# cat mgmt
> +		in device/<dev> <dev_cmd>
> +		in device_driver/<devt> <devt_cmd>
> +		in target_driver/<tgtt> <tgtt_cmd>
> +		in target_driver/<tgtt>/<target>/luns <tgt_cmd>
> +		in target_driver/<tgtt>/<target>/luns <luns_cmd>
> +		in target_driver/<tgtt>/<target>/ini_groups <acg_mgmt_cmd>
> +		in target_driver/<tgtt>/<target>/ini_groups/<acg> <acg_cmd>
> +		in target_driver/<tgtt>/<target>/ini_groups/<acg>/luns <luns_cmd>
> +		in target_driver/<tgtt>/<target>/ini_groups/<acg>/initiators <acg_ini_cmd>

What?  sysfs is one value per file, why would the mgmt file return more
than one line?  That's not acceptable, sorry.

> +
> +		dev_cmd syntax:
> +
> +		set_filename <filename>
> +		set_threads_num <n>
> +		set_thread_pool_type <thread_pool_type>
> +
> +		devt_cmd syntax:
> +
> +		add_device device_name [parameters]
> +		del_device device_name
> +		add_attribute <attribute> <value>
> +		del_attribute <attribute> <value>
> +		add_device_attribute device_name <attribute> <value>
> +		del_device_attribute device_name <attribute> <value>
> +
> +		devt_cmd syntax for pass-through device types:
> +
> +		add_device H:C:I:L
> +		del_device H:C:I:L
> +
> +		tgtt_cmd syntax:
> +
> +		add_target target_name [parameters]
> +		del_target target_name
> +		add_attribute <attribute> <value>
> +		del_attribute <attribute> <value>
> +		add_target_attribute target_name <attribute> <value>"
> +		del_target_attribute target_name <attribute> <value>"
> +
> +		where parameters is one or more <name>=<value> pairs separated by ';'
> +
> +		tgt_cmd syntax:
> +
> +		enable
> +		disable
> +		set_cpu_mask <mask>
> +
> +		luns_cmd syntax:
> +
> +		add|del H:C:I:L lun [parameters]
> +		add VNAME lun [parameters]
> +		del lun
> +		replace H:C:I:L lun [parameters]
> +		replace VNAME lun [parameters]
> +		clear
> +
> +		where parameters is either 'read_only' or empty.
> +
> +		acg_mgmt_cmd syntax:
> +
> +		create <group_name>
> +		del <group_name>
> +
> +		acg_cmd syntax:
> +		set_cpu_mask <mask>
> +
> +		acg_ini_cmd syntax:
> +
> +		add <initiator_name>
> +		del <initiator_name>
> +		move <initiator_name> <dest_group_name>
> +		clear

That's quite complex, are you sure it's correct, and actually describes
it in a manner that anyone else can use?

Again, one value per file.

thanks,

greg k-h
