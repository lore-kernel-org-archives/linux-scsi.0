Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0390DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 09:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbiGMJJF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 05:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiGMJJF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 05:09:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CAFA44D9
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 02:09:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5C43B1F899;
        Wed, 13 Jul 2022 09:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657703341; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lKU363P+X4155K3SD7IOzleQglqmIhnB08RXmzoXOlI=;
        b=YTNFe4KL3/nrl7OImvV8KvbQSozNydFCPRR1r6Au6aayjFgdkv+5eFqUOdinXlTcz/qQgx
        UPcE4uhm9x/Tj+HkmY3oBs5IR4YwGbwWlwTNstqJC2fNtgrlNOj7JZCAAL96RyGRPiY7Fb
        evcrPOxjqlQZwRtzIPc9VHbZII21C9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657703341;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lKU363P+X4155K3SD7IOzleQglqmIhnB08RXmzoXOlI=;
        b=uhDpQw9qvDQLozoeiQONeUdqOB21WH/2xuUHZu0yFb63VeZlOvQG0ArcAQguvj2lkCyI6Z
        n+BajNM7C7hGi3Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4652813754;
        Wed, 13 Jul 2022 09:09:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OKjAEK2LzmJZSgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 13 Jul 2022 09:09:01 +0000
Message-ID: <d3cb23e6-50a8-43bf-5031-90a0907bed7c@suse.de>
Date:   Wed, 13 Jul 2022 11:09:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [Bug 216232] New: mysterious block devices are shown under /dev
 folder
Content-Language: en-US
To:     bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org
References: <bug-216232-11613@https.bugzilla.kernel.org/>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <bug-216232-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/10/22 11:47, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216232
> 
>              Bug ID: 216232
>             Summary: mysterious block devices are shown under /dev folder
>             Product: SCSI Drivers
>             Version: 2.5
>      Kernel Version: 5.4.61
>            Hardware: All
>                  OS: Linux
>                Tree: Mainline
>              Status: NEW
>            Severity: normal
>            Priority: P1
>           Component: QLOGIC QLA2XXX
>            Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
>            Reporter: yshxxsjt715@gmail.com
>          Regression: No
> 
> we are using linux kernel 5.4.61 and fibre channel card is qlogic's
> ISP2722-based 16/32Gb adapter card.
> 
> the problem is that we are seeing some devices with lun 768 with size of 512B
> shown under /dev folder. In the syslog we saw something like
> 
> Jul 10 17:00:08 hci01 kernel: [21675145.568997] scsi_io_completion_action: 24
> callbacks suppressed
> Jul 10 17:00:08 hci01 kernel: [21675145.569005] sd 6:0:0:768: [sdau] tag#1298
> FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jul 10 17:00:08 hci01 kernel: [21675145.569011] sd 6:0:0:768: [sdau] tag#1298
> Sense Key : Illegal Request [current]
> Jul 10 17:00:08 hci01 kernel: [21675145.569015] sd 6:0:0:768: [sdau] tag#1298
> Add. Sense: Logical block address out of range
> Jul 10 17:00:08 hci01 kernel: [21675145.569019] sd 6:0:0:768: [sdau] tag#1298
> CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> Jul 10 17:00:08 hci01 kernel: [21675145.569021] print_req_error: 24 callbacks
> suppressed
> Jul 10 17:00:08 hci01 kernel: [21675145.569025] blk_update_request: critical
> target error, dev sdau, sector 0 op 0x0:(READ) flags 0x80700 phys_seg 1 prio
> class 0
> Jul 10 17:00:08 hci01 kernel: [21675145.601879] sd 6:0:0:768: [sdau] tag#1299
> FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jul 10 17:00:08 hci01 kernel: [21675145.601883] sd 6:0:0:768: [sdau] tag#1299
> Sense Key : Illegal Request [current]
> Jul 10 17:00:08 hci01 kernel: [21675145.601886] sd 6:0:0:768: [sdau] tag#1299
> Add. Sense: Logical block address out of range
> Jul 10 17:00:08 hci01 kernel: [21675145.601888] sd 6:0:0:768: [sdau] tag#1299
> CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> Jul 10 17:00:08 hci01 kernel: [21675145.601891] blk_update_request: critical
> target error, dev sdau, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class
> 0
> Jul 10 17:00:08 hci01 kernel: [21675145.604213] buffer_io_error: 22 callbacks
> suppressed
> Jul 10 17:00:08 hci01 kernel: [21675145.604215] Buffer I/O error on dev sdau,
> logical block 0, async page read
> Jul 10 17:00:08 hci01 kernel: [21675145.634149] sd 6:0:0:768: [sdau] tag#1300
> FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jul 10 17:00:08 hci01 kernel: [21675145.634152] sd 6:0:0:768: [sdau] tag#1300
> Sense Key : Illegal Request [current]
> Jul 10 17:00:08 hci01 kernel: [21675145.634155] sd 6:0:0:768: [sdau] tag#1300
> Add. Sense: Logical block address out of range
> Jul 10 17:00:08 hci01 kernel: [21675145.634158] sd 6:0:0:768: [sdau] tag#1300
> CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> 
> here, the lun id of 768 does not exist on SAN but when I try to manually delete
> it, after some seconds it still appears.
> 

This looks more like a configuration issue on the storage.
What is the output of 'lsscsi' on your system?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
