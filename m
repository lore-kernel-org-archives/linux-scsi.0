From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Re: [PATCH v2 3/4] libfcoe: Add fcoe_sysfs
Date: Tue, 20 Mar 2012 01:23:15 +0000
Message-ID: <4F67DC02.7000403@intel.com>
References: <20120316193640.5369.56932.stgit@localhost6.localdomain6>
 <20120316193656.5369.47569.stgit@localhost6.localdomain6>
 <20120317002517.GA22430@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51785 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab2CTBYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2012 21:24:08 -0400
In-Reply-To: <20120317002517.GA22430@kroah.com>
Content-Language: en-US
Content-ID: <A64192611CD2434980574BED40C5C57A@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "james.smart@emulex.com" <james.smart@emulex.com>, "bprakash@broadcom.com" <bprakash@broadcom.com>

On 03/16/2012 05:25 PM, Greg KH wrote:
> On Fri, Mar 16, 2012 at 12:36:56PM -0700, Robert Love wrote:

<snip>

> diff --git a/Documentation/ABI/testing/sysfs-class-fcoe b/Documentation/ABI/testing/sysfs-class-fcoe
> new file mode 100644
> index 0000000..e9cd7e9
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fcoe
> @@ -0,0 +1,77 @@
> +What:		/sys/class/fcoe_ctlr/ctlr_X
> We are really trying to stay away from new classes being created.  Why
> can't this be a bus and have the devices attach to that instead?  You
> can have one bus with both types of "devices" attached to it, making
> things a bit simpler in the end.

<snip>

> +	dev_set_name(&ctlr->dev, "ctlr_%d", ctlr->id);
> +	error = device_add(&ctlr->dev);
> +	if (error)
> +		goto out_del_q2;
> +
> +	error = sysfs_create_group(&ctlr->dev.kobj,
> +				&fcoe_ctlr_attribute_group);
> +	if (error)
> +		goto out_del_dev;
> +
> +	error = sysfs_create_group(&ctlr->dev.kobj,
> +				&fcoe_ctlr_lesb_attribute_group);
> +	if (error)
> +		goto out_del_dev;
> You just raced userspace by creating your attributes after device_add()
> causing lots of problems in the longrun.  Why not make these default
> attribute groups that the driver core automatically creates for you
> properly?  That also makes your error path simpler, as well as your
> cleanup path for when this device goes away.
>

Hi Greg. I have a local series that addresses most of the comments 
you've made. I have a question about the above two requests.

I've converted my series to create a 'fcoe bus' and now instances of the 
'fcoe_ctlr' and 'fcoe_fcf' are on the 'fcoe bus.' I did not create any 
drivers for the bus; I'm simply adding devices with their device pointer 
set to my 'fcoe bus' (dev->bus = &fcoe_bus_type) so that these devices 
are grouped under /sys/bus/fcoe/. This change results in the following, 
which I think is what you want.

[root@bubba ~]# ls -l /sys/bus/fcoe/drivers
total 0
[root@bubba ~]# ls -l /sys/bus/fcoe/devices/
total 0
lrwxrwxrwx 1 root root 0 Mar 19 18:20 ctlr_0 -> 
../../../devices/virtual/net/eth4.172-fcoe/ctlr_0
lrwxrwxrwx 1 root root 0 Mar 19 18:20 fcf_0 -> 
../../../devices/virtual/net/eth4.172-fcoe/ctlr_0/fcf_0

Is there a way for me to make default attribute groups for each of these 
device types, as you suggest, without having a 'fcoe_ctlr' driver and a 
'fcoe_fcf' driver, or does your suggestion imply that I should be 
creating drivers for these two types?

I think I'm limited to having default attributes for any device on the 
'fcoe bus,' which is not what I want because my fcoe_fcf and fcoe_ctlr 
devices do not share attributes. Or to create a drivers which have 
default attribute groups and therefore the core will create attributes 
as devices are matched with their drivers. Since I'm dealing with a 
'subsystem bus' and not a real bus, I'm not sure if it's appropriate for 
me to be creating virtual subsystem drivers...

Thanks, //Rob