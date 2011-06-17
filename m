From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Date: Fri, 17 Jun 2011 10:27:24 -0400
Message-ID: <1308320844.2586.14.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com>
	 <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave>
	 <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave>
	 <20110616181943.GB1439@kroah.com> <1308256290.2436.143.camel@mulgrave>
	 <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
	 <1308264321.2436.161.camel@mulgrave>
	 <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58905 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757905Ab1FQO12 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2011 10:27:28 -0400
In-Reply-To: <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On Fri, 2011-06-17 at 01:04 +0200, Kay Sievers wrote:
> >> We need many names, and we need all of them from the very
> beginning,
> >> and they should not change during device lifetime unless the device
> >> state changes.
> >
> > So that's actually an argument for leaving the links, surely?  We
> can
> > have many inbound links, but the kernel can only print one name in
> > messages, which would be the preferred name that was currently set.
> 
> I really question any concept of _the_ name. My take on it: It will
> never work in reality. 

OK, so lets take the common example: a desktop with three disks and an
enclosure with three slots and labels "fred", "jim", and "betty".

The desired outcome is that whenever the user manipulates those devices
he uses a name related to the label, so whenever dmesg flags a problem,
it says sd betty:  device offline or something.  Whenever he mounts, he
mounts by /dev/disk/by-preferred/betty (or whatever the current udev
vernacular is).  Whenever smartmon says there's an over temp problem. it
says that fred has it;  cat /proc/partitions shows how fred, jim and
betty are partitioned and so on.

To do this, we set the preferred name at start of day via a machine
specific customisation.  For an enclosure, there's a standard way of
mapping the name to the device, so we'd just use that, but it's not
impossible to imagine systems with stranger entities that require per
motherboard customisations.

Once the name is set in boot up, we, in fact, never alter it.

With the kernel patch proposed and a corresponding update to udev
actually makes all the above happen.  There have to be tweaks to the
startup scripts, like smartd needs a file configuration that lists the
disk by preferred path so that the output is correct.

Obviously, I chose the commands above so there is no need to modify any
of them.  There will be utilities (like overly smart san managers) that
do derive the name and will need updating, but they're not among the
standard workstation admin tools.

James


