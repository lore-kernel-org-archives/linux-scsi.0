From: christophe.varoqui@free.fr
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Fri, 22 Aug 2003 18:07:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061568453.3f463fc592678@impt1-2.free.fr>
References: <1061290087.3f4200678f811@impt2-2.free.fr> <20030819143552.K8420@sistina.com> <1061299572.3f4225742287c@impt1-2.free.fr> <20030819182347.O8420@sistina.com> <20030820012204.449c2b34.christophe.varoqui@free.fr> <20030820150253.X8420@sistina.com> <1061389164.3f43836ccaf56@impt1-1.free.fr> <20030821144716.Y8420@sistina.com> <1061483692.3f44f4ac24e07@impt1-2.free.fr> <20030822105146.B8420@sistina.com> <20030822075953.A28851@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:44960 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S263405AbTHVQHj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 12:07:39 -0400
In-Reply-To: <20030822075953.A28851@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: mauelshagen@sistina.com, linux-scsi@vger.kernel.org

>From "Working Draft SCSI Block Commands - 2 (SBC-2)"

4.2.1.4 Ready state
A direct-access block device is ready when medium access commands can be
executed. A block device using removable media is not ready until a volume is
mounted. Such a block device, with a volume not mounted, shall terminate medium
access commands with CHECK CONDITION status and the sense key shall be set to
NOT READY with the appropriate additional sense code for the condition.
Some direct-access block devices may be switched from being ready to being not
ready by using the START STOP UNIT command. An application client may need to
issue a START STOP UNIT command with a START bit set to bring a block device ready.
---

It seems a ghost LUN on HSV controlers is not doing the right thing as "sg_turs"
reports NOT READY the first time then hang on D-state on consecutive try.

Can the linux kernel be in cause or is it HP ? May the kernel should trap this
NOT READY sense on the fly and disconnect the path.
If it is HP, is there a way to bring them in conformance ?

regards,
cvaroqui
