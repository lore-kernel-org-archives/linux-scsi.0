From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: 23 Aug 2004 11:31:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093275122.1776.52.camel@mulgrave>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org>
	<1093217548.1727.367.camel@mulgrave>
	<1093218968.3553.17.camel@swtf.comptex.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:3053 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S266096AbUHWQWU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 12:22:20 -0400
Received: from hancock.sc.steeleye.com (stat16.steeleye.com [209.192.50.48])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id i7NGMCiw018856
	for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2004 09:22:13 -0700
In-Reply-To: <1093218968.3553.17.camel@swtf.comptex.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Burn Alting <burn@goldweb.com.au>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 2004-08-22 at 19:56, Burn Alting wrote:
> How about when disk arrays are booting? Typically, a disk array will
> quickly present target(s) to the host and then take some time to
> initialise before being ready for medium access. I assume most disk
> arrays will present the above sense condition (becoming ready) to all
> medium access commands until it is ready for medium access.

If you power off a disc and power it on again, the same thing happens.

I'd like to distinguish between normal occurrences at start of day which
we need to handle (like spinning up devices or waiting for them to
become ready from power on).  And normal occurrences during device
operation.  The former are handled in the ULD and the latter in the
mid-layer error handler.

It's certainly possible to rejig the mid-layer to add an extra delay via
schedule_delayed_work(), but I'd like to be sure its necessary first,
since the addition looks to be slightly messy.

James



