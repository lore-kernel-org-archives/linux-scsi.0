From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: libsrp, the SRP_CMD request and additional CDB's
Date: Sun, 6 Dec 2009 11:07:03 +0100
Message-ID: <e2e108260912060207s243a018cj422f852fdf57c1cf@mail.gmail.com>
References: <e2e108260912060204x475b8499j4e267e3995f6ff8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52748 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206AbZLFKG6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2009 05:06:58 -0500
Received: by bwz27 with SMTP id 27so2866231bwz.21
        for <linux-scsi@vger.kernel.org>; Sun, 06 Dec 2009 02:07:04 -0800 (PST)
In-Reply-To: <e2e108260912060204x475b8499j4e267e3995f6ff8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hello,

While reverse engineering the libsrp source code I came across the
following statement in the function called srp_transfer_data():

offset = cmd->add_cdb_len * 4;

This offset is computed such that the code below it can skip the
ADDITIONAL CDB section in SRP_CMD requests. According to the header
file include/scsi/srp.h, the field add_cdb_len corresponds to the
one-byte field at byte offset 31 in the SRP_CMD request. And according
to the SRP spec (draft r16a), the layout of the field at offset 31 is
as follows:
* Bits 0 and 1 are reserved.
* Bits 2 to 7 represent the ADDITIONAL CDB LENGTH field, symbolically
represented as n.
The SRP spec also makes clear that the ADDITIONAL CDB section takes 4*n bytes.

If my interpretation of the srp.h header file and the SRP spec is
correct, the above statement should be replaced by:

offset = (cmd->add_cdb_len >> 2) * 4;

or, equivalently:

offset = cmd->add_cdb_len & ~3;

Not ignoring the lower two bits of the add_cdb_len field would be
dangerous because at least the ibmvscsi driver uses these bits as
flags.

Does this make sense ?

Bart.
