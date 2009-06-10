From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 13499] Write cache: disabled, read cache: enabled,
 supports DPO and FUA? it's  bug???
Date: Wed, 10 Jun 2009 14:14:07 +0000
Message-ID: <1244643247.4109.9.camel@mulgrave.site>
References: <bug-13499-11613@http.bugzilla.kernel.org/>
	 <200906101400.n5AE0rtK002962@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59198 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754251AbZFJOOJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 10:14:09 -0400
In-Reply-To: <200906101400.n5AE0rtK002962@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-06-10 at 14:00 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> why Write cache: disabled??

The SCSI mid layer is merely reporting what your array is telling it.
For arrays without a battery backed cache, write through configuration
(i.e. read cache enabled, write cache disabled) is the usual safe
default.

You can alter your write cache settings using Doug Gilbert's
sg3-utils ... but be warned, enabling the write cache without battery
backing in an array is a dangerous thing to do since most arrays have
huge caches, they either ignore SYNCHRONIZE CACHE (which would leave you
vulnerable to data loss on power failure) or take such a long time, it
would kill performance.

James


