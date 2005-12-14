From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 6/6] statistics infrastructure - exploitation: zfcp
Date: Wed, 14 Dec 2005 09:24:37 -0700
Message-ID: <20051214162437.GW9286@parisc-linux.org>
References: <43A044E6.7060403@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42638 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S964813AbVLNQYi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 11:24:38 -0500
Content-Disposition: inline
In-Reply-To: <43A044E6.7060403@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, linux-scsi@vger.kernel.org

On Wed, Dec 14, 2005 at 05:14:30PM +0100, Martin Peschke wrote:
>  	if (device_register(&unit->sysfs_device)) {
> +		zfcp_unit_statistic_unregister(unit);
>  		kfree(unit);
>  		return NULL;
>  	}
> 
>  	if (zfcp_sysfs_unit_create_files(&unit->sysfs_device)) {
> +		zfcp_unit_statistic_unregister(unit);
>  		device_unregister(&unit->sysfs_device);
>  		return NULL;
>  	}

Unrelated, but doesn't that error path forget to release unit?

