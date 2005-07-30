From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance
	Initiator
Date: Sat, 30 Jul 2005 12:32:42 -0500
Message-ID: <1122744762.5055.10.camel@mulgrave>
References: <429E15CD.2090202@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:14304 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263069AbVG3Rcq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2005 13:32:46 -0400
In-Reply-To: <429E15CD.2090202@yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Wed, 2005-06-01 at 13:08 -0700, Alex Aizman wrote:
> This is open-iscsi/linux-iscsi-5 Initiator. This submission is ready for
> inclusion into mainline kernel.

OK, I tried to put this into scsi-misc.

FIB has taken your netlink number, so I changed it to 32

__nlm_put() has had an updated prototype, which I can fix (although I'm
not sure you're supposed to be using this function...)

I can't fix up the compile errors in iscsi_tcp.c:

  CC [M]  drivers/scsi/iscsi_tcp.o
drivers/scsi/iscsi_tcp.c: In function `iscsi_hdr_extract':
drivers/scsi/iscsi_tcp.c:160: warning: implicit declaration of function
`iscsi_cnx_error'
drivers/scsi/iscsi_tcp.c:161: error: `ISCSI_ERR_PDU_GATHER_FAILED'
undeclared (first use in this function)
drivers/scsi/iscsi_tcp.c:161: error: (Each undeclared identifier is
reported only once
drivers/scsi/iscsi_tcp.c:161: error: for each function it appears in.)
drivers/scsi/iscsi_tcp.c: In function `iscsi_tcp_state_change':
drivers/scsi/iscsi_tcp.c:1005: error: `ISCSI_ERR_CNX_FAILED' undeclared
(first use in this function)
drivers/scsi/iscsi_tcp.c: In function `iscsi_sendhdr':
drivers/scsi/iscsi_tcp.c:1092: error: `ISCSI_ERR_CNX_FAILED' undeclared
(first use in this function)
drivers/scsi/iscsi_tcp.c: In function `iscsi_sendpage':
drivers/scsi/iscsi_tcp.c:1141: error: `ISCSI_ERR_CNX_FAILED' undeclared
(first use in this function)
drivers/scsi/iscsi_tcp.c: In function `iscsi_data_xmit_more':
drivers/scsi/iscsi_tcp.c:1707: error: `STOP_CNX_RECOVER' undeclared
(first use in this function)
drivers/scsi/iscsi_tcp.c: At top level:
[...]

Do you have an updated driver that will work in the current tree?

Thanks,

James


