From: Jason Wang <jiasen.wang@gmail.com>
Subject: mpt2sas: disk name is out of order with expander
Date: Mon, 30 Jul 2012 06:43:53 +0800
Message-ID: <CAO5nWLbJhTKdttXDRm_diFjqnDhnK-QpHaC+whBKyN1XSoaKvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40811 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab2G2Wnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2012 18:43:55 -0400
Received: by lbbgm6 with SMTP id gm6so3188505lbb.19
        for <linux-scsi@vger.kernel.org>; Sun, 29 Jul 2012 15:43:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here is our configuration

OS: ubuntu 10.4( kernel 2.6.32)
HBA: H200
driver: mpt2sas

We'd like to map the disk name with enclosure slot.
That is to say, we would like to
sda -> slot 0,
sdb -> slto 1,
sdc-> slot 2
...;
With the ubuntu included mpt2sas driver, the disk name is out of order.

We use the new mpt2sas , which version is 13.115.   It solve the
problem, disk name order aligned with enclosure slot.
Then we use another server, but the OS is same(ubuntu 10.4), same
HBA(h200), save driver(mpt2sas 13.115), the only different is this
server(R515) has expander.  Then the disk name is out of order against
the enclosure slot.

1. With the ubuntu included mpt2sas, the disk name is always out of
order. No matter with expander or without expander.

2. With the new mpt2sas (13.115),  the disk name aligned with
enclosure slots on the server without expander.

3. With the new mpt2sas(13.115), the disk name is still out of order
on the server with expander.


Here are my questions.
1. Regarding the linux disk name, is there any difference between
expander and direct-connected?

2. How to use udev to solve the problem?  By uuid or serial number, it
is not practical for large number of servers.  Could I use the
expander physical attribute to map the disk name?


3. Could I use scsi enclosure service(SES) to solve the problem?   how to do it?

Thanks
