From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 13/24] mpt fusion: [2.6.30-rc6] Firmware event
	implementation using seperate WorkQueue
Date: Wed, 27 May 2009 17:24:32 +0000
Message-ID: <1243445072.6067.28.camel@localhost.localdomain>
References: <20090522110322.GG16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60429 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263AbZE0RYc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2009 13:24:32 -0400
In-Reply-To: <20090522110322.GG16331@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-05-22 at 16:33 +0530, Kashyap, Desai wrote:
> --- a/drivers/message/fusion/mptsas.h
> +++ b/drivers/message/fusion/mptsas.h
> @@ -61,12 +61,30 @@ enum mptsas_hotplug_action {
>         MPTSAS_DEL_DEVICE,
>         MPTSAS_ADD_RAID,
>         MPTSAS_DEL_RAID,
> +       MPTSAS_ADD_PHYSDISK,
> +       MPTSAS_ADD_PHYSDISK_REPROBE,
> +       MPTSAS_DEL_PHYSDISK,
> +       MPTSAS_DEL_PHYSDISK_REPROBE,
>         MPTSAS_ADD_INACTIVE_VOLUME,
>         MPTSAS_IGNORE_EVENT,
>  };
>  
> +struct sas_mapping{
> +       u8                      id;
> +       u8                      channel;
> +};
> +
> +struct sas_device_info {
> +       struct list_head        list;
> +       struct sas_mapping      os;     /* operating system mapping*/
> +       struct sas_mapping      fw;     /* firmware mapping */
> +       u64                     sas_address;
> +       u32                     device_info; /* specific bits for devices */
> +       u16                     slot;           /* enclosure slot id */
> +       u64                     enclosure_logical_id; /*enclosure address */
> +};

sas_device_info and sas_mapping aren't very good names for structures in
a file you include along with the generic scsi_transport_sas.h header,
which has a lot of sas_ prefix structures and functions in it ... it's
setting us up for a namespace clash.  Why aren't these mptsas_ prefixes
like everything else in this file?

James


