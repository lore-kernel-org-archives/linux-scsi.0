From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/1] sd: fix lbprz discard granularity as expected
Date: Fri, 11 Mar 2016 11:53:51 +0800
Message-ID: <CAGnHSEn39bHTikNgvJUpoJBFVUFmX=bAuUe9ber9D0EUSgf8NQ@mail.gmail.com>
References: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
	<CAGnHSEkGybgU0KXGYg_RLvgbnKvAth4dyHuxMPsKzF7cQs7qgQ@mail.gmail.com>
	<yq11t7hn4i3.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:35122 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933554AbcCKDx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 22:53:57 -0500
Received: by mail-yw0-f195.google.com with SMTP id s188so5492171ywe.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2016 19:53:57 -0800 (PST)
In-Reply-To: <yq11t7hn4i3.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 11 March 2016 at 10:16, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Discard is advisory, the command will not get rejected.
>

In that case, if the granularity only act as some sort of "reference"
but has no real "binding" to the actual behaviour, why would the
kernel even "make up" the granularity itself according to the physical
block size of the device:

q->limits.discard_granularity = max(sdkp->physical_block_size,
sdkp->unmap_granularity * logical_block_size);

Shouldn't it simply be:

q->limits.discard_granularity = sdkp->unmap_granularity * logical_block_size;
