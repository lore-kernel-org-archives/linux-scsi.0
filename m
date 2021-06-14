Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562DDC48BDF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 01:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 304396100B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 01:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhFNBaI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 21:30:08 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:47995 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhFNBaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 21:30:07 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 48A8A2EA0D3;
        Sun, 13 Jun 2021 21:28:05 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id 3LHZ4TsT1zIa; Sun, 13 Jun 2021 21:28:04 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id A39472EA0C2;
        Sun, 13 Jun 2021 21:28:04 -0400 (EDT)
Reply-To: dgilbert@interlog.com
To:     linux-scsi <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Tony Asleson <tasleson@redhat.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: libata: big endian bug in VPD page 89 (ATA Information)
Message-ID: <f0d1073e-b4a0-c255-41a3-ff52f1553c0f@interlog.com>
Date:   Sun, 13 Jun 2021 21:28:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In drivers/ata/libata-scsi.c in function ata_scsiop_inq_89() there is
this line, just before the return:
        memcpy(&rbuf[60], &args->id[0], 512);

args->id[0] is the first u16 word of an array from the ATA IDENTIFY
DEVICE response while rbuf is an array of u8 that will become the
response to a SCSI INQUIRY(VPD=89h). Given the definition of VPD
page 89h:
    byte 60+0:  ATA IDENTIFY DEVICE data word 0 bits 7:0
    byte 60+1:  ATA IDENTIFY DEVICE data word 0 bits 15:8
    byte 60+2:  ATA IDENTIFY DEVICE data word 1 bits 7:0
    ........

then that memcpy is just fine and dandy on a little endian machine.
On a big endian machine, not so much.

Would this call after the memcpy fix things?
     swap_buf_le16((u16 *)(rbuf + 60), ATA_ID_WORDS);

That function (in libata-core.c) only swaps bytes in 16 bit words
on big endian machines.

Doug Gilbert
