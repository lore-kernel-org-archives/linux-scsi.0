From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Tagged overlapped commands
Date: Thu, 04 Dec 2014 08:17:08 -0800
Message-ID: <1417709828.8998.7.camel@HansenPartnership.com>
References: <CAHOfOo1WuW8MD=r1zEEfd+csNEWacQA4EYa95zhUn49MxbEEsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50332 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442AbaLDQRK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 11:17:10 -0500
In-Reply-To: <CAHOfOo1WuW8MD=r1zEEfd+csNEWacQA4EYa95zhUn49MxbEEsA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Brooks <arb@sat.dundee.ac.uk>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2014-12-01 at 12:24 +0000, Andrew Brooks wrote:
> Hi
> 
> I'm having trouble writing to an LTO-5 tape drive connected via Adaptec 1405
> Writing aborts with this in syslog:
> 
> st0: Sense Key : Aborted Command [current]
> st0: Add. Sense: Tagged overlapped commands (task tag 0)
> 
> Both the drive and adapter have the latest firmware.
> I've tried ubuntu 12.04 (3.2.0-70) and the latest fedora 20.1.
> 
> Does anyone have any ideas on how to troubleshoot and fix this?

The error message likely means that the tape device had more than one
command outstanding at once (i.e. one command was sent while the current
command was still pending).  It could also mean that a tag got re-used
(same tag issued while command with that tag was outstanding) but for a
tape I think the former is more likely.  Is the queue depth set to one
for the device?

James


