From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] Add EVPD page 0x83 entries to sysfs
Date: Wed, 12 Feb 2014 00:02:56 -0800
Message-ID: <20140212080256.GA18203@infradead.org>
References: <1392129294-55235-1-git-send-email-hare@suse.de>
 <1392129294-55235-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaBLIDB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2014 03:03:01 -0500
Content-Disposition: inline
In-Reply-To: <1392129294-55235-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On Tue, Feb 11, 2014 at 03:34:54PM +0100, Hannes Reinecke wrote:
> EVPD page 0x83 is used to uniquely identify the device.
> So instead of having each and every program issue a separate
> SG_IO call to retrieve this information it does make far more
> sense to display it in sysfs.
> The page is displayed in its entirety with the attribute
> 'vpd_pg83', and the individual designators are stored in
> ident_<association>_<designator> attributes.
> Duplicate designators are added as individual lines to
> the corresponding attribute.

Looks correct to me, suggestions for a few possible cleanups below.

Signed-off-by: Christoph Hellwig <hch@lst.de>

> +#define SCSI_VPD_ASSOC_lun 0x0
> +#define SCSI_VPD_ASSOC_port 0x1
> +#define SCSI_VPD_ASSOC_target 0x2
> +
> +#define SCSI_VPD_DESIG_vendor 0x0
> +#define SCSI_VPD_DESIG_t10 0x1
> +#define SCSI_VPD_DESIG_eui 0x2
> +#define SCSI_VPD_DESIG_naa 0x3
> +#define SCSI_VPD_DESIG_relport 0x4
> +#define SCSI_VPD_DESIG_tpgrp 0x5
> +#define SCSI_VPD_DESIG_lugrp 0x6
> +#define SCSI_VPD_DESIG_md5 0x7
> +#define SCSI_VPD_DESIG_scsi_name 0x8
> +#define SCSI_VPD_DESIG_proto 0x9

Shouldn't these constants be in a header?

> +				switch (d[0] >> 4) {
> +				case SCSI_PROTOCOL_FCP:
> +					proto = "fcp";
> +					break;
> +				case SCSI_PROTOCOL_SPI:
> +					proto = "spi";
> +					break;

Splitting the protocol mapping into a separate helper woulkd be good.
In fact this could easily be an array lookup as well.

> +#define sdev_evpd_test_and_show_attr(sdev, attr, assoc, desig)		\
> +	if (attr == &dev_attr_ident_##assoc##_##desig.attr) {		\
> +		if (scsi_test_vpd_ident(sdev, SCSI_VPD_ASSOC_##assoc, \
> +					SCSI_VPD_DESIG_##desig))	\
> +			return S_IRUGO;					\
> +		else							\
> +			return 0;					\

No need for the else here.

> +	if (attr == &dev_attr_vpd_pg83.attr) {
> +		if (sdev->vpd_ident)
> +			return S_IRUGO;
> +		else
> +			return 0;
> +	}

Same here.

