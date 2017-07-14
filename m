From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH blktests] sg: add regression test for patch scsi: sg: fix
 SG_DXFER_FROM_DEV transfers
Date: Fri, 14 Jul 2017 10:31:40 -0700
Message-ID: <20170714173140.GB13690@vader.DHCP.thefacebook.com>
References: <20170706120921.14801-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:34451 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753844AbdGNRbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2017 13:31:44 -0400
Received: by mail-pg0-f44.google.com with SMTP id t186so48901368pgb.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2017 10:31:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170706120921.14801-1-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On Thu, Jul 06, 2017 at 02:09:21PM +0200, Johannes Thumshirn wrote:
> Add a regression test for the patch titled "scsi: sg: fix
> SG_DXFER_FROM_DEV transfers" which reassembles the syscalls done by Nero
> Burning ROM to discover CD and DVD burners.

Fixed up a few things below and applied, thanks!

> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  common/sg               |  2 +-
>  src/.gitignore          |  1 +
>  src/Makefile            |  2 +-
>  src/sg/dxfer-from-dev.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++
>  src/sg/sg-dxfer.c       | 57 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/sg/002            | 38 +++++++++++++++++++++++++++++++++
>  tests/sg/002.out        |  3 +++
>  7 files changed, 158 insertions(+), 2 deletions(-)
>  create mode 100644 src/sg/dxfer-from-dev.c
>  create mode 100644 src/sg/sg-dxfer.c
>  create mode 100755 tests/sg/002
>  create mode 100644 tests/sg/002.out
> 
> diff --git a/common/sg b/common/sg
> index c306af500350..19732ec6a541 100644
> --- a/common/sg
> +++ b/common/sg
> @@ -30,5 +30,5 @@ _test_dev_is_scsi() {
>  }
>  
>  _get_sg_from_blockdev() {
> -	echo /sys/block/"$1"/device/scsi_generic/sg+([0-9])
> +	echo ${TEST_DEV_SYSFS}/device/scsi_generic/sg* | grep -Eo "sg[0-9]+"
>  }

I renamed this to _get_test_dev_sg to reflect the new behavior.

> diff --git a/src/.gitignore b/src/.gitignore
> index 722c137c7fca..0fca08a74fb1 100644
> --- a/src/.gitignore
> +++ b/src/.gitignore
> @@ -1 +1,2 @@
>  /sg/syzkaller1
> +/sg/dxfer-from-dev
> diff --git a/src/Makefile b/src/Makefile
> index 0e8d74688db4..57b6bb25793a 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -1,4 +1,4 @@
> -TARGETS := sg/syzkaller1
> +TARGETS := sg/syzkaller1 sg/dxfer-from-dev
>  
>  CFLAGS := -O2
>  
> diff --git a/src/sg/dxfer-from-dev.c b/src/sg/dxfer-from-dev.c
> new file mode 100644
> index 000000000000..ca52f30e23af
> --- /dev/null
> +++ b/src/sg/dxfer-from-dev.c
> @@ -0,0 +1,57 @@
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <errno.h>
> +#include <unistd.h>
> +
> +#include <sys/ioctl.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +
> +#include <scsi/sg.h>
> +
> +int main(int argc, char **argv)
> +{
> +	int fd;
> +	int rc;
> +	int rsz = 131072;
> +	int tout = 10800000;
> +	char buf[42] = { 0 };
> +
> +	if (argc != 2) {
> +		printf("usage: %s /dev/sgX\n", argv[0]);
> +		return 1;
> +	}
> +
> +	fd = open(argv[1], O_RDWR);
> +	if (fd < 0) {
> +		perror("open");
> +		return 1;
> +	}
> +
> +	rc = ioctl(fd, SG_SET_RESERVED_SIZE, &rsz);
> +	if (rc < 0) {
> +		perror("ioctl SG_SET_RESERVED_SIZE");
> +		goto out_close;
> +	}
> +
> +	rc = ioctl(fd, SG_SET_TIMEOUT, &tout);
> +	if (rc < 0) {
> +		perror("ioctl SG_SET_TIMEOUT");
> +		goto out_close;
> +	}
> +
> +	buf[4] = 'H';
> +	rc = write(fd, &buf, sizeof(buf));
> +	if (rc < 0) {
> +		perror("write");
> +		if (errno == EINVAL)
> +			printf("FAIL\n");
> +		goto out_close;
> +	}
> +
> +	printf("PASS\n");
> +
> +out_close:
> +	close(fd);
> +}
> diff --git a/src/sg/sg-dxfer.c b/src/sg/sg-dxfer.c
> new file mode 100644
> index 000000000000..ca52f30e23af
> --- /dev/null
> +++ b/src/sg/sg-dxfer.c

This file looks like a copy of sg-dxfer-dev.c, removed it.

> diff --git a/tests/sg/002 b/tests/sg/002
> new file mode 100755
> index 000000000000..c8b39091f82a
> --- /dev/null
> +++ b/tests/sg/002
> @@ -0,0 +1,38 @@
> +#!/bin/bash
> +#
> +# TODO: provide a description of the test here, i.e., what it tests and how. If
> +# this is a regression test for a patch, reference the patch title:

You forgot to delete this part :)
