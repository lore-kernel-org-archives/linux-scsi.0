From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 0/3] Follow-on patches to
 "adding support to FCoE transport"
Date: Thu, 23 Dec 2010 21:35:50 -0800
Message-ID: <1293168950.4676.508.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1496 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0LXFgD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 00:36:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, michaelc@cs.wisc.edu, yi.zou@intel.com

These are follow-on patches to Yi's patches for adding support
to FCoE transport.

This patch fixes the following issues:

1. bugs w.r.t locking and is_vendor check.

2. Since we are using the same 'fcoe' service for software fcoe as
well as vendor drivers(bnx2fc for eg.), some interfaces will be 
claimed by bnx2fc and some interfaces will be claimed by fcoe
driver.  This may cause some confusion to the administrator,
as he cannot control which interfaces should be claimed by which
driver.

3. match() assumes that the netdev/driver mapping shall remain intact.
This may not be true. Lets say, 'fcoe' is the only driver loaded
initially, and create is called on that. Subsequently, 'bnx2fc' driver
is loaded, which may claim the interface. Destroy will be called on
bnx2fc driver instead of fcoe. 

4. Currently we do not have a mapping for create and corresponding
destroy/disable or enable.


Bhanu Prakash Gollapudi (3):
  Resolve circular lock warning and is_vendor check
  libfcoe: transport structure lookup based on driver name
  fcoe: Remove match() and is_vendor fields in fcoe_transport structure

 drivers/scsi/fcoe/fcoe.c              |   17 +--
 drivers/scsi/fcoe/libfcoe.h           |    2 +-
 drivers/scsi/fcoe/libfcoe_transport.c |  200 ++++++++++++++++++++++++--------
 include/scsi/libfcoe.h                |   14 ++-
 4 files changed, 166 insertions(+), 67 deletions(-)




