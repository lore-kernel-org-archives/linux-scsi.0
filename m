From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] fusion update to current APIs
Date: Fri, 11 Jun 2004 17:36:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040612003608.GA152454@sgi.com>
References: <20040531115229.GA16143@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:31603 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S264432AbUFLAg7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2004 20:36:59 -0400
Content-Disposition: inline
In-Reply-To: <20040531115229.GA16143@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Emoore@lsil.com, linux-scsi@vger.kernel.org

On Mon, May 31, 2004 at 01:52:29PM +0200, Christoph Hellwig wrote:
>  - kill scsi_to_pci_dma_dir usage, both pci and scsi use the same bits
>  - kill mptscsih_io_direction and always trust the midlayer

Christoph, the midlayer gets it wrong sometimes.

Specifically, when the sg driver can't tell the direction, because the
input and output buffer sizes are identical (and an older sg interface
is being used), the sg driver assumes that the direction is inbound
(SCSI_READ).

There are several apps out there that get that do this, but which work
because the host drivers override the direction passed in from sg.

Now if we have to go out and get all these apps fixed, there will be
a lot of pain out there :-)

jeremy
