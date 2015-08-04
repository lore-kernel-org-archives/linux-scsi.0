From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Patch] scsi_ioctl: support persistent reserve commands for
 non-root user.
Date: Mon, 03 Aug 2015 18:32:17 -0700
Message-ID: <1438651937.2173.69.camel@HansenPartnership.com>
References: <OF27ABBEA2.0BA86E1E-ON48257E97.0004D192-48257E97.000691DB@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52240 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbbHDBcT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 21:32:19 -0400
In-Reply-To: <OF27ABBEA2.0BA86E1E-ON48257E97.0004D192-48257E97.000691DB@zte.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jiang.biao2@zte.com.cn
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Tue, 2015-08-04 at 09:11 +0800, jiang.biao2@zte.com.cn wrote:
> scsi_ioctl: support persistent reserve commands through ioctl for
> non-root user.
> 
> Scsi persistent reserve commands need to be used for non-root user in
> many scenarios.
> EPERM error will be returned by sg_io() when PERSISTENT_RESERVE_OUT
> or PERSISTENT_RESERVE_IN command is sent through ioctl() for
> non-root user.
> Add PERSISTENT_RESERVE_OUT and PERSISTENT_RESERVE_IN into
> blk_default_cmd_filter in blk_set_cmd_filter_defaults() to support 
> persistent reserve commands for non-root user.

I'm very dubious about this: a PR third party reservation can deny
access to the local device ... effectively allowing any local user to
cause I/O errors on all devices by issuing a bogus third party
reservation.  What's the reason for allowing non-root use in the first
place?

James




