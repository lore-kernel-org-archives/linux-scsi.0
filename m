From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 04/12] Protect SCSI device state changes with a mutex
Date: Fri, 2 Jun 2017 09:17:20 +0200
Message-ID: <20170602071720.GD560@lst.de>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com> <20170601232711.29062-5-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51438 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbdFBHRV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Jun 2017 03:17:21 -0400
Content-Disposition: inline
In-Reply-To: <20170601232711.29062-5-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On Thu, Jun 01, 2017 at 04:27:03PM -0700, Bart Van Assche wrote:
> Enable this mechanism for all scsi_target_*block() callers but not
> for the scsi_internal_device_unblock() calls from the mpt3sas driver
> because that driver can call scsi_internal_device_unblock() from
> atomic context.

This is missing an explanation on why we'd want to serialize them
using a mutex.
