From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: add statistics and other zfcp relatedinformation
	to sysfs
Date: Thu, 6 Sep 2007 20:56:39 +0100
Message-ID: <20070906195638.GA10758@osiris.ibm.com>
References: <200709051754.34701.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:36689 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbXIFT5T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2007 15:57:19 -0400
Content-Disposition: inline
In-Reply-To: <200709051754.34701.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

> - * 
> - * This program is free software; you can redistribute it and/or modify 
> - * it under the terms of the GNU General Public License as published by 
> - * the Free Software Foundation; either version 2, or (at your option) 
> - * any later version. 
> - * 
> - * This program is distributed in the hope that it will be useful, 
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of 
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
> - * GNU General Public License for more details. 
> - * 
> - * You should have received a copy of the GNU General Public License 
> - * along with this program; if not, write to the Free Software 
> - * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 
> - */ 
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2, or (at your option)
> + * any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */

You probably may consider splitting this patch into two patches: one that
adds the new functionality and one that contains all the whitespace changes.
It's much easier to review if one doesn't get distracted by trivial stuff.

> +#define FSF_FEATURE_MEASUREMENT_DATA		0x00000200

What is this good for? You never use it.

> +	if ((fsf_req->fsf_command == FSF_QTCB_FCP_CMND) &&
> +	    (fsf_req->qtcb->prefix.prot_status &
> +	    (FSF_PROT_GOOD | FSF_PROT_FSF_STATUS_PRESENTED))) {
> +		lat_inf = &fsf_req->qtcb->prefix.prot_status_qual.latency_info;
> +		unit = fsf_req->unit;
> +		switch(fsf_req->qtcb->bottom.io.data_direction) {
> +			case FSF_DATADIR_READ:
> +				unit->latencies.read.channel +=
> +					lat_inf->channel_lat;
> +				unit->latencies.read.fabric +=
> +					lat_inf->fabric_lat;
> +				unit->latencies.read.counter++;
> +				break;
> +			case FSF_DATADIR_WRITE:
> +				unit->latencies.write.channel +=
> +					lat_inf->channel_lat;
> +				unit->latencies.write.fabric +=
> +					lat_inf->fabric_lat;
> +				unit->latencies.write.counter++;
> +				break;
> +			case FSF_DATADIR_CMND:
> +				unit->latencies.cmd.channel +=
> +					lat_inf->channel_lat;
> +				unit->latencies.cmd.fabric +=
> +					lat_inf->fabric_lat;
> +				unit->latencies.cmd.counter++;
> +				break;
> +		}
> +	}

For better readability you should have an own function for this.

> +	adapter->stat_services.parent = &adapter->ccw_device->dev;
> +	adapter->stat_services.release = zfcp_dummy_release;
> +	snprintf(adapter->stat_services.bus_id, BUS_ID_SIZE,
> +		 "statistic_services");
> +	dev_set_drvdata(&adapter->stat_services, adapter);
> +
> +	if (device_register(&adapter->stat_services)) {
> +		ZFCP_LOG_NORMAL("SSS:stat_reg failed.\n");
> +		goto services_failed;
> +	}
> +	ZFCP_LOG_NORMAL("SSS:stat_reg succeeded.\n");
> +
> +	if (zfcp_sysfs_statistic_services_create_files(&adapter->stat_services))
> +	{
> +		ZFCP_LOG_NORMAL("SSS: create files failed.\n");
> +		goto sysfs_failed;
> +	}
> +
> +	ZFCP_LOG_NORMAL("SSS:create files succeeded.\n");

I assume the "SSS" printks are for debugging purposes and shouldn't be here
at all, right?

>  	adapter->generic_services.parent = &adapter->ccw_device->dev;
>  	adapter->generic_services.release = zfcp_dummy_release;
>  	snprintf(adapter->generic_services.bus_id, BUS_ID_SIZE,
>  		 "generic_services");
> 
>  	if (device_register(&adapter->generic_services))
> -		goto generic_services_failed;
> +		goto services_failed;

There is no device_unregister of stat_services if this fails. Hence you free
memory that might still be in use. Actually a simple device_unregister()
with a following kfree() won't help you. If device_unregister() returns that
doesn't mean that the piece of memory isn't anymore referenced. So you have
to wait until the release function gets called before you may free memory.
Btw. this is also broken for generic_services in zfcp_adapter_enqueue().

