From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature
 support
Date: Fri, 8 Aug 2014 22:01:05 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D859D323@nice.asicdesigners.com>
References: <1407364668-20931-1-git-send-email-anish@chelsio.com>
 <1407364668-20931-2-git-send-email-anish@chelsio.com>,<53E2E3A6.7010402@cs.wisc.edu>,<525DB349B3FB5444AE057A887CB2A8D859BA06@nice.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:20549
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758243AbaHHWCY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2014 18:02:24 -0400
In-Reply-To: <525DB349B3FB5444AE057A887CB2A8D859BA06@nice.asicdesigners.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

Mike, I presume you meant the
8846bab
    scsi_cmnd: Introduce scsi_transfer_length helper
d77e653
libiscsi, iser: Adjust data_length to include protection information

 & Martin's fix after that 
5616b0
use the scsi data buffer length to extract transfer size

I see the commits in the branches, but not in master. Do the patches need to be
 rebased onto drivers-for-3.17 then ?
-Anish
________________________________________
From: Anish Bhatt
Sent: Wednesday, August 06, 2014 7:35 PM
To: Mike Christie
Cc: linux-scsi@vger.kernel.org; hch@infradead.org; jbottomley@parallels.com; Karen Xie; Manoj Malviya
Subject: RE: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature support

This patch was made over scsi-devel/master, I'll rebase it to Christoph's tree
-Anish
________________________________________
From: Mike Christie [michaelc@cs.wisc.edu]
Sent: Wednesday, August 06, 2014 7:25 PM
To: Anish Bhatt
Cc: linux-scsi@vger.kernel.org; hch@infradead.org; jbottomley@parallels.com; Karen Xie; Manoj Malviya
Subject: Re: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature support

 On 08/06/2014 05:37 PM, Anish Bhatt wrote
> @@ -436,12 +473,12 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>                       /* No unsolicit Data-Out's */
>                       hdr->flags |= ISCSI_FLAG_CMD_FINAL;
>       } else {
> +             unsigned in_len = iscsi_scsi_in_total_length(sc);
>               hdr->flags |= ISCSI_FLAG_CMD_FINAL;
>               zero_data(hdr->dlength);
> -             hdr->data_length = cpu_to_be32(scsi_in(sc)->length);
> -
>               if (sc->sc_data_direction == DMA_FROM_DEVICE)
>                       hdr->flags |= ISCSI_FLAG_CMD_READ;
> +             hdr->data_length = cpu_to_be32(in_len);
>       }
>

What tree and branch did you make these over? Have you seen the patches
from Sagi for iser and libiscsi support?

Could you rebuild this over Christoph's tree which has his patches:

git://git.infradead.org/users/hch/scsi-queue.git
