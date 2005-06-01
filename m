From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/4] fusion - sas support
Date: Wed, 01 Jun 2005 12:35:28 -0500
Message-ID: <1117647329.5047.37.camel@mulgrave>
References: <200506011047.30607.Eric.Moore@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:37773 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261485AbVFARfi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2005 13:35:38 -0400
In-Reply-To: <200506011047.30607.Eric.Moore@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com
Cc: linux scsi <linux-scsi@vger.kernel.org>

On Wed, 2005-06-01 at 10:47 -0600, Moore, Eric Dean wrote:
> Changelog:
> * adding support for new module in Kconfig and Makefile
> * adding mptsas.c module 

No to this one until you and Adaptec (and any other interested parties)
get the sas transport class sorted out and in use ... at least in
embryo.  I won't hold the drivers up while the fine details and code
location is sorted out, but we need to get at least the structure in
place.

Additionally:


> +static struct device_attribute mptsas_queue_depth_attr = {
> +       .attr = {
> +               .name =         "queue_depth",
> +               .mode =         S_IWUSR,
> +       },
> +       .store = mptscsih_store_queue_depth,
> +};

This can all be done with the change_queue_depth host template API.

There are also a suspicious lot of SPI strings in the SAS driver (are
these cut and paste issues?):


> +       .name                           = "MPT SPI Host",

> +       mptsasDoneCtx = mpt_register(mptscsih_io_done, MPTSPI_DRIVER);
> +       mptsasTaskCtx = mpt_register(mptscsih_taskmgmt_complete,
> MPTSPI_DRIVER);
> +       mptsasInternalCtx = mpt_register(mptscsih_scandv_complete,
> MPTSPI_DRIVER);

James


