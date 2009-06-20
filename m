From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: generic_make_request fucntion for scsi_disk
Date: Sat, 20 Jun 2009 09:20:40 -0500
Message-ID: <1245507640.4255.6.camel@mulgrave.site>
References: <e42309110906200705j6a731ecay204969f639af5330@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56075 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbZFTOUn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Jun 2009 10:20:43 -0400
In-Reply-To: <e42309110906200705j6a731ecay204969f639af5330@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravish Tayal <ravish.tayal@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Sat, 2009-06-20 at 19:35 +0530, Ravish Tayal wrote:
> I am debugging Filesystem code for USB mass storage devices.  I need
> help to figure out after generic_make_request how the request is
> placed to scsi disk (sd) requeset queue and than how sd qeueuecommand
> to usb_storeage thread.  (in which context, is it system call context)

requests out of the lower end of block come from the elevators.  The
elevators can operate in a variety of contexts: user, kernel thread or
softirq depending on state.

The mechanism for queueing to the USB thread is in
scsiglue.c:queuecommand() it's basically a simple single command
consumer model: fill in slot and wake thread.

James


