From: christophe varoqui <christophe.varoqui@free.fr>
Subject: sd.c and storageworks assistance
Date: Sun, 28 Sep 2003 12:13:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064744014.1736.40.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.wanadoo.fr ([193.252.22.28]:25060 "EHLO
	mwinf0302.wanadoo.fr") by vger.kernel.org with ESMTP
	id S262531AbTI1KNk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Sep 2003 06:13:40 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

James,

I put up a small tool to auto-configure multipath device-mapper targets.
I will release it as soon as the dm target is available.
The path coalescing is based on and unique id, which is vendor specific.
The approach taken is to explicitly declare a fonction for retreiving
this UID, the default being "ignore the path if no method found"
(WhiteList).
This initial release is focused on storageworks controlers : I have
access to HSG80 and HSV110 hw. For them, the UID is the WWID stored in
page 0x83 of the VPD at offset 8.

These controlers, as I have already mentioned on linux-scsi, export Luns
through all 4 FC ports, but only two ports of the same controler (in the
pair) present valid IO paths. The other two are what we called in
previous threads "ghost paths".

TUR can be reliably used to detect if a path is in ghost or valid state.

After this long intro, here goes my problem :
Recent 2.4 linux kernels attach /dev/sd* only to the valid paths. Ghosts
structures are present in the sg and mid-layer, giving access to HBTL,
TUR, VPD info. In case the active controler reboots, the 2 ghosts become
active but Linux won't dynamically assign them a /dev/sd* name. Having
no /dev/sd* name, they can't be used in a multipath map, and the
multipath runs out of paths even if there are 2 paths around but Linux
can't see them ... not good.

I ask for assistance for implementing the following behaviour :
/dev/sd* names must be assigned to ghosts.

Multipath maps contain only the valid paths (test based on TUR), so no
IO will be submitted to the ghosts (IO can safely block or fail). When a
controler reboots, TUR states will change and the updated devmap will
contain the newly valid paths.

Do you agree with this solution ?
If not, do you have other ?
Can you help ?
(I'd rather avoid kernel dev)

regards,
cvaroqui

