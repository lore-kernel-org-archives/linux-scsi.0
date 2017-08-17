From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: No I/O errors reported after SATA link hard reset
Date: Thu, 17 Aug 2017 17:01:36 +0200
Message-ID: <5546b954a6f291189a7d949ba8ced69a@assyoma.it>
References: <fe5cc200a4cba71cb9e5e6a980699805@assyoma.it>
 <13561110-4e59-303a-8e3d-dd60c1bafba8@fastmail.fm>
 <20170817124821.GA3238792@devbig577.frc2.facebook.com>
 <4debd4d8dea1d534ef555ceae4429435@assyoma.it>
 <20170817144657.GF3238792@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:35408 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdHQPBl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 11:01:41 -0400
In-Reply-To: <20170817144657.GF3238792@devbig577.frc2.facebook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

Il 17-08-2017 16:46 Tejun Heo ha scritto:
> Upper layer can request to avoid retrying on errors but it won't help
> too much.  It doesn't have much to do with specific commands.  A power
> event can take place without any command in flight and lose the
> buffered data.  Unless upper layer is tracking all that's being
> written, there isn't much it can do outside doing full scan.  This is
> a condition which should be handled from the driver side.

True, I was not thinking about buffered (delayed) writes. However, for 
synchronized writes it should be possible: after all, for sync() writes 
the application is waiting for its completion. This means that if a 
powerloss/link renegotiation is detected between *the two FLUSH_CACHE 
commands*, and I/O error can be reported to the calling application.

What about disk supporting FUAs? Are they unaffected by this problem? If 
my understand it properly, torn writes remain a potential, but 
inevitable, problem when facing powerloss conditions.

By the way, when speaking about a "full scan" your are referring to full 
bus scanning/enumeration? Will it change devices name when 
re-discovering them?

> Yeah, looking into getting it implemented on the kernel side.

Great! Are your thinking about a polling approach or an event-driven 
one?

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
