From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: do not requeue requests unaligned with device sector size
Date: Wed, 21 Dec 2016 09:01:11 -0500
Message-ID: <yq1fulh1ivs.fsf@sermon.lab.mkp.net>
References: <1482199347-9128-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1482199347-9128-1-git-send-email-mauricfo@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Tue, 20 Dec 2016 00:02:27
        -0200")
Sender: linux-block-owner@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, gpiccoli@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Mauricio,

Mauricio> When a SCSI command (e.g., read operation) is partially
Mauricio> completed with good status and residual bytes (i.e., not all
Mauricio> the bytes from the specified transfer length were transferred)
Mauricio> the SCSI midlayer will update the request/bios with the
Mauricio> completed bytes and requeue the request in order to complete
Mauricio> the remainder/pending bytes.

I agree with Christoph and Hannes. Some of this falls into the gray area
that's outside of the T10 spec (HBA programming interface guarantees)
but it seems like a deficiency in the HBA to report a byte count that's
not a multiple of the logical block size. A block can't be partially
written. Either it made it or it didn't. Regardless of how the I/O is
being broken up into frames at the transport level and at which offset
the transfer was interrupted.

I am also not a fan of the delayed retry stuff which seems somewhat
orthogonal to the problem you're describing.

-- 
Martin K. Petersen	Oracle Linux Engineering
