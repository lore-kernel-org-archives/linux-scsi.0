From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: initio.h header user confusion
Date: Wed, 21 Feb 2007 10:57:02 -0600
Message-ID: <1172077022.3335.24.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.63.0702211558220.5167@thor.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57623 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422685AbXBUQ5G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 11:57:06 -0500
In-Reply-To: <Pine.LNX.4.63.0702211558220.5167@thor.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Srdjan Todorovic <todorovic.s@googlemail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2007-02-21 at 16:12 +0000, Srdjan Todorovic wrote:
> I'm working on a set of patches for the initio scsi driver and I found
> some strangeness with its header file, initio.h. I noticed that
> sun3_scsi.c and sun3_scsi_vme.c include the header, and it uses defines
> such as SCSI_ABORT_SNOOZE (defined in initio.h).

It's a remnant of the old 2.4 error handler and should be excised.

In early 2.4 or perhaps even 2.2 the error handler ran in interrupt
context, so there was no way of waiting for an abort to complete, hence
this return value (it told the eh to wait a while for the abort).

In 2.6 all eh routines run in the context of the host eh thread, so you
can use standard msleep() etc. calls to wait for aborts to timeout or
complete.

James


