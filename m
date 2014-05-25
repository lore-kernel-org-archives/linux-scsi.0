From: Julian Satran <julians@infinidat.com>
Subject: Re: iSCSI Expected Data Transfer Length for T10-PI
Date: Sun, 25 May 2014 22:39:28 +0300
Message-ID: <AD52A8E9-F044-4E3A-A842-D53BF06C8CF1@infinidat.com>
References: <53820C9B.3090003@dev.mellanox.co.il>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:60875 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaEYTjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 May 2014 15:39:33 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so7211497wes.27
        for <linux-scsi@vger.kernel.org>; Sun, 25 May 2014 12:39:32 -0700 (PDT)
In-Reply-To: <53820C9B.3090003@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Oren Duer <oren@mellanox.com>, "james.smart@emulex.com" <james.smart@emulex.com>, Or Gerlitz <ogerlitz@mellanox.com>, "cbm@chadalapaka.com" <cbm@chadalapaka.com>, "meth@il.ibm.com" <meth@il.ibm.com>, "david.black@emc.com" <david.black@emc.com>

I have some trouble parsing you English/Question. I think the intent of SCSI PI was that wherever the PI exist it should be checked end-to-end and it may be checked in between.
A storage client (server) will have the PI appended in the memory when writing and reading and checking it. As the values are standardized storage may also check it both when reading and when writing but it should not change it. If by implicit you mean inclusive I assume iSCSI Expected data transfer length will take whatever is in the cdb.
Block transfer devices will likely add the PI length to the pure data length - i.e. inclusive. iSER may allow placing PI in diferent memory areas than the pure data but I think it has already provisions for that.

Regards,
Julo


> On May 25, 2014, at 18:30, Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
> 
> Hey All,
> 
> Recently, iSER end-to-end T10-PI support maid it mainline.
> I am wandering about the impact T10-PI should or shouldn't have on iSCSI header
> field "Expected Data Transfer Length".
> 
> RFC-7143 states:
> "the Expected Data Transfer Length field contains the number of bytes of data involved in this SCSI operation."
> Since this field relates to *data bytes* I kept T10-PI implicit wrt this field. The iSCSI target calculates the
> total transfer length (data + protection) from the cdb transfer length field and protect bits.
> 
> In FC, the fc_dl field was updated to relate to the total number of transfer bytes and includes
> data and protection bytes. virtio_scsi was added with a header PI section (virtio_scsi_cmd_req_pi).
> 
> So my question is, should this field be updated to explicitly include T10-PI bytes like the FC equivalent fc_dl?
> Or should T10-PI bytes be implicit?
> 
> I want to pin down this one to avoid a situation where the standard is open for interpretations.
> 
> Thanks,
> Sagi.
