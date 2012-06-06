From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/4] notify userspace of offline->running transitions
 (v2)
Date: Wed, 06 Jun 2012 16:18:44 -0500
Message-ID: <4FCFC934.8010009@cs.wisc.edu>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51196 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab2FFVSf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jun 2012 17:18:35 -0400
In-Reply-To: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hey,

Would it be ok to still merge patches 1 - 3? I think they are still
useful on their own. They fix that issue where during fast io
fail/replacement_timeout failures IO is failed, but the scsi_device
state indicates the devices are still running.

It seems Hannes was ok with them right?

Drop patch 4 since we all seemed to agree we will do it a different way.


On 05/17/2012 11:56 PM, michaelc@cs.wisc.edu wrote:
> The following patches were made over the misc branch of the scsi tree.
> 
> The patches fix a issue where if the device is offlined or IO is
> failed due to fast_io_fail (fc) /recovery_tmo (iscsi) then comes
> back, apps do not have a way a nice way to figure out the state
> has transitioned to running. Apps have to either poll the sysfs state
> file or send a SG IO to figure it out. With the patch apps can listen
> for the KOBJ CHANGE event like some of them (at least udev does) do
> already.
> 
> v2:
> - Rebased to misc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

