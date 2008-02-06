From: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] sr: update to follow tray status correctly
Date: Wed, 06 Feb 2008 17:09:26 +0000
Message-ID: <47A9E9C6.4000802@gentoo.org>
References: <20071027225830.585C8657DB@smtp.gentoo.org>	 <1193801523.3321.138.camel@localhost.localdomain> <1199551191.3399.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090006030005000304030208"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756613AbYBFRJA@vger.kernel.org>
In-Reply-To: <1199551191.3399.29.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Maarten Bressers <mbres@gentoo.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, tasio@hierro.tasio.net
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090006030005000304030208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi James,

James Bottomley wrote:
> It's been a while with no status on this one, so I corrected the patch
> based on my original input.  The attached is what I think is the best
> way of doing this (I've replaced the home grown test_unit_ready routine
> with the SCSI one and updated some of the sense check conditions).

Many thanks for following up on this. The user has not responded to my 
request for him to test your patch, so I decided to try it myself. I'm 
using Linus git as of today, I noticed the patch is merged.

It doesn't work for me. On unpatched 2.6.24, I get the behaviour 
previously described - the ioctl always gives CDS_TRAY_OPEN regardless 
of tray status. On 2.6.24-git which includes your patch, I instead 
always get CDS_DISC_OK. I have confirmed that on 2 systems this is 
because scsi_test_unit_ready() is returning 0.

Before I dig further, does this work for you? I have attached the test 
program I am using.

Thanks!
Daniel


--------------090006030005000304030208
Content-Type: text/plain;
 name="test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test.c"

#include <sys/ioctl.h>
#include <sys/types.h>
#include <fcntl.h>
#include <linux/cdrom.h>
#include <unistd.h>
#include <stdio.h>

int main(void)
{
	int fd = open("/dev/sr0", O_RDONLY | O_NONBLOCK);
	int ret;
	if (fd < 0) {
		perror("open");
		return 1;
	}

	ret = ioctl(fd, CDROM_DRIVE_STATUS, 0);
	printf("ioctl result %d\n", ret);

	switch(ret) {
		case CDS_NO_INFO: printf("CDS_NO_INFO\n"); break;
		case CDS_NO_DISC: printf("CDS_NO_DISC\n"); break;
		case CDS_TRAY_OPEN: printf("CDS_TRAY_OPEN\n"); break;
		case CDS_DRIVE_NOT_READY: printf("CDS_DRIVE_NOT_READY\n"); break;
		case CDS_DISC_OK: printf("CDS_DISC_OK\n"); break;
		default: printf("Unknown\n"); break;
	}
	return 0;
}

--------------090006030005000304030208--
