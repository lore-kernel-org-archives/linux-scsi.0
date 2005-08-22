From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Sun, 21 Aug 2005 20:52:14 -0700
Message-ID: <20050821205214.2a75b3cf.akpm@osdl.org>
References: <20050822003325.33507.qmail@web51613.mail.yahoo.com>
	<1124680540.5068.37.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:15502 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751434AbVHVW4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 18:56:34 -0400
In-Reply-To: <1124680540.5068.37.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: luben_tuikov@adaptec.com, jim.houston@ccur.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davej@redhat.com, jgarzik@pobox.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> Since you won't post the usage code, just answer this: how does what
>  you're doing with idr differ from its originally designed consumer: the
>  posix timers which also do the idr_remove() in IRQ context?

erp.  posix_timers has its own irq-safe lock, so we're doing extra,
unneeded locking in that code path.

I think providing locking inside idr.c was always a mistake - generally we
rely on caller-provided locking for such things.
