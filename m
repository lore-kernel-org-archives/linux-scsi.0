From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_mid_low_api.txt in lk 2.5.72+
Date: Wed, 18 Jun 2003 19:30:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030618193023.A30835@infradead.org>
References: <3EF05D16.1060101@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:50188 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265424AbTFRSQ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2003 14:16:29 -0400
Content-Disposition: inline
In-Reply-To: <3EF05D16.1060101@torque.net>; from dougg@torque.net on Wed, Jun 18, 2003 at 10:37:42PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Wed, Jun 18, 2003 at 10:37:42PM +1000, Douglas Gilbert wrote:
> It anticipates various patches that Christoph has sent to
> this list being accepted. These include:
>    - addition of scsi_host_alloc()
>    - renaming of struct SHT to struct scsi_host_template

This seems to be in now.  I'll also send you another update
once the header reorgansization is finished.

> Idea: perhaps scsi_add_host() could have an extra argument
> to inhibit the scsi device scan (or alternatively a new field
> in struct scsi_host_template and struct Scsi_Host). Then
> LLDs that know about their devices hot (un)plugging can use
> scsi_add_device() and scsi_remove_device() at their leisure.
> [Actually ieee1394/sbp2.c is already doing this ...]

I though about this already but maybe the cleaner interface
would be to remove the call to scsi_scan_host from scsi_add_host
and let drivers that want it do it themselves.  (and the same
for scsi_forget_host in scsi_remove_host)

