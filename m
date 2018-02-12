From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] libata: don't try to pass through NCQ commands to
 non-NCQ devices
Date: Mon, 12 Feb 2018 09:21:56 -0800
Message-ID: <20180212172156.GD695913@devbig577.frc2.facebook.com>
References: <94eb2c1fae0400ce57055cd4e9bb@google.com>
 <20180204043351.16812-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:40061 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbeBLRV7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 12:21:59 -0500
Content-Disposition: inline
In-Reply-To: <20180204043351.16812-1-ebiggers3@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, syzkaller-bugs@googlegroups.com, Vinayak Kale <vinayak.kale@seagate.com>, Eric Biggers <ebiggers@google.com>

On Sat, Feb 03, 2018 at 08:33:51PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> syzkaller hit a WARN() in ata_bmdma_qc_issue() when writing to /dev/sg0.
> This happened because it issued an ATA pass-through command (ATA_16)
> where the protocol field indicated that NCQ should be used -- but the
> device did not support NCQ.
> 
> We could just remove the WARN() from libata-sff.c, but the real problem
> seems to be that the SCSI -> ATA translation code passes through NCQ
> commands without verifying that the device actually supports NCQ.
> 
> Fix this by adding the appropriate check to ata_scsi_pass_thru().

Applied to libata/for-4.16-fixes.

Thanks.

-- 
tejun
