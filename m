From: michaelc@cs.wisc.edu
Subject: RFC: add target reset handler to scsi_error.c
Date: Tue, 18 Dec 2007 22:11:07 -0600
Message-ID: <1198037469664-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbXLSEL4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Dec 2007 23:11:56 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lBJ4BrHB005139
	for <linux-scsi@vger.kernel.org>; Tue, 18 Dec 2007 23:11:53 -0500
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lBJ4BrKT026862
	for <linux-scsi@vger.kernel.org>; Tue, 18 Dec 2007 23:11:53 -0500
Received: from localhost.localdomain (vpn-14-36.rdu.redhat.com [10.11.14.36])
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lBJ4Blfo025652
	for <linux-scsi@vger.kernel.org>; Tue, 18 Dec 2007 23:11:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These patches add a target reset handler to scsi_error.c's error
handler. It is needed because drivers like qla4xxx either have to
do a target reset in the eh_device_reset_handler then do some
tricks so that when that handler is called again we do not send
extra resets, or the driver has to do its own loop in the bus
or host reset handler that loops over the host's targets and sends a
target reset for each target.

Patches were made over scsi-misc.


