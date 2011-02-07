From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Why using configfs as the only interface is wrong for a storage target
Date: Mon, 7 Feb 2011 12:41:18 +0100
Message-ID: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34500 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab1BGLlj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 06:41:39 -0500
Received: by iyj8 with SMTP id 8so2026147iyj.19
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2011 03:41:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>

On Fri, Feb 4, 2011 at 7:45 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Please consider the following patch series for mainline target code.
> It consists of predominately configfs bugfixes uncovered with recent SLUB
> poison testing, and proper removal of legacy procfs target_core_mib.c code.
> Note that the complete set of fabric independent statistics (SCSI MIBs) and
> fabric dependent statistics will be included as native configfs group context
> 'per value' attribute series during the .39 time frame.

I'm still not convinced that using configfs in a storage target as the
only interface between kernel space and user space is a good idea.
While configfs may satisfy all the needs of an iSCSI target, the use
of configfs in combination with hot-pluggable HCAs is really awkward.
Whenever a HCA is plugged in, the user has to issue mkdir commands to
make these interfaces appear in configfs. And whenever a HCA is
removed, stale information will remain present in configfs until the
user issues an rmdir command. As we all know, it is not possible for a
storage target to make these directories appear / disappear
automatically in configfs because of basic configfs design choices.

Regarding the SCSI-MIB (RFC 4455): using configfs makes it impossible
to ensure that the information in the scsiTgtPortEntry table is
current. If a HCA is plugged in, it won't appear in that table until
the user or some software issues an mkdir command. If a HCA is
removed, it won't appear in that table until an rmdir command is
issued. All these mkdir / rmdir commands are redundant since the
target core already knows which HCAs are available - a natural way to
implement a storage target driver that has to handle HCA hot-plugging
is to let it tell the storage target core about hot-plug events in the
bus add_one / remove_one callbacks.

Bart.
