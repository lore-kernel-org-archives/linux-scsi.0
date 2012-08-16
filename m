From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: return TARGET_ERROR when a device has been disconnected
Date: Thu, 16 Aug 2012 09:53:27 -0500
Message-ID: <AF371CF6-F10B-470D-810E-4C1F42057E79@cs.wisc.edu>
References: <1345099208-31687-1-git-send-email-hare@suse.de>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59116 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab2HPOxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Aug 2012 10:53:39 -0400
In-Reply-To: <1345099208-31687-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>


On Aug 16, 2012, at 1:40 AM, Hannes Reinecke <hare@suse.de> wrote:

> When we receive a sense code of
> NOT READY, LOGICAL UNIT NOT SUPPORTED
> the device has been disconnected and any retry on other paths
> would be pointless. So return TARGET_ERROR here.


What target is this with? What about {ILLEGAL_REQUEST,  LOGICAL UNIT NOT SUPPORTED}? Would you want to do the same behavior for that error?

I ask because I have seen targets return {ILLEGAL_REQUEST,  LOGICAL UNIT NOT SUPPORTED} when you only unexport the LUN from a path/port on the target. I was wondering if some might do the same for {NOT_READY, LOGICAL UNIT NOT SUPPORTED}? In those cases, we would not want multipath to fail IO.

In these type of cases should the target be returning something else?