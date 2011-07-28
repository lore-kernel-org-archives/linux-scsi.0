From: Roland Dreier <roland@kernel.org>
Subject: Re: Handling multiple paths to enclosure devices?
Date: Thu, 28 Jul 2011 13:57:33 -0700
Message-ID: <1311886653-14193-1-git-send-email-roland@kernel.org>
References: <1311872730-4863-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:41894 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754759Ab1G1U5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jul 2011 16:57:41 -0400
Received: by mail-pz0-f44.google.com with SMTP id 5so5769291pzk.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2011 13:57:40 -0700 (PDT)
In-Reply-To: <1311885202.5464.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, eric@purestorage.com

 > So this configuration should form a single wide port and thus not
 > actually be multiple paths.  However, if you have two HBAs instead of
 > one (or a non-SAS HBA), I grant it becomes multipath.

Yeah ... actually my case is an HBA with two wide (4-lane) ports,
where either the expander or the HBA is not able to fuse them into a
single 8-lane port.  But clearly this can happen at least with two
HBAs pretty easily.

 > My initial thought is that in a multi-path situation, as above, we get
 > two enclosures appearing as well (one down each path).  If we
 > incorporated the idea of topological subtrees into the identity matching
 > code, we'd end up filling each of the enclosures with the path connected
 > devices.  That seems to be an easy situation for multi-path drivers to
 > sort out and one requiring no alteration of the existing enclosure code
 > (except to do the topological subtree search).

Ah, good insight: we do have two copies of the expander device, and so
it would be natural to attach each disk to the expander device on the
same path to that disk.

I'm a bit confused by what you mean about multi-path drivers though --
it would seem we would need the enclosure stuff to handle this
somehow?  It seems that if I have this situation, my HBA driver (eg
mpt2sas) will discover the SCSI bus, hit an enclosure, trigger loading
the ses driver (which pulls in the enclosure driver), and then
continue discovering disks.  And it seems this code needs to get the
topology sorted by itself -- how could a multi-path driver inject
itself into the symlink creation in enclosure.c?

 - R.
