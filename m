From: Alex Aizman <itn780@yahoo.com>
Subject: [ANNOUNCE 0/7] open-iscsi/linux-iscsi-5 Initiator
Date: Thu, 04 Aug 2005 19:29:28 -0700
Message-ID: <42F2CF08.6050407@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp017.mail.yahoo.com ([216.136.174.114]:38245 "HELO
	smtp017.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262809AbVHEC3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 22:29:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "David S. Miller" <davem@davemloft.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>


Open-iSCSI/Linux-iSCSI-5 Initiator: Data Path and Transport Class
==========================================

This submission contains 7 patches for 2.6.13 (today's git repository). The same 
7 patches can be downloaded at:

http://www.open-iscsi.org/bits/submission-08042005/

This submission corresponds to Open-iSCSI r389 in the SVN repository.

The entire Initiator source, including control plane and tools, is available at:

http://www.open-iscsi.org/index.html#download


Major Changes since the previous (06/01/2005) submission,
also available at http://lkml.org/lkml/2005/6/1/279
==================================

* Made it work with 2.6.13
* Fixed corner case in Data-In processing
* Internally reviewed and cleaned up the code
* Added IPv6 support


Thanks
======

Many people contributed to testing *and* development. In particular, special
thanks to: Zhenyu Wang, Fujita Tomonori, Ming Zhang, Albert (pauw@o2.ie), Arne
Redlich.


Changelog
========

* Zhenyu Wang: kmap_atomic lockup fix
* Included Mike Christie in Copyright
* Zhenyu Wang: support iSCSI Data Digest
* Fujita Tomonori: improve str_to_ipport() for handling IPv6 address
* Fujita Tomonori: remove discovery_file() (hack/obsolete)
* Fujita Tomonori: added IPv6 support (user land)
* SN checking: added check_assign_cmdsn(), better checking and wrap around
* updated backward-compile-2.6.12 patch
* Mike: support multiple LUNs via new API in 2.6.13
* Fujita Tomonori, Arne Redlich: corruption when processing Data-Ins at non
page-aligned offsets
* Mike: 2.6.13 will not hold the host lock when calling eh callouts
* fix for XFS: sendpage() only if page refcounted, otherwise kernel_sendmsg().


Patches
=====

1. open-iscsi-tcp.c.patch - drivers/scsi/iscsi_tcp.c, iscsi data path.

This is ~3600 lines 96K file. If it does not make it through via e-mail, the
exact same patch along with the rest 6 can be downloaded at
http://www.open-iscsi.org/bits/submission-08042005/

2. open-iscsi-tcp.h.patch - drivers/scsi/iscsi_tcp.h, header file.

3. open-iscsi-headers.patch - common header files:
	- iscsi_if.h (user/kernel #defines and user/kernel events);
	- iscsi_proto.h (RFC3720 #defines and types);
	- scsi_transport_iscsi.h (transport API, transport #defines and types).


4. open-iscsi-netlink.patch - include/linux/netlink.h changes (added new
protocol NETLINK_ISCSI).

5. open-iscsi-Makefile.patch - drivers/scsi/Makefile changes.

6. open-iscsi-transport.patch - new iscsi transport class
(drivers/scsi/scsi_transport_iscsi.c).

7. open-iscsi-Kconfig.patch - drivers/scsi/Kconfig changes.

Thanks,

Linux-iscsi Team


