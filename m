From: Lukasz Kosewski <lkosewsk@nit.ca>
Subject: [PATCH 0/3] Add disk hotswap support to libata
Date: Thu, 21 Jul 2005 17:14:12 -0400
Message-ID: <42E01024.9030600@nit.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ptr-64-201-187-87.ptr.terago.ca ([64.201.187.87]:50066 "HELO
	mars.net-itech.com") by vger.kernel.org with SMTP id S261875AbVGUVOO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2005 17:14:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Hey all, introductory blurb here.

This sequence of patches will add a framework to libata to allow for 
hot-swapping disks in and out.

There are three patches:
01-promise_sataII150_support
02-libata_hotswap_infrastructure
03-promise_hotswap_support

The rationale for each will be described in following emails.

I encourage anyone with design ideas to come forward and contribute, and 
anyone who can see concurrency problems (I will describe what I see as 
issues along with the second patch) to suggest fixes.

Thus far, I've tested this HEAVILY with a 2.6.11.12 kernel + 
2.6.11-libata-dev1.patch.  I have found no issues outstanding on that 
kernel.  All testing was done with Promise SATA150 and SATAII150 Tx4/Tx2 
  Plus controllers and a huge variety of Western Digital and Seagate disks.

I have ported my patches to 2.6.13-rc3 and 2.6.13-rc3-mm1, and have 
tested on the latter as well; they work identically to the 2.6.11 tests 
except for a breakage in the SCSI layer [1].

The patches I will attach apply to the latter (2.6.13-rc3-mm1) tree, 
since I expect that by the time people start looking at them seriously, 
the existing libata patches in that tree will have become part of 
mainline.  If this is NOT the right thing to do, please tell me, and 
I'll submit patches for the requested kernel version.

Enjoy!

Luke Kosewski
Human Cannonball
Net Integration Technologies

[1]  The SCSI error on 2.6.13-rc3-mm1 that I found:
'echo "scsi add-single-device a b c d" > /proc/scsi/scsi'  //works, or 
no-op if the sd corresponding to that device is there already
'echo "scsi remove-single-device a b c d" > /proc/scsi/scsi'  //works
'echo "scsi add-single-device a b c d" > /proc/scsi/scsi'  //works
'echo "scsi remove-single-device a b c d" > /proc/scsi/scsi'  //FAILS

As such, since the same underlying functions are called by hotplugging, 
you will only be able to remove a disk from a device once before it 
fails, until this error is fixed.  I'll look into it as well.
