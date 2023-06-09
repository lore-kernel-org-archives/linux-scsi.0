Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 484ADC7EE29
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jun 2023 21:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjFIVJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jun 2023 17:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjFIVJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2023 17:09:22 -0400
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Jun 2023 14:09:21 PDT
Received: from amazone.undermydesk.org (amazone.undermydesk.org [213.211.198.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400971FDC
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jun 2023 14:09:21 -0700 (PDT)
Received: from [192.168.178.141] (p4fc62d90.dip0.t-ipconnect.de [79.198.45.144])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: frank)
        by amazone.undermydesk.org (Postfix) with ESMTPSA id 23CE2E773CD;
        Fri,  9 Jun 2023 22:53:11 +0200 (CEST)
Message-ID: <a1bf6f05-9be3-3bd8-7878-abfa3ff5dbe8@undermydesk.org>
Date:   Fri, 9 Jun 2023 22:54:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: memcpy: detected field-spanning write (size 128) of single field
 "&r1_cmd->io_request->SGL" at
 drivers/scsi/megaraid/megaraid_sas_fusion.c:3326 (size 16)
Content-Language: en-US
To:     Holger Kiehl <Holger.Kiehl@dwd.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <88de8faa-56c4-693d-2d3-67152ee72057@diagnostix.dwd.de>
From:   Frank Reppin <frank@undermydesk.org>
In-Reply-To: <88de8faa-56c4-693d-2d3-67152ee72057@diagnostix.dwd.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: amazone.undermydesk.org
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=frank smtp.mailfrom=frank@undermydesk.org
X-Rspamd-Queue-Id: 23CE2E773CD
X-Spamd-Result: default: False [-0.10 / 999999.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         RCPT_COUNT_SEVEN(0.00)[9];
         NEURAL_HAM(-0.00)[-0.960];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:3320, ipnet:79.192.0.0/10, country:DE];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear all,

at first - my apologies to bring this up again here.

But may I please ask/request to have this fix committed
to longterm 6.1 too?

Reason: Upcoming Debian Bookworm (currently RC4) comes with 6.1 but
does not include this fix yet - as it is only present in 6.3. - and
probably nobody noticed this one yet.

We do encounter this issue on brand new test machines (which should go
live once Bookworm is released) and this is a real showstopper
when it comes to show logs to QA audit people... ;)

Another reason: I see vanished /dev/disk/by-uuid/ entries when
this issue hits us

For example...

cryptsetup -v -y luksFormat 
/dev/disk/by-uuid/926943a2-8e40-445f-aad4-2ee96807cd32
-> this command should succeed - but returns with error because
somehow this (some seconds earlier perfectly valid and existing)
by-uuid entry vanished during the issue.
Other entries pointing to the same virtual drive are not affected.
(by-id,by-path,by-diskseq)

Last but not least... is this really a warning only?!
While I don't think that something on our brand new servers is broken
(it affects all btw - same observation as Holger mentioned here earlier)
it is really disturbing to see vanishing /dev/disk/by-uuid/ entries
since they might be used somewhere else and their sudden disappearance
might cause severe havoc for other daemons looking for them (server 
monitoring comes to mind ... nagios... zabbix)

Thankyou all!
cheers
Frank Reppin


-- 
43rd Law of Computing:
         Anything that can go wr
fortune: Segmentation violation -- Core dumped
