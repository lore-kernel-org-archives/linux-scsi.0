From: "Kotian, Deepak" <Deepak.Kotian@patni.com>
Subject: Plug pull scenario in scsi observation on kernel 2.6, what is correct behavior and why
Date: Thu, 17 Mar 2005 16:55:49 +0530
Message-ID: <374639AB1012AA4C840022842AA95BC20491798A@ruby.patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from pcsmail.patni.com ([203.124.139.197]:7357 "EHLO
	pcsmail.patni.com") by vger.kernel.org with ESMTP id S263067AbVCQL0E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2005 06:26:04 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernelnewbies@nl.linux.org, linux-scsi@vger.kernel.org

kernel version(SUSE): 2.6.5-7.97.

There seems to be an abnormal write behavior when
we are writing on /dev/sdc in a loop with following user application code
----------------------------------------------------------------------------
#include <errno.h>
#include<stdio.h>
#include<unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

for ( i = 0; i<100 ; i++)
{
    ret = write(fd,buf,1000000);
    printf("%d\n", ret);
   fsync(fd);
   printf("%d\n",errno);

}
O/P on scenario-----------------------------------------
before plug pull O/P is like this for each write
1000000
0

and after plug pull O/P for remaining writes is always 
98603
5

Is this correct and why
Or
should be the behaviour
for all remaining writes be
-1
5
or
0
5

since after a plug pull no data transfer can occur.

Thanks and Regards
Deepak
