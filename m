From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Re: Patch?: linux-2.5.45/drivers/scsi/hosts.[ch] - Eliminate scsi_host_tmpl_list
Date: Sat, 9 Nov 2002 21:37:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211100537.VAA27429@baldur.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: hch@lst.de, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
>But, there is no way to match the previous functionallity without having
>a host name list.
>
>That is before the patch we can do this:
>
>        insmod foo; insmod bar
>
>And foo gets scsi4, bar scsi5. And then:
>
>        rmmod foo; rmmod bar
>        insmod bar; insmod foo
>
>And foo should still be scsi4, bar scsi5.
>
>Without the host name list, the best we can do is have
>foo become scsi5, and bar scsi4.

	I do not understand why you think these is any change
in behavior.

	If you passed "scsihosts=host1,host2,host3,foo,bar", then
you should the first foo controller will always be assigned ID 4,
and the first bar controller will always be assigned ID 5, no matter
how you load, unload and reload the foo and bar SCSI drivers.
A successful scsi_register always calls scsi_hostnum; scsi_hostname
always checks the scsihosts variable.

	If you disagree with this, please walk me through how the
second "insmod foo" gets scsi ID 4 when the scsihosts string has
reserved that ID for something else.  If you can actually produce
the behavior in real life, that would be even better.

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Miplitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."
