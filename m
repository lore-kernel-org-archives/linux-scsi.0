From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] aic79xx: fix misuse of static variables
Date: Tue, 01 Apr 2014 07:10:41 -0700
Message-ID: <1396361441.2187.13.camel@dabdike.int.hansenpartnership.com>
References: <1396186235-3053-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56029 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbaDAOKm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2014 10:10:42 -0400
In-Reply-To: <1396186235-3053-1-git-send-email-minipli@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, PaX Team <pageexec@freemail.hu>

On Sun, 2014-03-30 at 15:30 +0200, Mathias Krause wrote:
> The format strings for various printk()s make use of a temporary
> variable that is declared 'static'. This is probably not intended,
> so fix those.

Actually, it was intended.  It was to work around an assignment to const
gcc bug: some versions of gcc won't allow the first assignment to an
uninitialised const.  I can't remember how long ago this was, but
probably at least 10 years, so it's likely whatever version of gcc that
caused the problem is long gone, but someone should check this
modification works on our earliest supported version.

James




