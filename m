From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/1] scsi: Add EH Start Unit retry
Date: Thu, 29 Mar 2007 18:02:07 -0400
Message-ID: <460C375F.1000000@torque.net>
References: <11751999513070-patch-mail.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37473 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422655AbXC2WD6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 18:03:58 -0400
In-Reply-To: <11751999513070-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com

Brian King wrote:
> Currently, the scsi error handler will issue a START_UNIT
> command if the drive indicates it needs its motor started
> and the allow_restart flag is set in the scsi_device. If,
> after the scsi error handler invokes a host adapter reset
> due to error recovery, a device is in a unit attention
> state AND also needs a START_UNIT, that device will be placed
> offline. The disk array devices on an ipr RAID adapter
> will do exactly this when in a dual initiator configuration.
> This patch adds a single retry to the EH initiated
> START_UNIT.

I have no objection to this patch. Just seems a pity
that SCSI devices go to the trouble of sending unit
attentions while OSes just throw them away.

Perhaps the scsi_device sysfs directory could have entries
like:
  last_ua_asc
  last_ua_ascq
  last_ua_timestamp
where code could place the asc/ascq codes and a timestamp
then continue doing a retry.
Could we get a log entry, hotplug event?

Logical units may queue unit attentions (sam4r10.pdf
section 5.8.7) so it is possible that one retry may
not be enough. With my suggestion above, only the last
one would persist for a reasonable time.

Doug Gilbert
