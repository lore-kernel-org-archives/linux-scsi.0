From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/7] Performance improvements for LSI SCSI cards
Date: Sun, 30 Mar 2014 22:54:45 -0700
Message-ID: <1396245285.22255.52.camel@haakon3.risingtidesystems.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39456 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaCaFy5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 01:54:57 -0400
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-scsi@vger.kernel.org, willy@linux.intel.com, "Kashyap, Desai" <kashyap.desai@lsi.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

Hi Matthew,

On Thu, 2014-03-27 at 16:40 -0400, Matthew Wilcox wrote:
> The host lock is a serious scalability problem on 2-socket and larger
> systems which are doing a lot of I/O.  Before removing the temporary
> usgae of DEF_SCSI_QCMD, we need to remove all uses of serial_number.
> 
> An unrelated performance issue is that reusing the most recent
> driver-specific data structure to track the I/O instead of the least
> recently used keeps the cache-hot lines in use, which is a nice
> performance improvement.  It's already present in the mpt3sas driver,
> it just didn't make it into the fusion or mpt2sas drivers yet.
> 
> Matthew Wilcox (7):
>   mpt3sas: Remove uses of serial_number
>   mpt3sas: Remove use of DEF_SCSI_QCMD
>   mpt2sas: Remove uses of serial_number
>   mpt2sas: Remove use of DEF_SCSI_QCMD
>   mpt2sas: Add free smids to the head, not tail of list
>   fusion: Add free msg frames to the head, not tail of list
>   fusion: Remove use of DEF_SCSI_QCMD
> 
>  

+1 to this long overdue series to enable host_lock-less mode with
mpt*sas + fusion.  (CC'ing LSI folks + jejb)

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

