From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC & PATCH 2.6.9-rc1] Add Blacklist for RAID configuration luns
Date: Tue, 14 Sep 2004 11:22:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914182203.GA100433@sgi.com>
References: <20040914063237.GA97486@sgi.com> <20040914144023.GA9524@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:23785 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S269627AbUINSWT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 14:22:19 -0400
Content-Disposition: inline
In-Reply-To: <20040914144023.GA9524@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, axboe@suse.de

On Tue, Sep 14, 2004 at 07:40:23AM -0700, Patrick Mansfield wrote:
> On Mon, Sep 13, 2004 at 11:32:37PM -0700, Jeremy Higdon wrote:
> > Engenio RAIDs have special luns that are used for configuring the RAID.
> > These luns have a device type of 0 (disk), but do not adhere to
> > standard disk semantics.  To avoid having to parse potentially dozens
> > of error messages during initialization, it's good to avoid attaching
> > these devices to sd.  This can be done by changing the device type
> > to RAID (0xC).
> 
> What error messages are output without your patch?
> 
> -- Patrick Mansfield

If you try to read block 1 of the device, for example, you get these
errors (cut & pasted from /var/log/messages):

	Sep 13 16:12:51 perflinux29 kernel: Buffer I/O error on device sdo, logical block 0
	Sep 13 16:12:51 perflinux29 kernel: Buffer I/O error on device sdo, logical block 1
	Sep 13 16:12:51 perflinux29 kernel: Buffer I/O error on device sdo, logical block 2
	Sep 13 16:12:51 perflinux29 kernel: Buffer I/O error on device sdo, logical block 3
	Sep 13 16:12:51 perflinux29 kernel: end_request: I/O error, dev sdt, sector 0

On SLES9, for example, you get these messages when hwscan or blkid
is run (they're opening disk devices and presumably scanning for
partition tables).  There are several system utilities that might
do this sort scanning (lvm, for example).

The error occurs, because the lun in question returns errors for
any request beyond block 64, and the new readahead algorithm
generally issues requests for 128 blocks even when only one block
is requested.

If we convince sd not to attach to this device, the problem goes
away.  Thus, the new blacklist type and new entry.

jeremy
