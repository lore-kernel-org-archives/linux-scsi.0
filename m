From: Andy Grover <agrover@redhat.com>
Subject: targetcli-fb and rtslib-fb update, Feb '13
Date: Wed, 06 Feb 2013 12:58:53 -0800
Message-ID: <5112C40D.7090401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab3BFU6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Feb 2013 15:58:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi all,

I don't know how many of you follow my work on github so I just wanted 
to give an update on some stuff I've been working on, for my branches of 
the kernel target user space configuration tools.

The biggest recent rtslib change is that we've gone back to using Python 
classes to describe the differences between fabrics. See
https://github.com/agrover/rtslib-fb/blob/master/rtslib/fabric.py
for how things look now. This significantly simplifies the 
implementation of FabricModule, and other classes that use it. Having to 
write Python to add support for a new fabric seems like a very small 
price to pay.

The biggest recent targetcli change is a WWN-handling overhaul. All 
fabric WWNs are prefixed by their type, either "iqn.", "eui." or "naa." 
This lets us do a better job checking WWNs are valid, and we allow 
fabrics that allow multiple WWN formats, like iSCSI, to use any of 
these, but still check for correctness. But we aren't WWN format zealots 
-- when possible we convert user input to the correct WWN format if 
possible. This should make cut n paste of FCoE initiator WWNs much less 
aggravating, for example.

Here are some highlights of other things we've added since my last 
update to the list in Jan 2012:

targetcli:
* Only show fabric modules that are present, or don't need HW WWNs
* "targetcli <cmd>" executes the command and exits
* restoreconfig now emits specific info on each recoverable error when 
parsing the savefile
* ipv6 and localhost addresses allowed for portals
* Creating a NodeACL MappedLUN can take a storage object, and tpg lun 
will be automatically created
* sbp (1394) fabric support
* More info in storageobject and target summaries
* read-only parameter on block backstores
* "sessions" command to list iscsi sessions
* Added targetcli.8 man page
* rd_mcp backstore shown as "ramdisk"
* iblock backstore shown as "block"
* Change summary formats to "<thing>s: <num>" from "<num> thing{s}"

rtslib:
* Don't load fabric kernel modules until used
* Remove class Backstore from API - now handled as StorageObject 
implementation detail
* Remove legacy code
* Improve performance of listing 500 luns from 6 min to 3 sec
* lines of code reduced 20% (not counting .spec removal)
* Removed python-ipaddr, python-netifaces and python-configobj dependencies
* Use python-kmod for module loading if present

Regards -- Andy