> +++ HEAD/drivers/s390/scsi/zfcp_sysfs_statistics.c
> @@ -0,0 +1,191 @@
> +/*
> + * This file is part of the zfcp device driver for
> + * FCP adapters for IBM System z9 and zSeries.
> + *
> + * (C) Copyright IBM Corp. 2002, 2006

2007?

> +static ssize_t
> +zfcp_sysfs_adapter_utilization_show(struct device *dev,
> +				    struct device_attribute *attr, char *buf) {
> +	struct zfcp_adapter *adapter;
> +	struct fsf_qtcb_bottom_port *qtcb_port;
> +	int retval;
> +
> +	adapter = dev_get_drvdata(dev);
> +
> +	qtcb_port = kzalloc(sizeof(struct fsf_qtcb_bottom_port), GFP_KERNEL);
> +	if (!qtcb_port) {
> +		ZFCP_LOG_NORMAL("error: cannot allocate memory for exchange "
> +				"port data request (adapter %s).\n",
> +				zfcp_get_busid_by_adapter(adapter));

Do you really need to print an error message for each memory allocation that
might fail?

> +		return (ssize_t) 0;

Why the cast? Why 0 and not -ENOMEM?

> +	retval = zfcp_fsf_exchange_port_data_sync(adapter, qtcb_port);
> +	if (retval) {
> +		ZFCP_LOG_NORMAL("error: exchange port data request failed for "
> +				"adapter %s.\n",
> +				zfcp_get_busid_by_adapter(adapter));
> +		kfree(qtcb_port);
> +		return (ssize_t) 0;

same here, except for a different return value maybe?

> +static ssize_t
> +zfcp_sysfs_adapter_request_show(struct device *dev,
> +				struct device_attribute *attr, char *buf) {
> +	struct zfcp_adapter *adapter;
> +	struct fsf_qtcb_bottom_config *qtcb_config;
> +	int retval;
> +
> +	adapter = dev_get_drvdata(dev);
> +
> +	qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
> +			      GFP_KERNEL);
> +	if (!qtcb_config) {
> +		ZFCP_LOG_NORMAL("error: cannot allocate memory for exchange "
> +				"configuration data request (adapter %s).\n",
> +				zfcp_get_busid_by_adapter(adapter));
> +		return (ssize_t) 0;
> +	}
> +
> +	retval = zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
> +	if (retval)
> +		ZFCP_LOG_NORMAL("error: exchange configuration data request "
> +				"failed for adapter %s.\n",
> +				zfcp_get_busid_by_adapter(adapter));
> +	else
> +		retval = sprintf(buf, "%lu %lu %lu\n",
> +				 qtcb_config->stat_info.input_req,
> +				 qtcb_config->stat_info.output_req,
> +				 qtcb_config->stat_info.control_req);
> +
> +	kfree(qtcb_config);
> +	return (retval > 0) ? retval : (ssize_t) 0;
> +}
> +
> +static DEVICE_ATTR(requests, S_IRUGO, zfcp_sysfs_adapter_request_show, NULL);
> +
> +static ssize_t
> +zfcp_sysfs_adapter_mb_show(struct device *dev,
> +			   struct device_attribute *attr, char *buf) {
> +	struct zfcp_adapter *adapter;
> +	struct fsf_qtcb_bottom_config *qtcb_config;
> +	int retval;
> +
> +	adapter = dev_get_drvdata(dev);
> +
> +	qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
> +			      GFP_KERNEL);
> +
> +	if (!qtcb_config) {
> +		ZFCP_LOG_NORMAL("error: cannot allocate memory for exchange "
> +				"configuration data request (adapter %s).\n",
> +				zfcp_get_busid_by_adapter(adapter));
> +		return (ssize_t) 0;
> +	}
> +
> +	retval = zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
> +	if (retval)
> +		ZFCP_LOG_NORMAL("error: exchnage configuration data request "
> +				"failed for adapter %s.\n",
> +				zfcp_get_busid_by_adapter(adapter));
> +	else
> +		retval = sprintf(buf, "%lu %lu\n",
> +				 qtcb_config->stat_info.input_mb,
> +			 	 qtcb_config->stat_info.output_mb);
> +
> +	kfree(qtcb_config);
> +	return (retval > 0) ? retval : (ssize_t) 0;
> +}
> +
> +static DEVICE_ATTR(megabytes, S_IRUGO, zfcp_sysfs_adapter_mb_show, NULL);
> +
> +static ssize_t
> +zfcp_sysfs_adapter_seconds_active_show(struct device *dev,
> +				       struct device_attribute *attr,
> +				       char *buf) {
> +	struct zfcp_adapter *adapter;
> +	struct fsf_qtcb_bottom_config *qtcb_config;
> +	int retval;
> +
> +	adapter = dev_get_drvdata(dev);
> +
> +	qtcb_config = kzalloc(sizeof(struct fsf_qtcb_bottom_config),
> +			      GFP_KERNEL);
> +
> +	if (!qtcb_config) {
> +		ZFCP_LOG_NORMAL("error: cannot allocate memory for exchange "
> +				"configuration data request (adapter %s).\n",
> +				zfcp_get_busid_by_adapter(adapter));
> +		return (ssize_t) 0;
> +	}
> +
> +	retval = zfcp_fsf_exchange_config_data_sync(adapter, qtcb_config);
> +	if (retval)
> +		ZFCP_LOG_NORMAL("error: exchange configuration data request "
> +				"failed for adapter %s.\n",
> +				zfcp_get_busid_by_adapter(adapter));
> +	else
> +		retval = sprintf(buf, "%lu\n",
> +				 qtcb_config->stat_info.seconds_act);
> +
> +	kfree(qtcb_config);
> +	return (retval > 0) ? retval: (ssize_t) 0;
> +}
> +
> +static DEVICE_ATTR(seconds_active, S_IRUGO,
> +		   zfcp_sysfs_adapter_seconds_active_show, NULL);

Four functions that are nearly identical. Writing a helper function
will probably avoid a lot of code duplication here.
