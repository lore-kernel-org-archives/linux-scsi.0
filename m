From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: 07 Nov 2003 09:56:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068224213.2286.115.camel@patrh9>
References: <1068165515.28505.29.camel@patrh9>
	 <1068222286.2286.50.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:55779 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264481AbTKGQ5W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 11:57:22 -0500
In-Reply-To: <1068222286.2286.50.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: patmans@us.ibm.com, linux-scsi@vger.kernel.org

> Perhaps we should be looking at 
> implementing camcontrol in Linux.

Implementing, yes.  Copying, no.  I have a series of arguments, this
email presents only the First:

> Unix Man Page For 8 camcontrol
> http://www.svbug.com/cgi-bin/man.cgi?comd=8+camcontrol

I vote (: vehemently :) against merging into sg utils the camcontrol
etc. practice of ...

... obscuring the plain hex by substituting English at this level.  For
example, in place of:

camcontrol tur da0
camcontrol eject -n cd -u 1 -v
camcontrol inquiry -D

I vote for:

sg_io -y "00 00:00:00 00 00"
sg_io -y "1B 01:00:00 02 00"
sg_io -i 0x24 -y "12 00:00:00 24 00"

Already we have sg_scan sg_inq sg_turs for less precise communication.

I vote for the hex because I can see what it means.  With those
camcontrol examples, I have to guess whether they sometimes or always
mean the hex I intend.

I'm not opposed to offering text & gui as well.  I just want text & gui
made available separately.  Some of my ideas for a gui full of natural
language text cribbed from the t10 fiction appear as screen shots near
the end of the web trail:

Pat LaVarre et alia
http://members.aol.com/ppaatt/

Directly manipulating storage devices
http://members.aol.com/ppaatt/#storage

2.1. Arbitrary transparent pass thru of SCSI.
2.1.1. Via Java GUI
screen shots
http://members.aol.com/plforth/console/scsi/

http://members.aol.com/plforth/console/scsi/javaspt3c.png
(and others)

Although few people can easily give SCSI pass thru privilege to a Java
applet, I surprised myself by discovering that an unsigned unprivileged
Java applet here remains useful.  In practice I found I left the
voluminous text & GUI on the web, then where I was actually working I
fetched the command line app and copy-pasted the command line args I
wanted from the applet.

Pat LaVarre


