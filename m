From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31192] New: ioctl SG_GET_REQUEST_TABLE returns 64-bit structure
 to 32-bit app.
Date: Wed, 16 Mar 2011 13:24:13 GMT
Message-ID: <bug-31192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:43374 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1CPNYP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2011 09:24:15 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2GDOEkB018332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2011 13:24:14 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31192

           Summary: ioctl SG_GET_REQUEST_TABLE returns 64-bit structure to
                    32-bit app.
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.18-194.32.1.el5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: jbyers@stonefly.com
                CC: jbyers@stonefly.com
        Regression: No


The 'sg' module ioctl 'SG_GET_REQUEST_TABLE', when run on an
2.6.18-194.32.1.el5 x86_64 kernel, from a 32-bit application
seems to return the 64-bit version of the
sg_req_info_t[SG_MAX_QUEUE] table, not the 32-bit version.

Because there is a pointer in the sg_req_info_t structure,
the returned size is (4 * SG_MAX_QUEUE) = 64 bytes too
large, and it corrupts neighboring user memory, as well as
not returning the correct data.

Although there is code in 'fs/compat_ioctl.c' that looks to
be handling the 32-bit user to 64-bit kernel conversion, the
"COMPATIBLE_IOCTL(SG_GET_REQUEST_TABLE)" line in
'include/linux/compat_ioctl.h' conflicts with it and seems
to prevent the conversion code from being called.

The same ioctl called from a 64-bit app works fine.

The problem looks to still be present in the newest kernel
source, although I haven't tested it.

It seems like the "COMPATIBLE_IOCTL(SG_GET_REQUEST_TABLE)"
line should be removed from 'compat_ioctl.h' ('compat_ioctl.c'
in the newest kernel).

~ Jeff Byers ~

# gcc -m32 -Wall -o sg_get_request_table sg_get_request_table.c
# ./sg_get_request_table /dev/sg1
SG Request Table:
Memory fence damaged:
0xff90c034: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0xff90c044: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0xff90c054: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0xff90c064: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0xff90c074: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0xff90c084: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0xff90c094: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0xff90c0a4: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

============================

// Test sg 'SG_GET_REQUEST_TABLE ioctl.
// Build with:
// gcc -m32 -Wall -o sg_get_request_table sg_get_request_table.c
// gcc -m64 -Wall -o sg_get_request_table sg_get_request_table.c

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <scsi/sg.h> /* take care: fetches glibc's /usr/include/scsi/sg.h */

static void hex_dump(const unsigned char *buf, int len, const char *str);
static int  memunchr(const void *s, int c, size_t n);

int main(int argc, char * argv[])
{
    int sg_fd;
    int idx;
    unsigned char fence[128];
    sg_req_info_t req_info[SG_MAX_QUEUE] = {{0}};

    if (2 != argc) {
        printf("Usage: '%s <sg_device>'\n", argv[0]);
        return 1;
    }
    if ((sg_fd = open(argv[1], O_RDONLY)) < 0) {
        perror("error opening given file name");
        return 1;
    }

    printf("SG Request Table:\n");
    memset(req_info, 0xFF, sizeof(req_info));
    memset(fence, 0xFF, sizeof(fence));
    if (ioctl(sg_fd, SG_GET_REQUEST_TABLE, &req_info) < 0) {
        perror("SG_GET_REQUEST_TABLE ioctl error");
        return 1;
    }
    for(idx=0; idx < SG_MAX_QUEUE; idx++){
        if(req_info[idx].req_state == 0)
            continue;
        printf("req_info[%u]: req_state=%u, pack_id=%u, usr_ptr=%p,
duration=%u\n",
               idx, req_info[idx].req_state, req_info[idx].pack_id,
               req_info[idx].usr_ptr, req_info[idx].duration);
    }
    if (memunchr(fence, 0xFF, sizeof(fence)) != 0){
        hex_dump(fence, sizeof(fence), "Memory fence damaged:");
    }
    close(sg_fd);
    return 0;
}

static void hex_dump(const unsigned char *buf, int len, const char *str)
{
    printf("%s\n", str);
    int idx;
    for(idx=0; idx < len; idx++){
        if ((idx > 0) && ((idx & 0x0F) == 0)){
            printf("\n");
        }
        if ((idx & 0x0F) == 0){
            printf("%p:", &buf[idx]);
        }
        printf(" %02x", buf[idx]);
    }
    printf("\n");
    return;
}

static int memunchr(const void *s, int c, size_t n)
{
    unsigned char *ptr = (unsigned char *)s;
    for(; n > 0; n--){
        if (*ptr++ != c)
            return 1;
    }
    return 0;
}

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
