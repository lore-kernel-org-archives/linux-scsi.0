From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] allow NULL dev argument to scsi_add_host
Date: Sun, 12 Jan 2003 09:06:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030112090647.A28861@lst.de>
References: <20030111203317.A25836@lst.de> <20030112011720.GC1878@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030112011720.GC1878@beaverton.ibm.com>; from andmike@us.ibm.com on Sat, Jan 11, 2003 at 05:17:20PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Jan 11, 2003 at 05:17:20PM -0800, Mike Anderson wrote:
> This will cause all scsi device registers to show up in the root of the sysfs
> tree. The goal was that children of the adapter would be equal to the
> my_devices member. I also thought that callers of this interface would
> be converted to support sysfs.

I want to use this interface in driver that I can't support to the
device model yet (i.e. due to lack of eisa/vlb hardware I can't add
ldm support to them, but we have common drivers).

> If there are going to be many pseudo adapters that do not want to go
> through the overhead of creating a sysfs bus entry like ide-scsi
> then maybe I should work on a sysfs SCSI sub-system like block and if
> dev is null it means you are pseudo and we would create an entry for
> the adapter under (? /sysfs/scsi/pseudo ?). This could then be the value
> we stuff in host_gendev. Though the sysfs entry would not be much use to
> the caller, but useful for SCSI.

I'm all for useful entries in sysfs, but what about doing that
implicitly in scsi_add_host when dev is null?  (and getting rid of the
separate __scsi_add_host)

