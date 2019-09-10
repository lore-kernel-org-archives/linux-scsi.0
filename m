Return-Path: <SRS0=qYHy=XF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A7EC4740A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 14:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10C1421019
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 14:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731801AbfIJOHl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 10:07:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfIJOHl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Sep 2019 10:07:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD7FA30044CE;
        Tue, 10 Sep 2019 14:07:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4F135DA21;
        Tue, 10 Sep 2019 14:07:38 +0000 (UTC)
Subject: Re: [RFC PATCH 0/4] iscsi: chap: introduce support for SHA1 and
 SHA3-256
To:     "Black, David" <David.Black@dell.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "cleech@redhat.com" <cleech@redhat.com>,
        "mchristi@redhat.com" <mchristi@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
References: <20190829155929.27701-1-mlombard@redhat.com>
 <20190903070013.GA12256@infradead.org>
 <CE03DB3D7B45C245BCA0D24327794936306D540B@MX307CL04.corp.emc.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <78692dca-949b-dcf2-3b69-a1755956f216@redhat.com>
Date:   Tue, 10 Sep 2019 16:07:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CE03DB3D7B45C245BCA0D24327794936306D540B@MX307CL04.corp.emc.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 10 Sep 2019 14:07:40 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello David,

first of all, thank for your reply and your offer to help with this.
We appreciate this a lot.


Dne 4.9.2019 v 01:59 Black, David napsal(a):
> Christoph,
> 
>> Adding Dave Black who has helped with IANA interaction in NVMe recently.
> 
> I see my cue ... please keep me cc:'d on this conversation, as I'm not on either of the mailing lists.
> 
>> But we'll need IANA assignments and IETF consensus before adding new
>> algorithms to ensure we have interoperable implementations.
> 
> In reverse order ...
> 
> -- IETF Consensus: 
> 
> My sense of the IETF view on secure hashes is that MD5 and SHA1 are broken, whereas the SHA2 algorithms are proving to be longer-lived (more resistant to attack) than expected, and the SHA3 algorithms are fine.
> 
> That suggests that registration of codepoints for both SHA2 and SHA3 would be a good thing to do, as opposed to only SHA3.  I'd suggest starting with either SHA-256 or SHA-512/256 (both are SHA2 hashes) in addition to SHA3-256, as all three have the same 256-bit output size.

Agree. Having SHA-256 would make sense.

> 
> Figuring out exactly what should be done here (e.g., which SHA2 variant to register) would benefit from some discussion at IETF.  I would start with the Security Area's saag@ietf.org mailing list.  In addition, as iSCSI falls within IETF's Transport Area, the Transport Area Directors ought to be looped in beforehand.  Fortunately, publication of an RFC is not necessary, because ...

Ok, I am going to send an email for the SAAG mailing list to see what they think about it.

> 
> -- IANA assignments
> 
> ... the Registration Procedure for PPP Authentication Algorithms is Expert Review.   The long version of what that means is in Section 4.5 of RFC 8126: https://tools.ietf.org/html/rfc8126#section-4.5.  The short version is that a request for allocation of these codepoints is submitted to IANA, whose designated expert then makes a decision.  It's probably a good idea for that request to state that the intended usage is iSCSI, and say that it's ok to restrict the resulting registrations solely to use by iSCSI.
> 
> As Christoph notes, I've helped with IANA interactions at NVMe, and would be likewise willing to help here.  My name is attached to the SHA1 registration, so it would make sense for me to ask for the SHA2 and SHA3 registrations, and I know a number of the people who will be involved in ensuring that the proverbial "right thing" happens, e.g., the Transport Area Directors.

Thank you very much for the help!
Maurizio Lombardi
