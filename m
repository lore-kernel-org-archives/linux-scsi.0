From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Make UAS work on HS for devices with and without command tagging support
Date: Wed, 14 Dec 2011 19:47:50 +0100
Message-ID: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:34275 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab1LNSrJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2011 13:47:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Sarah and Matthew,

the two patches were required to get my new fancy uasp gadget work on HS
with dummy_hcd. It is processing only one command at a time however it
caught a few bugs already :)

To deal with canceled commands (where we may have to kill some status urbs)
I've been thinking about a list within uas_dev_info which keeps track of
all status urbs and counts all commands which are queued. Once we start
removing commands which timed out we should make sure that the number of
commands which remain is the same as the number of status urbs which we
have. If we have more status urbs than commands then we kill some status
urbs. If it is the other way around then someone was too trigger happy.

Sebastian

