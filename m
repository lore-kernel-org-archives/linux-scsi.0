From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Nero 4 Linux applications broken in 4.12
Date: Wed, 5 Jul 2017 13:52:35 +0200
Message-ID: <20170705115235.GF4076@linux-x5ow.site>
References: <460fefb4-d002-6989-0c90-63ea0e209fc3@googlemail.com>
 <20170705073928.GA4076@linux-x5ow.site>
 <9c58bac7-ddf4-3e47-b729-76e595804836@googlemail.com>
 <20170705084447.GD4076@linux-x5ow.site>
 <20170705084810.GE4076@linux-x5ow.site>
 <d92e31ed-db7f-aa4b-5dfd-3f6df4a49ea9@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33865 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751637AbdGELwi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Jul 2017 07:52:38 -0400
Content-Disposition: inline
In-Reply-To: <d92e31ed-db7f-aa4b-5dfd-3f6df4a49ea9@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jul 05, 2017 at 10:06:49AM +0100, Chris Clayton wrote:
> I'll do this  and send dmesg(?) output as soon as I've got scsi_logging_level installed.

Hi Chris,

does this reproducer work (i.e. output FAIL) for you?

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>

#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <scsi/sg.h>

int main(int argc, char **argv)
{
	int fd;
	int rc;
	int rsz = 131072;
	int tout = 10800000;
	char buf[42] = { 0 };

	if (argc != 2) {
		printf("usage: %s /dev/sgX\n", argv[0]);
		return 1;
	}

	fd = open(argv[1], O_RDWR);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	rc = ioctl(fd, SG_SET_RESERVED_SIZE, &rsz);
	if (rc < 0) {
		perror("ioctl SG_SET_RESERVED_SIZE");
		goto out_close;
	}

	rc = ioctl(fd, SG_SET_TIMEOUT, &tout);
	if (rc < 0) {
		perror("ioctl SG_SET_TIMEOUT");
		goto out_close;
	}

	buf[4] = 'H';
	rc = write(fd, &buf, sizeof(buf));
	if (rc < 0) {
		perror("write");
		if (errno == EINVAL)
			printf("FAIL\n");
		goto out_close;
	}

	printf("PASS\n");

out_close:
	close(fd);
}

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
