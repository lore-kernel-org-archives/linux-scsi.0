From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk wakeup on resume
Date: Tue, 05 Nov 2013 19:07:45 -0500
Message-ID: <52798851.3010507@ubuntu.com>
References: <527859D9.3030607@ubuntu.com> <5278B4DB.7080302@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:41920 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3KFAHr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2013 19:07:47 -0500
In-Reply-To: <5278B4DB.7080302@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I found the culprit.  It seems that ata_port_reset identifies the
device, and if it has power up in standby enabled, and requires the
SET FEATURES command to spin up, issues the command right away.  I wonder:

1)  If the spinup command can't be delayed until the disk is actually
accessed and/or

2)  If the disk is in runtime suspend when the system is suspended,
why doesn't it remain suspended when the system is resumed, thus
delaying the port reset until the runtime suspend is lifted ( when the
disk is accessed ).

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSeYhMAAoJEJrBOlT6nu75jUgH/A64U4GQZxzLdkM6/ewpSK31
C+UZ+PAy3l0jUdCtYwDCca7k7bC94Jh5vrOi2WlglmRIVnRl1PzcMfOFalm0Ca2m
uibKvA3LSLsE/ICB+gl0329au5GADO/hLcuLb8v0U7ZgTPwSwdrqFM5ApUatPFf5
RBVZbwMojl7aXSRkmHS1L48BIRc9X4G2wLB4qgE+tJFP8s04l1cC7fWSf5e7vUNw
4scSPzahgGAOrsy7tQQgc2vP7uM/m0LRFN4Gs6gC9axFfCTQ5oYA/0TiOVpeRDYh
PfPfp0InoNiOuq1QPW+T9TbuAsHp7GxxoAl6ljqOUAZ3sWisEV56lYYsNjwCEs0=
=wQsh
-----END PGP SIGNATURE-----
