From: Tejun Heo <htejun@gmail.com>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Date: Fri, 07 Mar 2008 17:40:07 +0900
Message-ID: <47D0FF67.8050503@gmail.com>
References: <200802252005.22663.gml@inode.at> <200802292259.12047.gml@inode.at> <20080301145354.ca4d4f1a.vsu@altlinux.ru> <200803011329.11315.gml@inode.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000506050203060601000100"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:12051 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYCGIkR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 03:40:17 -0500
Received: by wa-out-1112.google.com with SMTP id v27so419584wah.23
        for <linux-scsi@vger.kernel.org>; Fri, 07 Mar 2008 00:40:17 -0800 (PST)
In-Reply-To: <200803011329.11315.gml@inode.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerold Jury <gml@inode.at>
Cc: Sergey Vlasov <vsu@altlinux.ru>, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000506050203060601000100
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,

Gerold Jury wrote:
> Yes it happens with the DVD+RW (testet with dd now) and with DVD+R
> 
> Thank you for the byte interpretation.
> Now I have a hint where to start with the debugging.

I've tried to reproduce the problem here but failed.  Can you please try
the test with the file generated with the attached program?  "genseqfile
524288 > testfile" will give you 1 meg testfile and it will give us
better idea how the data is getting corrupted.

Thanks.

-- 
tejun

--------------000506050203060601000100
Content-Type: text/x-csrc;
 name="genseqfile.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="genseqfile.c"

#include <unistd.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	unsigned int i;

	for (i = 0; i < atoi(argv[1]); i++)
		fwrite(&i, 2, 1, stdout);
	return 0;
}

--------------000506050203060601000100--
