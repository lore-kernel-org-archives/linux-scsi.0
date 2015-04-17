From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 01/43] hpsa: add masked physical devices into h->dev[]
 array
Date: Fri, 17 Apr 2015 15:15:18 +0200
Message-ID: <55310766.5060208@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134645.30238.22953.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbDQNPs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:15:48 -0400
In-Reply-To: <20150416134645.30238.22953.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:46 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>
> Cache the ioaccel handle so that when we need to abort commands sent
> down the ioaccel2 path, we can look up the LUN ID in h->dev[] instead of
> having to do I/O to the controller.
>
> Add a field to elements in h->dev[] to keep track of how the device is exposed
> to the SCSI mid layer: Not at all, without an upper level driver
> (no_uld_attach) or normally exposed.
>
> Since masked physical devices are now present in h->dev[] array
> it would be perfectly possible to do
>
> 	echo scsi add-single-device 2 2 0 0 > /proc/scsi/scsi
>
> and bring them online.  This was previously not allowed for masked
> physical devices.
>
> Ensure that the mapping of physical disks to logical drives gets updated in a
> consistent way when a RAID migration occurs and is not touched until updates
> to it are complete.
>
> now instead of doing CISS_REPORT_PHYSICAL to get the LUNID for
> the physical disk in hpsa_get_pdisk_of_ioaccel2(), just get
> it out of h->dev[] where we already have it cached.
>
> do not touch phys_disk[] for ioaccel enabled logical drives during rescan
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

