From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and
	implementation.
Date: Fri, 17 Apr 2009 20:24:32 +0200
Message-ID: <ac3eb2510904171124h11c4c70bu371fa06127cb45da@mail.gmail.com>
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com>
	<49E85F1C.7040106@vlnb.net> <49E8832F.6070302@linux.vnet.ibm.com>
	<49E88E3F.8030107@vlnb.net> <49E891C8.1050007@emulex.com>
	<49E8BFB2.50608@vlnb.net> <ac3eb2510904171056v4c6c971dx99bfb87464a6b02d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f211.google.com ([209.85.218.211]:40508 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbZDQSYt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 14:24:49 -0400
In-Reply-To: <ac3eb2510904171056v4c6c971dx99bfb87464a6b02d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Smart <James.Smart@emulex.com>, Daniel Debonzi <debonzi@linux.vnet.ibm.com>, "scst-devel@lists.sourceforge.net" <scst-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Apr 17, 2009 at 19:56, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Fri, Apr 17, 2009 at 19:43, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> Thank you for the suggestion. If nobody objects, we will go with
>> /sys/class/scst_tgt.
>
> On Fri, Apr 17, 2009 at 19:43, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> I agree, looks like using struct device instead of struct kobject should
>> additionally complicate the code a lot for not clear gain.
>
> Thes both replies together suggest that you miss how sysfs and the
> driver core works. Please go and read the current code, and look at
> sysfs, before trying anything like this.
>
> There is no way to add any stuff to /sys/class/scst_tgt/ without using
> proper "struct device" objects.
>
> For the same reason we will not have a disconnected device tree, we
> will not havet any raw kobject in the /sys/devices, /sys/class,
> /sys/bus directories.

As a starting point, consider creating a "scst" bus_type. Then make
sure all devices you need are uniquely named, so they can be in a flat
list in /sys/bus/scst/devices/.

Then add all the devices as struct_device to the tree, maybe use an
existing parent struct_device (like a pci device) if you have one, or
create a custom one in /sys/devices/ if there is nothing to use.

All the devices you add will show up in a hierarchy in /sys/devices/
depending on the parent information you supply, and every single
device of your subsystem will be listed in a flat list in
/sys/bus/scst/devices/*. You will also get proper events for userspace
that way.

The question is where the actual block devices hang off, and if they
can use one of the created scst devices, or if they will be virtual
ones?

Thanks,
Kay
