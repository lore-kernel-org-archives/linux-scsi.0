From: Olaf Hering <olh@suse.de>
Subject: glibc and make headers_install_all provide /usr/include/scsi
Date: Mon, 6 Aug 2007 14:45:46 +0200
Message-ID: <20070806124546.GA2117@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXHFMps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Aug 2007 08:45:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sources.redhat.com


glibc and make headers_install_all provide /usr/include/scsi
One of them has to go.

A quick diff shows no differences, expect:

scsi.h:
     glibc #define STATUS_MASK          0x3e
     Linux #define STATUS_MASK          0xfe

     glibc #define ABORT               0x06
     Linux #define ABORT_TASK_SET      0x06

sg.h:struct sg_iovec ->sg_iovec
     unsigned char * in glibc
     void * in Linux

     glibc #define SG_DEFAULT_RETRIES 1
     Linux #define SG_DEFAULT_RETRIES 0


Which copy should be provided by a distributor?
