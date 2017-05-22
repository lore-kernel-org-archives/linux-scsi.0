From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH blktests v2 3/3] sg/001: add regression test for
 syzcaller generated GPF in sg_read path
Date: Mon, 22 May 2017 10:59:05 -0700
Message-ID: <20170522175905.GA17738@vader.DHCP.thefacebook.com>
References: <cover.1495201975.git.jthumshirn@suse.de>
 <79600648b662bc8b9e701ff6627986887384585b.1495201975.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34384 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760846AbdEVR7Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 13:59:16 -0400
Received: by mail-pf0-f180.google.com with SMTP id 9so89285592pfj.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2017 10:59:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <79600648b662bc8b9e701ff6627986887384585b.1495201975.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On Fri, May 19, 2017 at 03:55:31PM +0200, Johannes Thumshirn wrote:
> Add a regression test for commit 48ae8484e9fc ("scsi: sg: don't return
> bogus Sg_requests"). This is a general protection fault triggered by
> syzcaller via issuing bogus read(2)s on the /dev/sg devices.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  tests/sg/001     | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/sg/001.out |  2 ++
>  2 files changed, 49 insertions(+)
>  create mode 100755 tests/sg/001
>  create mode 100644 tests/sg/001.out
> 
> diff --git a/tests/sg/001 b/tests/sg/001
> new file mode 100755
> index 000000000000..86430409b6a3
> --- /dev/null
> +++ b/tests/sg/001
> @@ -0,0 +1,47 @@
> +#!/bin/bash
> +#
> +# Regression test for commit 48ae8484e9fc ("scsi: sg: don't return bogus
> +# Sg_requests")
> +#
> +# Copyright (C) 2017 Johannes Thumshirn <jthumshirn@suse.de>
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
> +. common/sg
> +. common/scsi_debug
> +
> +DESCRIPTION="try triggering a kernel GPF with 0 byte SG reads"
> +QUICK=1
> +
> +requires() {
> +	_have_program src/sg-001 \
> +	    && _have_scsi_debug \
> +	    && _have_scsi_generic
> +}
> +
> +
> +test() {
> +	echo "Running ${TEST_NAME}"
> +
> +	if ! _get_scsi_debug_dev; then
> +	    return 1
> +	fi
> +
> +	SG_DEV=$(_get_sg_from_blockdev "$SCSI_DEBUG_NAME")
> +	timeout -s INT 10s ./src/sg-001 "$SG_DEV"
> +
> +	_put_scsi_debug_dev
> +
> +	echo "Test complete"
> +}

This looks much better, thanks! One question for you: is there any value
in running this on specific test devices (i.e., changing test() to
test_device() and using "$TEST_DEV" instead of a scsi-debug device), or
would it be a waste of time since it's just exercising generic code?
