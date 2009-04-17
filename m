From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and
	implementation.
Date: Fri, 17 Apr 2009 18:03:28 +0200
Message-ID: <ac3eb2510904170903n4fa28bfdud80fe25b61be3c2a@mail.gmail.com>
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com>
	<49E85F1C.7040106@vlnb.net> <49E8832F.6070302@linux.vnet.ibm.com>
	<ac3eb2510904170724l654b00b4k79156138f9fd926d@mail.gmail.com>
	<49E8A551.7050307@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53236 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761114AbZDQQLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 12:11:33 -0400
In-Reply-To: <49E8A551.7050307@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Apr 17, 2009 at 17:50, Daniel Debonzi
<debonzi@linux.vnet.ibm.com> wrote:
> Do you mean that uses struct device is the right way to do it instead of
> kobjects or it is just a option to get things on right places into sysfs?

You can not put kobjects in /sys/devices/ and there will be no
disconnected kobject tree just for scsi, unless the scsi maintainers
really want want that, and then they should create their own
filesystem instead, and not use kobjects at all.

> I don't know this struct closely but my first impression looking to the
> source code is that it is tied with hardware and has some complexity we
> probably don't need. What do you think?

If you want to integrate with the current scsi devices/objects, which
is the only sensible option I think, you have to use struct device
devices, kobjects will not get a classification in sysfs, and will be
invisible for userspace tools unless you do random readdir() in
/sys/devices/ to find them.

Kay
