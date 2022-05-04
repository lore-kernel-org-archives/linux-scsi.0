Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C5DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 07:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242210AbiEDHPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 03:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbiEDHP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 03:15:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3838122BEA
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 00:11:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D7780210ED;
        Wed,  4 May 2022 07:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651648309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tFn9wwCC2jbZbvF2m0NYpG+KYz+1Qoet6t0hgOWJc6Y=;
        b=qQs5BaWdkBcajRkOAEHRS6mRI+h/bTAuISJP75XGmBoaLJcqQvySBhKZxv83vRza0J5qIg
        cMjjDnBcp0Mfx8hSeEAZaVP+X0OJcCkvuHUXJcEUeCz7PepO6nIel4kmphUhD90AVjoj0a
        LdojoyU97Ovi274zrssUWkDExqKDav4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9BDEC131BD;
        Wed,  4 May 2022 07:11:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4kiXJDUncmKiSwAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 04 May 2022 07:11:49 +0000
Message-ID: <9d7e7a5613decc1737ef2601ebb2506890790930.camel@suse.com>
Subject: lpfc: regression with lpfc 14.2.0.0 / Skyhawk: FLOGI failure
From:   Martin Wilck <mwilck@suse.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Justin Tee <justin.tee@broadcom.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        David Bond <dbond@suse.com>, Hannes Reinecke <hare@suse.com>
Date:   Wed, 04 May 2022 09:11:49 +0200
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have encountered a regression with linux 5.18-rc5, where Skyhawk
controllers ("Emulex OneConnect OCe14000") fail at the FLOGI stage and
don't detect any rports.

We've bisected it to 1b64aa9eae28 ("scsi: lpfc: SLI path split:
Refactor fast and slow paths to native SLI4").

As this was 5.18-rc5,the following fixups on top of 14.2.0.0 were
already included in the tested code:

c26bd6602e1d scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()
7294a9bcaa7e scsi: lpfc: Fix broken SLI4 abort path
4f3beb36b1e4 scsi: lpfc: Update lpfc version to 14.2.0.1
df0101197c4d scsi: lpfc: Fix queue failures when recovering from PCI parity=
 error
a4691038b407 scsi: lpfc: Fix unload hang after back to back PCI EEH faults
35ed9613d83f scsi: lpfc: Improve PCI EEH Error and Recovery Handling

The relevant part of the log (AFAICT) looks like this, showing an "ELS
CQE error at the FLOGI stage:

lpfc 0000:04:00.2: 0:1303 Link Up Event x1 received Data: x1 x0 x4 x0 x0 x0=
 0
lpfc 0000:04:00.2: 0:2778 Start FCF table scan at linkup
lpfc 0000:04:00.2: 0:2726 READ_FCF_RECORD Indicates empty FCF table.
lpfc 0000:04:00.2: 0:2765 Mailbox command READ_FCF_RECORD failed to retriev=
e a FCF record.
lpfc 0000:04:00.2: 0:0392 Async Event: word0:x0, word1:x1, word2:x2, word3:=
xc0010200
lpfc 0000:04:00.2: 0:2546 New FCF event, evt_tag:x2, index:x0
lpfc 0000:04:00.2: 0:2779 Read FCF (x0) for updating roundrobin FCF failove=
r bmask
lpfc 0000:04:00.2: 0:2770 Start FCF table scan per async FCF event, evt_tag=
:x2, index:x0
lpfc 0000:04:00.2: 0:2764 READ_FCF_RECORD:
lpfc 0000:04:00.2: 0:3059 adding idx x0 pri x80 flg x0
lpfc 0000:04:00.2: 0:2790 Set FCF (x0) to roundrobin FCF failover bmask
lpfc 0000:04:00.2: 0:2764 READ_FCF_RECORD:
lpfc 0000:04:00.2: 0:3059 adding idx x0 pri x80 flg x1
lpfc 0000:04:00.2: 0:2790 Set FCF (x0) to roundrobin FCF failover bmask
lpfc 0000:04:00.2: 0:2840 Update initial FCF candidate with FCF (x0)
lpfc 0000:04:00.2: 0:(0):0247 Start Discovery Timer state x7 Data: x21 xfff=
f9ac83c2449e8 x0 x0
lpfc 0000:04:00.2: 0:(0):0932 FIND node did xfffffe NOT FOUND.
lpfc 0000:04:00.2: 0:0001 Allocated rpi:x0 max:x1000 lim:x40
lpfc 0000:04:00.2: 0:(0):0007 Init New ndlp xffff9abe3071ce00, rpi:x0 DID:f=
ffffe flg:x0 refcnt:1
lpfc 0000:04:00.2: 0:(0):0116 Xmit ELS command x4 to remote NPORT xfffffe I=
/O tag: x800, port state:x7 rpi x0 fc_flag:x90014
lpfc 0000:04:00.2: 0:(0):0247 Start Discovery Timer state x7 Data: x21 xfff=
f9ac83c2449e8 x0 x0
lpfc 0000:04:00.2: 0:(0):0354 Mbox cmd issue - Enqueue Data: x31 (x0/x0) x7=
 x200 x2
