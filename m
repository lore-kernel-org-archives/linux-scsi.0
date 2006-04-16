From: =?ISO-8859-1?Q?Roger_H=E5kansson?= <hson@ludd.luth.se>
Subject: Re: lpfc target renumbering problem
Date: Sun, 16 Apr 2006 23:35:53 +0200
Message-ID: <4442B8B9.3040103@ludd.luth.se>
References: <4441A693.7060004@ludd.luth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mother.ludd.ltu.se ([130.240.16.3]:59046 "EHLO
	mother.ludd.ltu.se") by vger.kernel.org with ESMTP id S1750810AbWDPVgB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Apr 2006 17:36:01 -0400
Received: from [192.168.150.100] (root@localhost [127.0.0.1])
	by mother.ludd.ltu.se (8.13.6+Sun/8.12.10) with ESMTP id k3GLZxYM027746
	for <linux-scsi@vger.kernel.org>; Sun, 16 Apr 2006 23:35:59 +0200 (MEST)
In-Reply-To: <4441A693.7060004@ludd.luth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Roger H=E5kansson wrote:
>=20
> Now my question:
> Is there anything I can do to "fix" this, or do I have to "accept" th=
at
> this hardware/software-combination can't do what I want?
>=20

I've found a "solution" which seems to work, but I'm not sure how to
implement it.
If I, before device-mapper-multipath determines the devices to be
"dead", do "echo 1 > /sys/class/scsi_device/1:0:0:0/device/rescan", bot=
h
sdb (which 1:0:0:0 was mapped to at the time of my test) and(!, even
though its on another HBA) sdc (2:0:0:0) doesn't get marked as dead.
But how do this in a more automatic fashion?
I could set up a script which polls /var/log/messages, or write a
program which opens a pipe and let syslogd write to that pipe, and pars=
e
the log in order to watch for SCSI-errors, but none of this seems like
the right way to do it.
Anyone got a better solution?

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
