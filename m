From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Thu, 16 Feb 2017 09:50:51 +0900
Message-ID: <3b0ea061-225b-92f6-ee81-01f015185fae@wdc.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
 <1487171439.2990.2.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:39858 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbdBPAvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 19:51:04 -0500
In-Reply-To: <1487171439.2990.2.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "hch@lst.de" <hch@lst.de>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, Ram Pai <linuxram@us.ibm.com>

Bart,

On 2/16/17 00:10, Bart Van Assche wrote:
> On Wed, 2017-02-15 at 11:12 +0900, Damien Le Moal wrote:
>> +			resid = round_up(resid, sector_size);
>> +			if (resid < good_bytes)
>> +				good_bytes -= resid;
>> +			else
>> +				good_bytes = 0;
>> +			scsi_set_resid(SCpnt, resid);
> 
> Hello Damien,
> 
> If the Data-Out buffer is smaller than a single logical block, can the above
> code cause resid to exceed the Data-Out buffer size? I think we should avoid
> to convert a residual overflow into a residual underflow. Additionally, will
> round_up() work correctly if resid is negative (residual underflow)? How
> about using the following (untested) code instead of the above?
> 
> if (resid > 0) {
>         resid = min(good_bytes, round_up(resid, sector_size));
>         good_bytes -= resid;
>         scsi_set_resid(SCpnt, resid);
> }

Indeed, that would be more solid and cover all possible weird values of
resid. I will resend a v5.

Thanks.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
