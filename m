Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A1BEEAA56
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 16:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjINQla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjINQl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Sep 2023 12:41:29 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9E21FD7;
        Thu, 14 Sep 2023 09:41:25 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 0906213953C; Thu, 14 Sep 2023 12:41:25 -0400 (EDT)
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-5-dlemoal@kernel.org>
 <0d7e1e2d-06a8-4992-be0b-7a97646c170d@suse.de>
 <8ca4afdb-bf15-c964-c225-b5f6d7b4d670@kernel.org>
 <82d68ebf-bde9-4046-b6bf-3e908a94a8eb@suse.de>
User-agent: mu4e 1.7.12; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 04/19] ata: libata-scsi: Disable scsi device
 manage_start_stop
Date:   Thu, 14 Sep 2023 12:37:37 -0400
In-reply-to: <82d68ebf-bde9-4046-b6bf-3e908a94a8eb@suse.de>
Message-ID: <875y4cyafe.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes Reinecke <hare@suse.de> writes:

>> forever. This is according to SAT specs. There is no command to explicitly get
>> out of standby-mode. Even a reset should not change the drive power state
>> (though I do see a lot of drive waking up on COMRESET). A media access command
>> does that. See ACS specs "Power Management states and transitions". The only
>> exception is that you can use SET FEATURE command to wake up a drive, but only
>> from PUIS state (Power-Up in Standby), which is a different feature that is not
>> necessarilly supported by a device.


IIRC, there was a bit in the IDENTIFY block that if set, meant that the
drive WOULD NOT automatically spin up on access, and you HAD to use SET
FEATURE to wake it.  I seem to recall that my Western Digital drives did
this and my bios would not recognize the drives as bootable because it
did not know how to issue SET FEATURE to force it to spin up.

