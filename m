From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: libsrp, the SRP_CMD request and additional CDB's
Date: Tue, 8 Dec 2009 08:35:18 +0900
Message-ID: <20091208082337J.fujita.tomonori@lab.ntt.co.jp>
References: <e2e108260912060204x475b8499j4e267e3995f6ff8@mail.gmail.com>
	<e2e108260912060207s243a018cj422f852fdf57c1cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:54193 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935067AbZLGXfW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2009 18:35:22 -0500
In-Reply-To: <e2e108260912060207s243a018cj422f852fdf57c1cf@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bart.vanassche@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Sun, 6 Dec 2009 11:07:03 +0100
Bart Van Assche <bart.vanassche@gmail.com> wrote:

> While reverse engineering the libsrp source code I came across the
> following statement in the function called srp_transfer_data():
> 
> offset = cmd->add_cdb_len * 4;
> 
> This offset is computed such that the code below it can skip the
> ADDITIONAL CDB section in SRP_CMD requests. According to the header
> file include/scsi/srp.h, the field add_cdb_len corresponds to the
> one-byte field at byte offset 31 in the SRP_CMD request. And according
> to the SRP spec (draft r16a), the layout of the field at offset 31 is
> as follows:
> * Bits 0 and 1 are reserved.
> * Bits 2 to 7 represent the ADDITIONAL CDB LENGTH field, symbolically
> represented as n.
> The SRP spec also makes clear that the ADDITIONAL CDB section takes 4*n bytes.
> 
> If my interpretation of the srp.h header file and the SRP spec is
> correct, the above statement should be replaced by:
> 
> offset = (cmd->add_cdb_len >> 2) * 4;
> 
> or, equivalently:
> 
> offset = cmd->add_cdb_len & ~3;

Oops, good catch.

Either is fine by me. The reserved bits shall be set to zero in SCSI
though.


> Not ignoring the lower two bits of the add_cdb_len field would be
> dangerous because at least the ibmvscsi driver uses these bits as
> flags.

Hmm, where does the ibmvscsi driver use these bits?


Thanks,
