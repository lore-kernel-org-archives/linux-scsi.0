From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/32] Refcounts and rbtrees to increase luns above 255
Date: Mon, 16 Dec 2013 14:03:46 -0800
Message-ID: <1387231426.20247.260.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33836 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3LPWCx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 17:02:53 -0500
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> Hi Nicholas,
> 
> This patchset uses krefs to refcount structures shared across threads.
> LIO is full of these because configfs-based configuration actions can
> be removing an object, even while that object is being used by a SCSI
> command.
> 
> Using kref to free the struct on whichever thread drops the last
> reference allows us to avoid busy-waiting in configfs removal functions.
> Next, this set removes the statically-sized tpg lun and deve arrays in
> favor of dynamically adding entries into rbtrees. This reduces memory
> consumption and allows more than 255 luns per tpg and initiator mapping.
> 
> Except for some rbtree lookups, these changes are entirely in the
> configuration paths of Lio. I have tested these as extensively as I can,
> and it's ready for wider testing.
> 
> Note: patch 22 converts a percpu refcount to a normal kref. I'd argue
> the benefit is really in the "refcount" part rather than the "percpu",
> so a simpler kref does the job, but we might want to discuss this some
> more.
> 

It would be helpful to breakup future patches into different series
based on:

  * Bugfixes
  * New features
  * Minor improvements

Thanks,

--nab

