From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Tue, 13 Jun 2017 10:29:27 +0200
Message-ID: <95f6a1a1-8ebd-3178-42a0-898d6321bad2@suse.de>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
 <1488485325.5580.9.camel@haakon3.risingtidesystems.com>
 <20170305173528.00006b41@gmx.de>
 <CAL1RGDVBvgzaQTRfWS14=S1M1DuzKGPYzAPWWeQyAASDQ=05Rw@mail.gmail.com>
 <55205e7e-e1c6-5f09-8dd3-338492728dfe@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59040 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751753AbdFMI3a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jun 2017 04:29:30 -0400
In-Reply-To: <55205e7e-e1c6-5f09-8dd3-338492728dfe@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Roland Dreier <roland@purestorage.com>, Sebastian Herbszt <herbszt@gmx.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, jsmart2021@gmail.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On 06/13/2017 01:08 AM, James Smart wrote:
> Here's what I'd like to propose for a direction:
> 1) Create an initiator driver and a target driver.  For now, initiator
> would support both SCSI and NVME initiator. Target would support SCSI
> and NVME target.
> 2) SLI3 support would be contained only within the initiator driver and
> limited to SCSI (as it is today in lpfc).
> 3) SLI4 support would be library-ized,so that the code can be shared
> between the two drivers.  Library-izing SLI-4 means SLI-3 will also be
> library-ized.
> 4) Discovery support would be librarized so it can be shared. As part of
> this effort we will minimally move generic functions from the library to
> drivers/scsi/libfc (example: setting RPA payloads, etc).  At this time,
> the drivers will not attempt to use libfc for discovery. There is too
> much sensitive code tied to interlocks with adapter api design that are
> visible in the discovery state machine. Use of libfc can be a future,
> but for the short term, the goal is a single library for the broadcom
> initiator/target drivers.

Good idea, but be aware that libfc unfortunately is using skbs
internally which I don't like, but didn't have the time to clean it up.

> 5) lpfc will be refactored, addressing concerns that have been desired
> for a while.

\o/

When doing you refactoring can you please have a look at the levels of
indent (not more than 3 if possible), no unnecessary camelCase, etc...

The cyclomatic complexity GCC plugin we have in scripts/gcc-plugins
could be of help here, though I only have read about it and never really
used myself.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
