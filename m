From: Jeff Garzik <jeff@garzik.org>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 03 May 2009 14:40:10 -0400
Message-ID: <49FDE50A.4060503@garzik.org>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com> <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils> <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com> <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com> <49FDE3BB.505@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49FDE3BB.505@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> (2) determine at init if queue (a) supports explicit DISCARD and/or (b) 
> supports DISCARD flag passed with READ or WRITE


As an aside -- does any existing command set support case #b, above?

AFAICT, ATA, SCSI and NVMHCI all have a single, explicit hardware 
command to discard/deallocate unused sectors.

Therefore, creating REQ_TYPE_DISCARD seems to eliminate any need for new 
hook ->prepare_discard().

This provides a 1:1 correspondence between hardware and struct request, 
most closely matching the setup of known hardware.

	Jeff



