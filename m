From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
Date: Fri, 20 Aug 2010 16:32:37 +0900
Message-ID: <20100820163058P.fujita.tomonori@lab.ntt.co.jp>
References: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:32800 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab0HTHdD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2010 03:33:03 -0400
In-Reply-To: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, hare@suse.de

On Thu, 19 Aug 2010 15:45:47 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> So, assuming that the conversion of all struct iscsi_init_* and struct
> iscsi_target* to use include/scsi/iscsi_proto.h defs just involves
> checking structure size and renaming the member use in
> drivers/target/lio-target, would it be acceptable to do something like:
> 
> /* iSCSI PDU Header */
> struct iscsi_cmd {
>         uint8_t opcode;
>         uint8_t flags;
>         __be16 rsvd2;
>         uint8_t hlength;
>         uint8_t dlength[3];
>         uint8_t lun[8];
>         itt_t    itt;   /* Initiator Task Tag */
>         __be32 data_length;
>         __be32 cmdsn;
>         __be32 exp_statsn;
>         uint8_t cdb[ISCSI_CDB_SIZE];    /* SCSI Command Block */
>         /* Additional Data (Command Dependent) */
> #ifdef ISCSI_TARGET_MODE
>         __be32 header_digest;
> #endif
> };

It's up to Mike but it looks hacky to me. struct iscsi_pdu is defined
in the exact way as the spec does.

I don't think that iscsi_proto.h conversion is a must for the mainline
inclusion. I prefer to let it alone for now.