lpfc 0000:04:00.2: 0:(0):0355 Mailbox cmd x31 (x0/x0) issue Data: x7 x300
lpfc 0000:04:00.2: 0:0357 ELS CQE error: status=3Dx3: CQE: 08000300 0000000=
0 00000002 80010000
lpfc 0000:04:00.2: 0:0321 Rsp Ring 2 error: IOCB Data: x8000300 x0 x2 x8001=
0000
lpfc 0000:04:00.2: 0:2611 FLOGI failed on FCF (x0), status:x3/x2, tmo:x14, =
perform roundrobin FCF failover
lpfc 0000:04:00.2: 0:3060 Last IDX 0
lpfc 0000:04:00.2: 0:3061 Last IDX 0
lpfc 0000:04:00.2: 0:2844 No roundrobin failover FCF available
lpfc 0000:04:00.2: 0:2865 No FCF available, stop roundrobin FCF failover an=
d change port state:x7/x0

Comparison with a "good" case with lpfc 14.0.0.4:

lpfc 0000:04:00.2: 0:1303 Link Up Event x1 received Data: x1 x0 x4 x0 x0 x0=
 0
lpfc 0000:04:00.2: 0:2778 Start FCF table scan at linkup
lpfc 0000:04:00.2: 0:2726 READ_FCF_RECORD Indicates empty FCF table.
lpfc 0000:04:00.2: 0:2765 Mailbox command READ_FCF_RECORD failed to retriev=
e a FCF record.
lpfc 0000:04:00.2: 0:0392 Async Event: word0:x0, word1:x1, word2:x2, word3:=
xc0010200
lpfc 0000:04:00.2: 0:2546 New FCF event, evt_tag:x2, index:x0
lpfc 0000:04:00.2: 0:2779 Read FCF (x0) for updating roundrobin FCF failove=
r bmask
lpfc 0000:04:00.2: 0:2770 Start FCF table scan per async FCF event, evt_tag=
:x2, index:x0
lpfc 0000:04:00.2: 0:2764 READ_FCF_RECORD:
lpfc 0000:04:00.2: 0:3059 adding idx x0 pri x80 flg x0
lpfc 0000:04:00.2: 0:2790 Set FCF (x0) to roundrobin FCF failover bmask
lpfc 0000:04:00.2: 0:(0):0307 Mailbox cmd x9b (xc/x8) Cmpl lpfc_mbx_cmpl_fc=
f_scan_read_fcf_rec [lpfc] Data: x9b00 x8 x244 x0 x0 x0 xfa8cd000 xf x244 x=
0 x0 x0
lpfc 0000:04:00.2: 0:2764 READ_FCF_RECORD:
lpfc 0000:04:00.2: 0:3059 adding idx x0 pri x80 flg x1
lpfc 0000:04:00.2: 0:2790 Set FCF (x0) to roundrobin FCF failover bmask
lpfc 0000:04:00.2: 0:2840 Update initial FCF candidate with FCF (x0)
lpfc 0000:04:00.2: 0:(0):0247 Start Discovery Timer state x7 Data: x21 xfff=
f94b6fcae69e8 x0 x0
lpfc 0000:04:00.2: 0:(0):0932 FIND node did xfffffe NOT FOUND.
lpfc 0000:04:00.2: 0:0001 Allocated rpi:x0 max:x1000 lim:x40
lpfc 0000:04:00.2: 0:(0):0007 Init New ndlp xffff94c6f0c99000, rpi:x0 DID:f=
ffffe flg:x0 refcnt:1
lpfc 0000:04:00.2: 0:(0):0116 Xmit ELS command x4 to remote NPORT xfffffe I=
/O tag: x800, port state:x7 rpi x0 fc_flag:x90014
lpfc 0000:04:00.2: 0:(0):0247 Start Discovery Timer state x7 Data: x21 xfff=
f94b6fcae69e8 x0 x0
lpfc 0000:04:00.2: 0:(0):0101 FLOGI completes successfully, I/O tag:x800, x=
ri x0 Data: x40002 xd0070000 x10270000 x0 x7 90014 2
lpfc 0000:04:00.2: 0:(0):1816 FLOGI NPIV supported, response data 0x1
lpfc 0000:04:00.2: 0:(0):0904 NPort state transition xfffffe, UNUSED -> UNM=
APPED
lpfc 0000:04:00.2: 0:(0):3183 lpfc_register_remote_port rport xffff94b7c467=
f800 DID xfffffe, role x0 refcnt 3

Hints appreciated. Complete logs and additional debug data can be provided =
on request.

Regards
Martin

