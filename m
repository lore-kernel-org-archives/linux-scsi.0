From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - questions on Linux SCSI low-level driver
Date: Tue, 11 May 2004 13:00:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFEC@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:35133 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S262361AbUEKSAi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2004 14:00:38 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

To make sure we can integrate the functionalities of the Linux SCSI low-level driver into an existing module, a dummy detect( ) (the first function called from the SCSI mid-level) and hosts.h are added into hello_world module (attached bellow).

However, when compiling it, I got lots of errors (see bellow please).  This is probably not the regular way to create a low-level driver but we have to do it this way to use/work with existing modules.  How can we create a SCSI low-level driver and compile it from the command line by using normal make/gcc (without using "make menuconfig", "make modules", etc.)?  Do I miss some common setups/configurations?  I'm not very familiar with the stuff in this area.  Any suggestions/hints would be appreciated.

Thank,

Lee


######################### hello_world ######################
#define MODULE
#include <linux/module.h>
#include </usr/src/linux-2.4.20-8/drivers/scsi/hosts.h>

int init_module(void)
{
    printk("<0> Hello, world\n");
    return 0;
}

int detect(scsi_host_template * shtp)
{
    return 0;
}

void cleanup_module(void)
{
    printk("<0> Goodbye cruel world\n");
}
####################### end of hello_world ###################


#######################  compile errors below ################

[root@localhost my_scsi_debug]#
[root@localhost my_scsi_debug]#
[root@localhost my_scsi_debug]# gcc -c -isystem /lib/modules/`uname -r`/build/include/ hello_world.c
In file included from /usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:29,
                 from hello_world.c:3:
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:47: parse error before "off_t"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:51: parse error before "off_t"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:57: parse error before "mode_t"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:59: parse error before "uid"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:60: parse error before "gid"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:72: parse error before "rdev"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:91: parse error before "filldir_t"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:93: parse error before "mode_t"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:110: parse error before "filldir_t"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:143: parse error before "mode_t"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:148: parse error before "mode_t"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h: In function `create_proc_read_entry':
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:151: `name' undeclared (first use in this function)
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:151: (Each undeclared identifier is reported only once
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:151: for each function it appears in.)
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:151: `mode' undeclared (first use in this function)
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:151: `base' undeclared (first use in this function)
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:153: dereferencing pointer to incomplete type
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:154: dereferencing pointer to incomplete type
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h: At top level:
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:160: parse error before "mode_t"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h: In function `create_proc_info_entry':
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:162: `name' undeclared (first use in this function)
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:162: `mode' undeclared (first use in this function)
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:162: `base' undeclared (first use in this function)
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:163: dereferencing pointer to incomplete type
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h: At top level:
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:168: parse error before "mode_t"
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h: In function `proc_net_create':
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:170: `name' undeclared (first use in this function)
/lib/modules/2.4.20-8/build/include/linux/proc_fs.h:170: `mode' undeclared (first use in this function)
In file included from hello_world.c:3:
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h: At top level:
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:75: parse error before "off_t"
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:100: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:107: warning: `struct Scsi_Host' declared inside parameter list
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:114: warning: `struct Scsi_Host' declared inside parameter list
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:119: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:132: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:145: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:145: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:145: `queuecommand' declared as function returning a function
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:145: warning: no semicolon at end of struct or union
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:162: warning: `struct Scsi_Host' declared inside parameter list
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:163: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:164: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:165: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:166: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:185: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:185: `abort' redeclared as different kind of symbol
<built-in>:0: previous declaration of `abort'
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:200: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:215: parse error before "kdev_t"
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:221: parse error before "Scsi_Device"
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:221: warning: `struct Scsi_Host' declared inside parameter list
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:270: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:280: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:287: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:292: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:294: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:301: parse error before '}' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:301: warning: data definition has no type or storage class
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:320: parse error before "Scsi_Device"
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:320: warning: no semicolon at end of struct or union
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:329: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:331: warning: data definition has no type or storage class
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:332: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:332: warning: data definition has no type or storage class
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:355: `base' used prior to declaration
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:392: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:393: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:394: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:395: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:400: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:405: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:411: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:417: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:423: parse error before ':' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:425: parse error before "Scsi_Device"
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:440: parse error before '}' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:449: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:450: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:450: warning: data definition has no type or storage class
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:469: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:469: warning: data definition has no type or storage class
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:471: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:480: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h: In function `scsi_set_pci_device':
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:489: dereferencing pointer to incomplete type
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h: At top level:
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:497: parse error before "uint"
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:520: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:524: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:525: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:526: parse error before '*' token
/usr/src/linux-2.4.20-8/drivers/scsi/hosts.h:530: parse error before '*' token
hello_world.c:11: parse error before '*' token
[root@localhost my_scsi_debug]#

