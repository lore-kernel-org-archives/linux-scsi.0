From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] EDD: fix raw_data file and edd_has_edd30(), misc cleanups
Date: Tue, 7 Jan 2003 16:18:06 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030108001806.GA3669@beaverton.ibm.com>
References: <Pine.LNX.4.44.0301071728280.3361-100000@humbolt.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0301071728280.3361-100000@humbolt.us.dell.com>
To: Matt Domsch <Matt_Domsch@Dell.com>
Cc: linux-kernel@vger.kernel.org, mochel@osdl.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matt Domsch [Matt_Domsch@Dell.com] wrote:
>   * use new find_bus() and bus_for_each_dev() to match SCSI devices

.. snip ..
> +	struct edd_match_data * data = (struct edd_match_data *)d;
> +	struct edd_info *info = edd_dev_get_info(data->edev);
> +	struct scsi_device * sd = to_scsi_device(dev);
> +
> +	if (info) {
> +		if ((sd->channel == info->params.interface_path.pci.channel) &&
> +		    (sd->id == info->params.device_path.scsi.id) &&
> +		    (sd->lun == info->params.device_path.scsi.lun)) {
> +			data->sd = sd;
> +			return 1;
> +		}

This change assumes that the scsi sysfs bus only contains struct
scsi_device's. According to sysfs policy we are suppose to have only one
type of struct on this list, but this is not the case currently.

I will work on a patch tonight to remove these extra nodes so that the
st, sg, and osst maintainers can review it.

-andmike
--
Michael Anderson
andmike@us.ibm.com
