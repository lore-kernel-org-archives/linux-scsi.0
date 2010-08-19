From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
Date: Thu, 19 Aug 2010 15:45:47 -0700
Message-ID: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:36798 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753316Ab0HSWta (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2010 18:49:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>

Greetings mnc and tomo,

So as per our discussions last week, I will be moving forward with the
conversion of the LIO-Target iSCSI fabric module v4 to use protocol and
PDU include/scsi/iscsi_proto.h.  As mnc and I agreed privately, this is
going to the right level of integration for v2.6.37, as making libiscsi
target mode aware does not really make for a target mode iSCSI stack
sense due to the amount of logic in place for kernel <-> user with the
Open-iSCSI initiator.

So aside from the main tedious work that will be involved in actually
producing a patch for this on my end, I did notice one immediate item
that will cause an extra headache..  This involves the struct
iscsi_init_* and struct iscsi_target* structure definitions in:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/lio-target/iscsi_protocol.h;hb=refs/heads/lio-4.0

namely that they all have trailing 'u32 header_digest' member that a
decent amount of utility code in iscsi_target.c and iscsi_target_util.c
currently depends upon.

So, assuming that the conversion of all struct iscsi_init_* and struct
iscsi_target* to use include/scsi/iscsi_proto.h defs just involves
checking structure size and renaming the member use in
drivers/target/lio-target, would it be acceptable to do something like:

/* iSCSI PDU Header */
struct iscsi_cmd {
        uint8_t opcode;
        uint8_t flags;
        __be16 rsvd2;
        uint8_t hlength;
        uint8_t dlength[3];
        uint8_t lun[8];
        itt_t    itt;   /* Initiator Task Tag */
        __be32 data_length;
        __be32 cmdsn;
        __be32 exp_statsn;
        uint8_t cdb[ISCSI_CDB_SIZE];    /* SCSI Command Block */
        /* Additional Data (Command Dependent) */
#ifdef ISCSI_TARGET_MODE
        __be32 header_digest;
#endif
};

for the existing PDU defs in iscsi_proto.h in order to the pain
of having to convert this over in existing LIO-Target fabric module
code..?  This really help me alot.

Thanks!

--nab


