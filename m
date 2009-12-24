From: Clemens Fruhwirth <clemens@endorphin.org>
Subject: Re: [PATCH] Forcing capacity sizes for block devices
Date: Thu, 24 Dec 2009 14:40:50 +0100
Message-ID: <2f83750a0912240540p2bb9fe21i7129e9cc5dbb9c09@mail.gmail.com>
References: <2f83750a0912200405v77f39a7eifef024cc4cb10a20@mail.gmail.com>
	 <200912201843.40169.bzolnier@gmail.com>
	 <da824cf30912211204jc70fc10ta6f6de1208d2b364@mail.gmail.com>
	 <200912212259.34808.bzolnier@gmail.com>
	 <2f83750a0912240503g3aa7bcbw876a164d0e350b27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59002 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbZLXNkv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2009 08:40:51 -0500
Received: by fxm25 with SMTP id 25so2791927fxm.21
        for <linux-scsi@vger.kernel.org>; Thu, 24 Dec 2009 05:40:50 -0800 (PST)
In-Reply-To: <2f83750a0912240503g3aa7bcbw876a164d0e350b27@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

Hi Bartlomiej, Hi Grant!

(sorry for resending this mail, gmail switched into HTML mode for
unknown reasons, and vger.kernel.org rightfully rejected this mail)

On Mon, Dec 21, 2009 at 10:59 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
> We should be able to detect working SD reader/card combination in sd
> driver's ->set_capacity method implementation (i.e. by issuing read
> request for the last partitioned sector outside of the reported device
> capacity) during the initial partition table scan and at the same time
> adjust the device capacity used by the kernel if necessary.

1. I disagree with the strategy to add some automatism that does not
work for all cases (unformated cards in this case). Do you want the
user to jump through the additional hop of creating oversized
partition tables that fdisk and friends might not even allow easily?
The case with manual override is easier and more straight forward.
Also this approach is tied to using partition tables and in my case SD
cards work fine without partition tables.

2. I strongly opt for not-creating a kernel that tries to domineer[1]
over its users. If I say my device is size X I want the kernel to
follow that order. Also I dislike the kernel to probe beyond the
device boundaries unless I told it do so. I don't want to be this
behavior to be auto enabled by (probably broken) partition tables that
I can not even see before plugging that disk into my device (and
naturally triggering this behavior)

3. The kernel is not supposed to work correctly when writing incorrect
junk to random sysfs files. So assuming the required knowledge for
manual intervention is ok at /sys.

> Firstly block layer needs to be properly informed about capacity changes
> (set_capacity() + request for partition rescan which the patch doesn't do)
> and secondly fixing the problem at the sysfs block/partition layer seems
> to be a layering violation (i.e. it also allows partition size changes).

git log -p --color db429e9^1..e957b60 does not seem related to me. The
implementation of ide_disk_set_capacity suggests that the semantic of
set_capacity is that the caller can make the device smaller than
probed_capacity with the intention to protect stuff (Host Protect
Area?). The caller can not enlarge the device beyond the device
boundaries because of its first line "u64 set = min(capacity,
drive->probed_capacity)". The intention of my patch and its potential
use of any set_capacity is exactly that, namely to override these
device limits. So it's seems a bit orthogonal.

I don't object to inform the device layer somehow about the forceful
size change, however is set_capacity really the intended place to do
it? Where do we set nr_sects, if so?

[1] Sorry if that translation sounds strange:
http://dict.leo.org/ende?search=bevormunden
--
Fruhwirth Clemens http://clemens.endorphin.org
