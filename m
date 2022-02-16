Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7536C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 08:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiBPIdP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 03:33:15 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiBPIdO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 03:33:14 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 00:33:02 PST
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15EAB2534
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 00:33:02 -0800 (PST)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 74F4B61577
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 06:35:34 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id 651D43AA58
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 06:35:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id 7B3slkDB9Wzb for <linux-scsi@vger.kernel.org>;
        Wed, 16 Feb 2022 06:35:34 +0000 (UTC)
Received: from [192.168.48.23] (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 15DAD3AA55
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 06:35:34 +0000 (UTC)
Message-ID: <ae40bef0-702f-04c4-9219-47502c37d977@interlog.com>
Date:   Wed, 16 Feb 2022 01:35:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: dgilbert@interlog.com
Content-Language: en-CA
To:     SCSI development list <linux-scsi@vger.kernel.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: sd: Unaligned partial completion
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

What should the sd driver do when it gets the error in the subject
line? Try again, and again, and again, and again ...?

sd 2:0:1:0: [sdb] Unaligned partial completion (resid=3584, sector_sz=4096)
sd 2:0:1:0: [sdb] tag#407 CDB: Read(16) 88 00 00 00 00 00 00 00 00 00 00 00 00 01 00

Not very productive, IMO. Perhaps, after say 3 retries getting the _same_
resid, it might rescan that disk. There is a big hint in the logged
data shown above: trying to READ 1 block (sector_sz=4096) and getting a
resid of 3584. So it got back 512 bytes (again and again ...). The disk
isn't mounted so perhaps it is being prepared. And maybe that preparation
involved a MODE SELECT which changed the LB size in its block descriptor,
prior to a FORMAT UNIT.


Another issue with that error message: what does "unaligned" mean in
this context? Surely it is superfluous and "Partial completion" is
more accurate (unless the resid is negative).

Doug Gilbert

