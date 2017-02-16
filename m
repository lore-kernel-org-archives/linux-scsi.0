From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Thu, 16 Feb 2017 01:10:09 +0000
Message-ID: <1487207394.2666.14.camel@sandisk.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
         <1487176942.2666.1.camel@sandisk.com>
         <6f142c01-dc11-e86b-9100-d1e11c13f507@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:56504 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdBPBKe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 20:10:34 -0500
In-Reply-To: <6f142c01-dc11-e86b-9100-d1e11c13f507@wdc.com>
Content-Language: en-US
Content-ID: <F0C6585E7538154CA7017F5387A07B18@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linuxram@us.ibm.com" <linuxram@us.ibm.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "hch@lst.de" <hch@lst.de>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

On Thu, 2017-02-16 at 09:54 +0900, Damien Le Moal wrote:
> On 2/16/17 01:42, Bart Van Assche wrote:
> > An additional concern: what if the size of the Data-Out buffer is not a
> > multiple of the logical block size? Shouldn't we round down (good_bytes -
> > resid) instead of rounding up resid?
> 
> The only REQ_TYPE_FS request that may not operate on LBA size aligned
> payloads is REQ_OP_ZONE_REPORT which is handles in a different case of
> the switch statement. So I think it is safe.

Hello Damien,

Are you aware that it is the software that submits a request that controls
the buffer length and not the device that processes a request? Submitting
Data-Out buffers with odd sizes is one of the tests in the libiscsi test
suite. See e.g. the source file test-tool/test_write10_residuals.c in that
test suite. The request submitted by the libiscsi test suite reach the
kernel of the target system either through SG IO or through the iSCSI
target driver. When using iSCSI, both the LIO and SCST SCSI target
frameworks translate these requests into REQ_TYPE_FS requests. I think we
should aim not to affect the outcome of libiscsi tests when the underlying
device is a SCSI disk.

Thanks,

Bart.
