From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH 2/2] tests/scsi/0001: Regression test for SCSI device
 blacklisting
Date: Tue, 15 Aug 2017 23:00:49 -0700
Message-ID: <20170816060049.GA6640@vader>
References: <1502275806-27972-1-git-send-email-hare@suse.de>
 <1502275806-27972-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:36933 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751592AbdHPGAx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 02:00:53 -0400
Received: by mail-pg0-f47.google.com with SMTP id y129so18531350pgy.4
        for <linux-scsi@vger.kernel.org>; Tue, 15 Aug 2017 23:00:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1502275806-27972-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Omar Sandoval <osandov@fb.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.com>

On Wed, Aug 09, 2017 at 12:50:06PM +0200, Hannes Reinecke wrote:
> SCSI device blacklisting seems to be a tricky subject, with
> lots of potential for messing up the selection algorithm.
> This adds a test for catching regressions here.

I'm waiting to see how the patches end up before applying this, but I'm
glad to see this test :) A few comments below. I've addressed most of
them and pushed it to https://github.com/osandov/blktests/tree/scsi-blacklist,
but the golden output needs to be updated for v3 of your patches. Could
you modify the patch in my branch and resend? Thanks for adding tests!

> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  tests/scsi/001     | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/scsi/001.out | 10 ++++++++
>  2 files changed, 79 insertions(+)
>  create mode 100644 tests/scsi/001
>  create mode 100644 tests/scsi/001.out
> 
> diff --git a/tests/scsi/001 b/tests/scsi/001
> new file mode 100644
> index 0000000..374a458
> --- /dev/null
> +++ b/tests/scsi/001
> @@ -0,0 +1,69 @@
> +#!/bin/bash
> +#
> +# Regression test for scsi device blacklisting

In my experience with xfstests, the single most useful piece of
information to include for a regression test is the commit or patch it
tests. I fixed this to say 'Regression test for patch "scsi_devinfo:
fixup string compare".'

> +# Copyright (C) 2017 Hannes Reinecke, SUSE Linux GmbH
> +#
> +# This program is free software: you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License as published by
> +# the Free Software Foundation, either version 3 of the License, or
> +# (at your option) any later version.
> +#
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program.  If not, see <http://www.gnu.org/licenses/>.
> +
> +DESCRIPTION="SCSI device blacklisting"
> +
> +QUICK=1
> +
> +CHECK_DMESG=0

I realize that the documentation wasn't clear about what we check for in
dmesg. It's just oopses and warnings and such, so we don't need/want to
disable checking dmesg here. I removed it and improved the
documentation.

> +requires() {
> +    if modinfo scsi_debug | grep -q inq_vendor ; then
> +	return 0
> +    fi
> +    return 1
> +}

There's a helper for this, _have_module_param.

> +test() {
> +    local inq vendor model host dev blacklist
> +
> +    echo "Running ${TEST_NAME}"
> +
> +    for inq in \
> +	"                        " \
> +	"AAAAAAAABBBBBBBBBBBBBBBB" \
> +	"HITACHI OPEN-V          " \
> +	"        Scanner         " \
> +	"Inateck                 " \
> +	"Promise STEX            " \
> +	"HITA    OPEN-V          " \
> +	"ABCD    Scanner         " ; do
> +	vendor=${inq:0:8}
> +	model=${inq:8:16}
> +	modprobe scsi_debug inq_vendor="$vendor" inq_product="$model"
> +	host=$(lsscsi -H | sed -n 's/.\([0-9]*\).*scsi_debug/\1/p')
> +	if [ -z "$host" ] ; then
> +	    echo "Test failed, scsi_debug could not be loaded"
> +	    return 1
> +	fi
> +	dev=$(lsscsi | grep $host | sed -n 's/.*\/dev\/\(sd[a-z]*\).*/\1/p')
> +	if [ -z "$dev" ] ; then
> +	    echo "Test failed, SCSI device not found"
> +	    rmmod scsi_debug
> +	    return 1
> +	fi

The biggest change I made was improving the existing scsi_debug helpers
so you don't have to hardcode this.

> +	vendor=$(cat /sys/block/$dev/device/vendor)
> +	model=$(cat /sys/block/$dev/device/model)
> +	blacklist=$(cat /sys/block/$dev/device/blacklist)
> +	echo "$vendor $model $blacklist"
> +	rmmod scsi_debug
> +    done
> +    echo "Test complete"
> +    return 0
> +}
> diff --git a/tests/scsi/001.out b/tests/scsi/001.out
> new file mode 100644
> index 0000000..64db97c
> --- /dev/null
> +++ b/tests/scsi/001.out
> @@ -0,0 +1,10 @@
> +Running scsi/001
> +                          0x0
> +AAAAAAAA BBBBBBBBBBBBBBBB 0x0
> +HITACHI  OPEN-V           0x20000
> +         Scanner          0x1
> +Inateck                   0x0
> +Promise  STEX             0x40
> +HITA     OPEN-V           0x0
> +ABCD     Scanner          0x0
> +Test complete

As mentioned above, this needs updating for the symbolic constants.
